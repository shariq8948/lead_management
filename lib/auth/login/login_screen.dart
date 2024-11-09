import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Login Screen Controller
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 80),

                    // Logo
                    Image.asset(
                      "assets/images/login.png",
                      fit: BoxFit.fitWidth,
                    ),

                    const SizedBox(height: 60),

                    // Form
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 24),
                          CustomTextField(
                            labelText: "Email",
                            hintText: "Enter your email address",
                            textController: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field is required";
                              }
                              if (!GetUtils.isEmail(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 34),
                          Obx(
                                () => CustomTextField(
                              labelText: "Password",
                              hintText: "Enter your password",
                              textController: controller.passwordController,
                              secure: true,
                              showPass: controller.showPass.value,
                              showPassFn: () => controller.showPass.toggle(),
                              passwordField: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Obx(
                          () => CustomButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          controller.login(); // Call login method
                        },
                        buttonType: ButtonTypes.primary,
                        width: Get.size.width * 0.6,
                        text: "Login",
                        enabled: true,
                        loading: controller.loading.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
