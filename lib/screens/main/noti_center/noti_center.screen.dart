import 'package:flutter/material.dart';

class NotifCenterScreen extends StatefulWidget {
  const NotifCenterScreen({super.key});

  @override
  State<NotifCenterScreen> createState() => _NotifCenterScreenState();
}

class _NotifCenterScreenState extends State<NotifCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Noti Center',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
