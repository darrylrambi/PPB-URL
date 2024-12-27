import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchData() async {
  http.Response response = await http.get(Uri.parse(
      'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2022-03-05&endtime=2022-03-06&limit=10'));

  final Map<String, dynamic> data = jsonDecode(response.body);
  final List<Map<String, dynamic>> listProperties = (data['features'] as List)
      .map((feature) => feature['properties'] as Map<String, dynamic>)
      .toList();

  return listProperties;
}

Future<List<Map<String, dynamic>>> listData = fetchData();

Future<void> main() async {
  try {
    final data = await fetchData();
    print(data);
  } catch (e) {
    print('Error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TPMOD13',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TPMOD13'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: listData,
          builder: (context, snapshot) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      item['title'],
                    ),
                    trailing: Text(item['type']),
                  ),
                );
              },
            );
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
