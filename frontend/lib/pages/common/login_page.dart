import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_pass_management/pages/common/forget_password.dart';
import 'package:hostel_pass_management/pages/rt/rt_page.dart';
import 'package:hostel_pass_management/pages/security/security_page.dart';
import 'package:hostel_pass_management/pages/student/student_page.dart';
import 'package:hostel_pass_management/pages/warden/hostel_stats.dart';
import 'package:hostel_pass_management/providers/rt_announcement_provider.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/student_announcement_provider.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/utils/validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  bool isForgotPassLoading = false;
  bool isLoginLoading = false;
  late FToast toast;

  void login(context) async {
    HapticFeedback.selectionClick();
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      setState(() {
        isLoginLoading = true;
      });

      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": _emailController.text,
            "password": _passController.text,
          },
        ),
      );

      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      if (responseData["role"] == "student") {
        await prefs?.setString('jwtToken', responseData['jwtToken']);
        await prefs?.setString('uid', responseData['uid']);
        await prefs?.setString('studentId', responseData['studentId']);
        await prefs?.setString('gender', responseData['gender']);
        await prefs?.setString('email', responseData['email']);
        await prefs?.setString('username', responseData['username']);
        await prefs?.setString('role', responseData['role']);
        await prefs?.setString('phNo', responseData['phNo']);
        await prefs?.setInt('blockNo', responseData['blockNo']);
        await prefs?.setString('dept', responseData['dept']);
        await prefs?.setString('fatherName', responseData['fatherName']);
        await prefs?.setString('motherName', responseData['motherName']);
        await prefs?.setString('fatherPhNo', responseData['fatherPhNo']);
        await prefs?.setString('motherPhNo', responseData['motherPhNo']);
        await prefs?.setString('regNo', responseData['regNo']);
        await prefs?.setInt('year', responseData['year']);
        await prefs?.setString('section', responseData['section']);
        await prefs?.setInt('roomNo', responseData['roomNo']);

        await ref.read(studentPassProvider.notifier).loadPassFromDB();
        await ref
            .read(studentAnnouncementNotifier.notifier)
            .loadAnnouncementsFromDB();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const StudentPage(),
          ),
        );
      } else if (responseData["role"] == "rt") {
        await prefs?.setString('jwtToken', responseData['jwtToken']);
        await prefs?.setString('uid', responseData['uid']);
        await prefs?.setString('rtId', responseData['rtId']);
        await prefs?.setString('username', responseData['username']);
        await prefs?.setString('email', responseData['email']);
        await prefs?.setString('role', responseData['role']);
        await prefs?.setString('phNo', responseData['phNo']);
        await prefs?.setInt('permanentBlock', responseData['permanentBlock']);
        await prefs?.setBool('isBoysHostelRt', responseData['isBoysHostelRt']);

        await ref.read(blockStudentProvider.notifier).loadBlockStudentsFromDB();

        await ref.read(rtPassProvider.notifier).loadPassRequestsFromDB();
        await ref
            .read(rtAnnouncementNotifier.notifier)
            .loadAnnouncementsFromDB();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RtPage(),
          ),
        );
      } else if (responseData["role"] == "warden") {
        await prefs?.setString('jwtToken', responseData['jwtToken']);
        await prefs?.setString('uid', responseData['uid']);
        await prefs?.setString('wardenId', responseData['wardenId']);
        await prefs?.setString('username', responseData['username']);
        await prefs?.setString('email', responseData['email']);
        await prefs?.setString('role', responseData['role']);
        await prefs?.setString('phNo', responseData['phNo']);

        await ref
            .read(hostelStudentProvider.notifier)
            .loadHostelStudentsFromDB();
        await ref.read(specialPassProvider.notifier).getSpecailPassesFromDB();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StatsPage(),
            // builder: (context) => StatsPage(),
          ),
        );
      } else if (responseData["role"] == "faculty") {
        await prefs?.setString('jwtToken', responseData['jwtToken']);
        await prefs?.setString('uid', responseData['uid']);
        await prefs?.setString('facultyId', responseData['facultyId']);
        await prefs?.setString('username', responseData['username']);
        await prefs?.setString('email', responseData['email']);
        await prefs?.setString('role', responseData['role']);
        await prefs?.setString('phNo', responseData['phNo']);

        await ref
            .read(hostelStudentProvider.notifier)
            .loadHostelStudentsFromDB();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StatsPage(),
            // builder: (context) => StatsPage(),
          ),
        );
      } else if (responseData["role"] == "security") {
        await prefs?.setString('jwtToken', responseData['jwtToken']);
        await prefs?.setString('uid', responseData['uid']);
        await prefs?.setString('securityId', responseData['securityId']);
        await prefs?.setString('username', responseData['username']);
        await prefs?.setString('email', responseData['email']);
        await prefs?.setString('role', responseData['role']);
        await prefs?.setString('phNo', responseData['phNo']);
        setState(() {
          isLoginLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SecurityPage(),
          ),
        );
      }
    } catch (err) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
          ),
        ),
      );
    } finally {
      HapticFeedback.heavyImpact();
      setState(() {
        isLoginLoading = false;
      });
    }
  }

  void forgotPass() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email"),
        ),
      );
      return;
    }
    if (!isEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid email"),
        ),
      );
      return;
    }
    setState(() {
      isForgotPassLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/auth/forgotPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": _emailController.text,
          },
        ),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ForgetPassword(
            email: _emailController.text,
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
      setState(() {
        isForgotPassLoading = false;
      });
    }
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 130,
                ),
                const SizedBox(height: 12),
                Text(
                  "Login your account",
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(229, 0, 0, 0),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(15),
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 5, 44, 76),
                              width: 2.0,
                            ),
                          ),
                          labelText: "Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: textTheme.displayLarge!
                              .copyWith(color: Colors.black, fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return "The email should not be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _passController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(15),
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 5, 44, 76),
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color.fromARGB(255, 1, 46, 76),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          labelText: "Password",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: textTheme.displayLarge!
                              .copyWith(color: Colors.black, fontSize: 20),
                        ),
                        validator: (pass) {
                          if (pass == null || pass.isEmpty) {
                            return "The password should not be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      InkWell(
                        onTap: isLoginLoading
                            ? null
                            : () {
                                login(context);
                              },
                        child: Ink(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 1, 46, 76),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: isLoginLoading
                              ? Column(
                                  children: [
                                    CircularProgressIndicator(
                                      color: colorScheme.background,
                                    ),
                                  ],
                                )
                              : Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: isForgotPassLoading ? null : forgotPass,
                  child: isForgotPassLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "Forgot Password?",
                          style: textTheme.bodyMedium!.copyWith(
                              color: const Color.fromARGB(255, 15, 60, 91)),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
