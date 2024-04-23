import 'dart:async';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:read_ranger/Products/Services/database_service.dart';

class CardDetailView extends ConsumerStatefulWidget {
  const CardDetailView({super.key, required this.bookModel});
  final BookModel bookModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends ConsumerState<CardDetailView> {
  final _databaseService = DatabaseService();

  late final File _image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = File(widget.bookModel.imagePath!);
  }

  bool _onSession = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Are you sure to remove this book ?  "),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              _databaseService.deleteBookModels(widget.bookModel.id);
                              Navigator.of(context).popAndPushNamed("/home");
                            },
                            child: Text("Yes"),
                          )
                        ],
                      ),
                    );
                  },
                  child: Text('Delete This Book ',
                      style: TextStyle(
                        color: Colors.red,
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Image.file(
                _image,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(widget.bookModel.bookName!),
            ),
            Text(widget.bookModel.description!),
            TextButton(
              onPressed: () {
                _onSession = !_onSession;
                setState(() {});
              },
              child: Text(
                "Start a new session",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TimeWidget(onSession: _onSession),
          ],
        ),
      ),
    );
  }
}

class TimeWidget extends StatefulWidget {
  TimeWidget({
    super.key,
    required bool onSession,
  }) : _onSession = onSession;

  final bool _onSession;

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> with SingleTickerProviderStateMixin {
  Duration duration = Duration();
  Timer? timer;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  void addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      addTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: widget._onSession ? 1 : 0,
      child: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    if (timer == null || !timer!.isActive) {
                      controller.forward();

                      startTimer();
                    } else {
                      timer!.cancel();
                      controller.reverse();
                    }
                  },
                  icon: AnimatedIcon(
                    size: 50,
                    icon: AnimatedIcons.play_pause,
                    progress: animation,
                  )),
              timeCard(
                time: minutes,
                header: "Minutes",
              ),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(right: 60),
                child: timeCard(
                  time: seconds,
                  header: "Seconds",
                ),
              ),
            ],
          )),
    );
  }
}

class timeCard extends StatelessWidget {
  const timeCard({super.key, required this.time, required this.header});

  final String time;
  final String header;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 5)),
      builder: (context, snapshot) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              "$time",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          Text(header),
        ],
      ),
    );
  }
}
