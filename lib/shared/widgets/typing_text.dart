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
    this.pauseDuration = const Duration(seconds: 2),
    this.deletingSpeed = const Duration(milliseconds: 50),
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  late String _currentText;
  late int _currentIndex;
  late bool _isDeleting;
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _currentText = widget.texts[_currentIndex];
    _isDeleting = false;
    _startTypingAnimation();
  }

  Future<void> _startTypingAnimation() async {
    while (mounted) {
      await Future.delayed(
        _isDeleting ? widget.deletingSpeed : widget.typingSpeed,
      );

      if (!mounted) return;

      setState(() {
        if (!_isDeleting) {
          if (_displayedText.length < _currentText.length) {
            _displayedText =
                _currentText.substring(0, _displayedText.length + 1);
          } else {
            _isDeleting = true;
            return;
          }
        } else {
          if (_displayedText.isNotEmpty) {
            _displayedText =
                _displayedText.substring(0, _displayedText.length - 1);
          } else {
            _isDeleting = false;
            _currentIndex = (_currentIndex + 1) % widget.texts.length;
            _currentText = widget.texts[_currentIndex];
          }
        }
      });

      if (!_isDeleting && _displayedText.length == _currentText.length) {
        await Future.delayed(widget.pauseDuration);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _displayedText,
          style: widget.style,
        ),
        _buildCursor(),
      ],
    );
  }

  Widget _buildCursor() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _displayedText.length == _currentText.length ? 0.0 : 1.0,
      child: Text(
        '|',
        style: widget.style,
      ),
    );
  }
}
