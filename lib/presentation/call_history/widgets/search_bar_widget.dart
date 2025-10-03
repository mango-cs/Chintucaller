import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onClearSearch;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    this.onClearSearch,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
    });
    widget.onSearchChanged('');
    widget.onClearSearch?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: TextField(
        controller: _searchController,
        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
          color: AppTheme.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search calls, numbers, or content...',
          hintStyle: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondary,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
          suffixIcon: _isSearchActive
              ? GestureDetector(
                  onTap: _clearSearch,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: AppTheme.contentSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.borderSubtle, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.borderSubtle, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.activeGreen, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        onChanged: (value) {
          setState(() {
            _isSearchActive = value.isNotEmpty;
          });
          widget.onSearchChanged(value);
        },
      ),
    );
  }
}
