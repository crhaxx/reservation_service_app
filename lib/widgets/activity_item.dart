import 'package:flutter/material.dart';
import 'package:reservation_service_app/pages/about_activity.dart';
import 'package:reservation_service_app/services/local_service.dart';

class ActivityItem extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final DateTime date;

  const ActivityItem({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(title),
          const SizedBox(width: 10),
          Text(
            "${date.day.toString()}.${date.month.toString()}.${date.year.toString()}",
            style: TextStyle(color: Color(Colors.grey[600]!.value)),
          ),
        ],
      ),
      subtitle: Text(description),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          LocalService.deleteActivity(id);
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutActivity(
              title: title,
              description: description,
              date: date,
            ),
          ),
        );
      },
    );
  }
}
