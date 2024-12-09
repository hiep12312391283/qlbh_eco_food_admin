import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/app/binding/global_binding.dart';
import 'package:qlbh_eco_food_admin/app/ui/splash_screen.dart';
import 'package:qlbh_eco_food_admin/features/home_page/home_page_binding.dart';
import 'package:qlbh_eco_food_admin/features/home_page/home_page_view.dart';
import 'package:qlbh_eco_food_admin/features/login/binding/login_binding.dart';
import 'package:qlbh_eco_food_admin/features/login/view/login_page.dart';
import 'package:qlbh_eco_food_admin/features/product/binding/product_binding.dart';
import 'package:qlbh_eco_food_admin/features/product/view/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final options = Firebase.app().options;
  print('Project ID: ${options.projectId}');
  print('App ID: ${options.appId}');
  print('API Key: ${options.apiKey}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      initialBinding: GlobalBinding(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(
            name: '/home_page',
            page: () => HomePageView(),
            binding: HomePageBinding()),
        GetPage(
            name: '/product',
            page: () => ProductPage(),
            binding: ProductBinding()),
      ],
    );
  }
}
