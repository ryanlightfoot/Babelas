import 'package:flutter/material.dart';
import '../models/player.dart';
import 'dart:math';

class Action {
  final String message;
  final int weight;

  Action({required this.message, required this.weight});
}

class StripGamePage extends StatefulWidget {
  final List<Player> players;

  const StripGamePage({Key? key, required this.players}) : super(key: key);

  @override
  _StripGamePageState createState() => _StripGamePageState();
}

class _StripGamePageState extends State<StripGamePage> {
  late Player currentPlayer;
  int currentPlayerIndex = 0;
  final Random random = Random();

  // List of actions with their weights
  final List<Action> actions = [
    Action(
      message: 'Take a drink',
      weight: 10, // Common
    ),
    Action(
      message: 'choose an item of clothing to swap with [PLAYER]',
      weight: 5, // Common
    ),
    Action(
      message: 'Everyone drinks',
      weight: 10, // Common
    ),
    Action(
      message: 'Everyone rotates one item of clothing to the left',
      weight: 5, // Very Rare
    ),
    Action(
      message: 'Rock-Paper-Scissors with [PLAYER]. Loser removes an item',
      weight: 10, // Moderate
    ),
    Action(
      message: 'Remove an item of clothing',
      weight: 5, // Common
    ),
    Action(
      message: 'Put on an item of clothing from the removed pile',
      weight: 5, // Less common
    ),
    Action(
      message: 'Remove an item of clothing from [PLAYER]',
      weight: 5, // Rare
    ),
    Action(
      message: 'Swap a clothing item with [PLAYER]',
      weight: 10, // Rare
    ),
  ];

  String _getRandomAction() {
    // Calculate total weight
    int totalWeight = actions.fold(0, (sum, action) => sum + action.weight);
    
    // Get random number between 0 and total weight
    int randomNumber = random.nextInt(totalWeight);
    
    // Find the selected action
    int currentWeight = 0;
    for (var action in actions) {
      currentWeight += action.weight;
      if (randomNumber < currentWeight) {
        // If action contains [PLAYER], replace it with a random player name
        if (action.message.contains('[PLAYER]')) {
          List<Player> otherPlayers = List.from(widget.players)
            ..removeWhere((player) => player == currentPlayer);
          Player randomPlayer = otherPlayers[random.nextInt(otherPlayers.length)];
          return action.message.replaceAll('[PLAYER]', randomPlayer.name);
        }
        return action.message;
      }
    }
    return actions.first.message; // Fallback
  }

  void _nextTurn() {
    setState(() {
      currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
      currentPlayer = widget.players[currentPlayerIndex];
      currentAction = _getRandomAction();
    });
  }

  late String currentAction;

  @override
  void initState() {
    super.initState();
    currentPlayer = widget.players[0];
    currentAction = _getRandomAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothes swap'),
      ),
      body: Container(
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
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${currentPlayer.name}\'s Turn',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
                SizedBox(height: 40),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      currentAction,
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _nextTurn,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Text(
                      'Next Turn',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
