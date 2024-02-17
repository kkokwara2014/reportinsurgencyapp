import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';

class UserList extends StatelessWidget {
  const UserList({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.nickname.substring(0, 2).toUpperCase()),
        ),
        title: Text(user.nickname),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text(user.role),
          ],
        ),
      ),
    );
  }
}
