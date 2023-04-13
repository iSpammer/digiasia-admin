import 'package:flutter/material.dart';
import '../models/analytic_info_model.dart';
import '/constants/constants.dart';
import '/constants/responsive.dart';

import '/widgets/analytic_info_card.dart';

class AnalyticCards extends StatelessWidget {
  final List<AnalyticInfo> list;
  const AnalyticCards({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Container(
      child: Responsive(
        mobile: AnalyticInfoCardGridView(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5, list: list,
        ),
        tablet:  AnalyticInfoCardGridView(list: list,),
        desktop: AnalyticInfoCardGridView(
          list: list,
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridView extends StatelessWidget {
  final List<AnalyticInfo> list;

  const AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4, required this.list,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: appPadding,
        mainAxisSpacing: appPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => AnalyticInfoCard(
        info: list[index],
      ),
    );
  }
}
