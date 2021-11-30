import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/data/medicine_api.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/entity/medicine.dart';
import 'package:givememedicineapp/src/screens/sales_screen.dart';
import 'package:givememedicineapp/utils.dart';

class RepresentativeScreen extends StatelessWidget {
  const RepresentativeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Operation'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalesScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const RepresentativeScreenPage(),
    );
  }
}

class RepresentativeScreenPage extends StatefulWidget {
  const RepresentativeScreenPage({Key? key}) : super(key: key);

  @override
  _RepresentativeScreenPageState createState() =>
      _RepresentativeScreenPageState();
}

class _RepresentativeScreenPageState extends State<RepresentativeScreenPage> {
  late AppDatabase database;
  List<Medicine> medicines = [];
  late StreamSubscription subscription;

  Future<List<int>> insertMedicines(AppDatabase db) async {
    return await db.medicineDao.insertMedicines(medicines);
  }

  Future<List<Medicine>> findAllMedicine() async {
    return await database.medicineDao.findAllMedicine();
  }

  Future<void> getMedicinesFromApi() async {
    List<int> ids = await findAllMedicine().then((list) {
      return list.map((e) => e.syncedId).toList();
    });
    medicines = await MedicineApi.getMedicines(ids).then((response) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Medicine.fromJson(model)).toList();
    });
    setState(() {
      insertMedicines(database);
    });
  }

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase
        .databaseBuilder('database.db')
        .build()
        .then((value) async {
      database = value;
      setState(() {
        var connectivityResult = Connectivity().checkConnectivity();
        connectivityResult.then((value) => {
              if (value == ConnectivityResult.mobile ||
                  value == ConnectivityResult.wifi)
                {
                  getMedicinesFromApi(),
                }
            });
      });
    });
    subscription =
        Connectivity().onConnectivityChanged.listen(checkConnectivityState);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('data');
  }

  void checkConnectivityState(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      getMedicinesFromApi();
      showConnectivitySnackBar(context, result);
    } else if (result == ConnectivityResult.none) {
      showConnectivitySnackBar(context, result);
    }
  }
}
