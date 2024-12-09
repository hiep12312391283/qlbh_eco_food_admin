import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/register/model/account_model.dart';
import 'package:qlbh_eco_food_admin/features/register/view/register_user_page.dart';
import 'package:qlbh_eco_food_admin/features/users/controller/user_controller.dart';
import 'user_detail_page.dart'; // Import trang chi tiết người dùng

class UserPage extends GetView<UserController> {
  final UserController controller = Get.put(UserController());
  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Danh sách người dùng',
          style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.green.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Điều hướng đến trang đăng ký tài khoản người dùng mới
              Get.to(() => RegisterUserPage());
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.green.shade100, AppColors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.users.isEmpty) {
            return Center(
                child: Text('Không có người dùng',
                    style: TextStyle(fontSize: 18.0)));
          }
          return ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              final account = controller.accounts.firstWhere(
                  (account) => account.accountId == user.id,
                  orElse: () => AccountModel(
                      accountId: '', email: '', password: '', role: 'user'));

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(user.name[0],
                        style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(user.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Email: ${user.email}\nRole: ${account.role}'),
                  onTap: () => Get.to(() => UserDetailPage(userModel: user)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      controller.deleteUser(user.id);
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
