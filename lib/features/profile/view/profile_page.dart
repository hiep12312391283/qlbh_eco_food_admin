import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/profile/controller/profile_controller.dart';
import 'package:qlbh_eco_food_admin/features/profile/view/edit_profile_page.dart';


class ProfilePage extends GetView<ProfileController> {
  ProfilePage({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                      onPressed: () {
                        Get.to(EditProfilePage());
                      },
                      text: "Thông tin cá nhân",
                      icon: Icons.person_outline),
                  const Divider(height: 0.5),
                  _buildButtonProfile(
                      onPressed: () {},
                      text: "Tổng đài tư vấn: 1900.1908",
                      icon: Icons.phone_outlined),
                  const Divider(height: 1),
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
