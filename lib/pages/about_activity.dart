import 'package:flutter/material.dart';

class AboutActivity extends StatefulWidget {
  final String title;
  final String description;
  final DateTime date;
  const AboutActivity({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  State<AboutActivity> createState() => _AboutActivityState();
}

class _AboutActivityState extends State<AboutActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(
        child: Text('Details about the activity will be shown here.'),
      ),
    );
  }
}
