import 'package:googleapis/calendar/v3.dart'
    as calendar; // Required for Google Calendar API
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'google_calendar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting

class CalDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Calendar Integration')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Sign in with Google and authenticate with Firebase
                User? user = await signInWithGoogle();
                if (user != null) {
                  final client = await getGoogleAuthClient();
                  if (client != null) {
                    // Open dialog to collect event details
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EventDialog(client: client);
                      },
                    );
                  } else {
                    print("Error: Could not authenticate with Google Calendar");
                  }
                } else {
                  print("Error: User not signed in");
                }
              },
              child: Text('Sign in with Google and Create Event'),
            ),
            ElevatedButton(
              onPressed: () async {
                await signOut(); // Sign out from Firebase and Google
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User Signed Out')),
                );
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDialog extends StatefulWidget {
  final AuthClient client;

  EventDialog({required this.client});

  @override
  _EventDialogState createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Event'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await _pickDateTime();
                  if (pickedDate != null) {
                    setState(() {
                      _startDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _startDate == null
                      ? 'Pick Start Date & Time'
                      : DateFormat('yyyy-MM-dd HH:mm').format(_startDate!),
                ),
              ),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await _pickDateTime();
                  if (pickedDate != null) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _endDate == null
                      ? 'Pick End Date & Time'
                      : DateFormat('yyyy-MM-dd HH:mm').format(_endDate!),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() &&
                _startDate != null &&
                _endDate != null) {
              await createCustomEvent(
                widget.client,
                _titleController.text,
                _locationController.text,
                _descriptionController.text,
                _startDate!,
                _endDate!,
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Event Created in Google Calendar')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill all fields')),
              );
            }
          },
          child: Text('Create'),
        ),
      ],
    );
  }

  Future<DateTime?> _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return null;
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

Future<void> createCustomEvent(AuthClient client, String title, String location,
    String description, DateTime start, DateTime end) async {
  try {
    final calendarApi = calendar.CalendarApi(client);

    final event = calendar.Event(
      summary: title,
      location: location,
      description: description,
      start: calendar.EventDateTime(
        dateTime: start,
        timeZone: 'GMT',
      ),
      end: calendar.EventDateTime(
        dateTime: end,
        timeZone: 'GMT',
      ),
    );

    final calendarEvent = await calendarApi.events.insert(event, 'primary');
    print('Event created: ${calendarEvent.summary}');
  } catch (e) {
    print('Error creating event: $e');
  }
}
