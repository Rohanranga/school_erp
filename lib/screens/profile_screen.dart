import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String enrollmentNumber = '';
  String profileImageUrl = '';
  File? _profileImage; // Profile image file

  // Controllers for user input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController enrollmentController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController academicController = TextEditingController();

  final ImagePicker _picker = ImagePicker(); // Image picker
  User? currentUser; // Firebase user
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // Fetch the current authenticated user
  }

  Future<void> fetchCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await fetchUserData(); // Fetch user profile data from Firestore
    }
  }

  Future<void> fetchUserData() async {
    if (currentUser != null) {
      try {
        // Reference to the user's profile document in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('profile_history')
            .doc(currentUser!.uid) // Using UID as document ID
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            userName = userData['name'] ?? 'NA';
            enrollmentNumber = userData['enrollmentNumber'] ?? 'Not available';
            profileImageUrl = userData['profileImageUrl'] ?? '';

            // Populate text fields
            nameController.text = userData['name'] ?? '';
            enrollmentController.text = userData['enrollmentNumber'] ?? '';
            branchController.text = userData['branch'] ?? '';
            dobController.text = userData['dateOfBirth'] ?? '';
            contactController.text = userData['contactNumber'] ?? '';
            fatherNameController.text = userData['fatherName'] ?? '';
            motherNameController.text = userData['motherName'] ?? '';
            addressController.text = userData['address'] ?? '';
            academicController.text = userData['academic'] ?? '';
          });
        } else {
          print("No document found for the current user.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> uploadProfileImage() async {
    if (_profileImage == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${currentUser!.uid}.jpg');
      await storageRef.putFile(_profileImage!);
      String downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        profileImageUrl = downloadUrl; // Set the download URL
      });
    } catch (e) {
      print("Error uploading profile image: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> storeUserProfile() async {
    if (currentUser == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      // Upload profile image if selected
      if (_profileImage != null) {
        await uploadProfileImage();
      }

      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('profile_history')
          .doc(currentUser!.uid); // Using UID as document ID

      // Store updated profile data
      await userDocRef.set({
        'name': nameController.text,
        'enrollmentNumber': enrollmentController.text,
        'branch': branchController.text,
        'dateOfBirth': dobController.text,
        'contactNumber': contactController.text,
        'fatherName': fatherNameController.text,
        'motherName': motherNameController.text,
        'address': addressController.text,
        'profileImageUrl': profileImageUrl,
        'academicyear': academicController,
        'created_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merge to update existing fields

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      print("Error storing user profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error updating profile. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  bool validateFields() {
    return nameController.text.isNotEmpty &&
        enrollmentController.text.isNotEmpty &&
        branchController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        contactController.text.isNotEmpty &&
        fatherNameController.text.isNotEmpty &&
        motherNameController.text.isNotEmpty &&
        addressController.text.isNotEmpty;
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
                            Icon(Icons.chevron_left,
                                size: 30, color: Colors.white),
                            SizedBox(width: 5.0),
                            Text("My Profile",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (validateFields()) {
                            await storeUserProfile(); // Store user profile on save
                            Navigator.pop(context, {
                              'name': nameController.text,
                              'enrollmentNumber': enrollmentController.text,
                              'academicyear': academicController,
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all fields.")),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check, size: 25.0),
                              SizedBox(width: 5.0),
                              Text("DONE", style: TextStyle(fontSize: 13.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          children: [
                            GestureDetector(
                              onTap: selectImage, // Trigger image selection
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : (profileImageUrl.isNotEmpty
                                        ? NetworkImage(profileImageUrl)
                                            as ImageProvider
                                        : const AssetImage(
                                            'assets/avatar_placeholder.png')),
                              ),
                            ),
                            const SizedBox(height: 15),
                            buildTextField("Name", nameController),
                            const SizedBox(height: 15),
                            buildTextField(
                                "Enrollment Number", enrollmentController),
                            const SizedBox(height: 15),
                            buildTextField(
                                "Contact Number", academicController),
                            const SizedBox(height: 15),
                            buildTextField("Branch", branchController),
                            const SizedBox(height: 15),
                            buildTextField("Date of Birth", dobController),
                            const SizedBox(height: 15),
                            buildTextField("Contact Number", contactController),
                            const SizedBox(height: 15),
                            buildTextField(
                                "Father's Name", fatherNameController),
                            const SizedBox(height: 15),
                            buildTextField(
                                "Mother's Name", motherNameController),
                            const SizedBox(height: 15),
                            buildTextField("Address", addressController),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isLoading)
              const Center(
                  child:
                      CircularProgressIndicator()), // Show loading spinner when saving or uploading
          ],
        ),
      ),
    );
  }

  // Reusable text field builder
  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
