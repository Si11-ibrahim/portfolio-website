import 'dart:math' as math;

import 'package:flutter/material.dart';

class TechStackCube extends StatefulWidget {
  const TechStackCube({super.key});

  @override
  State<TechStackCube> createState() => _TechStackCubeState();
}

class _TechStackCubeState extends State<TechStackCube>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_animation.value)
            ..rotateY(_animation.value),
          alignment: Alignment.center,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              children: [
                // Front
                Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0, 100.0),
                  child: _buildFace('Flutter', Colors.blue),
                ),
                // Back
                Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0, -100.0),
                  child: _buildFace('Firebase', Colors.amber),
                ),
                // Right
                Transform(
                  transform: Matrix4.identity()
                    ..rotateY(math.pi / 2)
                    ..translate(100.0, 0.0, 0.0),
                  child: _buildFace('Dart', Colors.teal),
                ),
                // Left
                Transform(
                  transform: Matrix4.identity()
                    ..rotateY(-math.pi / 2)
                    ..translate(-100.0, 0.0, 0.0),
                  child: _buildFace('REST', Colors.purple),
                ),
                // Top
                Transform(
                  transform: Matrix4.identity()
                    ..rotateX(-math.pi / 2)
                    ..translate(0.0, -100.0, 0.0),
                  child: _buildFace('Git', Colors.orange),
                ),
                // Bottom
                Transform(
                  transform: Matrix4.identity()
                    ..rotateX(math.pi / 2)
                    ..translate(0.0, 100.0, 0.0),
                  child: _buildFace('Python', Colors.blue[900]!),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..rotateX(math.pi / 2)
                    ..translate(0.0, 100.0, 0.0),
                  child: _buildFace('Node.js', Colors.green[900]!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFace(String text, Color color) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
