import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class MatakuliahNotifier extends StateNotifier<List<DocumentSnapshot>> {
  MatakuliahNotifier() : super([]);

  Stream<List<DocumentSnapshot>> streamData() {
    return FirebaseFirestore.instance
        .collection('matakuliah_23312183')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> addMatakuliah(
    String kode_mk,
    String nama_mk,
    String sks,
    String sifat,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('matakuliah_23312183').add({
        'kode_mk': kode_mk,
        'nama_mk': nama_mk,
        'sks': sks,
        'sifat': sifat,
      });
    } on Exception catch (e) {
      // TODO
      print("error input data matakuliah: $e");
    }
  }

  Future<Map<String, dynamic>?> getData(String id) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('matakuliah_23312183')
          .doc(id)
          .get();

      return doc.data() as Map<String, dynamic>?;
    } on Exception catch (e) {
      // TODO
      print("Error mengambil data: $e");
      return null;
    }
  }

  Future<void> updateMatakuliah(
    String kode_mk,
    String nama_mk,
    String sks,
    String sifat,
    String id,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('matakuliah_23312183')
          .doc(id)
          .update({
            'kode_mk': kode_mk,
            'nama_mk': nama_mk,
            'sks': sks,
            'sifat': sifat,
          });
    } catch (e) {
      print("Error updating matakuliah: $e");
    }
  }

  Future<void> deleteMatakuliah(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('matakuliah_23312183')
          .doc(id)
          .delete();
    } on Exception catch (e) {
      // TODO
      print("error delete data matakuliah: $e");
    }
  }
}

final MatakuliahProvider =
    StateNotifierProvider<MatakuliahNotifier, List<DocumentSnapshot>>(
      (ref) => MatakuliahNotifier(),
    );

final matakuliahDataProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) {
      return ref.watch(MatakuliahProvider.notifier).getData(id);
    });
