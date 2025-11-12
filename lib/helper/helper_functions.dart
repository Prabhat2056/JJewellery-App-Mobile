import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../presentation/pages/qr_scanner.dart';
import '../utils/color_constant.dart';

Future<bool> checkInternetConnection() async {
  bool connectivityResult =
      await Connectivity().checkConnectivity().then((value) {
    if (value.contains(ConnectivityResult.wifi) ||
        value.contains(ConnectivityResult.mobile)) {
      return true;
    } else {
      return false;
    }
  });
  return connectivityResult;
}

Future<bool> checkCameraStoragePermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      if (await Permission.storage.status.isDenied) {
        var status = await Permission.storage.request();

        if (status.isDenied) {
          return false;
        } else if (status.isGranted) {
          return true;
        }
      } else if (await Permission.storage.status.isPermanentlyDenied) {
        openAppSettings();
        return false;
      } else {
        return true;
      }
    } else {
      if (await Permission.photos.status.isDenied) {
        var status = await Permission.photos.request();
        if (status.isDenied) {
          return false;
        } else if (status.isGranted) {
          return true;
        }
      } else if (await Permission.photos.status.isPermanentlyDenied) {
        openAppSettings();
        return false;
      } else {
        return true;
      }
    }
  }
  if (Platform.isIOS) {
    if (await Permission.photos.status.isDenied) {
      var status = await Permission.photos.request();
      if (status.isDenied) {
        return false;
      }
    } else if (await Permission.photos.status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return true;
    }
  }
  return false;
}

void onQrPressed(context) async {
  //To pop all routes until it reaches home
 

  Navigator.of(context).popUntil((route) => route.isFirst);

  var status = await Permission.camera.status;
  if (status.isGranted) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QrScanner(),
    ));
  }
  if (status.isDenied) {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QrScanner(),
      ));
    }
  }
  if (status.isPermanentlyDenied) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorConstant.scaffoldColor,
        title: const Text(
          "Camera Permission Required",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text(
            "This app requires access to your camera to scan QR codes."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("Cancel"),
          ),
          if (status.isPermanentlyDenied)
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
        ],
      ),
    );
  }
}

bool isTokenExpired({required String token}) {
  final payload = token.split(".")[1];
  final normalizedPayload = base64.normalize(payload);
  final payloadString = utf8.decode(base64.decode(normalizedPayload));
  final decodePayload = jsonDecode(payloadString);
  final expirationDate = DateTime.fromMillisecondsSinceEpoch(
    decodePayload["exp"] * 1000,
    isUtc: true,
  );
  if (DateTime.now().toUtc().isAfter(expirationDate)) {
    return true;
  } else {
    return false;
  }
}

int getUserId({required String token}) {
  final payload = token.split(".")[1];
  final normalizedPayload = base64.normalize(payload);
  final payloadString = utf8.decode(base64.decode(normalizedPayload));
  final decodePayload = jsonDecode(payloadString);
  return int.parse(decodePayload["UserId"]);
}
