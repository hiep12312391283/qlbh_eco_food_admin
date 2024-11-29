import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';

class BaseWidget {
  static Widget buildText(
    String text, {
    FontWeight? fontWeight,
    TextAlign? textAlign,
    Color? textColor,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) {
    return AutoSizeText(
      text,
      textAlign: textAlign ?? TextAlign.center,
      style: style ??
          AppTextStyle.font12Re.copyWith(
              fontWeight: fontWeight,
              overflow: TextOverflow.ellipsis,
              color: textColor),
      maxLines: maxLines ?? 1,
    );
  }

  static Widget buildIconAppBar({
    Function()? onTap,
    required Icon icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: icon,
    );
  }

  static Widget buildAppBarCustom(
      {Color backgroundColor = AppColors.backgroundColor,
      String hintText = "Nhập để tìm kiếm..."}) {
    return Container(
      color: AppColors.green,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: const TextStyle(
                          fontFamily: "Oswald",
                          color: Colors.grey,
                          fontWeight: FontWeight.w300
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ).paddingOnly(right: 8),
          ),
          BaseWidget.buildIconAppBar(
            onTap: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          ).paddingOnly(right: 8),
          BaseWidget.buildIconAppBar(
            icon: const Icon(
              Icons.chat_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 16),
    );
  }

  static Widget buildButtonShoppingCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        BaseWidget.buildText(
          "Mua ngay",
          style: AppTextStyle.font16Re.copyWith(color: Colors.white),
        ).paddingSymmetric(horizontal: 12)
      ],
    );
  }
}
