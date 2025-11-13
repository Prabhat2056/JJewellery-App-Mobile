import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jjewellery/helper/helper_functions.dart';

import 'package:jjewellery/presentation/pages/tabbar_view_page.dart';
import 'package:jjewellery/presentation/widgets/Global/about_company.dart';

import 'package:jjewellery/utils/color_constant.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../bloc/QrResult/qr_result_bloc.dart';

import '../../main_common.dart';
import '../../models/qr_data_model.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({
    super.key,
  });

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [
      BarcodeFormat.qrCode,
    ],

    // cameraResolution: const Size(1280, 720),
  );

  final imagePicker = ImagePicker();

  late List<Map<String, dynamic>> karatSettings;
  bool isFlashOn = false;
  bool isCameraInitialized = false;

  String key0 = prefs.getString("QrCode") ?? "12345678912345678912345678912345";
  String iv0 = "1234567891234567";
  bool falseQr = false;
  late QrDataModel qrData;
  bool isZoomed = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      scannerController.start().then((_) {
        setState(() {
          isCameraInitialized = true;
          scannerController.setZoomScale(0.7);
        });
      });
    }
  }

  String findMetalName(name) {
    if (name == "G" || name == "g") {
      return "Gold";
    } else if (name == "S" || name == "s") {
      return "Silver";
    } else {
      return name;
    }
  }

  String findStoneName(name) {
    if (name == "D" || name == "d") {
      return "Diamond";
    } else if (name == "OD" || name == "od") {
      return "Other Diamond";
    } else if (name == "S" || name == "s") {
      return "Stone";
    } else {
      return name;
    }
  }

  void decryptQrCode(String code) {
    try {
      final key = encrypt.Key.fromUtf8(key0);
      final iv = IV.fromUtf8(iv0);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      List<String> dataParts = code.split("|");
      code = dataParts.length > 1 ? dataParts[1] : "BUILTBYRUSTU";
      final decrypted = encrypter.decrypt64(code, iv: iv);
      final values = decrypted.split("|");

      if (values.length == 17) {
        values.insert(0, '');
      }

      if (values.length < 18) {
        falseQr = true;
        return;
      }

      // print(values);
      qrData = QrDataModel(
        id: "",
        code: dataParts[0],
        item: values[1],
        itemId: 0,
        materialId: 0,
        pcs: 0,
        metal: findMetalName(values[2]),
        grossWeight: values[3].isEmpty ? values[4] : values[3],
        netWeight: values[4],
        purity: values[5],
        jarti: values[6],
        jyala: values[7],
        stone1Name: findStoneName(values[8]),
        stone1Id: 0,
        stone1Weight: values[9],
        stone1Price: values[10],
        stone2Name: findStoneName(values[11]),
        stone2Id: 0,
        stone2Weight: values[12],
        stone2Price: values[13],
        stone3Name: findStoneName(values[14]),
        stone3Id: 0,
        stone3Weight: values[15],
        stone3Price: values[16],
        mrp: values[17],
        jartiPercentage: "",
        jartiLal: "",
        jyalaPercentage: "",
        rate: "",
        price: "",
        todayRate: "",

        // Calculated fields set to 0; will be computed later
        baseAmount: 0,
        nonTaxableAmount: 0,
        taxableAmount: 0,
        luxuryAmount: 0,
        total: 0,
        expectedAmount: "",
      );
    } catch (e) {
      falseQr = true;
    }
  }

  void onQrDetect(BarcodeCapture? qrcode) async {
    String code = qrcode?.barcodes.first.rawValue ?? "";
    if (code.isEmpty) {
      handleInvalidQr();
      return;
    }
    scannerController.stop();
    decryptQrCode(code);
    if (!falseQr) {
      BlocProvider.of<QrResultBloc>(context).add(QrResultInitialEvent(
        qrData: qrData,
        isUpdate: false,
      ));
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TabbarViewPage(isScanned: true)),
      );
    } else {
      handleInvalidQr();
    }
  }

  void handleInvalidQr() {
    falseQr = true;
    Navigator.of(context).popUntil((route) => route.isFirst);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorConstant.scaffoldColor,
        content: SizedBox(height: 100, child: buildContactInfo(isQr: true)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (isZoomed) {
          scannerController.setZoomScale(0.25);
          isZoomed = false;
        } else {
          scannerController.setZoomScale(1);
          isZoomed = true;
        }
      },
      child: Scaffold(
        body: !isCameraInitialized
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor.withAlpha(100),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/playstore.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Align the QR code within the frame to scan",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: MobileScanner(
                            controller: scannerController,
                            onDetect: (qrcode) => onQrDetect(qrcode),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorConstant.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final storagePermission =
                                    await checkCameraStoragePermission();

                                if (!storagePermission) {
                                  return;
                                }
                                XFile? image = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  await scannerController
                                      .analyzeImage(image.path, formats: [
                                    BarcodeFormat.qrCode
                                  ]).then((v) => onQrDetect(v));
                                }
                              },
                              icon: Icon(Icons.photo),
                              color: Colors.white,
                            ),
                            Text(
                              '|',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            IconButton(
                              onPressed: () {
                                scannerController.toggleTorch();
                                setState(() {
                                  isFlashOn = !isFlashOn;
                                });
                              },
                              icon: isFlashOn
                                  ? const Icon(Icons.flash_off_rounded)
                                  : const Icon(Icons.flash_on_rounded),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
      ),
    );
  }
}
