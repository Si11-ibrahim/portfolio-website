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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'How to Play Code Breaker',
            style: TextStyle(
              fontSize: isSmallScreen ? 18.0 : 20.0,
            ),
          ),
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
          contentPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16.0 : 24.0,
            vertical: isSmallScreen ? 8.0 : 16.0,
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16.0 : 40.0,
            vertical: 24.0,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400; // Extra small mobile screens

    // Adjust padding, font sizes, and spacing based on screen size
    final containerPadding = isSmallScreen ? 8.0 : 16.0;
    final headerFontSize = isSmallScreen ? 20.0 : 24.0;
    final elementPadding = isSmallScreen ? 4.0 : 8.0;
    final elementMargin = isSmallScreen ? 2.0 : 4.0;
    final buttonSpacing = isSmallScreen ? 8.0 : 16.0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(containerPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Responsive game header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Code Breaker',
                    style: TextStyle(
                      fontSize: headerFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: _showTutorialDialog,
                  tooltip: 'How to Play',
                  padding: EdgeInsets.all(isSmallScreen ? 4.0 : 8.0),
                  constraints: BoxConstraints(
                    minWidth: isSmallScreen ? 36 : 48,
                    minHeight: isSmallScreen ? 36 : 48,
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 8.0 : 16.0),
            Text(
              'Break the code by arranging the brackets in the correct order!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 14.0 : 16.0,
              ),
            ),
            SizedBox(height: isSmallScreen ? 16.0 : 24.0),

            // Responsive controls - wrap into rows for smaller screens if needed
            Wrap(
              alignment: WrapAlignment.center,
              spacing: elementMargin * 2,
              runSpacing: elementMargin * 2,
              children: _codeElements.map((element) {
                return ElevatedButton(
                  onPressed: () => _addToGuess(element),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: elementPadding * 1.5,
                      vertical: elementPadding,
                    ),
                    minimumSize:
                        Size(isSmallScreen ? 40 : 50, isSmallScreen ? 36 : 40),
                  ),
                  child: Text(element),
                );
              }).toList(),
            ),
            SizedBox(height: isSmallScreen ? 12.0 : 16.0),

            // Current guess display - adapts to screen size
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ..._currentGuess.map((element) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: elementMargin),
                    padding: EdgeInsets.all(elementPadding),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      element,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14.0 : 16.0,
                      ),
                    ),
                  );
                }),
                ...List.generate(4 - _currentGuess.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: elementMargin),
                    padding: EdgeInsets.all(elementPadding),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ' ',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14.0 : 16.0,
                      ),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: isSmallScreen ? 12.0 : 16.0),

            // Game controls - more compact for small screens
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use icon button on small screens to save space
                isSmallScreen
                    ? ElevatedButton.icon(
                        onPressed: _removeLastGuess,
                        icon: const Icon(Icons.backspace_outlined, size: 18),
                        label: const Text('Back'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6.0,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _removeLastGuess,
                        child: const Text('Backspace'),
                      ),
                SizedBox(width: buttonSpacing),
                ElevatedButton(
                  onPressed: _submitGuess,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16.0 : 20.0,
                      vertical: isSmallScreen ? 6.0 : 10.0,
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 16.0 : 24.0),

            // Responsive scrollable area for previous guesses
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  // Adjust height based on screen size
                  maxHeight: isSmallScreen ? 200 : 300,
                  minHeight: isSmallScreen ? 100 : 150,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _previousGuesses.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          child: Text(
                            'Your previous guesses will appear here',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontSize: isSmallScreen ? 12.0 : 14.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 4.0 : 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                _previousGuesses.asMap().entries.map((entry) {
                              int index = entry.key;
                              List<String> guess = entry.value;
                              List<int> scores = _previousScores[index];

                              // For very small screens, use a more compact layout
                              if (isSmallScreen) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Guess display
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: guess.map((element) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              element,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 4),
                                      // Scores below the guess
                                      Text(
                                        '🎯 ${scores[0]} exact  •  🔄 ${scores[1]} misplaced',
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                // For larger screens, use the original side-by-side layout
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...guess.map((element) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: elementMargin),
                                          padding:
                                              EdgeInsets.all(elementPadding),
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
                              }
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ),

            // Congratulations message - responsive
            if (_showCongrats) ...[
              SizedBox(height: isSmallScreen ? 16.0 : 24.0),
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Text(
                      '🎉 Congratulations! You broke the code! 🎉',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 12.0 : 16.0),
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
              SizedBox(height: isSmallScreen ? 12.0 : 16.0),
            ],
          ],
        ),
      ),
    );
  }
}
