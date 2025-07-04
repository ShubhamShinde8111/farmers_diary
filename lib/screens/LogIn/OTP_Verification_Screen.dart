import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_name_screen.dart';  // Make sure this path is correct

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String otp; // OTP to be compared

  // Constructor
  OtpVerificationScreen({required this.phoneNumber, required this.otp});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final otpController = TextEditingController();
  bool isLoading = false;  // To track loading state
  String errorMessage = ''; // Store error message

  // Function to verify OTP
  void verifyOTP() async {
    String enteredOtp = otpController.text.trim();

    // Basic validation for OTP
    if (enteredOtp.isEmpty) {
      setState(() {
        errorMessage = 'Please enter the OTP';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';  // Clear previous error
    });

    // Simulate OTP verification (you can replace this with real backend call)
    await Future.delayed(Duration(seconds: 2));  // Simulate network delay

    if (enteredOtp == "123456") {
      // Successfully verified OTP
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('phone_verified', true); // Store phone verified status

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP Verified Successfully")),
      );

      // Navigate to UserNameScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => UserNameScreen()),
      );
    } else {
      // Invalid OTP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP")),
      );
    }

    setState(() {
      isLoading = false; // Stop loading after OTP verification
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "OTP sent to ${widget.phoneNumber}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  hintText: "6-digit OTP",
                  prefixIcon: Icon(Icons.lock, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: errorMessage.isNotEmpty ? errorMessage : null,
                ),
                obscureText: false,
              ),
              SizedBox(height: 20),
              if (isLoading)
                Center(child: CircularProgressIndicator()) // Show loading spinner while verifying
              else
                ElevatedButton(
                  onPressed: verifyOTP,
                  child: Text("Verify OTP"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                "By verifying, you agree to our Terms & Conditions and Privacy Policy.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
