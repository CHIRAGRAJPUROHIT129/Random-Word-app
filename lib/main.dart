import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[]; // List to hold favorite WordPairs
  int selectedIndex = 0;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair); // Removes the specific pair from the favorites list
    notifyListeners(); // Notify listeners about the change
  }

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners(); // Notify listeners when index changes
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home,size: 30,),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite,size: 30,  color: Colors.red),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: appState.selectedIndex,
              onDestinationSelected: (value) {
                appState.updateSelectedIndex(value);
                print("Selected index: $value"); // Debugging
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: appState.selectedIndex == 0
                  ? _buildHomeView(appState, pair)
                  : _buildFavoritesView(appState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeView(MyAppState appState, WordPair pair) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A Random Word:',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(height: 10),
          Card(color: Colors.deepPurple.shade200,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                pair.asLowerCase,
                style: TextStyle(fontSize: 40,fontWeight: FontWeight.w500),
                semanticsLabel: "${pair.first} ${pair.second}",
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.toggleFavorite();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      appState.favorites.contains(pair)
                          ? Icons.favorite
                          : Icons.favorite_border,color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text('Like',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next',style: TextStyle(fontSize:20,color: Colors.black,fontWeight: FontWeight.w500),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesView(MyAppState appState) {
    if (appState.favorites.isEmpty) {
      return Center(child: Text('No favorites yet!'));
    }

    return ListView.builder(
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        final pair = appState.favorites[index];

        return ListTile(
          title: Text(pair.asLowerCase),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              appState.removeFavorite(pair); // Correctly call removeFavorite
            },
          ),
          onTap: () {
            // Handle the tap event
          },
        );
      },
    );
  }
}
