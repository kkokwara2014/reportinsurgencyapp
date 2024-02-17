import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';

class ReportTile extends StatelessWidget {
  final ReportModel reportModel;
  const ReportTile({super.key, required this.reportModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reportModel.comment,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
