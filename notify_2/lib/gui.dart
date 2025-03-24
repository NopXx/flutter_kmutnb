// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notify_2/noti.dart';

class GUI extends StatefulWidget {
  const GUI({super.key});

  @override
  State<GUI> createState() => _GUIState();
}

class _GUIState extends State<GUI> {
  Noti noti = Noti();
  final TextEditingController _idController = TextEditingController();
  List<PendingNotificationRequest> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadPendingNotifications(); // Load notifications when widget initializes
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> _loadPendingNotifications() async {
    final List<PendingNotificationRequest> pending =
        await noti.listAllpending();
    setState(() {
      _pendingNotifications = pending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nopparat 6606021421012'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          noti.showNotification();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications, color: Colors.blue,),
                            SizedBox(width: 8),
                            Text('Show Notification'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? alarm = await noti.settime(context);
                          if (alarm != null) {
                            try {
                              await noti.schedule(alarm.hour, alarm.minute);
                              log(alarm.toString());
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Notification scheduled for ${alarm.format(context)}'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              _loadPendingNotifications();
                            } catch (e) {
                              log(e.toString());
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Failed to schedule: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.alarm_add, color: Colors.blue,),
                            SizedBox(width: 8),
                            Text('Schedule Alarm Notification'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await noti.schedule15s();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Notification scheduled for 15 seconds from now'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _loadPendingNotifications();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications, color: Colors.deepOrange,),
                            SizedBox(width: 8),
                            Text('Show Notification in 15 seconds'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _loadPendingNotifications();
                          },
                          child: const Text('List Pending Notifications'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            await noti.cancelAll();
                            if (!mounted) return; // Added mounted check
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All notifications canceled'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text(
                            'Cancel All Notifications',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          // This is now properly nested inside another Expanded
                          child: _pendingNotifications.isEmpty
                              ? const Center(
                                  child: Text('No pending notifications'))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _pendingNotifications.length,
                                  itemBuilder: (context, index) {
                                    final notification =
                                        _pendingNotifications[index];
                                    return ListTile(
                                      title: Text(
                                          'ID: ${notification.id} - ${notification.title ?? "No Title"}'),
                                      subtitle:
                                          Text(notification.body ?? "No Body"),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.cancel,
                                            color: Colors.red),
                                        onPressed: () async {
                                          await noti
                                              .cancelbyID(notification.id);
                                          _loadPendingNotifications();
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
