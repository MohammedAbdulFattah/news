import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/data/repositories/authentication_repository.dart';
import 'package:news/notifiers/authentication_notifier.dart';

final authenticationRepositoryProvider = Provider(
  (_) => AuthenticationRepository(),
);

final authenticationProvider = AsyncNotifierProvider(
  AuthenticationNotifier.new,
);

final authenticationTabIndexProvider = NotifierProvider(
  AuthenticationTabIndex.new,
);
