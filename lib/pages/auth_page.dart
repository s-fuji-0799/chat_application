import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_application/providers/notifiers.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'ようこそ',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            FilledButton(
              onPressed: () => context.go('/auth/signup'),
              child: const Text('新規登録'),
            ),
            OutlinedButton(
              onPressed: () => context.go('/auth/signin'),
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errorCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      '新規登録',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  _EmailTextFormField(
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 10),
                  _PasswordTextFormField(
                    onChanged: (value) => password = value,
                  ),
                  if (errorCode.isNotEmpty)
                    Text(
                      errorCode,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await ref.watch(userNotifierProvider.notifier).signUp(
                                email: email,
                                password: password,
                              );
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            errorCode = e.code;
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: const Text('新規登録'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String errorCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'ログイン',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  _EmailTextFormField(
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 10),
                  _PasswordTextFormField(
                    onChanged: (value) => password = value,
                  ),
                  if (errorCode.isNotEmpty)
                    Text(
                      errorCode,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await ref.watch(userNotifierProvider.notifier).signIn(
                                email: email,
                                password: password,
                              );
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            errorCode = e.code;
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: const Text('ログイン'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailTextFormField extends StatelessWidget {
  const _EmailTextFormField({super.key, this.onChanged});

  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'メールアドレス',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [
        AutofillHints.email,
        AutofillHints.username,
      ],
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'メールアドレスを入力してください';
        }
        return null;
      },
    );
  }
}

class _PasswordTextFormField extends StatefulWidget {
  const _PasswordTextFormField({super.key, this.onChanged});

  final void Function(String value)? onChanged;

  @override
  State<_PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<_PasswordTextFormField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'パスワード',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() => obscureText = !obscureText);
          },
        ),
      ),
      obscureText: obscureText,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'パスワードを入力してください';
        }
        return null;
      },
    );
  }
}
