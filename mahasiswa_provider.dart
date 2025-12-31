import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class MahasiswaNotifier extends StateNotifier<List<DocumentSnapshot>> {
  MahasiswaNotifier() : super([]);

  Stream<List<DocumentSnapshot>> streamData() {
    return FirebaseFirestore.instance
        .collection('mahasiswa')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> addMahasiswa(String npm, String nama, String prodi) async {
    try {
      await FirebaseFirestore.instance.collection('mahasiswa').add({
        'npm': npm,
        'nama': nama,
        'prodi': prodi,
      });
    } on Exception catch (e) {
      // TODO
      print("error input data mahasiswa: $e");
    }
  }

  Future<void> deleteMahasiswa(String id) async {
    try {
      await FirebaseFirestore.instance.collection('mahasiswa').doc(id).delete();
    } on Exception catch (e) {
      // TODO
      print("error delete data mahasiswa: $e");
    }
  }

  Future<Map<String, dynamic>?> getData(String id) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('mahasiswa')
          .doc(id)
          .get();

      return doc.data() as Map<String, dynamic>?;
    } on Exception catch (e) {
      // TODO
      print("Error mengambil data: $e");
      return null;
    }
  }

  Future<void> updateMahasiswa(
    String npm,
    String nama,
    String prodi,
    String id,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('mahasiswa').doc(id).update({
        'npm': npm,
        'nama': nama,
        'prodi': prodi,
      });
    } catch (e) {
      print("Error updating mahasiswa: $e");
    }
  }
}

final MahasiswaProvider =
    StateNotifierProvider<MahasiswaNotifier, List<DocumentSnapshot>>(
      (ref) => MahasiswaNotifier(),
    );

final mahasiswaDataProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) {
      return ref.watch(MahasiswaProvider.notifier).getData(id);
    });
