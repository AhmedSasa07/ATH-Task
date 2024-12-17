import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_cubit.dart';
import 'user_info_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoggedOut) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              builder: (context, state) {
                if (state is AuthSuccess) {
                  return UserInfoWidget(
                    userEmail: context.read<AuthCubit>().currentUser?.email ?? '',
                    onSignOut: () => context.read<AuthCubit>().signOut(),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}