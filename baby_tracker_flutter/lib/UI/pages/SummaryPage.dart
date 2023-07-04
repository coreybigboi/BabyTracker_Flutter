import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key, required this.date, required this.summary});

  final String date;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Baby Tracker 👶"),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: HighlightedText(label: "Summary for $date 📝", colour: Colors.deepOrange),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(summary, style: const TextStyle(fontSize: 18),),
              )
            ],
          ),
        ),
    );
  }
}
