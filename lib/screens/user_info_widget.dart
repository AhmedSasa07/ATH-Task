import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final String userEmail;
  final VoidCallback onSignOut;

  const UserInfoWidget({
    Key? key,
    required this.userEmail,
    required this.onSignOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome back!',
        ),
        const SizedBox(height: 16),
        Text(
          userEmail,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onSignOut,
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}