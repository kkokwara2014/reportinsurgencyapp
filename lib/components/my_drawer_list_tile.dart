import 'package:flutter/material.dart';

class MyDrawerListTile extends StatelessWidget {
  const MyDrawerListTile(
      {super.key,
      required this.onTap,
      required this.mytitle,
      this.leadingIcon,
      this.trailingIcon});
  final String mytitle;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(leadingIcon),
        title: Text(mytitle),
        trailing: Icon(
          trailingIcon,
          size: 20,
        ),
      ),
    );
  }
}
