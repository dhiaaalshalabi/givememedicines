import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/utils.dart';
import 'package:intl/intl.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final form = Form.of(context);
              if (form!.validate()) {}
            },
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
  _SalesScreenPage createState() => _SalesScreenPage();
}

class _SalesScreenPage extends State<SalesScreenPage> {
  late AppDatabase database;
  late StreamSubscription subscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _remark = TextEditingController();
  final TextEditingController _dateinput = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase
        .databaseBuilder('database.db')
        .build()
        .then((value) async {
      database = value;
    });
    subscription =
        Connectivity().onConnectivityChanged.listen(checkConnectivityState);
    _dateinput.text = "";
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Widget _buildDoctor() {
    return Flexible(
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Doctor',
        ),
        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return 'Choose a date.';
        //   }
        //   return null;
        // },
      ),
    );
  }

  Widget _buildDate() {
    return Flexible(
      child: TextFormField(
        controller: _dateinput,
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
              _dateinput.text = formattedDate;
            });
          }
        },
        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return 'Enter sales';
        //   }
        //   return null;
        // },
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
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Medicine',
              ),
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return 'Choose a medicine.';
              //   }
              //   return null;
              // },
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity Type',
              ),
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return 'Enter a quantity type.';
              //   }
              //   return null;
              // },
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantiry',
              ),
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return 'Enter a quantity.';
              //   }
              //   return null;
              // },
            ),
          ),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
