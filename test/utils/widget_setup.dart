import 'package:clean_architecture_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void widgetSetup() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await init();
  });
}

BlocProvider<T> widgetSetUpWithBloc<T extends Bloc<dynamic, dynamic>>(
    T blocMock, Widget widget) {
  return BlocProvider<T>(
    create: (_) => blocMock,
    child: MaterialApp(
      home: Scaffold(body: widget),
    ),
  );
}
