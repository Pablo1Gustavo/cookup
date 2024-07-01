import 'package:flutter/material.dart';
import 'package:front/services/auth_service.dart';
import 'package:front/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CheckInDiarioCard extends StatefulWidget {
  const CheckInDiarioCard({Key? key}) : super(key: key);

  @override
  _CheckInDiarioCardState createState() => _CheckInDiarioCardState();
}

class _CheckInDiarioCardState extends State<CheckInDiarioCard> {
  List<String> _weekDays = [];

  @override
  void initState() {
    super.initState();
    _getCurrentWeek();
  }

  void _getCurrentWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Start of the week (Monday)
    _weekDays = List.generate(7, (index) {
      DateTime day = startOfWeek.add(Duration(days: index));
      return DateFormat('dd/MM').format(day);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Card(
      color: Colors.orange[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check-in Diário',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Acumule pontos diariamente e compre novas skins',
              style: TextStyle(color: Colors.orange),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                DateTime date = DateTime.now().subtract(Duration(days: index));
                // bool checkedIn = checkInDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day);

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Text(
                        '+${2 + index * 2}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM').format(date),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).reversed.toList(),
            ),
          ],
        ),
      ),
    );
  }
}