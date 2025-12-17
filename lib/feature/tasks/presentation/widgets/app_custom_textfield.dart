import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager_flutter/core/utils/margine_extensions.dart';
import '../../../../core/constans/colors.dart';
import '../../../../core/constans/styles.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String labelText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final int? maxLines; 
  final int? minLines;
  final int? maxLength; 
  final bool useHintInsteadOfLabel;
  final double? height;
  final Function()? onTap;
   final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters; 

  const CustomTextField({
    super.key,
    this.label,
    required this.controller,
    required this.textInputType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.minLines,
    this.readOnly = false,
     this.inputFormatters,
    required this.labelText,
    this.onChanged,
    this.maxLines,
    this.maxLength,
    this.useHintInsteadOfLabel = false,
    this.height,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      readOnly: readOnly,
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      decoration: InputDecoration(
        counterText: '',
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: useHintInsteadOfLabel ? labelText : null,
        labelText: useHintInsteadOfLabel ? null : labelText,
        hintStyle: AppTextStyles.textStyle_500_14.copyWith(
          color: darkGrey,
        ),
        labelStyle: AppTextStyles.textStyle_500_14.copyWith(
          color: darkGrey,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ), // tweak this to increase internal vertical space
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
      ),
      validator: validator,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label!,
      style: AppTextStyles.textStyle_500_14.copyWith(color: darkerTextColor)),
        8.hBox,
        if (height != null)
          SizedBox(height: height, child: textField)
        else
          textField,
      ],
    );
  }
}
