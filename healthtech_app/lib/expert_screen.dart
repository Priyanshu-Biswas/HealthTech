import 'package:flutter/material.dart';
import 'departments_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health+',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Hero(
          tag: 'expertButton',
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DepartmentsScreen(),
                ),
              );
            },
            child: Text('Expert'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
