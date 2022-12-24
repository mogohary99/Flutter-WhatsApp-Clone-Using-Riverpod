import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_riverpod/cummon/widgets/loader.dart';
import 'package:whatsapp_riverpod/models/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;

  const StatusScreen({super.key, required this.status});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController storyController = StoryController();

  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItem();
  }

  void initStoryPageItem() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          url: widget.status.photoUrl[i],
          controller: storyController,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: storyController,
        onVerticalSwipeComplete: (direction){
                if(direction  == Direction.down){
                  Navigator.pop(context);
                }
        },

            ),
    );
  }
}
