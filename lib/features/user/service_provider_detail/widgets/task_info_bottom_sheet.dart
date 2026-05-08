import 'package:flutter/material.dart';

Future<void> showTaskInfoBottomSheet({
  required BuildContext context,
  required dynamic service,
  required int selectedVariantIndex,
}) async {
  final packages = service.servicePackages;

  if (packages.isEmpty) {
    debugPrint('No packages available');
    return;
  }

  int safeIndex = selectedVariantIndex;

  if (safeIndex < 0 || safeIndex >= packages.length) {
    safeIndex = 0;
  }

  final selectedPackage = packages[safeIndex];
  final taskGroups = selectedPackage.taskGroups;

  int selectedGroupIndex = 0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final selectedGroup =
          taskGroups.isNotEmpty ? taskGroups[selectedGroupIndex] : null;

          final taskItems = selectedGroup?.taskItems ?? [];

          return Container(
            height: MediaQuery.of(sheetContext).size.height * 0.75,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  "Task Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                if (taskGroups.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text("No task information available"),
                    ),
                  )
                else ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(taskGroups.length, (index) {
                        final group = taskGroups[index];
                        final isSelected = selectedGroupIndex == index;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(group.name),
                            selected: isSelected,
                            onSelected: (val) {
                              setSheetState(() {
                                selectedGroupIndex = index;
                              });
                            },
                            selectedColor: const Color(0xFFE8F0FE),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: taskItems.isEmpty
                        ? const Center(
                      child: Text("No task items available"),
                    )
                        : ListView.builder(
                      itemCount: taskItems.length,
                      itemBuilder: (sheetContext, i) {
                        final item = taskItems[i];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade100,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Colors.blue,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (item.description.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        item.description,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      );
    },
  );
}