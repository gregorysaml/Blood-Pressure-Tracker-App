import 'package:bloddpressuretrackerapp/bloc/login_bloc/bloc/pseudo_login_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/pseudo_login_status_enum.dart';
import 'package:bloddpressuretrackerapp/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// login screen
class LoginScreen extends StatefulWidget {
  /// constructor of the login screen
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PseudoLoginBloc, PseudoLoginState>(
      listener: (context, state) {
        if (state.status == PseudoLoginStatusEnum.loggedIn) {
          Navigator.pushNamed(context, '/mainpage');

          return;
        }
        if (state.status == PseudoLoginStatusEnum.loggedOut) {
          Navigator.pushNamed(context, '/login');

          return;
        }
      },
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to Blood Pressure Tracker',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _usernameController,
                      validator: (value) {
                        // ignore: avoid_non_null_assertion
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                      },

                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        // ignore: avoid_non_null_assertion
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          logger.i(
                            'Login pressed ${_usernameController.text} ${_passwordController.text}',
                          );
                          BlocProvider.of<PseudoLoginBloc>(context).add(
                            PseudoSignInEvent(
                              username: _usernameController.text,
                              password: _passwordController.text,
                            ),
                          );

                          return;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Login', style: TextStyle(fontSize: 16.sp)),
                      ),
                    ),
                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
