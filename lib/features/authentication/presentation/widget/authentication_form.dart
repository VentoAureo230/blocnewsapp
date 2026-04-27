import 'package:blocnewsapp/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:blocnewsapp/features/authentication/presentation/cubit/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({super.key});

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _registerUsernameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerUsernameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error?.message ?? 'Une erreur inattendue est survenue.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is AuthenticationSuccess) {
          Navigator.pushReplacementNamed(context, '/Home');
        }
      },
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: const Color(0xFF8B8B8B),
            indicatorColor: Colors.black,
            tabs: const [
              Tab(text: 'Connexion'),
              Tab(text: 'Inscription'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoginTab(),
                _buildRegisterTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            TextFormField(
              controller: _loginEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _loginPasswordController,
              obscureText: !_loginPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _loginPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () => setState(
                    () => _loginPasswordVisible = !_loginPasswordVisible,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                final isLoading = state is AuthenticationLoading;
                return FilledButton(
                  onPressed: isLoading ? null : _onLoginPressed,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Se connecter'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            TextFormField(
              controller: _registerUsernameController,
              decoration: const InputDecoration(
                labelText: 'Nom d\'utilisateur',
                prefixIcon: Icon(Icons.person_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer un nom d\'utilisateur';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _registerEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _registerPasswordController,
              obscureText: !_registerPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _registerPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () => setState(
                    () => _registerPasswordVisible = !_registerPasswordVisible,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Le mot de passe doit contenir au moins 8 caractères';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                final isLoading = state is AuthenticationLoading;
                return FilledButton(
                  onPressed: isLoading ? null : _onRegisterPressed,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('S\'inscrire'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginPressed() {
    if (_loginFormKey.currentState?.validate() ?? false) {
      context.read<AuthenticationCubit>().login(
            email: _loginEmailController.text.trim(),
            password: _loginPasswordController.text,
          );
    }
  }

  void _onRegisterPressed() {
    if (_registerFormKey.currentState?.validate() ?? false) {
      context.read<AuthenticationCubit>().register(
            username: _registerUsernameController.text.trim(),
            email: _registerEmailController.text.trim(),
            password: _registerPasswordController.text,
          );
    }
  }
}
