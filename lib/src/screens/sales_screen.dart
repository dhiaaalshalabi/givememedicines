import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/data/medicine_api.dart';
import 'package:givememedicineapp/data/sales_api.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/entity/doctor.dart';
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

  Stream<Doctor?> findDoctorById(int id) {
    return database.doctorDao.findDoctorById(id);
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
                  // getMedicinesFromApi(),
                  syncSalesWithApi(),
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
                              StreamBuilder<Doctor?>(
                                stream: findDoctorById(
                                    snapshot.data![index].doctorId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                        '${snapshot.data!.firstName} ${snapshot.data!.lastName}');
                                  }
                                  return const Text('');
                                },
                              ),
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

  Future<List<Sales>> findAllSalesByTagged(bool tagged) async {
    return await database.salesDao.findAllSalesByTagged(tagged);
  }

  Future<int> updateSale(AppDatabase db, Sales sales) async {
    return await database.salesDao.updateSales(sales);
  }

  Future<void> syncSalesWithApi() async {
    List<Sales> sales = await findAllSalesByTagged(false).then(
      (value) {
        return value.map((e) => e).toList();
      },
    );
    for (var element in sales) {
      final toJson = element.toJson();
      checkConnectivity().then(
        (value) {
          if (value == ConnectivityResult.mobile ||
              value == ConnectivityResult.wifi) {
            SalesApi.postSale(toJson).then(
              (response) {
                print("rrrrrrrrrr ${response.body}");
                if (response.statusCode == 200 || response.statusCode == 201) {
                  final mapData = json.decode(response.body);
                  element.tagged = true;
                  updateSale(database, element).then((value) {
                    if (value > 0) {
                      const snackBar = SnackBar(
                        content: Text('Sales synced successfully'),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                }
              },
            );
          }
        },
      );
    }
  }

  Future<ConnectivityResult> checkConnectivity() async {
    final connectivityResult = Connectivity().checkConnectivity();
    return await connectivityResult.then((value) {
      return value;
    });
  }

  void checkConnectivityState(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      // getMedicinesFromApi();
      showConnectivitySnackBar(context, result);
    } else if (result == ConnectivityResult.none) {
      showConnectivitySnackBar(context, result);
    }
  }
}
