import 'package:faani_dashboard/pages/tailleur/widget/list_tailleur.dart';
import 'package:flutter/material.dart';

class TailleurPage extends StatefulWidget {
  const TailleurPage({super.key});

  @override
  State<TailleurPage> createState() => _TailleurPageState();
}

class _TailleurPageState extends State<TailleurPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: const [
              ListTailleur(),
            ],
          ),
        ),
      ],
    );
  }
}
