import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQFlite Search Example',
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  late Database _database;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _openDatabase() async {
    _database = await openDatabase('notes.db', version: 1);
  }

  _search(String query) async {
    final result = await _database.query(
      'notes',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    setState(() {
      if (result.isNotEmpty) {
        _searchResults = result;
      }
      // _searchResults = result == null ? [] : result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Flutter SQFlite Search Example'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onChanged: (text) {
                _search(text);
              },
              decoration: InputDecoration(
                hintText: 'Search by name',
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final note = _searchResults[index];
                      return ListTile(
                        title: Text(note['title']),
                      );
                    },
                  )
                : Center(child: Text('No Results Found')),
          ),
        ],
      ),
    );
  }
}
