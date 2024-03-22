import 'dart:convert';
import 'package:hostel_pass_management/utils/validators.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    required this.email,
    super.key,
  });

  final String email;

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _otpformKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  final focusNode = FocusNode();
  bool isLoading = false;
  late String enteredOTP;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isOTPVerified = false;

  void verifyOTP() async {
    var response = await http.post(
      Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/auth/verifyOtp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "email": widget.email,
          "otp": otpController.text,
        },
      ),
    );

    var responseData = jsonDecode(response.body);

    if (!mounted) {
      return;
    }

    if (response.statusCode > 399) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            responseData["message"],
          ),
        ),
      );
      return;
    }

    enteredOTP = otpController.text;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          responseData["message"],
        ),
      ),
    );

    setState(() {
      isOTPVerified = true;
    });
  }

  void resetPassword() async {
    if (!_resetFormKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/auth/resetPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": widget.email,
            "password": _passwordController.text,
            "otp": enteredOTP,
          },
        ),
      );

      var responseData = jsonDecode(response.body);

      if (!mounted) {
        return;
      }

      if (response.statusCode > 399) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData["message"],
            ),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            responseData["message"],
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    } finally {
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromARGB(255, 68, 21, 112);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color.fromARGB(255, 183, 112, 255),
        ),
      ),
    );
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: !isOTPVerified,
            child: Form(
              key: _otpformKey,
              child: Column(
                children: [
                  const Row(),
                  Text(
                    "OTP Verification",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Enter the code sent to the email",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.email,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "OTP gets automatically verified after entered",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      controller: otpController,
                      length: 6,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      keyboardType: TextInputType.number,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      validator: (value) {
                        verifyOTP();
                        return null;
                      },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: focusedBorderColor,
                          ),
                        ],
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: focusedBorderColor,
                          ),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: focusedBorderColor,
                          ),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isOTPVerified,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text(
                    "Reset Password",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Enter your new password",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _resetFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            // contentPadding: const EdgeInsets.symmetric(
                            //   vertical: 15,
                            //   horizontal: 15,
                            // ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          validator: (password) {
                            if (password == null) {
                              return "The password should not be empty";
                            }
                            if (!isPassword(password.trim())) {
                              return "The password must have at least 6 characters";
                            }
                            if (!passHasNumeric(password.trim())) {
                              return "The password must contain a numeric value";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            // contentPadding: const EdgeInsets.symmetric(
                            //   vertical: 15,
                            //   horizontal: 15,
                            // ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "Confirm Password",
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          validator: (password) {
                            if (password == null) {
                              return "The password should not be empty";
                            }
                            if (!isPassword(password.trim())) {
                              return "The password must have at least 6 characters";
                            }
                            if (_passwordController.text != password) {
                              return "The passwords do not match";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: resetPassword,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(58, 142, 66, 255),
                      ),
                      width: MediaQuery.of(context).size.width - 225,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Reset",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
