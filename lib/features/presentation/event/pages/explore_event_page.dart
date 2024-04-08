
import 'package:flutter/material.dart';
import 'package:ku_noti/features/presentation/event/widgets/ar/ar_section.dart';
import 'package:ku_noti/features/presentation/event/widgets/map_section.dart';


class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: ARSection()
              ),

              Expanded(
                flex: 2,
                child: MapSection()
              )
            ],
          ),
        )
    );
  }
}