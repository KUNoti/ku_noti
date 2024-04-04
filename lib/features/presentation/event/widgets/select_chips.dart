import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/colors.dart';

typedef ChipSelectedCallback = void Function(String selectedLabel, int index);

class SelectChips extends StatelessWidget {
  final List<String> chipLabels = ['All', 'Music', 'Art', 'Workshop'];
  final List<IconData> chipIcons = [Icons.all_inclusive, Icons.music_note, Icons.brush, Icons.build];
  final ChipSelectedCallback onChipSelected;
  final int selectedChipIndex;

  SelectChips({
    super.key,
    required this.selectedChipIndex,
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              showCheckmark: false,
              avatar: Icon(
                chipIcons[index],
                color: selectedChipIndex == index ? Colors.white : MyColors().primary,
              ),
              label: Text(
                chipLabels[index],
                style: TextStyle(
                  color: selectedChipIndex == index ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor: selectedChipIndex == index ? MyColors().primary : Colors.grey.shade200,
              selectedColor: MyColors().primary,
              selected: selectedChipIndex == index,
              onSelected: (_) {
                onChipSelected(chipLabels[index], index);
              },
              shape: StadiumBorder(
                side: BorderSide(
                  color: selectedChipIndex == index ? MyColors().primary : Colors.transparent,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}