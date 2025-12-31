import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_riverpod/providers/mahasiswa_provider.dart';

class MahasiswaAddScreen extends ConsumerWidget {
  final TextEditingController cNpm = TextEditingController();
  final TextEditingController cNama = TextEditingController();
  final TextEditingController cProdi = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(title: Text("Tambah Mahasiswa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cNpm,
              decoration: InputDecoration(labelText: 'NPM'),
            ),
            TextField(
              controller: cNama,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: cProdi,
              decoration: InputDecoration(labelText: 'Program Studi'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(MahasiswaProvider.notifier)
                    .addMahasiswa(cNpm.text, cNama.text, cProdi.text);
                Navigator.pop(context);
              },
              child: Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }
}