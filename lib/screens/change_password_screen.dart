import 'package:flutter/material.dart';
import 'package:school_erp/components/buttom_vector_image.dart';
import 'package:school_erp/components/custom_appbar.dart';
import 'package:school_erp/components/heading.dart';
import 'package:school_erp/components/star_background.dart';
import 'package:school_erp/components/submit_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color textFieldTitle = const Color(0xFFA5A5A5);

    return Scaffold(
      backgroundColor: const Color(0xFF7292CF),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            const StarBackground(),
            Column(
              children: [
                const CustomAppBar(title: "Change Password"),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 30.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10.0),
                              const CommonTitle(title: "Old Password"),
                              const TextField(
                                cursorColor: Color(0xFF2855AE),
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF2855AE)),
                                )),
                              ),
                              const SizedBox(height: 30.0),
                              const CommonTitle(title: "New Password"),
                              const TextField(
                                cursorColor: Color(0xFF2855AE),
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF2855AE)),
                                )),
                              ),
                              const SizedBox(height: 30.0),
                              const CommonTitle(title: "Re-enter Password"),
                              const TextField(
                                cursorColor: Color(0xFF2855AE),
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF2855AE)),
                                )),
                              ),
                              const SizedBox(height: 40.0),
                              SubmitButton(
                                buttonText: "CHANGE PASSWORD",
                                onTap: () {},
                              ),
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
            const BottomVectorImage(),
          ],
        ),
      ),
    );
  }
}
