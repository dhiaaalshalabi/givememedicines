import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void showConnectivitySnackBar(BuildContext context, ConnectivityResult result) {
  if (result == ConnectivityResult.none) {
    showSimpleNotification(
      const Text('No Internet Connection'),
      background: Colors.red,
      trailing: const Icon(Icons.error),
    );
  } else {
    showSimpleNotification(
      Text(
        result == ConnectivityResult.mobile
            ? 'You are connected to a mobile network.'
            : result == ConnectivityResult.wifi
                ? 'You are connected to a wifi network.'
                : 'You are offline.',
      ),
      background: Colors.green,
      trailing: const Icon(Icons.check),
    );
  }
}
