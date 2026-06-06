import 'package:flutter/material.dart';

class StepInfo {
  final int step;
  final String label;
  final IconData icon;

  const StepInfo({
    required this.step,
    required this.label,
    required this.icon,
  });
}

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<StepInfo> steps;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xFFCDC4CA)),
        ),
      ),
      child: Row(
        children: List.generate(
          totalSteps * 2 - 1,
          (index) {
            if (index.isOdd) {
              // Connecting line
              final stepIndex = index ~/ 2;
              return _buildConnectorLine(stepIndex);
            }
            final stepIndex = index ~/ 2;
            return _buildStepDot(stepIndex);
          },
        ),
      ),
    );
  }

  Widget _buildStepDot(int stepIndex) {
    final isCompleted = stepIndex < currentStep;
    final isActive = stepIndex == currentStep;
    final step = steps[stepIndex];

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF2D6A3F)
                  : isActive
                      ? Colors.black
                      : const Color(0xFFE0E0E0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : Icon(
                      step.icon,
                      size: 16,
                      color: isActive ? Colors.white : const Color(0xFF9E9E9E),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            step.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isActive || isCompleted
                  ? Colors.black
                  : const Color(0xFF9E9E9E),
              fontSize: 9,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectorLine(int stepIndex) {
    final isCompleted = stepIndex < currentStep;
    return Container(
      width: 16,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF2D6A3F) : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
