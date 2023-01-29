import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kPrimaryBlue = Color(0xFF24B6F7);
const kPrimaryPurple = Color(0xFF7240FF);
const kPrimaryYellow = Color(0xFFFFCC66);
const kPrimaryGrey = Color(0xFFA4A4A4);
const kDarkTheme = Color(0xFF141418);
const kCardDarkBg = Color(0xFF090912);
const kRedCircleBg = Color(0xFFEE4444);
const kGreenCircleBg = Color(0xFF35773C);
const kCreamTheme = Color(0xFFDFDFD6);
const kPrimaryRed = Color(0xFFEE4444);
const kLightGrey = Color(0xFF141418);

void showSnackbar({required String title, required String subtitle, path}) {
  Get.snackbar(
    title,
    subtitle,
    backgroundColor: kCreamTheme,
    colorText: kPrimaryPurple,
    icon: Icon(path, size: 28, color: kPrimaryPurple),
    snackPosition: SnackPosition.BOTTOM,
  );
}

Widget primaryBtn(
    {required String label,
    required Color txtColour,
    required Color bgColour,
    required bool isLoading,
    required void Function()? function}) {
  return Container(
    height: 70,
    padding: const EdgeInsets.symmetric(vertical: 10),
    alignment: Alignment.center,
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 70),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: (isLoading)
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1.5,
              ))
          : Text(label,
              style: TextStyle(
                  color: txtColour,
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
    ),
  );
}

Widget formField(
    {required label,
    required require,
    required controller,
    type,
    required final String? Function(String?) validator}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              TextSpan(
                text: require ? ' *' : '',
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: kRedCircleBg),
              ),
            ]))),
        SizedBox(
          height: 50,
          child: TextFormField(
            cursorColor: kPrimaryBlue,
            controller: controller,
            keyboardType: type,
            validator: validator,
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                color: Colors.black),
            decoration: const InputDecoration(
              fillColor: kCreamTheme,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        )
      ]));
}

Widget passwordField(
    {required label,
    required = true,
    required RxBool isHidden,
    required controller,
    required final String? Function(String?) validator}) {
  return Obx(() => Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              const TextSpan(
                text: ' *',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: kRedCircleBg),
              ),
            ]))),
        SizedBox(
          height: 50,
          child: TextFormField(
            cursorColor: kPrimaryBlue,
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                color: Colors.black),
            decoration: InputDecoration(
              fillColor: kCreamTheme,
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              suffix: InkWell(
                onTap: () {
                  isHidden.toggle();
                },
                child: Icon(
                  isHidden.value ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
              ),
            ),
            obscureText: !isHidden.value,
            controller: controller,
            validator: validator,
          ),
        )
      ])));
}

Widget textSpan(
    {required mainLabel,
    required childLabel,
    required final void Function()? function}) {
  return Container(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
          onTap: function,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: mainLabel,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: childLabel,
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: kPrimaryBlue)),
              ],
            ),
          )));
}
