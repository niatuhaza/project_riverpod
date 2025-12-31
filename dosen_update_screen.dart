import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_riverpod/providers/dosen_provider.dart';

class DosenUpdateScreen extends ConsumerWidget {
  final TextEditingController cnidn = TextEditingController();
  final TextEditingController cnama = TextEditingController();
  final TextEditingController cprodi = TextEditingController();
  final TextEditingController cfakultas = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final dosenAsyncValue = ref.watch(dosenDataProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text("Ubah Dosen")),
      body: dosenAsyncValue.when(
        data: (dosen) {
          if (dosen != null) {
            cnidn.text = dosen['nidn'];
            cnama.text = dosen['nama'];
            cprodi.text = dosen['prodi'];
            cfakultas.text = dosen['fakultas'];

            return Padding(
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
                          .updateDosen(
                            cnidn.text,
                            cnama.text,
                            cprodi.text,
                            cfakultas.text,
                            id,
                          );
                      Navigator.pop(context);
                    },
                    child: Text("Tambah"),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text("data tidak di temukan"));
          }
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, StackTrace) => Center(child: Text('error: $error')),
      ),
    );
  }
}