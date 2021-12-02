import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/data/medicine_api.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/entity/medicine.dart';
import 'package:givememedicineapp/entity/sales.dart';
import 'package:givememedicineapp/src/screens/add_sales_screen.dart';
import 'package:givememedicineapp/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSalesScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const SalesScreenPage(),
    );
  }
}

class SalesScreenPage extends StatefulWidget {
  const SalesScreenPage({Key? key}) : super(key: key);

  @override
  _SalesScreenPageState createState() => _SalesScreenPageState();
}

class _SalesScreenPageState extends State<SalesScreenPage> {
  late AppDatabase database;
  List<Medicine>? medicines = [];
  late StreamSubscription subscription;

  Future<List<int>> insertMedicines(AppDatabase db) async {
    return await db.medicineDao.insertMedicines(medicines!);
  }

  Future<List<Medicine>> findAllMedicine() async {
    return await database.medicineDao.findAllMedicine();
  }

  Future<List<Sales>> findAllSales() async {
    return await database.salesDao.findAllSales();
  }

  Future<void> getMedicinesFromApi() async {
    List<int> ids = await findAllMedicine().then((list) {
      return list.map((e) => e.syncedId).toList();
    });
    medicines = await MedicineApi.getMedicines(ids).then((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Medicine.fromJson(model)).toList();
      } else {
        showRAlertDialog(
            context,
            'Error!!',
            'Make sure that your connected network has an internet access.',
            AlertType.error);
      }
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      showRAlertDialog(
          context,
          'Timeout!!',
          'Make sure that your connected network has internet access.',
          AlertType.error);
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
    return FutureBuilder(
        future: findAllSales(),
        builder: (BuildContext context, AsyncSnapshot<List<Sales>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.tag_faces, size: 100, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'No sales found!',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${snapshot.data![index].doctorId} "),
                              Text(
                                snapshot.data![index].date,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text("${snapshot.data![index].remark} "),
                        ),
                      );
                    },
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
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
