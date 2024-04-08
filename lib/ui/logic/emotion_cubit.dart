
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../domain/emotion_model.dart';
import 'emotion_state.dart';

class EmotionCubit extends Cubit<EmotionState> {
  EmotionCubit()
      : super(const EmotionState(emotions: [], status: EmotionStatus.initial));

  Future<void> getEmotions() async {
    emit(const EmotionState(emotions: [], status: EmotionStatus.loading));
    await Future.delayed(const Duration(microseconds: 100));
    emit(state.copyWith(
      emotions: [
        EmotionModel(
          id: 1,
          name: 'Felicidad',
          icon: '😄',
          color: const Color(0xff92D406),
        ),
        EmotionModel(
          id: 2,
          name: 'Tristeza',
          icon: '😢',
          color: const Color(0xff2C10D9),
        ),
        EmotionModel(
          id: 3,
          name: 'Miedo',
          icon: '😨',
          color: const Color(0xff8606D4),
        ),
        EmotionModel(
          id: 5,
          name: 'Disgusto',
          icon: '🤢',
          color: const Color(0xffE99E0E),
        ),
        EmotionModel(
          id: 5,
          name: 'Enojo',
          icon: '😡',
          color: const Color(0xffB71C1C),
        ),
        EmotionModel(
          id: 6,
          name: 'Sorpresa',
          icon: '😲',
          color: const Color.fromARGB(255, 142, 144, 25),
        ),
      ],
      status: EmotionStatus.loaded,
    ));
  }
}
