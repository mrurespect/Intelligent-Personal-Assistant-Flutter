import 'package:chatpotgemini/helpers/font_size.dart';
import 'package:chatpotgemini/helpers/theme_colors.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final String? iconPath;
  final Function() onTap;
  const MainButton({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    required this.onTap,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor == null
              ? ThemeColors.primaryColor
              : backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconPath == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Image(
                        image: AssetImage(iconPath!),
                        height: 30,
                      ),
                    ),
              Text(
                text,
                style: TextStyle(
                  color: textColor == null
                      ? ThemeColors.whiteTextColor
                      : textColor,
                  fontSize: FontSize.medium,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
