import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_riverpod/providers/auth_provider.dart';
import 'package:project_riverpod/screens/auth/login_screen.dart';
import 'package:project_riverpod/screens/home/home_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignScreenState();
}

class _SignScreenState extends ConsumerState<SignupScreen> {
  final cEmail = TextEditingController();
  final cPass = TextEditingController();

  bool isLoading = false;

  void doSignup() async {
    final result = await ref
        .read(authProvider.notifier)
        .signup(cEmail.text, cPass.text);

    if (result == null) {
       ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kami telah mengirimkan verifikasi ke email ${cEmail.text}",
      ),
      ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Firebase (Riverpod)")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: cEmail,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: cPass,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: doSignup, child: Text("Sign Up")),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Belum Punya Akun ?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()
                      ),
                    );
                  },
                  child: Text("Daftar Disini"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}