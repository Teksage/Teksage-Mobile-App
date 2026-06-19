import 'dart:io';
import 'package:astro_prompt/Utility/imageConstant.dart';

class PlatformTextConfig {
  ///Onboarding
  static final List<Map<String, String>> onboardingData =
      Platform.isAndroid ? _androidData : _iosData;

  static const List<Map<String, String>> _androidData = [
    {
      "image": androidOnBoard1,
      "title": "AI-Powered\nAstrology Voice Chat",
      "description":
          "Instant Vedic astrology insights — just talk and listen to your AI Jyotish."
    },
    {
      "image": androidOnBoard2,
      "title": "Personalized Daily\n& Life Predictions",
      "description":
          "Discover accurate insights about your future with daily and life predictions."
    },
    {
      "image": androidOnBoard3,
      "title": "Marriage Compatibility\n& Free Astrology Reports",
      "description":
          "Check your compatibility and access free astrology reports for better decisions."
    },
  ];

  static const List<Map<String, String>> _iosData = [
    {
      "image": iosOnBoard1,
      "title": "No More Typing",
      "description":
          "Tired of typing long questions? Just speak your thoughts and let our AI Jyotish expert listen. Get answers effortlessly—your stars, your voice."
    },
    {
      "image": iosOnBoard2,
      "title": "Instant Responses",
      "description":
          "No waiting, no delays. Ask your question and receive real-time Jyotish insights instantly while you talk. Quick, simple, and accurate."
    },
    {
      "image": iosOnBoard3,
      "title": "Voice Answers",
      "description":
          "Go beyond text-based predictions. Listen to your AI Jyotish expert read out your personalized insights—making Jyotish more natural and interactive than ever."
    },
  ];

  ///Menu
  static String get panchang {
    return Platform.isAndroid ? 'Panchang' : 'Daily Calender';
  }

  static String get horoscope {
    return Platform.isAndroid ? 'Horoscope' : 'Star Chart';
  }

  ///Info Text
  static String get infoText {
    return Platform.isAndroid
        ? 'Predictions are based on birth details in your profile section'
        : 'Insights reflect information you’ve provided in your profile.';
  }

  ///PageTitle
  static String get panchangPageTitle {
    return Platform.isAndroid
        ? 'Personalized Panchang'
        : 'Personalized Daily Calendar';
  }

  ///Home Page
  static String get astrologerConsultation {
    return Platform.isAndroid
        ? 'Astrologer\nConsultation'
        : 'Expert\nConsultation';
  }

  static String get dailyPrediction {
    return Platform.isAndroid ? 'Daily\nPrediction' : 'Daily\nWisdom';
  }

  static String get weeklyPrediction {
    return Platform.isAndroid ? 'Weekly\nPrediction' : 'Weekly\nInsights';
  }

  static String get yearlyPrediction {
    return Platform.isAndroid ? 'Yearly\nPrediction' : 'Yearly\nOutlook';
  }

  static String get yearlyPredictionLanding {
    return Platform.isAndroid ? 'Yearly Prediction' : 'Yearly Outlook';
  }

  static String get lifePrediction {
    return Platform.isAndroid ? 'Life\nPrediction' : 'Life\nProjection';
  }

  static String get lifePredictionLanding {
    return Platform.isAndroid ? 'Life Prediction' : 'Life Projection';
  }

  static String get chatHomePage {
    return Platform.isAndroid ? 'AI Voice Astro Chat' : '24x7\nAI Guidance';
  }

  ///Astrologer - user
  static String get astrologerUserHomeTitle {
    return Platform.isAndroid
        ? 'Astrology Consultation'
        : 'Expert Consultation';
  }

  static String get astrologerUserCTA1 {
    return Platform.isAndroid
        ? 'Find & Consult Astrologers'
        : 'Find & Connect with Experts';
  }

  static String get astrologerUserCTA2 {
    return Platform.isAndroid ? '100+ Astrologers' : '100+ Experts';
  }

  static String get astrologerUserCTA3 {
    return Platform.isAndroid
        ? 'Explore and find your perfect match'
        : 'Explore and Discover your guide';
  }

  static String get astrologerUserLangSelect {
    return Platform.isAndroid
        ? 'This will help us to match the best astrologer'
        : 'This helps us pair you with the expert advisor';
  }

  static String get astrologerListingTop5 {
    return Platform.isAndroid
        ? 'Top 5 astrologers\nbased on preferences'
        : 'Top 5 Experts aligned\nwith your preferences';
  }

  static String get astrologerListing {
    return Platform.isAndroid
        ? 'List of Other Astrologers'
        : 'List of Other Experts';
  }

  static String get astrologerUserShareHoroscope {
    return Platform.isAndroid
        ? 'I consent to share my personal information & horoscope with the astrologer'
        : 'I consent to share my personal information & star chart with the advisor';
  }

  static String get astrologerUserShareHoroscopeError {
    return Platform.isAndroid
        ? 'Please agree to share your profile info and Horoscope to continue'
        : 'Please agree to share your profile info and star chart to continue';
  }

  ///Chat Screen
  static String get chatBanner {
    return Platform.isAndroid ? 'Consult Astrologer' : 'Consult an expert';
  }

  static String get chatTitle {
    return Platform.isAndroid ? 'AI Voice Astro Chat' : 'Teksage';
  }

  ///Predictions
  static String get dailyTitle {
    return Platform.isAndroid ? 'Daily Prediction' : 'Daily Wisdom';
  }

  static String get dailyFileSave {
    return Platform.isAndroid ? 'daily_prediction' : 'daily_wisdom';
  }

  static String get dailyParam {
    return Platform.isAndroid
        ? 'Here is my daily prediction!'
        : 'Here is my daily wisdom!';
  }

  static String get dailyShareSuccessMessage {
    return Platform.isAndroid
        ? 'Your Daily Prediction has been shared successfully. Thank you.'
        : 'Your Daily wisdom has been shared successfully. Thank you.';
  }

  static String get dailyShareErrorMessage {
    return Platform.isAndroid
        ? 'We encountered an issue while fetching your daily prediction. Please retry.'
        : 'We encountered an issue while fetching your daily wisdom. Please retry.';
  }

  static String get weeklyTitle {
    return Platform.isAndroid ? 'Weekly Predictions' : 'Weekly Insights';
  }

  static String get weeklyFileSave {
    return Platform.isAndroid ? 'weekly_predictions' : 'weekly_insights';
  }

  static String get weeklyParam {
    return Platform.isAndroid
        ? 'Here is my weekly prediction!'
        : 'Here is my weekly insights!';
  }

  static String get weeklyShareSuccessMessage {
    return Platform.isAndroid
        ? 'Your Weekly Prediction has been shared successfully. Thank you.'
        : 'Your Weekly Insights has been shared successfully. Thank you.';
  }

  static String get weeklyShareErrorMessage {
    return Platform.isAndroid
        ? 'We encountered an issue while fetching your weekly prediction. Please retry.'
        : 'We encountered an issue while fetching your weekly insights. Please retry.';
  }

  static String get yearlyTitle {
    return Platform.isAndroid ? 'Yearly Prediction' : 'Yearly Outlook';
  }

  static String get yearlyFileSave {
    return Platform.isAndroid ? 'yearly_predictions' : 'yearly_outlook';
  }

  static String get yearlyParam {
    return Platform.isAndroid
        ? 'Here is my yearly prediction!'
        : 'Here is my yearly outlook!';
  }

  static String get yearlyShareSuccessMessage {
    return Platform.isAndroid
        ? 'Your Yearly Prediction has been shared successfully. Thank you.'
        : 'Your Yearly Outlook has been shared successfully. Thank you.';
  }

  static String get yearlyShareErrorMessage {
    return Platform.isAndroid
        ? 'We encountered an issue while fetching your yearly prediction. Please retry.'
        : 'We encountered an issue while fetching your yearly outlook. Please retry.';
  }

  static String get yearlyLifeDesc {
    return Platform.isAndroid
        ? 'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology.'
        : 'Unlock personalized insights into your future, career, relationships, and more with AI-powered guidance.';
  }

  static String get lifeTitle {
    return Platform.isAndroid ? 'Life Prediction' : 'Life Projection';
  }

  //Subscription
  static final List<String> planFeatures =
      Platform.isAndroid ? _androidPlanData : _iosPlanData;

  static const List<String> _androidPlanData = [
    "Auto Schedule Daily Predictions",
    "Auto Schedule Weekly Predictions",
    "Book Consultations",
    "Basic Horoscope Chart",
    "Edit Horoscope Details",
    "Unlimited Number Of Chat Per Week",
    // "Download Chat History",
    "Pick Chat Avatar",
    "Pick Chat Style",
    "Life Predictions",
    "Yearly Predictions",
    "Personalized Panchang",
  ];

  static const List<String> _iosPlanData = [
    "Pick Chat Avatar",
    "Pick Chat Style",
    "Unlimited Number Of Chat Per Week",
    "Unlimited Voice Chats",
    "Unlimited Text Chats",
    "Unlimited Profile change",
  ];
}
