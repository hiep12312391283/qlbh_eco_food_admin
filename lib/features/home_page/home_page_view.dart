import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/category/view/category_page.dart';
import 'package:qlbh_eco_food_admin/features/profile/view/profile_page.dart';
import 'package:qlbh_eco_food_admin/features/home_page/home_page_controller.dart';
import 'package:qlbh_eco_food_admin/features/nofitication/view/nofitication_page.dart';
import 'package:qlbh_eco_food_admin/features/order/view/order_page.dart';
import 'package:qlbh_eco_food_admin/features/product/view/product_page.dart';

class HomePageView extends GetView<HomePageController> {
  HomePageView({super.key});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final role = arguments != null && arguments['role'] != null
        ? arguments['role']
        : 'default'; // Nếu không có giá trị 'role', sử dụng giá trị mặc định

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(), // Tắt hiệu ứng vuốt
        controller: _pageController,
        onPageChanged: (index) {
          controller.pageIndex.value = index;
        },
        children: _buildPages(role),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: Obx(
          () => BottomNavigationBar(
            items: _buildBottomNavItems(role),
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.pageIndex.value,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.green,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              controller.pageIndex.value = index;
              _pageController.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages(String role) {
    if (role == 'admin') {
      return [
        ProductPage(),
        NofiticationPage(),
        CategoryPage(),
      ];
    } else if (role == 'employee') {
      return [
        ProductPage(),
        OrderPage(),
        ProfilePage(),
      ];
    }
    // Trường hợp mặc định (role không phải là 'admin' hay 'employee')
    return [
      ProductPage(),
      OrderPage(),
      ProfilePage(),
    ];
  }

  List<BottomNavigationBarItem> _buildBottomNavItems(String role) {
    if (role == 'admin') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Sản phẩm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Thông Báo",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: 'Danh mục',
        ),
      ];
    } else if (role == 'employee') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Sản phẩm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          label: 'Đơn hàng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Tài Khoản',
        ),
      ];
    }
    // Trường hợp mặc định (role không phải là 'admin' hay 'employee')
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Sản phẩm',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.local_shipping),
        label: 'Đơn hàng',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Tài khoản',
      ),
    ];
  }
}
