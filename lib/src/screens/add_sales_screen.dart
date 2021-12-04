import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:givememedicineapp/data/sales_api.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/entity/doctor.dart';
import 'package:givememedicineapp/entity/medicine.dart';
import 'package:givememedicineapp/entity/sales.dart';
import 'package:givememedicineapp/utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSalesScreen extends StatelessWidget {
  const AddSalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sales'),
      ),
      body: const AddSalesScreenPage(),
    );
  }
}

class AddSalesScreenPage extends StatefulWidget {
  const AddSalesScreenPage({Key? key}) : super(key: key);

  @override
  _AddSalesScreenPage createState() => _AddSalesScreenPage();
}

class _AddSalesScreenPage extends State<AddSalesScreenPage> {
  late AppDatabase database;
  late StreamSubscription subscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _doctor = TextEditingController();
  final TextEditingController _dateInput = TextEditingController();
  final TextEditingController _remark = TextEditingController();
  final TextEditingController _medicine = TextEditingController();
  final TextEditingController _quantityType = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late List<Doctor> doctors;
  int _selectedDoctor = 0;
  int _selectedMedicine = 0;

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase
        .databaseBuilder('database.db')
        .build()
        .then((value) async {
      database = value;
      setState(() {
        database.doctorDao.findAllDoctor().then((value) {
          doctors = value;
        });
      });
      subscription =
          Connectivity().onConnectivityChanged.listen(checkConnectivityState);
      _dateInput.text = "";
    });
  }

  Future<void> getDoctorsList() async {
    doctors = await database.doctorDao.findAllDoctor();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Widget _buildDoctor() {
    return Flexible(
      child: TypeAheadFormField<Doctor>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _doctor,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Doctor',
          ),
        ),
        suggestionsCallback: (pattern) {
          return findAllDoctor();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text('${suggestion.firstName} ${suggestion.lastName}'),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          _doctor.text = '${suggestion.firstName} ${suggestion.lastName}';
          setState(() {
            _selectedDoctor = suggestion.syncedId;
          });
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please select a doctor';
          }
        },
      ),
    );
  }

  Widget _buildDate() {
    return Flexible(
      child: TextFormField(
        controller: _dateInput,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Date',
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2015, 8),
              lastDate: DateTime(2101));
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              _dateInput.text = formattedDate;
            });
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter sales';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRemark() {
    return TextFormField(
      controller: _remark,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Remark',
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your remark.';
        }
        return null;
      },
    );
  }

  Widget _buildFormSet() {
    return Column(children: [
      Row(
        children: [
          Flexible(
            child: TypeAheadFormField<Medicine>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _medicine,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Medicine',
                ),
              ),
              suggestionsCallback: (pattern) {
                return findAllMedicine();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.scientificName),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                _medicine.text = suggestion.scientificName;
                setState(() {
                  _selectedMedicine = suggestion.syncedId;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select a medicine';
                }
              },
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            child: TextFormField(
              controller: _quantityType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity Type',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a quantity type.';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            child: TextFormField(
              controller: _quantity,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a quantity.';
                }
                return null;
              },
            ),
          ),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'ENTER SALE INFORMATION',
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 2.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
            width: 300,
            child: Divider(
              color: Colors.grey.shade600,
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _buildDoctor(),
                      const SizedBox(width: 10),
                      _buildDate(),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  _buildRemark(),
                  const SizedBox(height: 10.0),
                  _buildFormSet(),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Save'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        syncSalesData();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<ConnectivityResult> checkConnectivity() async {
    final connectivityResult = Connectivity().checkConnectivity();
    return await connectivityResult.then((value) {
      return value;
    });
  }

  Future<void> syncSalesData() async {
    final prefs = await SharedPreferences.getInstance();
    int representativeId = prefs.getInt('representativeId') ?? 0;
    final sale = Sales(
      id: null,
      salesRepresentativeId: representativeId,
      doctorId: _selectedDoctor,
      remark: _remark.text,
      date: _dateInput.text,
      tagged: false,
    );
    final salesMedicine = SalesMedicine(
      id: null,
      salesId: null,
      medicineId: _selectedMedicine,
      quantityType: _quantityType.text,
      quantity: int.parse(_quantity.text),
      tagged: false,
    );

    final toJson = sale.toJson();
    print(toJson);
    checkConnectivity().then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        SalesApi.postSale(toJson).then((response) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            final mapData = json.decode(response.body);
            insertSale(database, Sales.fromJson(mapData)).then((value) {
              if (value > 0) {
                salesMedicine.salesId = value;
                final medicineToJson = salesMedicine.toJson();
                SalesApi.postSaleMedicine(medicineToJson).then((response) {
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    final mapData = json.decode(response.body);
                    insertSaleMedicine(
                            database, SalesMedicine.fromJson(mapData))
                        .then((value) {
                      if (value > 0) {
                        insertSaleMedicine(database, salesMedicine);
                        showAlertDialog(context, 'Success',
                            'Sale information added successfully');
                      }
                    });
                  }
                });
              }
            });
          } else {
            final list = json.decode(response.body);
            if (list['non_field_errors'] != null) {
              showAlertDialog(context, 'Error!',
                  'Doctor with these information already exists');
            }
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          showAlertDialog(context, 'Timeout!!',
              'Make sure that your connected network has internet access.');
        });
      } else {
        sale.tagged = false;
        insertSale(database, sale).then((value) {
          if (value > 0) {
            salesMedicine.salesId = value;
            insertSaleMedicine(database, salesMedicine);
            showAlertDialog(
                context, 'Success', 'Sale information added successfully');
          }
        });
      }
    });
  }

  Future<List<Sales>> findAllSalesByTagged(bool tagged) async {
    return await database.salesDao.findAllSalesByTagged(tagged);
  }

  Future<List<Doctor>> findAllDoctor() async {
    return await database.doctorDao.findAllDoctor();
  }

  Future<List<Medicine>> findAllMedicine() async {
    return await database.medicineDao.findAllMedicine();
  }

  Future<int> insertSale(AppDatabase db, Sales sale) async {
    return await database.salesDao.insertSales(sale);
  }

  Future<int> insertSaleMedicine(
      AppDatabase db, SalesMedicine salesMedicines) async {
    return await database.salesDao.insertSalesMedicine(salesMedicines);
  }

  void checkConnectivityState(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      showConnectivitySnackBar(context, result);
    } else if (result == ConnectivityResult.none) {
      showConnectivitySnackBar(context, result);
    }
  }
}
