import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/dialog_cubit.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  required MethodChannel channel,
}) {
  String selectedOption = "Option 1";
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: BlocConsumer<DialogCubit, DialogState>(
          bloc: context.read<DialogCubit>(),
          listener: (context, state) {
            selectedOption = state.option;
          },
          buildWhen: (previous, current) {
            return previous.option != current.option;
          },
          builder: (context, state) => Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.4,
            constraints: const BoxConstraints(
                maxWidth: 400,
                maxHeight: 400), // Añadimos restricciones de ancho y alto
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 212, 212, 212),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            message,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                              MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: DropdownButton(
                              hint: const Text("Select an option"),
                              value: selectedOption,
                              items: const [
                                DropdownMenuItem(
                                  value: "Option 1",
                                  child: Text("Option 1"),
                                ),
                                DropdownMenuItem(
                                  value: "Option 2",
                                  child: Text("Option 2"),
                                ),
                                DropdownMenuItem(
                                  value: "Option 3",
                                  child: Text("Option 3"),
                                ),
                              ],
                              onChanged: (value) {
                                // channel.invokeMethod("onOptionSelected", value);

                                context
                                    .read<DialogCubit>()
                                    .setOption(value.toString());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
