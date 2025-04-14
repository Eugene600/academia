import 'package:academia/features/ask_me/widgets/ask_me_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AskMeHome extends StatelessWidget {
  const AskMeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              },
            ),
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/study.gif',
                fit: BoxFit.fill,
              ),
              title: Text("Ask Me"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final parentContext = context;
          showModalBottomSheet(
            context: parentContext,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
            
            builder: (_) => AskMeFormSheet(parentContext: parentContext),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
