import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.isSuccess) {
                Navigator.of(context).pushReplacementNamed('/home');
              } else if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text('Login', style: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Welcome back', style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey[700])),
                const SizedBox(height: 30),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return TextField(
                      controller: _emailController,
                      onChanged: (v) => loginBloc.add(EmailChanged(v)),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: state.isEmailValid ? null : 'Enter a valid email',
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return TextField(
                      controller: _passwordController,
                      onChanged: (v) => loginBloc.add(PasswordChanged(v)),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: state.isPasswordValid ? null : 'Password must be 8+ chars, include upper, lower, digit & symbol',
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                          FocusScope.of(context).unfocus();
                          loginBloc.add(LoginSubmitted());
                        },
                        child: state.isSubmitting
                            ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Submit'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
