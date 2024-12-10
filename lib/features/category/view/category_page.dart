import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/category/controller/category_controller.dart';
import 'package:qlbh_eco_food_admin/features/employee/view/employee_page.dart';
import 'package:qlbh_eco_food_admin/features/login/view/login_page.dart';
import 'package:qlbh_eco_food_admin/features/statistics/orderstatistics_page.dart';
import 'package:qlbh_eco_food_admin/features/statistics/produc_statistics_page.dart';
import 'package:qlbh_eco_food_admin/features/statistics/user_statistics_page.dart';
import 'package:qlbh_eco_food_admin/features/users/view/user_page.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green.shade100,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildButtonProfile(
                      onPressed: () {},
                      text: "Thông tin cá nhân",
                      icon: Icons.person_outline),
                  const Divider(height: 0.5),
                  _buildButtonProfile(
                      onPressed: () {
                        Get.to(UserPage());
                      },
                      text: "Quản lý Khách hàng",
                      icon: Icons.people_outline), // Adjusted icon
                  const Divider(height: 0.5),
                  _buildButtonProfile(
                      onPressed: () {
                        Get.to(EmployeePage());
                      },
                      text: "Quản lý Nhân viên",
                      icon: Icons.people_alt_outlined), // Adjusted icon
                  const Divider(height: 1),
                  _buildButtonProfile(
                      onPressed: () {
                        Get.to(OrderStatisticsPage());
                      },
                      text: "Báo cáo đơn hàng",
                      icon: Icons.report), // Adjusted icon
                  const Divider(height: 1),
                  _buildButtonProfile(
                      onPressed: () {
                        Get.to(ProductStatisticsPage());
                      },
                      text: "Thống kê sản phẩm",
                      icon: Icons.inventory), // Adjusted icon
                  const Divider(height: 1),
                  _buildButtonProfile(
                      onPressed: () {
                        Get.to(UserStatisticsPage());
                      },
                      text: "Thống kê khách hàng",
                      icon: Icons.bar_chart), // Adjusted icon
                ],
              ),
            ).paddingAll(16),
            const Spacer(),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _buildButtonProfile(
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                  text: "Đăng xuất",
                  icon: Icons.logout_outlined,
                  showChevron: false),
            ).paddingAll(16)
          ],
        ),
      ),
    );
  }

  Widget _buildButtonProfile({
    required String text,
    IconData? icon,
    bool showChevron = true,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              Icon(icon).paddingSymmetric(horizontal: 16),
              Text(
                text,
                style: AppTextStyle.font18Be,
              ),
              const Spacer(),
              if (showChevron)
                const Icon(Icons.chevron_right).paddingSymmetric(horizontal: 8),
            ],
          ),
        ),
      ),
    );
  }
}
