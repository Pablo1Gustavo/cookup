import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front/utils/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularCountDown extends StatefulWidget {
  final int totalMinutes;

  const CircularCountDown({
    required this.totalMinutes,
    Key? key,
  }) : super(key: key);

  @override
  _CircularCountDownState createState() => _CircularCountDownState();
}

class _CircularCountDownState extends State<CircularCountDown> {
  late int secondsRemaining; 
  late double _percent;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    secondsRemaining = widget.totalMinutes*60;
    _percent = ( widget.totalMinutes*60 - secondsRemaining) / (widget.totalMinutes * 60);
    _startTimer();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        secondsRemaining--; 
        _percent = ( widget.totalMinutes*60 - secondsRemaining ) / (widget.totalMinutes * 60);
      });

      if (secondsRemaining <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 20.0,
        percent: _percent,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: primaryColor100,
        linearGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor300,
            primaryColor,
          ],
        ),
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Faltam',
              style: TextStyle(
                fontSize: 18.0,
                color: black400,
              ),
            ),
            Text(
              '${secondsRemaining ~/ 60}:${(secondsRemaining % 60).toString().padLeft(2, '0')} min',
              style: TextStyle(
                fontSize: 24.0,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
