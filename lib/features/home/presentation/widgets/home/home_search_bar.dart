import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class HomeSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String currentQuery;

  const HomeSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
    required this.currentQuery,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentQuery);
  }

  @override
  void didUpdateWidget(covariant HomeSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentQuery.isEmpty && _controller.text.isNotEmpty) {
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showClearIcon = widget.currentQuery.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: context.loc.searchPlaceholder,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.4),
          ),
          prefixIcon: Icon(Icons.search_rounded, color: context.colors.primary),

          suffixIcon: showClearIcon
              ? IconButton(
                  icon: Icon(Icons.close_rounded, color: context.colors.error),
                  onPressed: () {
                    _controller.clear();
                    widget.onClear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,

          filled: true,
          fillColor: context.colors.surface,
          contentPadding: context.paddingAllM,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.radius.large),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.radius.large),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.radius.large),
            borderSide: BorderSide(color: context.colors.primary, width: 1),
          ),
        ),
        style: context.textTheme.bodyLarge?.copyWith(
          color: context.colors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
