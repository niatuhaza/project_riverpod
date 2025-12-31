import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_riverpod/providers/matakuliah_provider.dart';

class MatakuliahAddScreen extends ConsumerWidget {
  final TextEditingController ckode_mk = TextEditingController();
  final TextEditingController cnama_mk = TextEditingController();
  final TextEditingController csks = TextEditingController();
  final TextEditingController csifat = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Matakuliah")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ckode_mk,
              decoration: InputDecoration(labelText: 'kode_mk'),
            ),
            TextField(
              controller: cnama_mk,
              decoration: InputDecoration(labelText: 'nama_mk'),
            ),
            TextField(
              controller: csks,
              decoration: InputDecoration(labelText: 'sks'),
            ),
            TextField(
              controller: csifat,
              decoration: InputDecoration(labelText: 'sifat'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(MatakuliahProvider.notifier)
                    .addMatakuliah(
                      ckode_mk.text,
                      cnama_mk.text,
                      csks.text,
                      csifat.text,
                    );
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