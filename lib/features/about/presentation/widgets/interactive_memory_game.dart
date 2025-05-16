import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class InteractiveMemoryGame extends StatefulWidget {
  const InteractiveMemoryGame({super.key});

  @override
  State<InteractiveMemoryGame> createState() => _InteractiveMemoryGameState();
}

class _InteractiveMemoryGameState extends State<InteractiveMemoryGame> {
  // Game configuration
  final int _numPairs = 6;
  late List<CardItem> _items;

  // Game state
  bool _isGameActive = false;
  bool _isProcessing = false;
  int? _firstSelectedIndex;
  int? _secondSelectedIndex;
  int _attempts = 0;
  int _matches = 0;
  int _bestScore = 0;
  Timer? _turnTimer;
  Timer? _confettiTimer;
  bool _showConfetti = false;

  // Define card items with programming-related icons
  final List<CardItem> _allCardItems = [
    CardItem(icon: Icons.code, color: Colors.blue),
    CardItem(icon: Icons.integration_instructions, color: Colors.green),
    CardItem(icon: Icons.bug_report, color: Colors.red),
    CardItem(icon: Icons.storage, color: Colors.purple),
    CardItem(icon: Icons.cloud, color: Colors.cyan),
    CardItem(icon: Icons.devices, color: Colors.orange),
    CardItem(icon: Icons.web, color: Colors.indigo),
    CardItem(icon: Icons.animation, color: Colors.pink),
    CardItem(icon: Icons.api, color: Colors.teal),
    CardItem(icon: Icons.data_object, color: Colors.amber),
    CardItem(icon: Icons.terminal, color: Colors.grey),
    CardItem(icon: Icons.security, color: Colors.deepPurple),
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Cancel any ongoing timers
    _turnTimer?.cancel();
    _confettiTimer?.cancel();

    // Randomly select card pairs from all available cards
    final random = Random();
    final selectedItems = List<CardItem>.from(_allCardItems)..shuffle(random);

    // Take only the number of pairs we want for this game
    final gamePairs = selectedItems.take(_numPairs).toList();

    // Create pairs of each card (duplicating the items)
    // Note: copyWith() now resets isFlipped and isMatched to false
    _items = [
      ...gamePairs.map((item) => CardItem(icon: item.icon, color: item.color)),
      ...gamePairs.map((item) => CardItem(icon: item.icon, color: item.color)),
    ]..shuffle(random);

    setState(() {
      _isGameActive = false;
      _isProcessing = false;
      _firstSelectedIndex = null;
      _secondSelectedIndex = null;
      _attempts = 0;
      _matches = 0;
      _showConfetti = false;
    });
  }

  void _handleCardTap(int index) {
    if (_isProcessing) return;
    if (_items[index].isMatched) return;
    if (_firstSelectedIndex == index) return;
    if (_secondSelectedIndex != null) return;

    if (!_isGameActive) {
      setState(() {
        _isGameActive = true;
      });
    }

    // Flip the card
    setState(() {
      _items[index].isFlipped = true;

      if (_firstSelectedIndex == null) {
        _firstSelectedIndex = index;
      } else {
        _secondSelectedIndex = index;
        _isProcessing = true;
        _checkForMatch();
      }
    });
  }

  void _checkForMatch() {
    final first = _items[_firstSelectedIndex!];
    final second = _items[_secondSelectedIndex!];

    // Increment attempts counter
    _attempts++;

    if (first.icon == second.icon && first.color == second.color) {
      // Cards match
      setState(() {
        first.isMatched = true;
        second.isMatched = true;
        _matches++;
        _isProcessing = false;
        _firstSelectedIndex = null;
        _secondSelectedIndex = null;
      });

      // Check for game completion
      if (_matches == _numPairs) {
        _handleGameComplete();
      }
    } else {
      // Cards don't match, flip them back after a delay
      _turnTimer = Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          first.isFlipped = false;
          second.isFlipped = false;
          _isProcessing = false;
          _firstSelectedIndex = null;
          _secondSelectedIndex = null;
        });
      });
    }
  }

  void _handleGameComplete() {
    // Update best score
    if (_bestScore == 0 || _attempts < _bestScore) {
      _bestScore = _attempts;
    }

    // Show confetti animation
    setState(() {
      _showConfetti = true;
    });

    // Hide confetti after a delay
    _confettiTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _turnTimer?.cancel();
    _confettiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 350;
    final isSmallScreen = screenWidth < 600;

    return Column(
      mainAxisSize: MainAxisSize.min, // Allow the column to size to its content
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Stretch children horizontally
      children: [
        // Game header with controls
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmallScreen ? 8.0 : 16.0,
            vertical: isVerySmallScreen ? 4.0 : 8.0,
          ),
          child: isVerySmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Game title and stats
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Memory Match',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Matches: $_matches/$_numPairs • Attempts: $_attempts',
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (_bestScore > 0)
                          Text(
                            'Best: $_bestScore attempts',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Reset button
                    ElevatedButton.icon(
                      onPressed: _initializeGame,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reset Game'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Game stats
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Memory Match',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Matches: $_matches/$_numPairs • Attempts: $_attempts',
                          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                        ),
                        if (_bestScore > 0)
                          Text(
                            'Best: $_bestScore attempts',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                      ],
                    ),

                    // Reset button
                    ElevatedButton.icon(
                      onPressed: _initializeGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 16,
                          vertical: isSmallScreen ? 8 : 10,
                        ),
                      ),
                    ),
                  ],
                ),
        ),

        const SizedBox(
            height:
                12), // Game instructions - more concise on very small screens
        if (!_isGameActive)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isVerySmallScreen ? 8.0 : 16.0,
                vertical: isVerySmallScreen ? 4.0 : 8.0),
            child: Container(
              padding: EdgeInsets.all(isVerySmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: isVerySmallScreen ? 16 : (isSmallScreen ? 20 : 24),
                  ),
                  SizedBox(width: isVerySmallScreen ? 8 : 12),
                  Expanded(
                    child: Text(
                      isVerySmallScreen
                          ? 'Find all matching pairs!'
                          : 'Tap on any card to begin. Find all matching pairs in the fewest attempts!',
                      style: TextStyle(
                        fontSize:
                            isVerySmallScreen ? 12 : (isSmallScreen ? 14 : 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: isVerySmallScreen ? 8 : 16),
        // Game board - using LayoutBuilder instead of fixed height with scroll
        LayoutBuilder(
          builder: (context, constraints) {
            // Configure game based on screen size
            final crossCount = isVerySmallScreen ? 3 : (isSmallScreen ? 3 : 4);
            final spacing =
                isVerySmallScreen ? 6.0 : (isSmallScreen ? 8.0 : 12.0);

            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isVerySmallScreen ? 8.0 : 16.0),
              // No fixed height - it will adjust based on content
              child: GridView.builder(
                shrinkWrap: true, // Use only the space needed
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: 1.0,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) =>
                    _buildCard(context, index, isVerySmallScreen),
              ),
            );
          },
        ), // Game completion message with confetti
        if (_matches == _numPairs) ...[
          SizedBox(height: isVerySmallScreen ? 8 : 16),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isVerySmallScreen ? 8.0 : 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity, // Make container take full width
                  padding: EdgeInsets.symmetric(
                      horizontal: isVerySmallScreen ? 16 : 24,
                      vertical: isVerySmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Congratulations!',
                        style: TextStyle(
                          fontSize: isVerySmallScreen
                              ? 16
                              : (isSmallScreen ? 18 : 22),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: isVerySmallScreen ? 4 : 8),
                      Text(
                        'You completed the game in $_attempts attempts',
                        style: TextStyle(
                          fontSize: isVerySmallScreen
                              ? 12
                              : (isSmallScreen ? 14 : 16),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isVerySmallScreen ? 12 : 16),
                      ElevatedButton.icon(
                        onPressed: _initializeGame,
                        icon: const Icon(Icons.replay),
                        label: const Text('Play Again'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: isVerySmallScreen ? 12 : 16,
                              vertical: isVerySmallScreen ? 6 : 8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Confetti animation
                if (_showConfetti)
                  for (int i = 0; i < (isVerySmallScreen ? 15 : 30); i++)
                    Positioned(
                      top: Random().nextDouble() *
                          (isVerySmallScreen ? -100 : -200),
                      left: Random().nextDouble() *
                              (isVerySmallScreen ? 300 : 400) -
                          50,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(
                          milliseconds: 1000 + Random().nextInt(2000),
                        ),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              value * (isVerySmallScreen ? 200 : 300),
                            ),
                            child: Opacity(
                              opacity:
                                  value < 0.8 ? 1.0 : 1.0 - (value - 0.8) * 5,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          Icons.star,
                          color: [
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                            Colors.yellow,
                            Colors.purple,
                            Colors.orange,
                          ][Random().nextInt(6)],
                          size: isVerySmallScreen
                              ? 10 + Random().nextDouble() * 14
                              : 16 + Random().nextDouble() * 20,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCard(BuildContext context, int index, bool isVerySmallScreen) {
    final item = _items[index];

    // Use slightly faster animation on smaller screens
    final animationDuration = isVerySmallScreen
        ? const Duration(milliseconds: 300)
        : const Duration(milliseconds: 400);

    return GestureDetector(
      onTap: () => _handleCardTap(index),
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: 0.0,
          end: item.isFlipped ? 1.0 : 0.0,
        ),
        duration: animationDuration,
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * pi),
            alignment: Alignment.center,
            child: value < 0.5
                ? _buildCardBack(isVerySmallScreen)
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildCardFront(item, isVerySmallScreen),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCardBack(bool isVerySmallScreen) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isVerySmallScreen ? 6 : 8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isVerySmallScreen ? 0.15 : 0.2),
            blurRadius: isVerySmallScreen ? 2 : 4,
            offset: Offset(0, isVerySmallScreen ? 1 : 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.code,
          color: Colors.white.withOpacity(0.8),
          size: isVerySmallScreen ? 20 : 30,
        ),
      ),
    );
  }

  Widget _buildCardFront(CardItem item, bool isVerySmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: item.isMatched ? item.color.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(isVerySmallScreen ? 6 : 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isVerySmallScreen ? 0.15 : 0.2),
            blurRadius: isVerySmallScreen ? 2 : 4,
            offset: Offset(0, isVerySmallScreen ? 1 : 2),
          ),
        ],
        border: Border.all(
          color: item.isMatched ? item.color : Colors.grey.withOpacity(0.3),
          width: isVerySmallScreen ? 1 : 2,
        ),
      ),
      child: Center(
        child: Icon(
          item.icon,
          color: item.color,
          size: isVerySmallScreen ? 28 : 40,
        ),
      ),
    );
  }
}

class CardItem {
  final IconData icon;
  final Color color;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.icon,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
  });
  CardItem copyWith() {
    return CardItem(
      icon: icon,
      color: color,
      isFlipped: false,
      isMatched: false,
    );
  }
}
