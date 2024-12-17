import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_cubit.dart';
import 'home_screen.dart';
import 'login_register_screen.dart';


class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: MaterialApp(
        title: 'ATW Auth Task',
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return HomeScreen();
            } else {
              return LoginRegisterScreen();
            }
          },
        ),
        routes: {
          '/home': (_) => HomeScreen(),
          '/login': (_) => LoginRegisterScreen(),
        },
      ),
    );
  }
}