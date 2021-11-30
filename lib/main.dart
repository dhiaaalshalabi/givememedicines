import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/representative_api.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Splash());
        } else {
          // Loading is done, return the app:
          return OverlaySupport(
            child: MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: const Text("Give Me Medicine"),
                ),
                body: const MainPage(),
              ),
            ),
          );
        }
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StreamSubscription subscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  void initState() {
    super.initState();
    subscription =
        Connectivity().onConnectivityChanged.listen(checkConnectivityState);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Widget _buildPhone() {
    return TextFormField(
      controller: _phone,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Your Phone Number',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter Your Phone Number.';
        }
        return null;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      controller: _pass,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Your Password',
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter Your Password.';
        }
        return null;
      },
    );
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  Future<void> getRepresentativeFromApi() async {
    print("Phone ${_phone.text}");
    print("Pass ${_pass.text}");
    await RepresentativeApi.getRepresentative().then((response) {
      print("rrrrrrrrrrrrrrrrrrr ${response}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Image(
                  image: AssetImage('images/app.png'),
                  height: 200,
                ),
                const SizedBox(height: 20.0),
                _buildPhone(),
                const SizedBox(height: 20.0),
                _buildPassword(),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Login'),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      getRepresentativeFromApi();
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                const Center(
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(fontSize: 15.0, color: Colors.blue),
                  ),
                ),
              ],
            ),
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

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor:
          lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
      body: Center(
          child: lightMode
              ? Image.asset('images/app.png')
              : Image.asset('images/app.png')),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}
