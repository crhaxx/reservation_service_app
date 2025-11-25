import 'package:flutter/material.dart';
import 'package:reservation_service_app/models/activity.dart';
import 'package:reservation_service_app/pages/about_activity.dart';
import 'package:reservation_service_app/services/local_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _nameController = TextEditingController();

  void _addActivity() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add New Activity'),
                TextField(
                  decoration: const InputDecoration(labelText: 'Activity Name'),
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text;
                    await LocalService.createNewActivity(name);
                    _nameController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Create Activity'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homepage')),
      body: Center(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                _addActivity();
              },
              icon: Icon(Icons.add, size: 50),
            ),

            StreamBuilder<List<Activity>>(
              stream: LocalService().getAllActivities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No activities found.');
                } else {
                  final activities = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return ListTile(
                          title: Text(activity.name),
                          subtitle: Text(activity.date.toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              LocalService.deleteActivity(activity.id);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutActivity(
                                  title: activity.name,
                                  description: activity.description,
                                  date: activity.date,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
