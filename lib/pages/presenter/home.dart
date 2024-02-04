import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:water_jug/constant/errors.dart';
import 'package:water_jug/pages/screen/home.dart';

class HomePresenter {
  final void Function(String error) errorCallback;
  final Stream<bool> Function(List<BucketAction> solution) successCallback;

  const HomePresenter({
    required this.errorCallback,
    required this.successCallback,
  });

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
      errorCallback(greaterThanZeroError);
      throw '';
    }

    ///Z value is not greater than X and Y
    if (z > x && z > y) {
      yield false;
      errorCallback(zLowerThanXorYError);
      throw '';
    }

    ///Check if X and Y are different or equal to Z
    if (x == y && x != z) {
      yield false;
      errorCallback(bucketsMustBeDifferentError);
      throw '';
    }

    ///Stop loading and execute method chosen
    yield* executeMethodBFS(
      xController: xController,
      yController: yController,
      measure: z,
    );
  }

  Stream<bool> executeMethodBFS({
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

    yield* successCallback(solution);

    ///Ends loading event
    yield false;
  }

  int _min(int a, int b) => a < b ? a : b;
}
