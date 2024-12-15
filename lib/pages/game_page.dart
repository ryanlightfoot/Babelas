import 'package:flutter/material.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
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

  @override
  void initState() {
    super.initState();
    _initializeDeck();
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
    
    if (deck.isEmpty) {
      setState(() {
        currentCard = 'No cards left! Reshuffling...';
        currentDescription = '';
      });
      _initializeDeck();
      return;
    }

    setState(() {
      currentCard = deck.removeLast();
      currentDescription = cardDescriptions[currentCard[0]] ?? '';
      
      if (currentCard[0] == 'K') {
        kingsDrawn++;
        if (kingsDrawn == 4) {
          isGameOver = true;
          currentDescription = 'GAME OVER! Down the Kings Cup!';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Babelas'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  currentCard,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                if (currentDescription.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentDescription,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 20),
                if (!isGameOver)
                  ElevatedButton(
                    onPressed: _drawCard,
                    child: Text('Draw Card'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Back to Main Menu'),
                  ),
                SizedBox(height: 10),
                if (!isGameOver)
                  Text(
                    '${4 - kingsDrawn} Kings remaining',
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 