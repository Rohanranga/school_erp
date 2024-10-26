import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_erp/screens/ask_doubt_screen.dart';
import 'package:school_erp/screens/assignment_screen.dart';
import 'package:school_erp/screens/attendance/attendance_screen.dart';
import 'package:school_erp/screens/events/events_screen.dart';
import 'package:school_erp/screens/fees_due_screen.dart';
import 'package:school_erp/screens/student_screens/settings_screen.dart';

import '../../model/user_model.dart';
import '../../reusable_widgets/home_screen_cards/master_card.dart';
import '../../reusable_widgets/home_screen_cards/small_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';
  String enrollmentNumber = '';
  String classyear = '';
  String _profileImageUrl = '';
  String _attendance = '';
  String _feesDue = '';
  String _section = '';

  Future<void> _fetchUserProfile() async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('profile_history')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final userDoc = await userDocRef.get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        _profileImageUrl = userData['profileImageUrl'];
        username = userData['name'];
        enrollmentNumber = userData['enrollmentNumber'];
        classyear = userData['class'];
        _section = userData['section'];
      });
      await _fetchFeesDue(enrollmentNumber);
    }
  }

  Future<void> _fetchFeesDue(String enrollmentNumber) async {
    final feeDocRef =
        FirebaseFirestore.instance.collection('fees').doc(enrollmentNumber);

    final feeDoc = await feeDocRef.get();

    if (feeDoc.exists) {
      final feeData = feeDoc.data() as Map<String, dynamic>;
      final amount = feeData['amount']; // Fetch the amount value

      setState(() {
        _feesDue = amount.toString(); // Convert to string to display in UI
      });
    } else {
      // Show "Due" if no data is found
      setState(() {
        _feesDue = "NULL";
      });
      print("No fees data found for enrollment number: $enrollmentNumber");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
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
            SingleChildScrollView(
              // Wrapped content with SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi,$username",
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "$enrollmentNumber",
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                "Class:$classyear$_section",
                                style: const TextStyle(
                                  color: Color(0xFF6184C7),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                          child: ZoomIn(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _profileImageUrl.isNotEmpty
                                  ? NetworkImage(_profileImageUrl)
                                  : null,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AttendanceScreen(),
                                  ),
                                );
                              },
                              child: BounceInLeft(
                                child: const HomeScreenMasterCard(
                                  attendancepercentage: '',
                                  attendance: true,
                                  tooltext: 'Check out your attendance here ',
                                ),
                              ),
                            ),
                            BounceInRight(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FeesDueScreen(),
                                    ),
                                  );
                                },
                                child: HomeScreenMasterCard(
                                  feespending: _feesDue,
                                  tooltext: 'Check your fee due here',
                                  attendance: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Wrap(
                          runAlignment: WrapAlignment.spaceBetween,
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 20.0,
                          spacing: 20.0,
                          children: [
                            BounceInDown(
                              child: HomeScreenSmallCard(
                                text: '',
                                tooltext:
                                    'Check out your marks by tapping the button',
                                icon: Icons.collections_bookmark_rounded,
                                buttonText: "Marks",
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Feature coming soon...",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      closeIconColor: Colors.white,
                                      showCloseIcon: true,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFF2855AE)
                                          .withOpacity(0.9),
                                    ),
                                  );
                                },
                              ),
                            ),
                            BounceInDown(
                              child: HomeScreenSmallCard(
                                text: '',
                                tooltext: 'Submit your assignments here ',
                                icon: Icons.person,
                                buttonText: "Assignments",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AssignmentScreen(),
                                  ),
                                ),
                              ),
                            ),
                            BounceInUp(
                              child: HomeScreenSmallCard(
                                text: '',
                                tooltext: 'Feel free to ask doughts here ',
                                icon: Icons.chat,
                                buttonText: "Ask Doubts",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AskDoubtScreen(),
                                  ),
                                ),
                              ),
                            ),
                            BounceInUp(
                              child: HomeScreenSmallCard(
                                text: '',
                                tooltext: 'Checkout all the events here ',
                                icon: Icons.edit_calendar_rounded,
                                buttonText: "Events",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventsScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
