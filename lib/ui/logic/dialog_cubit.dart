import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogCubit extends Cubit<DialogState> {
  DialogCubit() : super(const DialogState());

  void setOption(String option) {
    emit(state.copyWith(option: option));
  }

  void reset() {
    emit(const DialogState());
  }
}

class DialogState extends Equatable {
  final String option;

  const DialogState({this.option = 'Opcion 1'});

  DialogState copyWith({
    String? option,
  }) {
    return DialogState(
      option: option ?? this.option,
    );
  }

  @override
  List<Object> get props => [
    option,
  ];
}
