import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/common/widgets/circular_indicator.dart';
import 'package:vision_intelligence/src/auth/view/forget_password_screen.dart';
import 'package:vision_intelligence/src/auth/view/signup_screen.dart';
import 'package:vision_intelligence/src/auth/widgets/formtextfield.dart';
import 'package:vision_intelligence/src/main/view/main_screen.dart';
import '../../../common/theme/theme.dart';
import '../service/auth_service.dart';
import '../widgets/custom_scaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = AuthService();
  final _formSignInKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool rememberPassword = true;
  final RxBool _isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Stack(
        children: [
          Column(
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox(height: 10),
              ),
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
                      key: _formSignInKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: lightColorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 40.0),

                          Formtextfield(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Email';
                              }
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
                          const SizedBox(height: 25.0),

                          Obx(() {
                            return Formtextfield(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible.value,
                              obscuringCharacter: '*',
                              validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Please enter Password'
                                  : null,
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
                              label: 'Password',
                              hintText: 'Enter Password',
                            );
                          }),
                          const SizedBox(height: 25.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberPassword,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberPassword = value!;
                                      });
                                    },
                                    activeColor: lightColorScheme.primary,
                                  ),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(ForgotPasswordScreen());
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: lightColorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formSignInKey.currentState!.validate()) {
                                  isLoading.value = true; // Show loader

                                  final user = await _auth
                                      .loginUserWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                  );

                                  isLoading.value = false; // Hide loader

                                  if (user != null) {
                                    debugPrint("User Logged In");
                                    Get.offAll(() => MainScreen());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                          Text('Invalid email or password')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Sign in'),
                            ),
                          ),
                          const SizedBox(height: 35.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account? ',
                                style: TextStyle(color: Colors.black45),
                              ),
                              GestureDetector(
                                onTap: () => Get.to(() => const SignUpScreen()),
                                child: Text(
                                  'Sign up',
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
          Obx(() {
            return isLoading.value
                ? CircularIndicator(isLoading: true) // Show loader
                : SizedBox.shrink(); // Hide loader
          }),
        ],
      ),
    );
  }
}