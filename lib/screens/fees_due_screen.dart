import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:school_erp/constants/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/user_model.dart';
import '../reusable_widgets/fees_due_card.dart';

class FeesDueScreen extends StatefulWidget {
  const FeesDueScreen({super.key});

  @override
  State<FeesDueScreen> createState() => _FeesDueScreenState();
}

class _FeesDueScreenState extends State<FeesDueScreen> {
  Box<UserModel> userBox = Hive.box<UserModel>('users');
  late Razorpay _razorpay;
  String username = '';
  String enrollmentNumber = '';
  String classyear = '';
  List<Map<String, dynamic>> feesDueList = [];

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    _fetchUserProfile();
  }

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
        username = userData['name'];
        enrollmentNumber = userData['enrollmentNumber'];
        classyear = userData['class'];
      });

      await _fetchFeeCollection();
    }
  }

  Future<void> _fetchFeeCollection() async {
    // Reference to the user's fees document using enrollment number
    final feesCollectionRef = FirebaseFirestore.instance
        .collection('fees')
        .doc(enrollmentNumber); // Use correct enrollment number here

    final feesDoc = await feesCollectionRef.get();

    if (feesDoc.exists) {
      final feesData = feesDoc.data() as Map<String, dynamic>;

      // Since the structure seems flat, you can directly extract fields
      setState(() {
        feesDueList = [feesData]; // Add the fees data to the list
      });
    } else {
      debugPrint("No document found for enrollmentNumber: $enrollmentNumber");
    }
  }

  Future<void> _generateAndSavePDF(Map<String, dynamic> feeData) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Storage permission denied!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Fees Receipt", style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text("Receipt No: ${feeData['receipt_no']}"),
              pw.Text("Description: ${feeData['description']}"),
              pw.Text("Payment Date: ${feeData['payment_date']}"),
              pw.Text("Payment Mode: ${feeData['payment_mode']}"),
              pw.Text("Amount: ₹${feeData['amount']}"),
              pw.Text("Status: ${feeData['status']}"),
            ],
          );
        },
      ),
    );

    // Get path to save the file
    Directory? directory = await getExternalStorageDirectory();
    String path = directory!.path;
    String fileName = "fees_receipt_${feeData['receipt_no']}.pdf";

    // Save the PDF
    final file = File('$path/$fileName');
    await file.writeAsBytes(await pdf.save());

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PDF saved: $fileName"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint(
        "PaymentId: ${response.paymentId} \n OrderId: ${response.orderId}");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Payment Successful"),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Error Response: ${response.message}");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Payment Failed"),
      showCloseIcon: true,
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ));
  }

  void openCheckout() {
    debugPrint("Checkout initiated");
    var options = {
      "key": "rzp_test_wFEIWe7sxtp71p",
      "amount": 999 * 100,
      "name": "test payment",
      "description": "this is the test payment",
      "prefill": {
        "contact":
            userBox.get("user")?.contactNumber?.split(" ")[1] ?? "0000000000",
        "email": "tanish.pradhan4@gmail.com",
      }
    };
    _razorpay.open(options);
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
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 20.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.chevron_left, size: 30, color: Colors.white),
                        SizedBox(width: 5.0),
                        Text("Fees Due",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: $username",
                        style: const TextStyle(
                            fontSize: 22.0, color: Colors.white),
                      ),
                      Text(
                        "Enrollment Number: $enrollmentNumber",
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                      const SizedBox(height: 20.0), // Spacing
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 30.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: feesDueList.map((fee) {
                            return FeesDueCard(
                              description: fee['description'] ?? 'N/A',
                              status: fee['status'] ?? 'N/A',
                              receiptNo: fee['receipt_no'] ?? "#N/A",
                              paymentDate: fee['payment_date'] ?? "N/A",
                              paymentMode: fee['payment_mode'] ?? "N/A",
                              amount: "₹${fee['amount'] ?? '0'}",
                              onTapPay: () {
                                openCheckout(); // Trigger Razorpay checkout
                              },
                              onTapDownload: () {
                                _generateAndSavePDF(
                                    fee); // Generate and save PDF
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
