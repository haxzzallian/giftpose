import 'package:giftpose_app/theme/colors.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => _isFocused = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 46,
        decoration: BoxDecoration(
          color: _isFocused ? Colors.white : brandSurface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: _isFocused ? brandAccent : Colors.transparent,
            width: 1.8,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: brandAccent.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: TextFormField(
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            color: brandTextPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search anything...',
            hintStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: brandTextSecondary,
              fontSize: 13,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: _isFocused ? brandAccent : brandTextSecondary,
              size: 19,
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color:
                    _isFocused ? brandAccent : brandPrimary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: _isFocused ? Colors.white : brandPrimary,
                size: 14,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }
}
