import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/features/presentation/event/widgets/event_horizontal_card.dart';
import 'package:ku_noti/features/presentation/event/widgets/search_bar.dart';
import 'package:ku_noti/features/presentation/event/widgets/select_chips.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int selectedChipIndex = 0;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context),
          body: Column(
            children: [
              SelectChips(
                selectedChipIndex: selectedChipIndex,
                onChipSelected: (String selectedLabel, int index) {
                  print(selectedLabel);
                  setState(() {
                    selectedChipIndex = index;
                  });
                }
              ),
              EventHorizCard(
                imageUrl: kDefaultImage,
                title: 'International Concert',
                date: 'Sun, Dec 23 - 19.00 - 23.00 PM',
                location: 'Grand Park, New York',
                isFree: true,
                onLiked: () {
                  // Handle the like button tap
                },
              )
            ],
          ),
        )
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: MySearchBarWidget(
            _controller,
          ),
        )
    );
  }
}
