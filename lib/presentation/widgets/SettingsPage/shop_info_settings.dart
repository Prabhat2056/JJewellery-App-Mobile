import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jjewellery/helper/helper_functions.dart';
import 'package:jjewellery/models/shop_info_settings_model.dart';

import 'package:jjewellery/presentation/pages/tabbar_view_page.dart';
import 'package:jjewellery/presentation/widgets/Global/appbar.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../bloc/Settings/settings_bloc.dart';
import '../../../main_common.dart';
import '../../../utils/color_constant.dart';
import '../Global/custom_buttons.dart';
import '../Global/form_field_column.dart';

class CompanyInfo extends StatefulWidget {
  const CompanyInfo({
    super.key,
  });

  @override
  State<CompanyInfo> createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  final ImagePicker picker = ImagePicker();
  int count = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ShopInfoSettingsModel shopInfoSettingsModel;
  File? imagePath;

  TextEditingController nameController = TextEditingController();
  TextEditingController shortNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController panController = TextEditingController();

  Future loadShopSettingsFromDb() async {
    List shopInfo = await db.rawQuery('SELECT * FROM ShopInfo');
    if (shopInfo.isEmpty) {
      shopInfoSettingsModel = ShopInfoSettingsModel(
          name: '', shortName: '', contact: '', address: '', pan: '', logo: '');

      return shopInfoSettingsModel;
    }
    shopInfoSettingsModel = ShopInfoSettingsModel(
      name: shopInfo[0]['name'],
      shortName: shopInfo[0]['short_name'],
      contact: shopInfo[0]['contact'],
      address: shopInfo[0]['address'],
      pan: shopInfo[0]['pan'],
      logo: shopInfo[0]['logo'],
    );
    nameController = TextEditingController(
      text: shopInfo[0]['name'],
    );
    shortNameController =
        TextEditingController(text: shopInfo[0]['short_name']);
    addressController = TextEditingController(text: shopInfo[0]['address']);
    contactController = TextEditingController(text: shopInfo[0]['contact']);
    panController = TextEditingController(text: shopInfo[0]['pan']);
    imagePath = shopInfo[0]['logo'].isEmpty ? null : File(shopInfo[0]['logo']);
    return shopInfoSettingsModel;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppbar(
          isHomeWidget: false,
          title: prefs.containsKey("isfirstLogin")
              ? "Shop Settings"
              : "J-Jewellery App",
        ),
        body: FutureBuilder(
            future: loadShopSettingsFromDb(),
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formFieldColumn(
                            label: "Shop Name",
                            controller: nameController,
                            validator: (val) {
                              if (nameController.text.isEmpty &&
                                  !prefs.getBool("isfirstLogin")!) {
                                return "Name is needed";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          formFieldColumn(
                            label: "Display Name",
                            controller: shortNameController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          formFieldColumn(
                            label: "Contact Number",
                            controller: contactController,
                            validator: (val) {
                              if (contactController.text.isEmpty &&
                                  !prefs.getBool("isfirstLogin")!) {
                                return "Contact Number is needed";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          formFieldColumn(
                            label: "Address",
                            controller: addressController,
                            validator: (val) {
                              if (addressController.text.isEmpty &&
                                  !prefs.getBool("isfirstLogin")!) {
                                return "Address is needed";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          formFieldColumn(
                            label: "Pan number",
                            controller: panController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Logo:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    var bloc =
                                        BlocProvider.of<SettingsBloc>(context);
                                    if (!await checkCameraStoragePermission()) {
                                      return;
                                    }

                                    if (await Permission
                                            .photos.status.isGranted ||
                                        await Permission
                                            .storage.status.isGranted) {
                                      final XFile? image =
                                          await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 15,
                                        maxHeight: 800,
                                        maxWidth: 800,
                                      );
                                      if (image != null) {
                                        final directory =
                                            await getTemporaryDirectory();
                                        imagePath = await File(
                                                '${directory.path}/$count.png')
                                            .create();

                                        imagePath!.writeAsBytesSync(
                                            await image.readAsBytes());
                                        count++;
                                        bloc.add(
                                            OnShopSettingsLogoChangedEvent());
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add_a_photo_rounded,
                                    color: ColorConstant.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              BlocBuilder<SettingsBloc, SettingsState>(
                                buildWhen: (previous, current) =>
                                    current is OnShopSettingsLogoChangedState,
                                builder: (context, state) {
                                  return imagePath != null
                                      ? Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white30,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              imagePath!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: customElevatedButton(
                                title: "Save",
                                onPressed: () async {
                                  var nav = Navigator.of(context);

                                  //validation
                                  if (!prefs.getBool("isfirstLogin")!) {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                  }

                                  if (imagePath == null &&
                                      !prefs.getBool("isfirstLogin")!) {
                                    customToast("Logo Needed",
                                        ColorConstant.errorColor);
                                    return;
                                  }

                                  //removing cache and storing in permanent mobile storage
                                  File? perImgPath;
                                  if (imagePath != null) {
                                    final tempDir =
                                        await getTemporaryDirectory();
                                    final perDir =
                                        await getApplicationDocumentsDirectory();
                                    perImgPath =
                                        File('${perDir.path}/logo.png');
                                    await perImgPath.writeAsBytes(
                                        imagePath!.readAsBytesSync());
                                    for (var i = 0; i < count; i++) {
                                      await File("${tempDir.path}/$i.png")
                                          .delete();
                                    }
                                  }

                                  if (shortNameController.text.isEmpty) {
                                    shortNameController.text =
                                        nameController.text;
                                  }

                                  var shopInfo = await db
                                      .rawQuery('SELECT * FROM ShopInfo');

                                  if (shopInfo.isEmpty) {
                                    await db.rawInsert(
                                        "INSERT INTO ShopInfo (name,short_name,contact,address,pan,logo) VALUES (?,?,?,?,?,?)",
                                        [
                                          nameController.text,
                                          shortNameController.text,
                                          contactController.text,
                                          addressController.text,
                                          panController.text,
                                          perImgPath?.path
                                        ]);
                                  } else {
                                    await db.rawUpdate(
                                        "UPDATE ShopInfo SET name=?,short_name=?,contact=?,address=?,pan=?,logo=? WHERE id=?",
                                        [
                                          nameController.text,
                                          shortNameController.text,
                                          contactController.text,
                                          addressController.text,
                                          panController.text,
                                          perImgPath?.path,
                                          '1'
                                        ]);
                                  }

                                  if (perImgPath != null) {
                                    precacheImage(
                                        FileImage(File(perImgPath.path)),
                                        // ignore: use_build_context_synchronously
                                        context);
                                  }
                                  if (prefs.getBool("isfirstLogin")!) {
                                    prefs.setBool("isfirstLogin", false);
                                    nav.pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TabbarViewPage(
                                                isScanned: false,
                                              )),
                                    );
                                  } else {
                                    nav.pop();
                                  }
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
