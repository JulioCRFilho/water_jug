import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:water_jug/design_system/bucket/bucket.dart';
import 'package:water_jug/design_system/dialog/error.dart';
import 'package:water_jug/design_system/text/common.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final xController = TextEditingController();
  final yController = TextEditingController();
  final zController = TextEditingController();

  Stream<bool>? loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText('Measuring buckets'),
        centerTitle: true,
      ),
      body: StreamBuilder<bool>(
          stream: loading,
          initialData: false,
          builder: (context, snapshot) {
            final isLoading = snapshot.data == true;

            return IgnorePointer(
              ignoring: isLoading,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(36),
                    child: CommonText(
                      'Fill the values below to discover '
                      'how to measure the value of Z '
                      'using buckets X and Y.',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BucketWidget(
                        xController: xController,
                        label: 'X bucket',
                      ),
                      BucketWidget(
                        xController: yController,
                        label: 'Y bucket',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: BucketWidget(
                      label: 'Z bucket',
                      xController: zController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: IgnorePointer(
                      ignoring: isLoading,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            loading = calculate(
                              xController: xController,
                              yController: yController,
                              zController: zController,
                            );
                          });
                        },
                        child: Container(
                          width: 150,
                          alignment: Alignment.center,
                          height: 50,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const CommonText('Calculate'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Stream<bool> calculate({
    required final TextEditingController xController,
    required final TextEditingController yController,
    required final TextEditingController zController,
  }) async* {
    ///Start loading event
    yield true;

    ///Getting input values, ensuring they're integers
    final x = int.tryParse(xController.text) ?? 0;
    final y = int.tryParse(yController.text) ?? 0;
    final z = int.tryParse(zController.text) ?? 0;

    ///Initial validations
    ///Buckets values are greater than 0
    if (x <= 0 || y <= 0 || z <= 0) {
      yield false;
      const ErrorDialog(
        reason: 'Buckets must be greater than 0',
      ).show(context);
      return;
    }

    ///Z value is not greater than X and Y
    if (z > x && z > y) {
      yield false;
      const ErrorDialog(
        reason: 'Z must be lower than X or Y',
      ).show(context);
      return;
    }

    ///Check if X and Y are different or equal to Z
    if (x == y && x != z) {
      yield false;
      const ErrorDialog(
        reason: 'X and Y must be different',
      ).show(context);
      return;
    }

    final greater = x > y ? x : y;
    final smaller = x > y ? y : x;

    ///Ensure Z is reachable by X or Y
    if (smaller.isEven && greater.isEven && z.isOdd) {
      yield false;
      const ErrorDialog(
        reason: 'X or Y must be odd if Z is odd',
      ).show(context);
      return;
    }

    ///Check if there's a possible solution
    yield* _checkMeasurementPossible(
      smaller: smaller,
      greater: greater,
      measure: z,
    );

    ///Stop loading and execute method chosen
    yield* _executeMethodBFS(
      xController: xController,
      yController: yController,
      measure: z,
    );
  }

  ///Checks if there's a Great Common Divisor between X and Y.
  ///It's not mandatory but avoids waste of processing
  Stream<bool> _checkMeasurementPossible({
    required int smaller,
    required int greater,
    required int measure,
  }) async* {
    int dividend = greater;
    int divider = smaller;

    ///If there's not a Greater Common Divisor then there's no solution
    while (divider != 0) {
      int temp = divider;
      divider = dividend % divider;
      dividend = temp;
    }

    if (measure % dividend != 0) {
      yield false;
      const ErrorDialog(
        reason: 'No Great Common Divisor shared between X and Y',
      ).show(context);
      throw '';
    }
  }

  Stream<bool> _executeMethodBFS({
    required final int measure,
    required final TextEditingController xController,
    required final TextEditingController yController,
  }) async* {
    final capacityX = int.parse(xController.text);
    final capacityY = int.parse(yController.text);

    final List<BucketAction> solution = [];
    final Queue<BucketState> queue = Queue();
    final Set<BucketAction> previousAttempts = {};

    ///Starts with both buckets empty
    queue.add((
      state: (bucketX: 0, bucketY: 0),
      path: [
        (
          bucketX: 0,
          bucketY: 0,
        )
      ],
    ));

    while (queue.isNotEmpty) {
      ///Gets the values from the first state after removing the old one
      final BucketState current = queue.removeFirst();
      final BucketAction state = current.state;

      final int bucketX = state.bucketX;
      final int bucketY = state.bucketY;

      ///Checks the measure in any bucket
      if (bucketX == measure || bucketY == measure) {
        solution.addAll(current.path);
        break;
      }

      ///Create a list with all possible states derived from current
      final List<BucketAction> nextStates = [
        ///Fills bucket X while keeping Y
        (bucketX: capacityX, bucketY: bucketY),

        ///Fills bucket Y while keeping X
        (bucketX: bucketX, bucketY: capacityY),

        ///Empty bucket X while keeping Y
        (bucketX: 0, bucketY: bucketY),

        ///Empty bucket Y while keeping X
        (bucketX: bucketX, bucketY: 0),

        ///Transfer from X to Y
        (
          bucketX: bucketX - _min(bucketX, capacityY - bucketY),
          bucketY: bucketY + _min(bucketX, capacityY - bucketY),
        ),

        ///Transfer from Y to X
        (
          bucketX: bucketX + _min(bucketY, capacityX - bucketX),
          bucketY: bucketY - _min(bucketY, capacityX - bucketX),
        ),
      ];

      for (final BucketAction state in nextStates) {
        ///Add those states to previous attempts list if they're new
        if (!previousAttempts.contains(state)) {
          previousAttempts.add(state);

          final newPath = [...current.path, state];
          final BucketState bucketState = (
            state: state,
            path: newPath,
          );

          queue.add(bucketState);
        }
      }
    }

    yield* _executeActions(solution);

    ///Ends loading event
    yield false;
  }

  int _min(int a, int b) => a < b ? a : b;

  Stream<bool> _executeActions(List<BucketAction> solution) async* {
    if (solution.isEmpty) {
      yield false;
      const ErrorDialog(
        reason: 'There\'s not a possible solution',
      ).show(context);
      throw '';
    }

    print('actions: $solution');

    for (final action in solution) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          xController.text = action.bucketX.toString();
          yController.text = action.bucketY.toString();
        });
      }
    }
  }
}

typedef BucketAction = ({
  int bucketX,
  int bucketY,
});

typedef BucketState = ({
  BucketAction state,
  List<BucketAction> path,
});
