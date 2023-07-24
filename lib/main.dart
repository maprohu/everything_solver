import 'package:flutter/material.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

void main() {
  runApp(EverythingSolverApp());
}

sealed class State {}

class Initial extends State {}

class Solving extends State {}

class Solved extends State {}

class EverythingSolverApp extends StatelessWidget {
  EverythingSolverApp({super.key});

  final ui = FlcUi.create();

  final state = ValueNotifier<State>(Initial());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ui.nav,
      home: ScaffoldParts(
        title: const Text("Everything Solver"),
        body: flcTicker((tickers) {
          final animationController = AnimationController(
            duration: const Duration(seconds: 3),
            vsync: tickers,
          );
          return ValueListenableBuilder(
            valueListenable: state,
            builder: (context, currentState, child) {
              switch (currentState) {
                case Initial():
                  return Center(
                    child: ElevatedButton(
                      child: const Text("Solve Everything"),
                      onPressed: () {
                        animationController.forward();
                        state.value = Solving();
                        animationController.addStatusListener((status) {
                          if (status == AnimationStatus.completed) {
                            state.value = Solved();
                          }
                        });
                      },
                    ),
                  );
                case Solving():
                  return ListenableBuilder(
                    listenable: animationController,
                    builder: (BuildContext context, Widget? child) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: CircularProgressIndicator(
                                  value: animationController.value,
                                ),
                              ),
                            ),
                            const Text("Solving everything..."),
                          ],
                        ),
                      );
                    },
                  );
                case Solved():
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Everything is solved."),
                        Icon(
                          Icons.done_all,
                          color: Colors.green,
                          size: 64,
                        ),
                        Text("(You can relax now.)"),
                      ],
                    ),
                  );
              }
            },
          );
        }),
      ).scaffold,
    );
  }
}
