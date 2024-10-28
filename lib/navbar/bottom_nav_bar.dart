import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Main Content",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expandable buttons
          if (_isExpanded) ...[
            _buildExpandableButtonWithLabel(Icons.star, "Star", () {
              print('Star button pressed');
            }),
            const SizedBox(height: 10),
            _buildExpandableButtonWithLabel(Icons.task, "Task", () {
              print('Task button pressed');
            }),
            const SizedBox(height: 10),
            _buildExpandableButtonWithLabel(Icons.person, "Person", () {
              print('Person button pressed');
            }),
            const SizedBox(height: 10),
            _buildExpandableButtonWithLabel(Icons.receipt, "Receipt", () {
              print('Receipt button pressed');
            }),
            const SizedBox(height: 10),
          ],
          // Main FAB
          FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 0,
            onPressed: _toggleMenu,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Colors.teal),
              borderRadius: BorderRadius.circular(100),
            ),
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        pageIndex: 0,
        onTap: (index) {
          print("Navigated to tab: $index");
        },
      ),
    );
  }

  Widget _buildExpandableButtonWithLabel(IconData icon, String label, VoidCallback onPressed) {
    return FloatingActionButton(
      mini: true,
      onPressed: onPressed,
      backgroundColor: Colors.teal,
      child: Icon(icon, color: Colors.white),
    );
  }
}

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 60,
        color:Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navItem(
              icon: Icons.home_outlined,
              selected: pageIndex == 0,
              onTap: () => onTap(0),
            ),
            const SizedBox(width: 80), // Space for the FAB
            navItem(
              icon: Icons.person_outline,
              selected: pageIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem({required IconData icon, required bool selected, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}
