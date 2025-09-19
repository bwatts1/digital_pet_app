import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  String emoji = "😊";
  String game = "playing"; // "playing", "won", "lost"
  int _selectedPage = 0;
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color color = Colors.green;
  final myController = TextEditingController();
  Timer? _hungerTimer;

  @override
  void initState() {
    super.initState();
    // Start hunger timer
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel += 5;
        if (hungerLevel > 100) {
          hungerLevel = 100;
          happinessLevel -= 20;
        }
        _updateFeeling();
      });
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    myController.dispose();
    super.dispose();
  }

  void _goToSettings() {
    setState(() {
      _selectedPage = 1;
    });
  }

  void _goToHome() {
    setState(() {
      _selectedPage = 0;
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      if (hungerLevel < 0) hungerLevel = 0;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else if (hungerLevel == 0) {
      game = 'lost';
    } else {
      happinessLevel += 10;
    }
    _updateFeeling();
  }

  void _updateHunger() {
    hungerLevel += 5;
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel -= 20;
    }
    _updateFeeling();
  }

  void _updateFeeling() {
    if (happinessLevel <= 0 || game == 'lost') {
      color = Colors.grey;
      emoji = "💀";
      game = 'lost';
    } else if (happinessLevel > 70) {
      color = Colors.green;
      emoji = "😊";
    } else if (happinessLevel >= 30) {
      color = Colors.yellow;
      emoji = "😐";
    } else {
      color = Colors.red;
      emoji = "😢";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      // Home Page
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: $petName',
                style: TextStyle(fontSize: 20.0, color: color)),
            const SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel',
                style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel',
                style: const TextStyle(fontSize: 20.0)),
            const SizedBox(height: 32.0),
            Text(emoji, style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: const Text('Play with Your Pet'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: const Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
      
      // Settings Page
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("⚙️ Settings Page", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              TextField(
                controller: myController,
                decoration: const InputDecoration(labelText: "Enter Pet Name"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    petName =
                        myController.text.isEmpty ? petName : myController.text;
                  });
                },
                child: const Text("Save Name"),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: Column(
        children: <Widget>[
          // MenuBar at the top
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: MenuBar(
                  children: <Widget>[
                    SubmenuButton(
                      menuChildren: <Widget>[
                        MenuItemButton(
                          onPressed: _goToHome,
                          child: const Text('Home'),
                        ),
                        MenuItemButton(
                          onPressed: _goToSettings,
                          child: const Text('Settings'),
                        ),
                      ],
                      child: const Text('Menu'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Active page
          Expanded(child: _pages[_selectedPage]),
        ],
      ),
    );
  }
}
