
import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/colors.dart';

typedef ChipSelectedCallback = void Function(String selectedLabel, bool isSelected, int index);

class SelectTagFollow extends StatelessWidget {
  final List<String> chipLabels;
  final List<IconData> chipIcons;
  final ChipSelectedCallback onChipSelected;
  final Set<int> selectedChipIndices;

  const SelectTagFollow({
    super.key,
    required this.chipLabels,
    required this.chipIcons,
    required this.selectedChipIndices,
    required this.onChipSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chipLabels.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedChipIndices.contains(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              showCheckmark: false,
              avatar: Icon(
                chipIcons[index],
                color: isSelected ? Colors.white : MyColors().primary,
              ),
              label: Text(
                chipLabels[index],
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
              backgroundColor: isSelected ? MyColors().primary : Colors.white10,
              selectedColor: MyColors().primary,
              selected: isSelected,
              onSelected: (bool selected) {
                Set<int> newSelectedIndices = Set.from(selectedChipIndices);
                if (selected) {
                  newSelectedIndices.add(index);
                } else {
                  newSelectedIndices.remove(index);
                }
                // Call the callback with only the label of the changed tag
                onChipSelected(chipLabels[index], selected, index);
              },
              shape: StadiumBorder(
                side: BorderSide(color: MyColors().primary),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
