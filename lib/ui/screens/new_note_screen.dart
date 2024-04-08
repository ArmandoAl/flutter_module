import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/chennel_method.dart';
import '../../domain/emotion_model.dart';
import '../../helpers/emotion_utlis.dart';
import '../logic/emotion_cubit.dart';
import '../logic/emotion_state.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({super.key});

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  EmotionModel? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    context.watch<EmotionCubit>().getEmotions();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE3EDF3),
          title: const Text('Escribe una nueva nota'),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFE3EDF3),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none, //no border
                      ),
                      //no border
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      showEmotionsDialog(
                        context: context,
                        onEmotionSelected: (icon) {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        },
                      );
                    },
                    icon: _selectedIcon != null
                        ? Text(_selectedIcon!.icon!,
                        style: TextStyle(
                            fontSize: 30,
                            foreground: Paint()
                              ..style = PaintingStyle.fill
                              ..color =
                              emotionColors[_selectedIcon!.name]!))
                        : const Icon(Icons.emoji_emotions_outlined),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Contenido',
                    border: InputBorder.none, //no border
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffF3A953),
          onPressed: () async {
            if (_titleController.text.isEmpty ||
                _contentController.text.isEmpty ||
                _selectedIcon == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Por favor, completa todos los campos'),
              ));
              return;
            }

            if (_selectedIcon == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Por favor, selecciona una emoción'),
              ));
              return;
            }

            await sendNoteData(_titleController.text, _contentController.text);
          },
          child: const Icon(Icons.save),
        ));
  }
}

void showEmotionsDialog({
  required BuildContext context,
  required Function(EmotionModel) onEmotionSelected,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Selecciona una emoción'),
        content: SizedBox(
            height: 300,
            width: 300,
            child: BlocBuilder<EmotionCubit, EmotionState>(
              bloc: context.read<EmotionCubit>(),
              builder: (context, state) {
                if (state.status == EmotionStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.status == EmotionStatus.loaded) {
                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: state.emotions.length,
                    itemBuilder: (context, index) {
                      final emotion = state.emotions[index];
                      return InkWell(
                        onTap: () {
                          onEmotionSelected(emotion);
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(emotion.icon!,
                                style: TextStyle(
                                    fontSize: 30,
                                    foreground: Paint()
                                      ..style = PaintingStyle.fill
                                      ..color = emotion.color!)),
                            Text(emotion.name,
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Error al cargar las emociones'),
                  );
                }
              },
            )),
      );
    },
  );
}
