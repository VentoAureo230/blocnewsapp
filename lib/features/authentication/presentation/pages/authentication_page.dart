import 'package:blocnewsapp/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:blocnewsapp/features/authentication/presentation/widget/authentication_form.dart';
import 'package:blocnewsapp/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthenticationCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mon compte')),
        body: const AuthenticationForm(),
      ),
    );
  }
}
