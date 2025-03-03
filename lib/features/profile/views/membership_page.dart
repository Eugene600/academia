import 'package:flutter/material.dart';
import 'widgets/school_id_card.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            floating: true,
            pinned: true,
            expandedHeight: 256,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Academic Memberships & Identities"),
            ),
          ),
          SliverToBoxAdapter(
            child: SchoolIdCard(),
          )
        ],
      ),
    );
  }
}
