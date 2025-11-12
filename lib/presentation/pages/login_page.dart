import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jjewellery/main_common.dart';

import 'package:jjewellery/presentation/widgets/Global/custom_buttons.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';
import 'package:jjewellery/utils/color_constant.dart';

import '../../endpoints.dart';
import '../widgets/Global/about_company.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool isResponse = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: isResponse
            ? Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.primaryColor,
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Image.asset(
                        "assets/images/playstore.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Username"),
                            TextFormField(
                              controller: usernameController,
                              keyboardType: TextInputType.name,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Username cannot be empty"
                                      : null,
                              decoration: _inputDecoration(),
                            ),
                            const SizedBox(height: 12),
                            _buildLabel("Password"),
                            TextFormField(
                              controller: passwordController,
                              obscureText: hidePassword,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Password cannot be empty"
                                      : null,
                              decoration: _inputDecoration().copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: ColorConstant.primaryColor,
                                  ),
                                  onPressed: () => setState(
                                      () => hidePassword = !hidePassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: customElevatedButton(
                                title: "Log in",
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  setState(() {
                                    isResponse = true;
                                  });
                                  var nav = Navigator.of(context);
                                  try {
                                    final Response response = await Dio().post(
                                      "${Endpoints.baseUrl}Authentication/Login",
                                      data: {
                                        "userName": usernameController.text,
                                        "password": passwordController.text,
                                      },
                                    );

                                    if (response.statusCode == 200) {
                                      prefs.setString("accessToken",
                                          response.data['accessToken']);
                                      prefs.setString("refreshToken",
                                          response.data['refreshToken']);
                                      isResponse = false;
                                      nav.pop();
                                    }
                                  } on DioException catch (e) {
                                    customToast("${e.response?.data}",
                                        ColorConstant.errorColor);
                                    setState(() {
                                      isResponse = false;
                                    });
                                  } catch (e) {
                                    customToast("Server Error: $e",
                                        ColorConstant.errorColor);
                                    setState(() {
                                      isResponse = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      buildContactInfo(
                        isQr: false,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: ColorConstant.primaryColor,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
