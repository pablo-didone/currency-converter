import 'package:flutter/material.dart';

class CardLayout extends StatelessWidget {
  final Widget child;

  CardLayout({this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(15),
        child: child,
      ),
    );
  }
}
