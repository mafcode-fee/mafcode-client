import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.indigo,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "MafCode",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 35,
            right: 0,
            top: 0,
            bottom: 70,
            child: Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
          ),
          Positioned(
            left: 0,
            right: 35,
            top: 70,
            bottom: 0,
            child: Icon(
              Icons.people,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
