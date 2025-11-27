import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reservation_service_app/models/activity.dart';
import 'package:reservation_service_app/services/firebase_service.dart';
import 'package:reservation_service_app/services/local_service.dart';
import 'package:reservation_service_app/widgets/activity_item.dart';
import 'package:reservation_service_app/widgets/activity_selector.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    loadData(); // runs on widget creation (after reload)
  }

  final TextEditingController _nameController = TextEditingController();

  Map<String, dynamic>? data;
  bool isLoggedIn = false;
  bool isLoading = false;

  void loadData() async {
    print("Loading user data...");
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseService.getUserData(user);
      isLoggedIn = true;
      print(userData);
      setState(() {
        data = userData;
      });
      print("Username: ${data?['username']}");
    }
  }

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
                ActivitySelector(),
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
            Visibility(
              visible: !isLoading,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      _addActivity();
                    },
                    icon: Icon(Icons.add, size: 50),
                  ),

                  Visibility(
                    visible: !isLoggedIn,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseService.signUp(
                          "test@user.com",
                          "testpass",
                        );
                      },
                      child: Text('Register'),
                    ),
                  ),

                  Visibility(
                    visible: !isLoggedIn,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true; // show loading
                        });

                        try {
                          await FirebaseService.signIn(
                            "test@user.com",
                            "testpass",
                          );
                          loadData();
                          isLoggedIn = true;
                        } catch (e) {
                          print("Login failed: $e");
                        } finally {
                          setState(() {
                            isLoading = false; // hide loading
                          });
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),

                  Visibility(
                    visible: isLoggedIn,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseService.signOut();
                        isLoggedIn = false;
                        setState(() {});
                      },
                      child: const Text('Logout'),
                    ),
                  ),

                  Text(
                    'Logged in as: ${FirebaseAuth.instance.currentUser?.email ?? "Not logged in"}',
                  ),

                  if (data != null)
                    Visibility(
                      visible: isLoggedIn,
                      child: Text(
                        'Username: ${isLoggedIn ? data!['username'] : "Not logged in"}\nTestvalue: ${isLoggedIn ? data!['testvalue'] : "Not logged in"}',
                      ),
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
                              return ActivityItem(
                                id: activity.id,
                                title: activity.name,
                                description: activity.description,
                                date: activity.date,
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

            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        'Loading...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
