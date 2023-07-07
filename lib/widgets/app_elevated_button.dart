import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  const AppElevatedButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.shade100,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          )
        ],
        gradient: RadialGradient(
          colors: [Color(0xff0070BA), Color(0xff1546A0)],
          radius: 8.4,
          center: Alignment(-0.24, -0.36),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
