import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendarPage extends StatefulWidget {
  @override
  _CustomCalendarPageState createState() => _CustomCalendarPageState();
}

class _CustomCalendarPageState extends State<CustomCalendarPage> {
  late Map<DateTime, List<String>> _events;
  late List<String> _selectedEvents;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    // Sample events
    _events = {
      DateTime.utc(2024, 10, 5): ['Team Meeting', 'Project Update', 'Project Update', 'Project Update', 'Project Update', 'Project Update' 'Project Update'],
      DateTime.utc(2024, 10, 15): ['Product Launch'],
      DateTime.utc(2024, 10, 15): ['Product Launch'],
      DateTime.utc(2024, 10, 15): ['Product Launch'],
      DateTime.utc(2024, 10, 22): ['HR Workshop'],
      DateTime.utc(2024, 10, 28): ['Quarterly Review', 'Team Building Activity' , 'Team Building Activity' , 'Team Building Activity' , 'Team Building Activity'],
    };

    // Load today's events by default
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  void _loadSelectedEvents(DateTime day) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = _events[day] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Task'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // Calendar Widget
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2023, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  _loadSelectedEvents(selectedDay);
                  setState(() {
                    _focusedDay = focusedDay; // Update the focused day
                  });
                },
                eventLoader: (day) => _events[day] ?? [],
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.3),
                    shape: BoxShape.rectangle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.rectangle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.tealAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    bool hasEvent = _events.containsKey(date);
                    return Container(
                      margin: const EdgeInsets.all(4.0), // Margin for dates
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hasEvent ? Colors.teal : Colors.grey,
                          width: 1.5,
                        ),
                        color: hasEvent ? Colors.teal.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: hasEvent ? Colors.teal : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Event Details Card
            _selectedEvents.isNotEmpty
                ? EventCard(selectedEvents: _selectedEvents)
                : Center(
              child: Text(
                'No Events for Selected Date',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final List<String> selectedEvents;

  const EventCard({Key? key, required this.selectedEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Events',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          ...selectedEvents.map((event) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.event, color: Colors.teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    event,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
