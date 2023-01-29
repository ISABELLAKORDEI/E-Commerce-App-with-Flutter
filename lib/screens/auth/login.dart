import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/screens/auth/auth_widgets.dart';
import 'package:e_commerce_app/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";

  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _isHidden = false.obs;
  bool _isLoading = false;
  late TextEditingController emailctrl, passctrl;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final auth = Get.put(Auth());

  @override
  void initState() {
    super.initState();
    emailctrl = TextEditingController();
    passctrl = TextEditingController();
    setState(() {});
  }

  @override
  void dispose() {
    emailctrl.dispose();
    passctrl.dispose();
    super.dispose();
  }

  authSignIn() {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
    String userEmail = emailctrl.text;
    String userPass = passctrl.text;
    auth.signIn(userEmail, userPass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset('assets/images/louzies-logo.png',
                        width: 80, height: 80, fit: BoxFit.fill),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 22),
                      child: Text(
                        'Louzies',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Form(
                        key: loginFormKey,
                        child: Column(
                          children: <Widget>[
                            formField(
                              label: 'Email Address',
                              require: true,
                              controller: emailctrl,
                              type: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email';
                                }
                                return null;
                              },
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  passwordField(
                                    isHidden: _isHidden,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Password';
                                      }
                                      return null;
                                    },
                                    controller: passctrl,
                                    label: 'Password',
                                  )
                                ]),
                          ],
                        )),
                  ),
                  primaryBtn(
                    bgColour: Colors.black,
                    txtColour: Colors.white,
                    label: 'Login',
                    isLoading: _isLoading,
                    function: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      authSignIn();

                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                  textSpan(
                      mainLabel: "Don't have an account? ",
                      childLabel: 'Register',
                      function: () {
                        Get.to(const SignUp());
                      })
                ])
            // ])
            ));
  }
}
