import 'package:flutter/material.dart';
import 'package:jjewellery/presentation/widgets/Global/appbar.dart';
import 'package:jjewellery/presentation/widgets/QrResult/row_with_textfield.dart';

import '../../../main_common.dart';
import '../Global/custom_buttons.dart';

class KaratSettingsPage extends StatefulWidget {
  const KaratSettingsPage({super.key});
  @override
  State<KaratSettingsPage> createState() => _KaratSettingsPageState();
}

class _KaratSettingsPageState extends State<KaratSettingsPage> {
  final Map<int, TextEditingController> _controllers = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _karatSettings = [];

  Future<List<Map<String, dynamic>>> _getKaratSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _karatSettings = await db.rawQuery("SELECT * FROM KaratSettings");
    for (var karat in _karatSettings) {
      _controllers[karat["id"]] =
          TextEditingController(text: karat["percentage"].toString());
    }
    return _karatSettings;
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    for (var karat in _karatSettings) {
      final controller = _controllers[karat["id"]];
      if (controller != null) {
        await db.rawUpdate(
          'UPDATE KaratSettings SET percentage = ? WHERE id = ?',
          [double.tryParse(controller.text) ?? 0.0, karat["id"]],
        );
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppbar(
          isHomeWidget: false,
          title: "Karat Settings",
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getKaratSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading settings"));
            }

            return SingleChildScrollView(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ..._karatSettings.map((karats) {
                          return rowWithTextField(
                            title: karats['karat'],
                            controller: _controllers[karats["id"]]!,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Percentage is needed";
                              }
                              return null;
                            },
                            width: MediaQuery.of(context).size.width * 0.1,
                            isUnitLeading: false,
                            isNumberField: true,
                          );
                        }),
                        const SizedBox(height: 16),
                        customElevatedButton(
                          title: "Save",
                          onPressed: _saveSettings,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
