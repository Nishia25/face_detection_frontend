import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/src/auth/view/signin_screen.dart';
import 'package:vision_intelligence/src/auth/widgets/formtextfield.dart';
import '../../../common/theme/theme.dart';
import '../service/auth_service.dart';
import '../widgets/custom_scaffold.dart';
import 'dart:developer';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final _formSignupKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vehicleNoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool agreePersonalData = true;
  RxBool _isPasswordVisible = false.obs;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _vehicleNoController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox(height: 10)),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 35.0),

                      // Full Name
                      Formtextfield(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full name';
                          }
                          return null;
                        },
                        label: 'Full Name',
                        hintText: 'Enter Full Name',
                      ),
                      const SizedBox(height: 20.0),

                      // Email
                      Formtextfield(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          // Regular expression for basic email validation
                          final emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                        label: 'Email',
                        hintText: 'Enter Email',
                      ),
                      const SizedBox(height: 20.0),

                      // Vehicle Number
                      Formtextfield(
                        controller: _vehicleNoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Vehicle number';
                          }
                          return null;
                        },
                        label: 'Vehicle No.',
                        hintText: 'Enter Vehicle number',
                      ),
                      const SizedBox(height: 20.0),

                      //Phone number
                      Formtextfield(
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                        label: 'Phone No.',
                        hintText: 'Enter Phone number',
                      ),
                      const SizedBox(height: 20.0),

                      //Address
                      Formtextfield(
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                        label: 'Address',
                        hintText: 'Enter your address',
                      ),
                      const SizedBox(height: 20.0),

                      // Password
                      Obx(() {
                        return Formtextfield(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible.value,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          label: 'Password',
                          hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              _isPasswordVisible.value =
                              !_isPasswordVisible.value;
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 20.0),

                      // Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: lightColorScheme.primary,
                          ),
                          const Text(
                            'I agree to the processing of ',
                            style: TextStyle(color: Colors.black45),
                          ),
                          Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: lightColorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formSignupKey.currentState!.validate() && agreePersonalData) {
                                try {
                                  User? user = await _auth.createUserWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );

                                  if (user != null) {
                                    log("User Created Successfully");

                                    // Store additional user data in Firestore
                                    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                                      'name': _nameController.text.trim(),
                                      'email': _emailController.text.trim(),
                                      'vehicleNo': _vehicleNoController.text.trim(),
                                      'phone':_phoneController.text.trim(),
                                      'address':_addressController.text.trim(),
                                      'uid': user.uid,
                                      'createdAt': Timestamp.now(),
                                    });

                                    log("User Data Stored in Firestore");

                                    Get.snackbar(
                                      "Successfully Signed Up",
                                      "Please login here",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 3),
                                    );

                                    Get.off(() => const SignInScreen());
                                  }
                                } catch (e) {
                                  log("Error: $e");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Signup Failed: $e")),
                                  );
                                }
                              } else if (!agreePersonalData) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please agree to the processing of personal data'),
                                  ),
                                );
                              }
                            },
                          child: const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.black45),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.off(() => const SignInScreen());
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
