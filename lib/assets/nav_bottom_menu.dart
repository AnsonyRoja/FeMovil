import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function() onAddPressed;
  final Function() onRefreshPressed;
  final Function() onBackPressed;

  const CustomBottomNavigationBar({
    super.key,
    required this.onAddPressed,
    required this.onRefreshPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFloatingActionButton(
              onPressed: onAddPressed,
              icon: Icons.add,
            ),
            const SizedBox(width: 20),
            _buildFloatingActionButton(
              onPressed: onRefreshPressed,
              icon: Icons.refresh,
            ),
            const SizedBox(width: 20),
            _buildFloatingActionButton(
              onPressed: onBackPressed,
              icon: Icons.arrow_back,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return FloatingActionButton(
      heroTag: icon.toString(),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
