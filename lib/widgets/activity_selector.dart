import 'package:flutter/material.dart';

class ActivitySelector extends StatefulWidget {
  const ActivitySelector({super.key});

  @override
  _ActivitySelectorState createState() => _ActivitySelectorState();
}

class _ActivitySelectorState extends State<ActivitySelector> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Three', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          })
          .toList(),
    );
  }
}
