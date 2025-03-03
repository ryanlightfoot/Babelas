import 'package:flutter/material.dart';
import 'dart:math';
import '../models/player.dart';

class GamePage extends StatefulWidget {
  final List<Player> players;
  
  const GamePage({Key? key, required this.players}) : super(key: key);
  
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  final List<String> cardValues = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
  final List<String> suits = ['♠', '♥', '♦', '♣'];
  final Map<String, String> cardDescriptions = {
    'A': 'Waterfall: Everyone starts drinking at the same time, following the person who drew the card. When the person who drew the card stops, then the person to their right can stop, and so on.',
    '2': 'You: The player who drew the card chooses someone else to drink.',
    '3': 'Me: The person who drew the card takes a drink.',
    '4': 'Floor: Last person to touch the floor drinks. This is usually done by touching the ground with your hand.',
    '5': 'Guys: All male players drink.',
    '6': 'Chicks: All female players drink.',
    '7': 'Heaven: Last person to raise their hand drinks.',
    '8': 'Mate: The player who drew the card chooses another player to be their "drinking buddy." When one drinks, the other must also drink for the rest of the game.',
    '9': 'Rhyme: The player who drew the card says a word, and everyone must say a word that rhymes with it. The first person to mess up or repeat a word drinks.',
    '10': 'Categories: The player who drew the card chooses a category (like "types of cars" or "movie stars"), and everyone takes turns naming something in that category. The first person who can\'t think of an item or repeats an item drinks.',
    'J': 'Rule: The player who drew the card creates a rule that everyone must follow for the rest of the game. Breaking the rule results in drinking.',
    'Q': 'Question Master: Whoever draws this card becomes the Question Master. If anyone answers a direct question from the Question Master, they must drink.',
    'K': 'Kings Cup: When a King is drawn, the player pours some of their drink into the center cup (the Kings Cup). The person who draws the fourth King drinks the entire center cup, which is usually a mix of different alcoholic beverages.',
  };
  
  List<String> deck = [];
  String currentCard = 'Press the button to draw a card';
  String currentDescription = '';
  int kingsDrawn = 0;
  bool isGameOver = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  // Add player management
  late Player currentPlayer;
  int currentPlayerIndex = 0;
  
  bool isFirstTurn = true;
  
  @override
  void initState() {
    super.initState();
    _initializeDeck();
    currentPlayer = widget.players[0];
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeDeck() {
    deck = [];
    for (var value in cardValues) {
      for (var suit in suits) {
        deck.add('$value$suit');
      }
    }
    deck.shuffle();
  }

  void _drawCard() {
    if (isGameOver) return;
    
    _animationController.forward().then((_) {
      if (deck.isEmpty) {
        setState(() {
          currentCard = 'No cards left! Reshuffling...';
          currentDescription = '';
        });
        _initializeDeck();
      } else {
        setState(() {
          isFirstTurn = false;
          currentCard = deck.removeLast();
          currentDescription = cardDescriptions[currentCard.startsWith('10') ? '10' : currentCard[0]] ?? '';
          
          if (currentCard[0] == 'K') {
            kingsDrawn++;
            if (kingsDrawn == 4) {
              isGameOver = true;
              currentDescription = 'GAME OVER! Down the Kings Cup!';
            }
          }
          
          // Move to next player
          currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
          currentPlayer = widget.players[currentPlayerIndex];
        });
      }
      _animationController.reverse();
    });
  }

  Color _getCardColor() {
    if (currentCard.contains('♥') || currentCard.contains('♦')) {
      return Colors.red;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double yellowHeight = (kingsDrawn / 4) * screenHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.shade50,
                  Colors.white,
                ],
              ),
            ),
          ),
          // Kings progress indicator
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: yellowHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange.withOpacity(0.1), Colors.orange.shade200],
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Only show player's turn if not first turn
                    if (!isFirstTurn) ...[
                      Text(
                        '${currentPlayer.name}\'s Turn',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                    // Card display
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          currentCard,
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: _getCardColor(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    // Rule description
                    if (currentDescription.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          currentDescription,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(height: 32),
                    // Action buttons
                    if (!isGameOver)
                      ElevatedButton(
                        onPressed: _drawCard,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Draw Card',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Back to Main Menu',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    SizedBox(height: 16),
                    // Kings counter
                    if (!isGameOver)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${4 - kingsDrawn} Kings remaining',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 