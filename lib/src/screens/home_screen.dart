import 'package:flutter/material.dart';
import 'package:givememedicineapp/src/screens/doctor_screen.dart';
import 'package:givememedicineapp/src/screens/sales_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Give Me Medicine'),
        ),
        body: const HomeScreenPage(),
      ),
      routes: {
        '/doctor': (context) => const DoctorScreen(),
        '/representative': (context) => const SalesScreen(),
      },
    );
  }
}

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.pushNamed(context, '/doctor');
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.person_pin_outlined, size: 70.0),
                  Text('Doctor List'),
                ],
              ),
            ),
          ),
        ),
        Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.pushNamed(context, '/representative');
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add_box, size: 70.0),
                  Text('Add New Operation'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
