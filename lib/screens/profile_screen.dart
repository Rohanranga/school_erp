import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_erp/constants/colors.dart';

import '../model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Hive Box initialization
  Box<UserModel> userBox = Hive.box<UserModel>('users');

  //constant colour of text field title
  Color textFieldTitle = const Color(0xFFA5A5A5);

  //controllers initialization
  TextEditingController emailController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController academicYearController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    emailController.text = userBox.get("user")?.email ?? "";
    branchController.text = userBox.get("user")?.branch ?? "";
    academicYearController.text = userBox.get("user")?.academicYear ?? "";
    dobController.text = userBox.get("user")?.dateOfBirth ?? "";
    contactController.text = userBox.get("user")?.contactNumber ?? "";
    fatherNameController.text = userBox.get("user")?.fatherName ?? "";
    motherNameController.text = userBox.get("user")?.motherName ?? "";
    addressController.text = userBox.get("user")?.address ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = const InputDecoration(
        focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
    ));

    return Scaffold(
      backgroundColor: const Color(0xFF7292CF),
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              "assets/Star_Background.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 20.0, bottom: 10.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "My Profile",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 25.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "DONE",
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    // height: MediaQuery.of(context).size.height / 1.165,
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
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 80.0,
                                          width: 80.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFCACACA),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              userBox.get("user")?.name ?? "NA",
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Enroll: ${userBox.get("user")?.enrollmentNumber ?? "null"}",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xFF777777)),
                                            ),
                                            Text(
                                              "Semester: ${userBox.get("user")?.semester ?? "null"}",
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xFF777777)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 4.0, right: 4.0),
                                      child: Icon(Icons.camera_alt_outlined),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Contact Number",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: textFieldTitle,
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.4,
                                          child: TextField(
                                            cursorColor: primaryColor,
                                            controller: contactController,
                                          ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Academic Year",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: textFieldTitle,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                        child: TextField(
                                          controller: academicYearController,
                                          readOnly: true,
                                          decoration: inputDecoration,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Branch",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: textFieldTitle,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                        child: TextField(
                                          controller: branchController,
                                          readOnly: true,
                                          decoration: inputDecoration,
                                          cursorColor: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date of Birth",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: textFieldTitle,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                        child: TextField(
                                          controller: dobController,
                                          readOnly: true,
                                          decoration: inputDecoration,
                                          cursorColor: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email ID",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: textFieldTitle,
                                    ),
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration: inputDecoration,
                                    cursorColor: primaryColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mother Name",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: textFieldTitle,
                                    ),
                                  ),
                                  TextField(
                                    controller: motherNameController,
                                    decoration: inputDecoration,
                                    cursorColor: primaryColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Father Name",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: textFieldTitle,
                                    ),
                                  ),
                                  TextField(
                                    controller: fatherNameController,
                                    decoration: inputDecoration,
                                    cursorColor: primaryColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Permanent Address",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: textFieldTitle,
                                    ),
                                  ),
                                  TextField(
                                    controller: addressController,
                                    decoration: inputDecoration,
                                    cursorColor: primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
