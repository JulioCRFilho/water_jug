import 'package:flutter/material.dart';
import 'package:water_jug/design_system/bucket/bucket.dart';
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
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          loading = _calculate();
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
                ],
              ),
            );
          }),
    );
  }

  Stream<bool> _calculate() async* {
    yield true;

    //todo calculation

    await Future.delayed(const Duration(seconds: 1));

    yield false;
  }
}
