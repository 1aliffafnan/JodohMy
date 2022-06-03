import 'package:jodoh_my/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jodoh_my/navigation/wrapper.dart';
import 'package:provider/provider.dart';

import 'services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider.value(initialData: null, value: AuthService().user),
          ChangeNotifierProvider<UserModel>.value(value: UserModel())
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        ));
  }
}
