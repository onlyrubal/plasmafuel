import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plasma_fuel/providers/auth.dart';
import 'package:plasma_fuel/providers/donor_info.dart';
import 'package:plasma_fuel/widgets/today_cases_card.dart';
import '../widgets/donor_submission_card.dart';
import '../providers/covid_tracker.dart';
import 'package:provider/provider.dart';
import '../widgets/info_card.dart';
import '../widgets/prevention_card.dart';
import '../widgets/donor_requirement_card.dart';

Container buildHelpCard(BuildContext context) {
  return Container(
    height: 150,
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            // left side padding is 40% of total width
            left: MediaQuery.of(context).size.width * .4,
            top: 20,
            right: 20,
          ),
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE44236),
                Color(0xFFE83350),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Dial 999 for \nMedical Help!\n",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
                TextSpan(
                  text: "If any symptoms appear",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SvgPicture.asset("assets/icons/nurse.svg"),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: SvgPicture.asset("assets/icons/virus.svg"),
        ),
      ],
    ),
  );
}

SingleChildScrollView buildPreventation() {
  return SingleChildScrollView(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PreventitonCard(
          svgSrc: "assets/icons/hand_wash.svg",
          title: "Wash Hands",
        ),
        PreventitonCard(
          svgSrc: "assets/icons/use_mask.svg",
          title: "Use Masks",
        ),
        PreventitonCard(
          svgSrc: "assets/icons/Clean_Disinfect.svg",
          title: "Clean Disinfect",
        ),
      ],
    ),
  );
}

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_page';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _checkDidChangeDependenciesRan = true;
  bool _isLoadingSpinner = false;

  List<FlSpot> _weeklyCasesConfirmed = [
    FlSpot(0, 35551),
    FlSpot(1, 36595),
    FlSpot(2, 36652),
    FlSpot(3, 36011),
    FlSpot(4, 32981),
    FlSpot(5, 26567),
    FlSpot(6, 32080),
  ];
  List<FlSpot> _weeklyCasesDeaths = [
    FlSpot(0, 526),
    FlSpot(1, 540),
    FlSpot(2, 512),
    FlSpot(3, 482),
    FlSpot(4, 391),
    FlSpot(5, 385),
    FlSpot(6, 402),
  ];
  List<FlSpot> _weeklyCasesRecovered = [
    FlSpot(0, 31280),
    FlSpot(1, 31041),
    FlSpot(2, 32389),
    FlSpot(3, 34890),
    FlSpot(4, 33121),
    FlSpot(5, 34341),
    FlSpot(6, 36635),
  ];
  List<FlSpot> _weeklyCasesToday = [];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    if (_checkDidChangeDependenciesRan) {
      setState(() {
        _isLoadingSpinner = true;
      });

      Provider.of<CovidTrackers>(context).fetchCovidStatistics().then((_) {
        setState(() {
          _isLoadingSpinner = false;
        });
      });
    }
    _checkDidChangeDependenciesRan = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final covidTracker = Provider.of<CovidTrackers>(context);
    final donorInfoData = Provider.of<Donors>(context);
    final authID = Provider.of<Auth>(context).userId;
    final _hasSubmitted =
        (int.tryParse(donorInfoData.mySubmissionsCount(authID)) > 0)
            ? true
            : false;
    return Scaffold(
      body: SafeArea(
        child: _isLoadingSpinner
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 30,
                                child:
                                    Image.asset('assets/icons/flag_india.png')),
                          ),
                          Text(
                            covidTracker.item.country,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 20, right: 20, bottom: 20),
                      width: double.infinity,
                      child: Wrap(
                        runSpacing: 20,
                        spacing: 10,
                        children: [
                          InfoCard(
                            title: "Confirmed Cases",
                            iconColor: Color(0xFFFF8C00),
                            effectedNum:
                                int.tryParse(covidTracker.item.totalCases),
                            press: () {},
                            weeklyCasesCount: _weeklyCasesConfirmed,
                          ),
                          InfoCard(
                            title: "Total Deaths",
                            iconColor: Color(0xFFFF2D55),
                            effectedNum: int.tryParse(covidTracker.item.deaths),
                            press: () {},
                            weeklyCasesCount: _weeklyCasesDeaths,
                          ),
                          // SizedBox(width: 80),
                          InfoCard(
                            title: "Total Recovered",
                            iconColor: Color(0xFF50E3C2),
                            effectedNum:
                                int.tryParse(covidTracker.item.recovered),
                            press: () {},
                            weeklyCasesCount: _weeklyCasesRecovered,
                          ),

                          TodayCasesCard(
                            title: "Today Cases",
                            iconColor: Color(0xFF5856D6),
                            effectedNum: int.tryParse(
                              covidTracker.item.todayCases,
                            ),
                            press: () {},
                            weeklyCasesCount: _weeklyCasesToday,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                'Eligibility To Donate Plasma',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              width: double.infinity,
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 280,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  DonorRequirementCard(
                                    heading:
                                        'You are at least 17 years old and weigh 110 lbs. Additional weight requirements apply for donors age 18 or younger.',
                                    imageValue: 'assets/icons/requirement1.png',
                                  ),
                                  DonorRequirementCard(
                                    imageValue: 'assets/icons/requirement2.png',
                                    heading:
                                        'In good health. You generally feel well, even if you\'re being treated for a chronic condition.',
                                  ),
                                  DonorRequirementCard(
                                    imageValue: 'assets/icons/requirement3.png',
                                    heading:
                                        'Have a prior, verified diagnosis of COVID-19, but are now symptom free.',
                                  ),
                                  !_hasSubmitted
                                      ? DonorSubmissionCard(
                                          heading: 'If you are eligible',
                                          subHeading: 'Click here',
                                          imageValue:
                                              'assets/images/plasmabag.png',
                                        )
                                      : Text(''),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              child: Text(
                                'Prevention',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              width: double.infinity,
                            ),
                            SizedBox(height: 20),
                            buildPreventation(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    buildHelpCard(context),
                    SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
