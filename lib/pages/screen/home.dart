import 'package:flutter/material.dart';
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

  Stream<bool>? loading;

  @override
  void initState() {
    super.initState();
    loading?.listen((event) { }, onError: null);
  }

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
                ],
              ),
            );
          }),
    );
  }

  ///Executes the solution's actions into UI
  Stream<bool> executeActions(List<BucketAction> solution) async* {
    if (solution.isEmpty) {
      yield false;
      _showErrorDialog('There\'s not a possible solution');
      throw '';
    }

    for (final action in solution) {
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        setState(() {
          xController.text = action.bucketX.toString();
          yController.text = action.bucketY.toString();
        });
      }
    }
  }

  void _showErrorDialog(String error) =>
      ErrorDialog(reason: error).show(context);
}

typedef BucketAction = ({
  int bucketX,
  int bucketY,
});

typedef BucketState = ({
  BucketAction state,
  List<BucketAction> path,
});
