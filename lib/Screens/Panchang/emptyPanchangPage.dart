import 'package:astro_prompt/Components/Dashboard/subscribeDialog.dart';
import 'package:astro_prompt/Screens/Home/bottonNavController.dart';
import 'package:astro_prompt/Screens/Panchang/panchangPage.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PanchangSubscriptionCheckPage extends StatefulWidget {
  const PanchangSubscriptionCheckPage({super.key});

  @override
  State<PanchangSubscriptionCheckPage> createState() => _PanchangSubscriptionCheckPageState();
}

class _PanchangSubscriptionCheckPageState extends State<PanchangSubscriptionCheckPage> {
  final BottomNavController controller = Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    // The BottomNavController is responsible for performing the access checks
    // and showing login/subscribe dialogs when the user navigates to the
    // Panchang tab. Here we only react to the premium state for UI.
    return Obx(() {
      if (controller.isPremiumUser.value) {
        return PanchangPage();
      }

      return Scaffold(
        backgroundColor: Colors.amber,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xff0b121a), Color(0xff7ca2b9)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  panchangBG,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: util.height,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
