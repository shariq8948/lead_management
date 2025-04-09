import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_select.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Leads Login"),
        centerTitle: true,
      ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Section with Subtle Shadow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2),
                    //     spreadRadius: 2,
                    //     blurRadius: 5,
                    //     offset: Offset(0, 3),
                    //   ),
                    // ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/images/login.png",
                      height: size.height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Welcome Text with Enhanced Styling
                Text(
                  'Welcome Back',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign in to continue',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 30),

                Form(
                  key: controller.loginFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      // Domain Dropdown with Improved Design
                      CustomSelect(
                        withShadow: true,
                        // shadowColor: Colors.grey.withOpacity(0.2),
                        label: "Select Domain",
                        suggestionFn: (search) async {
                          if (search.length >= 3) {
                            var data =
                                await controller.fetchDomains(search.trim());
                            return data != null
                                ? data
                                    .map(
                                      (e) => CustomSelectItem(
                                        id: e.domainUrl ?? "",
                                        value: e.companyName ?? "",
                                      ),
                                    )
                                    .toList()
                                : [];
                          }
                          return [];
                        },
                        placeholder: "Choose your domain",
                        mainList: const [],
                        onSelect: (val) {
                          FocusScope.of(context).unfocus();
                          controller.domainController.text = val.value;
                          controller.selectedDomain.value = val;
                        },
                        textEditCtlr: controller.domainController,
                        showLabel: true,
                        onTapField: () {
                          controller.domainController.clear();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please select a domain";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Email Field with Refined Styling
                      CustomTextField(
                        labelText: "Email Address",
                        hintText: "Enter your email",
                        textController: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return "Email is required";
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      Obx(() => CustomTextField(
                            labelText: "Password",
                            hintText: "Enter your password",
                            textController: controller.passwordController,
                            secure: true,
                            showPass: controller.showPass.value,
                            showPassFn: () => controller.showPass.toggle(),
                            passwordField: true,
                            validator: (value) {
                              if (value!.isEmpty) return "Password is required";
                              return null;
                            },
                          )),

                      // Forgot Password with Better Alignment
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showForgotPasswordDialog(context),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button with Improved Aesthetics
                Obx(() => CustomButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        controller.login();
                      },
                      buttonType: ButtonTypes.primary,
                      width: size.width * 0.7,
                      text: "Login",
                      enabled: true,
                      loading: controller.loading.value,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController forgotMobileController =
        TextEditingController();
    final GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue.shade100, width: 2),
        ),
        backgroundColor: Colors.white,
        elevation: 10,
        title: Column(
          children: [
            Icon(Icons.lock_reset, color: Colors.blue, size: 50),
            Text(
              'Reset Password',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.blue.shade800,
                fontSize: 22,
              ),
            ),
          ],
        ),
        content: Form(
          key: forgotFormKey,
          child: TextFormField(
            controller: forgotMobileController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mobile number is required';
              }
              if (value.length != 10) {
                return 'Mobile number must be 10 digits';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Only numeric characters allowed';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone_android, color: Colors.blue),
              hintText: 'Enter your mobile number',
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              if (forgotFormKey.currentState!.validate()) {
                // Implement reset password logic with mobile number
                Navigator.pop(context);
              }
            },
            child: Text(
              'Reset Password',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
