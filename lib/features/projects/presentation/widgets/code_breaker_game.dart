import 'dart:math';

import 'package:flutter/material.dart';

class CodeBreakerGame extends StatefulWidget {
  const CodeBreakerGame({super.key});

  @override
  State<CodeBreakerGame> createState() => _CodeBreakerGameState();
}

class _CodeBreakerGameState extends State<CodeBreakerGame> {
  final List<String> _codeElements = ['[]', '{}', '()', '<>'];
  late List<String> _targetCode;
  List<String> _currentGuess = [];
  List<List<String>> _previousGuesses = [];
  List<List<int>> _previousScores =
      []; // Changed to store [exact, partial] matches
  bool _showCongrats = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _targetCode = List.generate(4, (index) {
      return _codeElements[Random().nextInt(_codeElements.length)];
    });
    _currentGuess = [];
    _previousGuesses = [];
    _previousScores = [];
    _showCongrats = false;
  }

  void _addToGuess(String element) {
    if (_currentGuess.length < 4) {
      setState(() {
        _currentGuess.add(element);
      });
    }
  }

  void _removeLastGuess() {
    if (_currentGuess.isNotEmpty) {
      setState(() {
        _currentGuess.removeLast();
      });
    }
  }

  void _submitGuess() {
    if (_currentGuess.length != 4) return;

    // Create copies of arrays to track matches
    List<String> remainingTarget = List.from(_targetCode);
    List<String> remainingGuess = List.from(_currentGuess);
    List<bool> matchedIndices = List.generate(4, (_) => false);
    List<bool> usedGuessIndices = List.generate(4, (_) => false);

    // First pass: Find exact matches
    int exactMatches = 0;
    for (int i = 0; i < 4; i++) {
      if (_currentGuess[i] == _targetCode[i]) {
        exactMatches++;
        matchedIndices[i] = true;
        usedGuessIndices[i] = true;
        remainingTarget[i] = '';
        remainingGuess[i] = '';
      }
    }

    // Second pass: Find partial matches (right bracket, wrong position)
    int partialMatches = 0;
    for (int i = 0; i < 4; i++) {
      if (usedGuessIndices[i]) continue;
      for (int j = 0; j < 4; j++) {
        if (matchedIndices[j]) continue;
        if (remainingGuess[i] == remainingTarget[j] &&
            remainingGuess[i].isNotEmpty) {
          partialMatches++;
          matchedIndices[j] = true;
          usedGuessIndices[i] = true;
          break;
        }
      }
    }

    setState(() {
      _previousGuesses.add(List.from(_currentGuess));
      _previousScores.add([exactMatches, partialMatches]);
      _currentGuess = [];

      if (exactMatches == 4) {
        _showCongrats = true;
      }
    });
  }

  void _showTutorialDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How to Play Code Breaker'),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎯 Goal:'),
                Text('Guess the correct sequence of 4 bracket pairs.'),
                SizedBox(height: 16),
                Text('📝 Rules:'),
                Text('1. Each position can be one of: [], {}, (), <>'),
                Text('2. The same bracket pair can appear multiple times'),
                Text('3. After each guess, you\'ll see two scores:'),
                Text('   • 🎯 Exact - brackets in correct position'),
                Text('   • 🔄 Misplaced - correct brackets in wrong position'),
                SizedBox(height: 16),
                Text('🎮 How to Play:'),
                Text('1. Click the bracket buttons to build your guess'),
                Text('2. Use backspace to remove the last bracket'),
                Text('3. Submit your guess when you have 4 brackets'),
                Text('4. Use the scores to deduce the correct sequence'),
                SizedBox(height: 16),
                Text('💡 Tips:'),
                Text('• If you see 2🎯 1🔄, you have 3 correct brackets total'),
                Text('• Focus on positions with exact matches first'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed game header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Code Breaker',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: _showTutorialDialog,
                  tooltip: 'How to Play',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Break the code by arranging the brackets in the correct order!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Fixed controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _codeElements.map((element) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _addToGuess(element),
                    child: Text(element),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Current guess display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ..._currentGuess.map((element) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(element),
                  );
                }),
                ...List.generate(4 - _currentGuess.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(' '),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Game controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _removeLastGuess,
                  child: const Text('Backspace'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _submitGuess,
                  child: const Text('Submit'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Scrollable area for previous guesses
            Flexible(
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 300, // Fixed height for scrollable area
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _previousGuesses.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Your previous guesses will appear here',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                _previousGuesses.asMap().entries.map((entry) {
                              int index = entry.key;
                              List<String> guess = entry.value;
                              List<int> scores = _previousScores[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...guess.map((element) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(element),
                                      );
                                    }),
                                    const SizedBox(width: 16),
                                    Flexible(
                                      child: Text(
                                        '🎯 ${scores[0]} exact  •  🔄 ${scores[1]} misplaced',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ),

            // Congratulations message
            if (_showCongrats) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    const Text(
                      '🎉 Congratulations! You broke the code! 🎉',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _initializeGame();
                        });
                      },
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
