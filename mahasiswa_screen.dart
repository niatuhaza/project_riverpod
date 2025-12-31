import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_riverpod/providers/mahasiswa_provider.dart';
import 'package:project_riverpod/screens/home/mahasiswa/mahasiswa_update_screen.dart';

class MahasiswaScreen extends ConsumerWidget {
  const MahasiswaScreen({super.key});

  void showOption(BuildContext context, String id, WidgetRef ref) async {
    var result = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          ListTile(
            onTap: () {
              ref.refresh(mahasiswaDataProvider(id));
              Navigator.pop(context);
              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MahasiswaUpdateScreen(),
                      settings: RouteSettings(arguments: id),
                    ),
                  );
                },
            title: Text('Update'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              ref.read(MahasiswaProvider.notifier).deleteMahasiswa(id);
            },
            title: Text('Delete'),
          ),
          ListTile(onTap: () => Navigator.pop(context), title: Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaController = ref.watch(MahasiswaProvider);
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: ref.read(MahasiswaProvider.notifier).streamData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var listAllDocs = snapshot.data ?? [];
          return listAllDocs.isNotEmpty
              ? ListView.builder(
                  itemCount: listAllDocs.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                      backgroundColor: Color.fromARGB(255, 248, 248, 248),
                    ),
                    title: Text(
                      "${(listAllDocs[index].data() as Map<String, dynamic>)["nama"]}",
                    ),
                    subtitle: Text(
                      "${(listAllDocs[index].data() as Map<String, dynamic>)["npm"]}",
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showOption(context, listAllDocs[index].id, ref);
                      },

                      icon: Icon(Icons.more_vert),
                    ),
                  ),
                )
              : Center(child: Text("Data Kosong"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
