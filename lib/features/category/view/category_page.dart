import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/category/controller/category_controller.dart';
import 'package:qlbh_eco_food_admin/features/customer/view/customer_page.dart';

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
            // Container(
            //   height: 50,
            //   width: double.infinity,
            //   decoration: const BoxDecoration(color: Colors.white),
            //   child: BaseWidget.buildText(
            //     "Tài khoản",
            //     style: AppTextStyle.font24Re,
            //   ),
            // ),
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
                        Get.to(CustomerPage());
                      },
                      text: "Quản lý Khách hàng",
                      icon: Icons.people_outline), // Adjusted icon
                  const Divider(height: 0.5),
                  _buildButtonProfile(
                      onPressed: () {},
                      text: "Quản lý Nhân viên",
                      icon: Icons.people_alt_outlined), // Adjusted icon
                  const Divider(height: 1),
                  _buildButtonProfile(
                      onPressed: () {},
                      text: "Lịch sử đơn hàng",
                      icon: Icons.history), // Adjusted icon
                  const Divider(height: 1),
                  _buildButtonProfile(
                      onPressed: () {},
                      text: "Báo cáo đơn hàng",
                      icon: Icons.report), // Adjusted icon
                  const Divider(height: 1),
                  _buildButtonProfile(
                      onPressed: () {},
                      text: "Thống kê sản phẩm",
                      icon: Icons.inventory), // Adjusted icon
                  const Divider(height: 1),
                  _buildButtonProfile(
                      onPressed: () {},
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
                    Get.offAllNamed("/login");
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
