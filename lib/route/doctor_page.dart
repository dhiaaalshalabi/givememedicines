import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/data/doctor_api.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/entity/doctor.dart';
import 'package:givememedicineapp/utils.dart';

class DoctorApp extends StatelessWidget {
  const DoctorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor List'),
      ),
      body: const DoctorPage(),
    );
  }
}

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  late AppDatabase database;
  List<Doctor> doctors = [];
  late StreamSubscription subscription;

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
                  getDoctorsFromApi(),
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
      future: findAllDoctor(),
      builder: (BuildContext context, AsyncSnapshot<List<Doctor>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.tag_faces, size: 100, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'No doctors found!',
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
                            Text(
                                "${snapshot.data![index].firstName} ${snapshot.data![index].lastName}"),
                            Text(
                              snapshot.data![index].phone,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                            "${snapshot.data![index].address} ${snapshot.data![index].nameOfTheClinic}"),
                      ),
                    );
                  },
                );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<int>> insertDoctors(AppDatabase db) async {
    return await db.doctorDao.insertDoctors(doctors);
  }

  Future<List<Doctor>> findAllDoctor() async {
    return await database.doctorDao.findAllDoctor();
  }

  Future<void> getDoctorsFromApi() async {
    List<int> ids = await findAllDoctor().then((list) {
      return list.map((e) => e.syncedId).toList();
    });
    doctors = await DoctorApi.getDoctors(ids).then((response) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Doctor.fromJson(model)).toList();
    });
    setState(() {
      insertDoctors(database);
    });
  }

  void checkConnectivityState(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      getDoctorsFromApi();
      showConnectivitySnackBar(context, result);
    } else if (result == ConnectivityResult.none) {
      showConnectivitySnackBar(context, result);
    }
  }
}
