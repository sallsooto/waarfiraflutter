import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double size;
  final bool withLabel;
  const StepIndicator(
      {this.currentStep,
      this.totalSteps = 5,
      this.size = 20,
      this.withLabel = true});
  @override
  Widget build(BuildContext context) {
    if (withLabel) {
      return Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Etape ' + currentStep.toString() + '/' + totalSteps.toString(),
              style: TextStyle(
                  color: MyAppColors.secondaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          StepProgressIndicator(
            totalSteps: totalSteps,
            currentStep: currentStep,
            size: size,
            selectedColor: MyAppColors.primaryColor,
            roundedEdges: Radius.circular(10),
          ),
        ],
      );
    } else {
      return StepProgressIndicator(
        totalSteps: totalSteps,
        currentStep: currentStep,
        size: size,
        selectedColor: MyAppColors.primaryColor,
        roundedEdges: Radius.circular(10),
      );
    }
  }
}
