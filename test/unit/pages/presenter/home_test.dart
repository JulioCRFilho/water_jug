import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_jug/constant/errors.dart';
import 'package:water_jug/pages/presenter/home.dart';

void main() {
  group('Home Presenter unit testing', () {
    ///Possible values expected to succeed
    _calculationTest(3, 5, 4);
    _calculationTest(4, 9, 6);
    _calculationTest(7, 11, 2);
    _calculationTest(6, 10, 8);
    _calculationTest(8, 13, 1);
    _calculationTest(2, 18, 12);

    ///Impossible values expected to fail
    _calculationTest(3, 6, 4, shouldSucceed: false);
    _calculationTest(5, 10, 7, shouldSucceed: false);
    _calculationTest(4, 8, 3, shouldSucceed: false);
    _calculationTest(7, 14, 5, shouldSucceed: false);
    _calculationTest(9, 18, 11, shouldSucceed: false);

    ///Edge cases test
    _calculationTest(128, 255, 127);
    _calculationTest(100, 3, 52);
    _calculationTest(991, 999, 3);
  });
}

void _calculationTest(int x, int y, int z, {bool shouldSucceed = true}) {
  test('Calculation for buckets $x and $y to achieve $z', () {
    final homePresenter = HomePresenter(
      errorCallback: (error) {
        ///Checks for success expected case
        if (shouldSucceed) {
          ///Expects there's no error message
          expect(error, isNull);

          ///Checks for failure expected case
        } else {
          ///Expects error message to be one of the pre defined errors
          expect(
              error,
              isIn([
                greaterThanZeroError,
                zLowerThanXorYError,
                bucketsMustBeDifferentError,
                noPossibleSolutionError,
              ]));
        }
      },
      successCallback: (solution) {
        ///Checks for success expected case
        if (shouldSucceed) {
          ///Expects the solution to not be empty
          expect(solution, isNotEmpty);

          ///Checks for failure expected case
        } else {
          ///Expects the solution to be empty
          expect(solution, isEmpty);
        }
        return const Stream.empty();
      },
    );

    final xController = TextEditingController(text: '$x');
    final yController = TextEditingController(text: '$y');
    final zController = TextEditingController(text: '$z');

    homePresenter
        .calculate(
          xController: xController,
          yController: yController,
          zController: zController,
        )

        ///Executes the stream function
        .listen((_) {});
  });
}
