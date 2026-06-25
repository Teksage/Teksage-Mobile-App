import 'dart:io';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:astro_prompt/Components/Settings/bulletPoints.dart';
import 'package:astro_prompt/Components/Settings/privacySection.dart';
import 'package:astro_prompt/Components/Settings/termsContent.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/imageConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/launchMail.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                            "Privacy Policy",
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
                      'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.',
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: util.fontSize14,
                        height: 1.5,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.',
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: util.fontSize14,
                        height: 1.5,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 30,
                    ),
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
                            "Account means a unique account created for You to access our Service or parts of our Service."),
                    BulletPoints(
                        content:
                            'Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.'),
                    BulletPoints(
                        content:
                            'Application refers to Teksage, the software program provided by the Company.'),
                    BulletPoints(
                        content:
                            'Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Teksage.'),
                    BulletPoints(
                        content: 'Country refers to: Tamil Nadu, India'),
                    BulletPoints(
                        content:
                            'Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.'),
                    BulletPoints(
                        content:
                            'Personal Data is any information that relates to an identified or identifiable individual.'),
                    BulletPoints(content: 'Service refers to the Application.'),
                    BulletPoints(
                        content:
                            'Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.'),
                    BulletPoints(
                        content:
                            'Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).'),
                    BulletPoints(
                        content:
                            'You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.'),
                    SizedBox(
                      height: util.height20,
                    ),
                    Text(
                      'Collecting and Using Your Personal Data',
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: 20,
                          height: 1.0),
                    ),
                    SizedBox(
                      height: util.height20,
                    ),
                    Text(
                      'Types of Data Collected',
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: 20,
                          height: 1.0),
                    ),
                    SizedBox(
                      height: util.height20,
                    ),
                    TermsContentSection(
                      title: "Personal Data",
                      content:
                          "While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:",
                    ),
                    BulletPoints(content: 'Email address'),
                    BulletPoints(content: 'First name and last name'),
                    BulletPoints(content: 'Phone number'),
                    BulletPoints(content: 'Usage Data'),
                    TermsContentSection(
                      title: "Usage Data",
                      content:
                          "Usage Data is collected automatically when using the Service.\n\nUsage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.\n\nWhen You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.\n\nWe may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.",
                    ),
                    TermsContentSection(
                      title: "Use of Your Personal Data",
                      content:
                          "The Company may use Personal Data for the following purposes:",
                    ),
                    PrivacySection(
                      title: "Storage of Birth Details & Personal Data:",
                      content:
                          "Teksage requires you to provide your birth details (date, time, and place of birth) to generate personalized astrological readings. This data is used exclusively for prediction purposes and is not shared with third parties without your explicit consent.  ",
                    ),
                    PrivacySection(
                      title: "Data Retention for Astrological Profiles:",
                      content:
                          "We may retain your birth details to allow repeated access to personalized predictions. This information is stored securely and remains in our system until you request its deletion.   ",
                    ),
                    PrivacySection(
                      title: "AI-Powered Chat & Conversations:",
                      content:
                          "Our AI-powered astrology chat processes user input to generate responses. Conversation data may be temporarily stored to improve prediction quality and enhance user experience. This data is never used for advertising, profiling, or sold to third parties.  ",
                    ),
                    PrivacySection(
                      title: "Consultation Bookings & Third-Party Experts:",
                      content:
                          "When you book a consultation through Teksage, your relevant birth details may be shared with the selected astrologer to facilitate accurate readings. Teksage does not control how astrologers use this information; users are encouraged to review the privacy policies of individual astrologers.   ",
                    ),
                    PrivacySection(
                      title: "No Automated Decision-Making:",
                      content:
                          "Teksage does not use your personal or astrological data for automated decision-making that may have legal, financial, or medical consequences. All astrological content is for informational purposes only. ",
                    ),
                    PrivacySection(
                      title:
                          "Right to Download & Delete Personal Astrological Data:",
                      content:
                          "You have the right to access, download, or permanently delete your stored birth details and chat history. Requests can be made through the app settings or by contacting our support team.",
                    ),
                    BulletPoints(
                        content:
                            'To provide and maintain our Service, including to monitor the usage of our Service.'),
                    BulletPoints(
                        content:
                            'To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user.'),
                    BulletPoints(
                        content:
                            'For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.'),
                    BulletPoints(
                        content:
                            'To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application\'s push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.'),
                    BulletPoints(
                        content:
                            'To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information.'),
                    BulletPoints(
                        content:
                            'To manage Your requests: To attend and manage Your requests to Us.'),
                    BulletPoints(
                        content:
                            'For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred.'),
                    BulletPoints(
                        content:
                            'For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience.'),
                    Text(
                      'We may share Your personal information in the following situations:',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: AppFont.get(FontType.medium),
                        fontSize: util.fontSize14,
                        height: 1.5,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                    BulletPoints(
                        content:
                            'With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You.'),
                    BulletPoints(
                        content:
                            'For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company.'),
                    BulletPoints(
                        content:
                            'With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us.'),
                    BulletPoints(
                        content:
                            'With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions.'),
                    BulletPoints(
                        content:
                            'With other users: when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside.'),
                    BulletPoints(
                        content:
                            'With Your consent: We may disclose Your personal information for any other purpose with Your consent.'),
                    TermsContentSection(
                      title: "Retention of Your Personal Data",
                      content:
                          'The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.\n\nThe Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.',
                    ),
                    TermsContentSection(
                      title: "Transfer of Your Personal Data",
                      content:
                          'Your information, including Personal Data, is processed at the Company\'s operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.\n\nYour consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.\n\nThe Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.',
                    ),
                    TermsContentSection(
                      title: "Delete Your Personal Data",
                      content:
                          'You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You.\n\nOur Service may give You the ability to delete certain information about You from within the Service.\n\nYou may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information. You may also contact Us to request access to, correct, or delete any personal information that You have provided to Us.\n\nPlease note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.',
                    ),
                    Text(
                      'Disclosure of Your Personal Data',
                      style: TextStyle(
                          fontFamily: AppFont.get(FontType.bold),
                          fontSize: 20,
                          height: 1.0),
                    ),
                    TermsContentSection(
                      title: "Business Transactions",
                      content:
                          'If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.',
                    ),
                    TermsContentSection(
                      title: "Law enforcement",
                      content:
                          'Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).',
                    ),
                    TermsContentSection(
                      title: "Other legal requirements",
                      content:
                          'The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:',
                    ),
                    BulletPoints(content: 'Comply with a legal obligation'),
                    BulletPoints(
                        content:
                            'Protect and defend the rights or property of the Company'),
                    BulletPoints(
                        content:
                            'Prevent or investigate possible wrongdoing in connection with the Service'),
                    BulletPoints(
                        content:
                            'Protect the personal safety of Users of the Service or the public'),
                    BulletPoints(content: 'Protect against legal liability'),
                    TermsContentSection(
                      title: "Security of Your Personal Data",
                      content:
                          'The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.',
                    ),
                    TermsContentSection(
                      title: "Children's Privacy",
                      content:
                          'Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.\n\nIf We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent\'s consent before We collect and use that information.',
                    ),
                    TermsContentSection(
                      title: "Links to Other Websites",
                      content:
                          'Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party\'s site. We strongly advise You to review the Privacy Policy of every site You visit.\n\nWe have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.',
                    ),
                    TermsContentSection(
                      title: "Changes to this Privacy Policy",
                      content:
                          'We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.\n\nWe will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.\n\nYou are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
                    ),
                    TermsContentSection(
                      title: "Use of Third-Party AI Services (OpenAI)",
                      content:
                          'To generate personalized astrological predictions, Teksage may send your calculated horoscope data (based on the birth details you provide) to third-party AI service providers, such as OpenAI. This data is used exclusively for generating predictive responses and is not used for any advertising or profiling purposes.\nTeksage does not control how OpenAI or similar providers process this data once it is transmitted. We encourage users to review OpenAI\'s Privacy Policy to understand how their information may be handled by these services. We take necessary measures to anonymize or limit the data sent to third parties to only what is essential for prediction purposes.',
                    ),
                    TermsContentSection(
                      title: "Contact Us",
                      content:
                          'If you have any questions about this Privacy Policy, You can contact us:',
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: util.width12),
                      child: Row(
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
                                        fontFamily:
                                            AppFont.get(FontType.medium),
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
                      ),
                    ),
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
