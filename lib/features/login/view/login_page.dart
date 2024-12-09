import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qlbh_eco_food_admin/app/ui/custom/custom_button.dart';
import 'package:qlbh_eco_food_admin/auth/auth_service.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/base/widget/base_widget.dart';
import 'package:qlbh_eco_food_admin/features/login/controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController controller = Get.put(LoginController());

  LoginPage({super.key});

  void login(BuildContext context) async {
    final authService = AuthService();

    // Bắt đầu quá trình đăng nhập, hiển thị loading
    controller.isLoading.value = true;

    try {
      User? user = await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
      if (user != null && user.emailVerified) {
        DocumentSnapshot accountDoc = await FirebaseFirestore.instance
            .collection('accounts')
            .doc(user.uid)
            .get();
        if (accountDoc.exists) {
          Map<String, dynamic> accountData =
              accountDoc.data()! as Map<String, dynamic>;
          String role = accountData['role'] ?? 'user';

          // In ra id và role tài khoản (cho mục đích debug)
          print('User ID: ${user.uid}');
          print('Role: $role');

          // Điều hướng dựa trên vai trò của tài khoản
          if (role == 'admin') {
            Get.offAllNamed('/home_page', arguments: {'role': 'admin'});
          } else if (role == 'employee') {
            Get.offAllNamed('/home_page', arguments: {'role': 'employee'});
          }

          // Ẩn loading sau khi lấy dữ liệu xong
          controller.isLoading.value = false;
        } else {
          controller.isLoading.value = false;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Không tìm thấy dữ liệu tài khoản"),
              content: Text("Không thể tải thông tin tài khoản từ Firestore."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        // Nếu email chưa xác thực
        controller.isLoading.value = false;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Email chưa được xác thực"),
            content: Text(
                "Vui lòng kiểm tra email của bạn để xác thực tài khoản trước khi đăng nhập."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Xử lý lỗi và ẩn loading
      controller.isLoading.value = false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Đăng nhập thất bại",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            "Email hoặc mật khẩu không đúng",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.green),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Form(
            autovalidateMode: controller.validateMode.value,
            child: SingleChildScrollView(
              child: SafeArea(child: Obx(
                () {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: SvgPicture.asset(
                          'assets/image/logo.svg',
                          width: 200,
                          height: 200,
                        ),
                      ).paddingOnly(top: 30),
                      const SizedBox(height: 20),
                      txtFormField(
                        controllerr: _emailController,
                        text: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập email";
                          }
                          return null;
                        },
                      ).paddingOnly(bottom: 16),
                      txtFormField(
                        obscureText: controller.isObscure.value,
                        controllerr: _passwordController,
                        text: "Mật khẩu",
                        icon: IconButton(
                          onPressed: () {
                            controller.toggleEyeIcon();
                          },
                          icon: Icon(
                            controller.isObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.length < 8 ||
                              value.isEmpty) {
                            return "Mật khẩu phải lớn hơn 8 ký tự";
                          }
                          return null;
                        },
                      ).paddingOnly(bottom: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {
                              Get.toNamed('/forgot-password');
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: BaseWidget.buildText("Quên mật khẩu?",
                                style: AppTextStyle.font16Re.copyWith(
                                  color: AppColors.green,
                                ))),
                      ).paddingOnly(bottom: 8),
                      // Nếu đang loading, hiển thị CircularProgressIndicator
                      controller.isLoading.value
                          ? CircularProgressIndicator()
                          : CustomButton(
                              textBtn: 'Đăng nhập',
                              onPressed: () {
                                login(context);
                              },
                            ).paddingOnly(bottom: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Chưa có tài khoản?",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Oswald',
                            ),
                          ).paddingOnly(right: 4),
                          InkWell(
                            onTap: () {
                              Get.toNamed('/register');
                            },
                            child: const Text(
                              "Đăng ký",
                              style: TextStyle(
                                color: Color(0xFF83C167),
                                fontSize: 16,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 16);
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget txtFormField({
    required String text,
    required TextEditingController controllerr,
    required FormFieldValidator<String> validator,
    TextStyle? style,
    int? maxLength,
    TextInputType? textInputType,
    List<TextInputFormatter>? inputFormatters,
    IconButton? icon,
    bool obscureText = false,
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(text, style: AppTextStyle.font16Re),
        ).paddingOnly(bottom: 8),
        TextFormField(
          controller: controllerr,
          obscureText: obscureText,
          style: style ??
              AppTextStyle.font14Re.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
          maxLength: maxLength,
          keyboardType: textInputType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            counterText: "",
            hintText: text,
            hintStyle: style,
            filled: true,
            fillColor: AppColors.txtFormField,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            suffixIcon: icon,
          ),
        )
      ],
    );
  }
}
