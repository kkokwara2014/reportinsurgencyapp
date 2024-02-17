import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  ProfileListTile({
    super.key,
    required this.onTap,
    required this.caption,
    required this.leadingIcon,
    required this.hasTrailingIcon,
  });
  final void Function()? onTap;
  final IconData leadingIcon;
  final String caption;
  bool hasTrailingIcon = true;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        leadingIcon,
        size: 21,
      ),
      title: Text(caption),
      trailing: hasTrailingIcon
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16,
            )
          : null,
    );
  }
}
