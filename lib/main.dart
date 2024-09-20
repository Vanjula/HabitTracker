import 'package:flutter/material.dart';

void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Color(0xFFF0F0F0), // Light white shade
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HabitTrackerPage(),
    );
  }
}

class HabitTrackerPage extends StatefulWidget {
  @override
  _HabitTrackerPageState createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  List<Habit> habits = [];
  final _habitController = TextEditingController();
  int? _editingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black, // Ensure background color is black
        elevation: 0, // Remove shadow for a clean look
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0, bottom: 8.0), // Increased padding
              child: Text(
                'Habit Tracker', // Main title
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22, // Adjust font size
                ),
              ),
            ),
            Text(
              'Helps to do your task', // Subtitle
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontSize: 16, // Adjust font size
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _habitController,
                    decoration: InputDecoration(
                      labelText: _editingIndex == null ? 'Enter a new habit' : 'Edit habit',
                      labelStyle: TextStyle(color: Colors.black87),
                      fillColor: Color(0xFFE0E0E0), // Light greyish shade
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Black button background
                    shape: CircleBorder(), // Make it a circle
                    padding: EdgeInsets.all(14), // Add padding for size
                  ),
                  onPressed: _editingIndex == null ? _addHabit : _editHabit,
                  child: Icon(
                    Icons.add, // "+" icon
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: habits.isEmpty
                ? Center(
                    child: Text(
                      'No habits added.',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      return HabitTile(
                        habit: habits[index],
                        onToggle: () {
                          setState(() {
                            habits[index].toggleCompletion();
                          });
                        },
                        onEdit: () {
                          _startEditing(index);
                        },
                        onDelete: () {
                          setState(() {
                            habits.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addHabit() {
    if (_habitController.text.isNotEmpty) {
      setState(() {
        habits.add(Habit(name: _habitController.text));
        _habitController.clear();
      });
    }
  }

  void _editHabit() {
    if (_habitController.text.isNotEmpty) {
      setState(() {
        habits[_editingIndex!] = Habit(name: _habitController.text);
        _editingIndex = null;
        _habitController.clear();
      });
    }
  }

  void _startEditing(int index) {
    setState(() {
      _habitController.text = habits[index].name;
      _editingIndex = index;
    });
  }
}

class Habit {
  String name;
  bool completed;

  Habit({required this.name, this.completed = false});

  void toggleCompletion() {
    completed = !completed;
  }
}

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitTile({
    Key? key,
    required this.habit,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8, // Add shadow effect to the card
      shadowColor: Colors.black54,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: GestureDetector(
          onTap: onToggle,
          child: Icon(
            habit.completed ? Icons.check_circle : Icons.circle_outlined,
            color: habit.completed ? Colors.black87 : Colors.grey,
            size: 32,
          ),
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 18,
            decoration: habit.completed ? TextDecoration.lineThrough : null,
            color: habit.completed ? Colors.black87 : Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black.withOpacity(0.7)), // Edit icon with black and white mixed color
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400]), // Delete icon
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
