import 'package:blocnewsapp/features/authentication/domain/usecases/get_stored_token.dart';
import 'package:blocnewsapp/features/authentication/presentation/pages/authentication_page.dart';
import 'package:blocnewsapp/features/homepage/presentation/pages/home_page.dart';
import 'package:blocnewsapp/injection_container.dart';
import 'package:flutter/material.dart';

class AuthenticationGate extends StatelessWidget {
  final Widget authenticatedChild;

  const AuthenticationGate({
    super.key,
    this.authenticatedChild = const HomePage(),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: sl<GetStoredTokenUseCase>()(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final token = snapshot.data;
        if (token != null && token.isNotEmpty) {
          return authenticatedChild;
        }

        return const AuthenticationPage();
      },
    );
  }
}