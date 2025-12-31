import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_riverpod/providers/auth_provider.dart';
import 'package:project_riverpod/screens/auth/login_screen.dart';
import 'package:project_riverpod/screens/home/home_screen.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final cEmail = TextEditingController();
  

  bool isLoading = false;

  void doResetPassword() async {
    final result = await ref
        .read(authProvider.notifier)
        .ResetPassword(cEmail.text);

    if (result == null) {
       ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kami telah mengirimkan Reset Password ke email ${cEmail.text}",
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
      appBar: AppBar(title: Text("Reset Password Firebase (Riverpod)")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: cEmail,
              decoration: InputDecoration(labelText: "Email"),
            ),
            
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: doResetPassword, child: Text("Reset Password")),
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