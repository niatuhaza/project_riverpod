import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_riverpod/providers/dosen_provider.dart';

class DosenAddScreen extends ConsumerWidget {
  final TextEditingController cnidn = TextEditingController();
  final TextEditingController cnama = TextEditingController();
  final TextEditingController cprodi = TextEditingController();
  final TextEditingController cfakultas = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(title: Text("Tambah Dosen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cnidn,
              decoration: InputDecoration(labelText: 'nidn'),
            ),
            TextField(
              controller: cnama,
              decoration: InputDecoration(labelText: 'nama'),
            ),
            TextField(
              controller: cprodi,
              decoration: InputDecoration(labelText: 'prodi'),
            ),
            TextField(
              controller: cfakultas,
              decoration: InputDecoration(labelText: 'fakultas'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(DosenProvider.notifier)
                    .addDosen(cnidn.text, cnama.text, cprodi.text, cfakultas.text);
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