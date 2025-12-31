import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter_riverpod/legacy.dart';

class DosenNotifier extends StateNotifier<List<DocumentSnapshot>> {
  DosenNotifier() : super([]);

  Stream<List<DocumentSnapshot>> streamData() {
    return FirebaseFirestore.instance
        .collection('dosen')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> addDosen(
    String nidn,
    String nama,
    String prodi,
    String fakultas,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('dosen').add({
        'nidn': nidn,
        'nama': nama,
        'prodi': prodi,
        'fakultas': fakultas,
      });
    } on Exception catch (e) {
      // TODO
      print("error input data dosen: $e");
    }
  }

  Future<void> deleteDosen(String id) async {
    try {
      await FirebaseFirestore.instance.collection('dosen').doc(id).delete();
    } on Exception catch (e) {
      // TODO
      print("error delete data dosen: $e");
    }
  }

  Future<Map<String, dynamic>?> getData(String id) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('dosen').doc(id).get();

      return doc.data() as Map<String, dynamic>?;
    } on Exception catch (e) {
      // TODO
      print("Error mengambil data: $e");
      return null;
    }
  }

  Future<void> updateDosen(
    String nidn,
    String nama,
    String prodi,
    String fakultas,
    String id,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('dosen').doc(id).update({
        'nidn': nidn,
        'nama': nama,
        'prodi': prodi,
        'fakultas': fakultas,
      });
    } catch (e) {
      print("Error updating mahasiswa: $e");
    }
  }
}

final DosenProvider =
    StateNotifierProvider<DosenNotifier, List<DocumentSnapshot>>(
      (ref) => DosenNotifier(),
    );

final dosenDataProvider = FutureProvider.family<Map<String, dynamic>?, String>((
  ref,
  id,
) {
  return ref.watch(DosenProvider.notifier).getData(id);
});