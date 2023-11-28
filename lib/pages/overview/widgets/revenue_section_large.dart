import 'package:flutter/material.dart';
import 'package:faani_dashboard/constants/style.dart';
import 'package:faani_dashboard/pages/overview/widgets/chart.dart';
import 'package:faani_dashboard/pages/overview/widgets/revenue_info.dart';
import 'package:faani_dashboard/widgets/custom_text.dart';

class RevenueSectionLarge extends StatelessWidget {
  const RevenueSectionLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGray.withOpacity(.1),
              blurRadius: 12)
        ],
        border: Border.all(color: lightGray, width: .5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: "Commandes graph",
                  size: 20,
                  weight: FontWeight.bold,
                  color: lightGray,
                ),
                const SizedBox(width: 600, height: 200, child: Chart()),
              ],
            ),
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    RevenueInfo(
                      title: "Commandes par moi",
                      amount: "102",
                    ),
                    RevenueInfo(
                      title: "7 jours derniers",
                      amount: "40",
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    RevenueInfo(
                      title: "30 derniers jours",
                      amount: "99",
                    ),
                    RevenueInfo(
                      title: "Aujourd'hui",
                      amount: "21",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
