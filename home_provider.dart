import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier {}

final HomeProvider = Provider<HomeNotifier>((ref) => HomeNotifier());