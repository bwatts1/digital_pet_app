import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: ThemeData(
        brightness: _themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
        primarySwatch: Colors.blueGrey,
      ),
      duration: const Duration(milliseconds: 500),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        darkTheme: ThemeData.dark(),
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Theme Demo'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Choose the Theme:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        changeTheme(ThemeMode.light);
                      },
                      child: const Text("Light Theme"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        changeTheme(ThemeMode.dark);
                      },
                      child: const Text("Dark Theme"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    changeTheme(ThemeMode.system);
                  },
                  child: const Text("System Default"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(_createFadeRoute());
                  },
                  child: const Text("Go to Settings Page"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  PageRouteBuilder _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SettingsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(
        child: Text("This is the Settings Page"),
      ),
    );
  }
}