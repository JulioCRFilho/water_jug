import 'package:flutter/material.dart';
import 'package:water_jug/constant/errors.dart';
import 'package:water_jug/design_system/bucket/bucket.dart';
import 'package:water_jug/design_system/dialog/error.dart';
import 'package:water_jug/design_system/text/common.dart';
import 'package:water_jug/pages/presenter/home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final presenter = HomePresenter(
    errorCallback: _showErrorDialog,
    successCallback: executeActions,
  );

  final xController = TextEditingController();
  final yController = TextEditingController();
  final zController = TextEditingController();

  double xProportion = 0;
  double yProportion = 0;
  double zProportion = 0;

  Stream<bool>? loading;

  List<BucketAction> history = [];

  bool showHistory = false;

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
              child: SingleChildScrollView(
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
                          proportion: xProportion,
                          controller: xController,
                          label: 'X bucket',
                        ),
                        BucketWidget(
                          proportion: yProportion,
                          controller: yController,
                          label: 'Y bucket',
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: BucketWidget(
                        proportion: zProportion,
                        label: 'Z bucket',
                        controller: zController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: IgnorePointer(
                        ignoring: isLoading,
                        child: OutlinedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            ///Adds the first stream to execution and updates UI
                            setState(() {
                              loading = presenter.calculate(
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
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showHistory = !showHistory;
                        });
                      },
                      child: const CommonText('Show history'),
                    ),
                    Visibility(
                      visible: showHistory,
                      child: Text(
                        history.isEmpty ? 'History empty' : history.join('\n'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  ///Executes the solution's actions into UI
  Stream<bool> executeActions(List<BucketAction> solution) async* {
    if (solution.isEmpty) {
      yield false;
      _showErrorDialog(noPossibleSolutionError);
      throw '';
    }

    final xCapacity = int.parse(xController.text);
    final yCapacity = int.parse(yController.text);

    for (final action in solution) {
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        setState(() {
          xController.text = action.bucketX.toString();
          yController.text = action.bucketY.toString();

          ///Handles animation
          xProportion = action.bucketX / xCapacity;
          yProportion = action.bucketY / yCapacity;

          ///Adds action to history
          history.add(action);
        });
      }
    }

    if (mounted) {
      setState(() {
        zProportion = 1;
      });
    }
  }

  void _showErrorDialog(String error) =>
      ErrorDialog(reason: error).show(context);
}
