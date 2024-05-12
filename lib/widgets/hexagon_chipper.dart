import 'package:flutter/material.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;
    final double middle = width / 2;

    path.moveTo(0, height / 2);
    path.lineTo(middle / 2, 0);
    path.lineTo(middle + (middle / 2), 0);
    path.lineTo(width, height / 2);
    path.lineTo(middle + (middle / 2), height);
    path.lineTo(middle / 2, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HexagonContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget child;

  const HexagonContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        width: width,
        height: height,
        color: color,
        child: child,
      ),
    );
  }
}