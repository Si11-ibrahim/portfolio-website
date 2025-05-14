import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration pauseDuration;
  final Duration deletingSpeed;

  const TypingText({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(milliseconds: 2000),
    this.deletingSpeed = const Duration(milliseconds: 50),
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  late String _currentText;
  late int _textIndex;
  late int _charIndex;
  late bool _isTyping;
  late bool _isPaused;

  @override
  void initState() {
    super.initState();
    _currentText = '';
    _textIndex = 0;
    _charIndex = 0;
    _isTyping = true;
    _isPaused = false;
    _startTypingAnimation();
  }

  void _startTypingAnimation() async {
    while (mounted) {
      if (_isTyping) {
        // Typing phase
        if (_charIndex < widget.texts[_textIndex].length) {
          setState(() {
            _currentText =
                widget.texts[_textIndex].substring(0, _charIndex + 1);
            _charIndex++;
          });
          await Future.delayed(widget.typingSpeed);
        } else {
          // Finished typing current text
          _isTyping = false;
          _isPaused = true;
          await Future.delayed(widget.pauseDuration);
          _isPaused = false;
        }
      } else {
        // Deleting phase
        if (_charIndex > 0) {
          setState(() {
            _currentText =
                widget.texts[_textIndex].substring(0, _charIndex - 1);
            _charIndex--;
          });
          await Future.delayed(widget.deletingSpeed);
        } else {
          // Move to next text
          _textIndex = (_textIndex + 1) % widget.texts.length;
          _isTyping = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _currentText,
          style: widget.style,
        ),
        _buildCursor(),
      ],
    );
  }

  Widget _buildCursor() {
    return AnimatedOpacity(
      opacity: _isPaused ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 500),
      child: Text(
        '|',
        style: widget.style,
      ),
    );
  }
}
