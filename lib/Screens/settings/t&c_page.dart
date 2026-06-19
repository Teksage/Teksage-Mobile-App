import 'dart:io';

import 'package:astro_prompt/Components/Settings/bulletPoints.dart';
import 'package:astro_prompt/Components/Settings/termsContent.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/launchMail.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    // print('Width: ${util.responsiveWidth(0.2668)}');
    // print('Height: ${util.responsiveHeight(0.1971)}');
    // print('FontSize: ${util.responsiveFontSize(0.0186)}');

    return Scaffold(
      backgroundColor: whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: util.responsiveHeight(0.1971),
            backgroundColor: Platform.isAndroid ? mainColor : iosMainColor,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset(
                backButton,
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                double percentage = ((constraints.maxHeight - kToolbarHeight) /
                        (150 - kToolbarHeight))
                    .clamp(0.0, 1.0);

                return Stack(
                  children: [
                    FlexibleSpaceBar(
                      background: Align(
                        alignment: Alignment.bottomCenter,
                        child: Opacity(
                          opacity: percentage,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Last updated: April 26, 2025",
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.regular),
                                fontSize: util.fontSize12,
                                height: 1.0,
                                color: whiteColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: percentage * 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Transform.translate(
                          offset: Offset(0, 10),
                          child: Text(
                            "Terms & Conditions",
                            style: TextStyle(
                                fontFamily: AppFont.get(FontType.bold),
                                fontSize: util.fontSize24,
                                color: whiteColor,
                                height: 1.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: Platform.isIOS
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(iosSettingBg),
                        alignment: Alignment.topLeft,
                      ),
                    )
                  : null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interpretation and Definitions',
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: 20,
                          height: 1.0),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TermsContentSection(
                      title: "Interpretation",
                      content:
                          "The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Definitions',
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.semiBold),
                              fontSize: util.fontSize20,
                              height: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: util.width12),
                          Text(
                            'For the purposes of these Terms and Conditions:',
                            style: TextStyle(
                              fontFamily: AppFont.get(FontType.medium),
                              fontSize: util.fontSize14,
                              height: 1.5,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BulletPoints(
                        content:
                            "Application means the software program provided by the Company downloaded by You on any electronic device, named Teksage"),
                    BulletPoints(
                        content:
                            "Application Store means the digital distribution service operated and developed by Apple Inc. (Apple App Store) or Google Inc. (Google Play Store) in which the Application has been downloaded."),
                    BulletPoints(
                        content:
                            'Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.'),
                    BulletPoints(
                        content:
                            'Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Teksage.'),
                    BulletPoints(
                        content:
                            "Device means any device that can access the Service such as a computer, a cellphone or a digital tablet."),
                    BulletPoints(content: "Service refers to the Application."),
                    BulletPoints(
                        content:
                            'Terms and Conditions (also referred as "Terms") mean these Terms and Conditions that form the entire agreement between You and the Company regarding the use of the Service.'),
                    BulletPoints(
                        content:
                            'Third-party Social Media Service means any services or content (including data, information, products or services) provided by a third-party that may be displayed, included or made available by the Service.'),
                    BulletPoints(
                        content:
                            'You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.'),
                    SizedBox(
                      height: util.height20,
                    ),
                    TermsContentSection(
                      title: "Acknowledgment",
                      content:
                          "These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service. \n\nYour access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users and others who access or use the Service.\n\nBy accessing or using the Service You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.\n\nYou represent that you are over the age of 18. The Company does not permit those under 18 to use the Service.\n\nYour access to and use of the Service is also conditioned on Your acceptance of and compliance with the Privacy Policy of the Company. Our Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your personal information when You use the Application or the Website and tells You about Your privacy rights and how the law protects You. Please read Our Privacy Policy carefully before using Our Service.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "Informational Purposes Only:",
                      content:
                          "The astrological insights and predictions provided by Teksage are intended for informational and guidance purposes only. Astrology is a science of tendencies, not certainties, and should not be interpreted in a fatalistic or deterministic manner—whether applied at an individual or collective level. ",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "No Guarantee of Accuracy",
                      content:
                          "While we aim to offer accurate and personalized readings, astrology is inherently interpretive. Teksage and its creators make no guarantees regarding the accuracy, completeness, or reliability of any astrological predictions or content.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "User Responsibility",
                      content:
                          "You as a user are solely responsible for any decisions or actions they take based on the astrological insights or guidance offered through Teksage. The Company assumes no liability for consequences arising from reliance on the information provided by the app.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "Not a Substitute for Professional Advice",
                      content:
                          "Astrological guidance should not replace professional advice. For matters involving health, finance, law, or other specialized domains, please consult qualified professionals. Teksage does not provide medical, legal, or financial advice, and its content should not be interpreted as such.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "Links to Other Websites",
                      content:
                          "Our Service may contain links to third-party web sites or services that are not owned or controlled by the Company.\n\nThe Company has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that the Company shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods or services available on or through any such web sites or services.\n\nWe strongly advise You to read the terms and conditions and privacy policies of any third-party web sites or services that You visit.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "Termination",
                      content:
                          "We may terminate or suspend Your access immediately, without prior notice or liability, for any reason whatsoever, including without limitation if You breach these Terms and Conditions.\n\nUpon termination, Your right to use the Service will cease immediately.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "Limitation of Liability",
                      content:
                          "Notwithstanding any damages that You might incur, the entire liability of the Company and any of its suppliers under any provision of this Terms and Your exclusive remedy for all of the foregoing shall be limited to the amount actually paid by You through the Service or 100 USD if You haven't purchased anything through the Service.\n\nTo the maximum extent permitted by applicable law, in no event shall the Company or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, damages for loss of profits, loss of data or other information, for business interruption, for personal injury, loss of privacy arising out of or in any way related to the use of or inability to use the Service, third-party software and/or third-party hardware used with the Service, or otherwise in connection with any provision of this Terms), even if the Company or any supplier has been advised of the possibility of such damages and even if the remedy fails of its essential purpose.\n\nSome states do not allow the exclusion of implied warranties or limitation of liability for incidental or consequential damages, which means that some of the above limitations may not apply. In these states, each party's liability will be limited to the greatest extent permitted by law.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: '"AS IS" and "AS AVAILABLE" Disclaimer',
                      content:
                          'The Service is provided to You "AS IS" and "AS AVAILABLE" and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, the Company, on its own behalf and on behalf of its Affiliates and its and their respective licensors and service providers, expressly disclaims all warranties, whether express, implied, statutory or otherwise, with respect to the Service, including all implied warranties of merchantability, fitness for a particular purpose, title and non-infringement, and warranties that may arise out of course of dealing, course of performance, usage or trade practice. Without limitation to the foregoing, the Company provides no warranty or undertaking, and makes no representation of any kind that the Service will meet Your requirements, achieve any intended results, be compatible or work with any other software, applications, systems or services, operate without interruption, meet any performance or reliability standards or be error free or that any errors or defects can or will be corrected.\n\nWithout limiting the foregoing, neither the Company nor any of the company\'s provider makes any representation or warranty of any kind, express or implied: (i) as to the operation or availability of the Service, or the information, content, and materials or products included thereon; (ii) that the Service will be uninterrupted or error-free; (iii) as to the accuracy, reliability, or currency of any information or content provided through the Service; or (iv) that the Service, its servers, the content, or e-mails sent from or on behalf of the Company are free of viruses, scripts, trojan horses, worms, malware, timebombs or other harmful components.\n\nSome jurisdictions do not allow the exclusion of certain types of warranties or limitations on applicable statutory rights of a consumer, so some or all of the above exclusions and limitations may not apply to You. But in such a case the exclusions and limitations set forth in this section shall be applied to the greatest extent enforceable under applicable law.',
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "Governing Law",
                      content:
                          "The laws of the Country, excluding its conflicts of law rules, shall govern this Terms and Your use of the Service. Your use of the Application may also be subject to other local, state, national, or international laws.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: " Disputes Resolution",
                      content:
                          "If You have any concern or dispute about the Service, You agree to first try to resolve the dispute informally by contacting the Company.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "For European Union (EU) Users",
                      content:
                          "If You are a European Union consumer, you will benefit from any mandatory provisions of the law of the country in which You are resident.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "United States Legal Compliance",
                      content:
                          'You represent and warrant that (i) You are not located in a country that is subject to the United States government embargo, or that has been designated by the United States government as a "terrorist supporting" country, and (ii) You are not listed on any United States government list of prohibited or restricted parties',
                    ),
                    SizedBox(height: util.height10),
                    Text(
                      'Severability and Waiver',
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: util.fontSize20,
                          height: 1.0),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TermsContentSection(
                      title: "Severability",
                      content:
                          "If any provision of these Terms is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.",
                    ),
                    TermsContentSection(
                      title: "Waiver",
                      content:
                          "Except as provided herein, the failure to exercise a right or to require performance of an obligation under these Terms shall not affect a party's ability to exercise such right or require such performance at any time thereafter nor shall the waiver of a breach constitute a waiver of any subsequent breach.",
                    ),
                    TermsContentSection(
                      title: "Translation Interpretations",
                      content:
                          "These Terms and Conditions may have been translated if We have made them available to You on our Service. You agree that the original English text shall prevail in the case of a dispute.",
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "Changes to These Terms and Conditions",
                      content:
                          'We reserve the right, at Our sole discretion, to modify or replace these Terms at any time. If a revision is material We will make reasonable efforts to provide at least 30 days\' notice prior to any new terms taking effect. What constitutes a material change will be determined at Our sole discretion.\n\nBy continuing to access or use Our Service after those revisions become effective, You agree to be bound by the revised terms. If You do not agree to the new terms, in whole or in part, please stop using the website and the Service.',
                    ),
                    SizedBox(height: util.height10),
                    TermsContentSection(
                      title: "Contact Us",
                      content:
                          "If you have any questions about these Terms and Conditions, You can contact us",
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontFamily: AppFont.get(FontType.bold),
                            fontSize: util.fontSize24,
                            height: 1.0,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                        SizedBox(height: util.width12),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.medium),
                                fontSize: util.fontSize14,
                                height: 1.5,
                                color: Colors.black.withValues(alpha: 0.6),
                              ),
                              children: [
                                TextSpan(
                                    text: 'By email:',
                                    style: TextStyle(
                                      fontFamily: AppFont.get(FontType.medium),
                                      fontSize: util.fontSize14,
                                      height: 1.5,
                                      color:
                                          Colors.black.withValues(alpha: 0.6),
                                    )),
                                TextSpan(
                                  text: ' support@teksage.app',
                                  style: TextStyle(
                                    fontFamily: AppFont.get(FontType.medium),
                                    fontSize: util.fontSize14,
                                    height: 1.5,
                                    color: Platform.isAndroid
                                        ? mainColor
                                        : iosMainColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchSupportEmail();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
