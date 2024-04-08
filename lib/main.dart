import 'package:add_note_module/ui/logic/dialog_cubit.dart';
import 'package:add_note_module/ui/logic/emotion_cubit.dart';
import 'package:add_note_module/ui/screens/counter_screen.dart';
import 'package:add_note_module/ui/screens/new_note_screen.dart';
import 'package:add_note_module/ui/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp(isCounterScreen: true,));
}

@pragma('vm:entry-point')
void newNoteMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp(isCounterScreen: false,));
}


class MyApp extends StatefulWidget {
  final bool isCounterScreen;
  const MyApp({super.key, required this.isCounterScreen});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = const MethodChannel('show-dialog');
    _channel.setMethodCallHandler((call) async {
      if (call.method == "showDialog") {
        // Show a dialog
        showCustomDialog(
          context: context,
          title: call.arguments["title"],
          message: call.arguments["message"],
          channel: _channel,
        );
      } else {
        throw Exception('not implemented ${call.method}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmotionCubit>(
          create: (_) => EmotionCubit(),
        ),
        BlocProvider<DialogCubit>(
          create: (_) => DialogCubit(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: widget.isCounterScreen ? const CounterScreen() : const NewNoteScreen(),
      ),
    );
  }
}
