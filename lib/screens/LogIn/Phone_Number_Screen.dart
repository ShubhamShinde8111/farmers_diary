import 'package:flutter/material.dart';
import 'dart:math';
import 'OTP_Verification_Screen.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String errorMessage = '';
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');

  void sendMockOTP() {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    Future.delayed(Duration(seconds: 2), () {
      try {
        final otp = (100000 + Random().nextInt(899999)).toString();
        print("Generated OTP: $otp");

        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: _phoneNumber.phoneNumber ?? '',
              otp: otp,
            ),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to send OTP. Please try again.';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.verified_user, size: 70, color: Colors.teal.shade700),
                SizedBox(height: 20),
                Text(
                  "Phone Verification",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Enter your phone number to receive an OTP.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          setState(() => _phoneNumber = number);
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DROPDOWN, // <- Dropdown Selector
                          useEmoji: true,
                          trailingSpace: false,
                        ),
                        initialValue: _phoneNumber,
                        textFieldController: phoneController,
                        inputDecoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.phone, color: Colors.teal),
                        ),
                        maxLength: 15,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : sendMockOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                              : Text(
                            "Send OTP",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "By continuing, you agree to our Terms & Conditions and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
