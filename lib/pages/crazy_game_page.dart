import 'package:flutter/material.dart';
import '../models/player.dart';
import 'dart:math';

class Action {
  final String message;
  final int weight;
  final String category;

  Action({
    required this.message, 
    required this.weight,
    required this.category
  });
}

class CrazyGamePage extends StatefulWidget {
  final List<Player> players;

  const CrazyGamePage({Key? key, required this.players}) : super(key: key);

  @override
  _CrazyGamePageState createState() => _CrazyGamePageState();
}

class _CrazyGamePageState extends State<CrazyGamePage> {
  late Player currentPlayer;
  int currentPlayerIndex = 0;
  final Random random = Random();

  // List of actions with their weights and categories
  final List<Action> actions = [
    // Drinking actions (higher weights)
    Action(
      message: 'Take a shot',
      weight: 30,
      category: 'drinking',
    ),
    Action(
      message: 'Take 2 sips of your drink',
      weight: 35,
      category: 'drinking',
    ),
    Action(
      message: 'Everyone drinks',
      weight: 25,
      category: 'drinking',
    ),
    Action(
      message: 'Give out 3 sips to any player',
      weight: 25,
      category: 'drinking',
    ),

    // Strip actions (medium weights)
    Action(
      message: 'Remove one item of clothing',
      weight: 20,
      category: 'strip',
    ),
    Action(
      message: 'Put on an item of clothing from the removed pile',
      weight: 15,
      category: 'strip',
    ),
    Action(
      message: 'Exchange an item of clothing with [PLAYER]',
      weight: 10,
      category: 'strip',
    ),

    // Flirty/Dare actions (lower weights)
    Action(
      message: 'Give [PLAYER] a massage for 30 seconds',
      weight: 15,
      category: 'flirty',
    ),
    Action(
      message: 'Sit on [PLAYER]\'s lap until your next turn',
      weight: 12,
      category: 'flirty',
    ),
    Action(
      message: 'Kiss [PLAYER] on the cheek',
      weight: 10,
      category: 'flirty',
    ),
    Action(
      message: 'Tell [PLAYER] your biggest turn on',
      weight: 8,
      category: 'flirty',
    ),
    Action(
      message: 'Do your sexiest dance move',
      weight: 15,
      category: 'flirty',
    ),
    
    // Fun/Game actions
    Action(
      message: 'Play rock, paper, scissors with [PLAYER]. Loser drinks',
      weight: 20,
      category: 'game',
    ),
    Action(
      message: 'Truth or Dare: Choose your fate',
      weight: 20,
      category: 'game',
    ),
    Action(
      message: 'Categories: Pick a topic, go around naming items. Loser drinks',
      weight: 18,
      category: 'game',
    ),
    Action(
      message: 'Never have I ever: Start a round',
      weight: 18,
      category: 'game',
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
        title: Text('Crazy Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
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
                    color: Colors.purple.shade900,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
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
