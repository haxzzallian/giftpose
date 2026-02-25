import 'package:giftpose_app/theme/colors.dart';
import 'package:giftpose_app/theme/sizes.dart';
import 'package:giftpose_app/theme/text-styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color? enabledBtnColor;
  final Color? disabledBtnColor;
  final Color? textColor;
  final bool? enabled;
  final double? paddingVertical;
  final bool? smallButton;
  final Function() onTap;
  const AppButton(
      {super.key,
      required this.text,
      this.enabledBtnColor,
      this.textColor,
      this.enabled,
      required this.onTap,
      this.disabledBtnColor,
      this.paddingVertical,
      this.smallButton = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var screenHeight = size.height;
    return GestureDetector(
      onTap: enabled == null
          ? onTap
          : enabled!
              ? onTap
              : null,
      child: Container(
        height: screenHeight * 0.065,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: enabled == null
                  ? enabledBtnColor ?? appPrimaryColor
                  : enabled!
                      ? enabledBtnColor ?? appPrimaryColor
                      : disabledBtnColor ??
                          const Color.fromRGBO(181, 223, 188, 1),
              width: 1),
          color: enabled == null
              ? enabledBtnColor ?? appPrimaryColor
              : enabled!
                  ? enabledBtnColor ?? appPrimaryColor
                  : disabledBtnColor ?? Color.fromRGBO(181, 223, 188, 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 8.0),
          child: Center(
            child: Text(text,
                style: bodyText2Style.copyWith(
                    color: enabled != null
                        ? enabled!
                            ? textColor ?? Colors.white
                            : Colors.black
                        : textColor ?? Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: ts3)),
          ),
        ),
      ),
    );
  }
}
