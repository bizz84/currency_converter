import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.trailing,
  });
  final String title;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
