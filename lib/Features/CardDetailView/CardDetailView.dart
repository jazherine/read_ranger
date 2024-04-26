import 'dart:async';
import 'dart:io';

import 'package:com.ugurTurker.read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:com.ugurTurker.read_ranger/Features/CardDetailView/cardDetailProvider.dart';
import 'package:com.ugurTurker.read_ranger/Features/Home/HomeProvider.dart';
import 'package:com.ugurTurker.read_ranger/Products/Services/database_service.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    super.initState();
    _image = File(widget.bookModel.imagePath!);
  }

  @override
  Widget build(BuildContext context) {
    bool _onSession = ref.watch(onSessionProvider);
    int? _duration = widget.bookModel.durationMinutes ?? 0;
    String? _bookPages = widget.bookModel.bookPages ?? "0";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(onSessionProvider.notifier).update((state) => state = false);

          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back),
      ),
      body: Center(
        child: Column(
          children: [
            //DELETE THİS BOOK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                //FİNİSH BUTTON
                Padding(
                  padding: const EdgeInsets.only(top: 100, left: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _databaseService.updateCompletedBookModels(id: widget.bookModel.id);
                      Navigator.of(context).popAndPushNamed("/home");

                      ref.read(selectedIndex.notifier).state = 0;
                    },
                    child: Text("Finish This Book", style: TextStyle(color: Colors.green)),
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Text(
                "You read this book for ${_duration ~/ 60} hours and    ${_duration % 60} minutes",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            Divider(),

            //RESİM
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 80),
                  child: Image.file(
                    _image,
                    height: 200,
                  ),
                ),

                // KİTAP  VERİ

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20, top: 35),
                      child: SizedBox(
                        width: 130,
                        child: Text(
                          widget.bookModel.bookName!,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          widget.bookModel.description!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _bookPages + " Pages",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Divider(),

            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Card(
                shadowColor: Colors.blue,
                elevation: 5,
                child: TextButton(
                  onPressed: () async {
                    Duration _duration = ref.read(durationProvider);

                    if (_onSession == true && mounted) {
                      var _oldDuration = widget.bookModel.durationMinutes ?? 0;
                      _oldDuration += _duration.inMinutes;
                      Duration newduration = Duration(minutes: _oldDuration);

                      await _databaseService.updateDurationBookModels(id: widget.bookModel.id, duration: newduration);
                    }
                    ref.read(onSessionProvider.notifier).update((state) => state = !state);
                  },
                  child: Text(
                    _onSession ? "Finish Reading" : "Start Reading",
                    style: _onSession ? TextStyle(color: Colors.red) : TextStyle(color: Colors.blue, fontSize: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 35),
              child: TimeWidget(
                onSession: _onSession,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeWidget extends ConsumerStatefulWidget {
  const TimeWidget({
    super.key,
    required bool onSession,
  }) : _onSession = onSession;

  final bool _onSession;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends ConsumerState<TimeWidget> with SingleTickerProviderStateMixin {
  Timer? timer;
  late AnimationController controller;
  late Animation<double> animation;
  late Duration _duration;

  @override
  void initState() {
    _duration = Duration();
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
    controller.dispose();
  }

  void addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = _duration.inSeconds + addSeconds;
      _duration = Duration(seconds: seconds);
      if (widget._onSession == false) {
        _duration = Duration(seconds: 0);
      }
      ref.read(durationProvider.notifier).update((state) => state = _duration);
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
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    final hours = twoDigits(_duration.inHours);

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
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: IconButton(
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
                      size: 30,
                      icon: AnimatedIcons.play_pause,
                      progress: animation,
                    )),
              ),
              timeCard(
                time: hours,
                header: "Hours",
              ),
              SizedBox(width: 10),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Text(
            "$time",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        Text(header),
      ],
    );
  }
}
