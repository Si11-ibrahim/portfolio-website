import 'package:flutter/material.dart';

class TerminalIntro extends StatefulWidget {
  const TerminalIntro({super.key});

  @override
  State<TerminalIntro> createState() => _TerminalIntroState();
}

class _TerminalIntroState extends State<TerminalIntro> {
  final List<String> _lines = [];
  int _currentLine = 0;
  final List<String> _script = [
    'Loading developer profile...',
    'Initializing skills database...',
    'Connecting to project repository...',
    'Welcome to my portfolio!',
    'Type "help" for available commands',
  ];

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  Future<void> _startTyping() async {
    for (var line in _script) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _lines.add(line);
        _currentLine++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._lines.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Text(
                      '> ',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      line,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              )),
          if (_currentLine < _script.length)
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: BlinkingCursor(),
            ),
        ],
      ),
    );
  }
}

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const Text(
        '█',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'monospace',
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
