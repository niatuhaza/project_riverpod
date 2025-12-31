import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_riverpod/providers/matakuliah_provider.dart';
import 'package:project_riverpod/screens/matakuliah/matakuliah_update_screen.dart';

class MatakuliahScreen extends ConsumerWidget {
  const MatakuliahScreen({super.key});
  void showOption(BuildContext context, String id, WidgetRef ref) async {
    var result = await showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            children: [
              ListTile(
                onTap: () {
                  var refresh = ref.refresh(matakuliahDataProvider(id));
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatakuliahaUpdateScreen(),
                      settings: RouteSettings(arguments: id),
                    ),
                  );
                },
                title: Text('Update'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  ref.read(MatakuliahProvider.notifier).deleteMatakuliah(id);
                },
                title: Text('Delete'),
              ),
              ListTile(
                onTap: () => Navigator.pop(context),
                title: Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matakuliahController = ref.watch(MatakuliahProvider);
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: ref.read(MatakuliahProvider.notifier).streamData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var listAllDocs = snapshot.data ?? [];
          return listAllDocs.isNotEmpty
              ? ListView.builder(
                itemCount: listAllDocs.length,
                itemBuilder:
                    (context, index) => ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                        backgroundColor: Color.fromARGB(255, 248, 248, 248),
                      ),
                      title: Text(
                        "${(listAllDocs[index].data() as Map<String, dynamic>)["kode_mk"]}",
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${(listAllDocs[index].data() as Map<String, dynamic>)["nama_mk"]}",
                          ),
                          Text(
                            "${(listAllDocs[index].data() as Map<String, dynamic>)["sks"]}",
                          ),
                          Text(
                            "${(listAllDocs[index].data() as Map<String, dynamic>)["sifat"]}",
                          ),
                        ],
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