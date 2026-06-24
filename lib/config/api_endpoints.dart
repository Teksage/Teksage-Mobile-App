class ApiEndpoint {
 // static const String mainUrl = 'https://anwshecjj0.execute-api.ap-south-1.amazonaws.com';
  ///Production Environment
//   static const String mainUrl = 'http://ec2-15-206-194-79.ap-south-1.compute.amazonaws.com:8000';
//   static const String chatUrl = 'ws://ec2-15-206-194-79.ap-south-1.compute.amazonaws.com:8000/chat';
  ///Dev Environment
  //emulator
  // static const String mainUrl ="http://10.0.2.2:8000";
  //physical device — use your PC's current Wi‑Fi IPv4 (ipconfig). Must match same network as phone.
//   static const String mainUrl ="http://10.122.202.187:8000";
static const String mainUrl ="http://192.168.1.2:8000";

  // static const String mainUrl ='https://teksage-backend-latest.onrender.com';
  // static const String chatUrl ='wss://teksage-backend-latest.onrender.com/chat';
  

  //emulator
  // static const String chatUrl ="ws://10.0.2.2:8000/chat";
  //physical device
//   static const String chatUrl ="ws://10.122.202.187:8000/chat";
static const String chatUrl ="ws://192.168.1.2:8000/chat";
  

  ///
  static const String baseUrl = '$mainUrl/api';
  static const String auth = '$baseUrl/auth/otp';
  static const String profile = '$baseUrl/auth';
  static const String prediction = '$baseUrl/prediction';
  static const String astrologer = '$baseUrl/astrologer';
  static const String events = '$astrologer/events';
  static const String slots = '$astrologer/slots';
  static const String payment = '$baseUrl/payment';
  static const String admin = '$baseUrl/admin';
  static const String share = '$baseUrl/share';

  // Login APIs
  static const String login = '$auth/request';
  static const String verifyOTP = '$auth/login-verify';
  static const String refreshToken = '$profile/refresh';
  static const String logout = '$profile/logout';

  // Profile
  static const String getProfile = '$profile/profile';
  static const String profileVerify = '$auth/send-authenticated';
  static const String profileVerifyOtp = '$auth/verify';
  static const String getRasiNakshatram = '$profile/rashi-nakshatra';
  static const String updateProfile = '$profile/update-profile';

  // Prediction APIs
  static const String dailyPrediction = '$prediction/daily';
  static const String weeklyPrediction = '$prediction/weekly';
  static const String yearlyPrediction = '$prediction/yearly';
  static const String lifePrediction = '$prediction/life';

  // Panchang
  static const String panchang = '$prediction/panchang';

  //Horoscope
  static const String horoscope = '$profile/horoscope';
  static const String horoscopeDownload = '$baseUrl/horoscope/download';

  //Rashi&Nakshatra
  static const String rashi = '$astrologer/rashi';
  static const String nakshatra = '$astrologer/nakshatra';

  //MatchMaking
  static const String matchMaking = '$prediction/compatibility';

  //Astrologer
  static const String userConsultationFilter = '$astrologer/filter';
  static const String getAstrologerDetail = '$astrologer/astrologer';

  //Slots
  static const String getAstrologerSlots = slots;
  static const String createAstrologerSlots = '$slots/create';

  //Booking
  static const String createAstrologerBooking = '$astrologer/book';

  //Payment
  static const String verifyPayment =
      '$payment/verify-payment/'; //verify-auto-payment
  static const String verifyAutoPayment = '$payment/verify-auto-payment/';
  static const String subscriptionPayment = '$payment/subscribe';
  static const String autoSubscriptionPayment = '$payment/subscribe-auto';
  static const String paymentUpdateIos = '$payment/ios-subscription';

  //Coupon
  static const String applyCoupon = '$payment/apply-coupon';

  //Subscription
  static const String getSubscriptionPlans = '$admin/service-catalogs/';

  //Events
  static const String astroEvents = events;

  //Questions
  static const String astrologerAnswerUpdate = '$astrologer/questions';

  //Settings
  static const String getFaq = '$baseUrl/faq';
  static const String supportMail = '$profile/support';
  static const String updateNotificationPreference = '$profile/notify-update';
  static const String deleteAccountSendOtp = '$profile/delete/request';
  static const String deleteAccountVerifyOtp = '$profile/delete/confirm';

  //Chat
  static const String getRelatedQueries = '$prediction/related_queries';
  static const String chatDownload = '$baseUrl/download-chat-pdf';
  static const String chatHistory = '$baseUrl/chat-history';
  static const String maintainChatHistory = '$profile/maintain_history';
  static const String chatMail = '$baseUrl/chat-history/download';
  static const String recordAudio = '$baseUrl/transcribe-audio';
  static const String chatFormat = '$profile/update-chat-format';

  //Share
  static const String dailyShare = '$share/daily';
  static const String weeklyShare = '$share/weekly';
  static const String yearlyShare = '$share/yearly';
  static const String lifeShare = '$share/life';
  static const String panchangShare = '$share/panchang';
  static const String matchMakingShare = '$share/match_making';

  //Notification
  static const String registerFcmToken = '$profile/register-token/';
  static const String getNotification = '$baseUrl/notifications';
  static const String updateNotification = '$getNotification/update-status';

  //Common
  static const String getCountyCode = '$baseUrl/countries';
  static const String updateTimeZone = '$profile/timezone/update';
  static const String getAppLanguage = '$profile/update-app-language';

  //WhatsApp consent
  static const String whatsappBase = '$baseUrl/whatsapp/consent';
  static const String whatsappConsentStatus = '$whatsappBase/status';
  static const String whatsappConsentRequest = '$whatsappBase/request';
  static const String whatsappConsentRevoke = '$whatsappBase/revoke';

  //Ask Astrologer
  static const String askAstrologerBase = '$baseUrl/ask-astrologer';
  static const String askAstrologerPricing = '$askAstrologerBase/pricing';
  static const String askAstrologerCreate = '$askAstrologerBase/create';
  static const String askAstrologerVerify = '$askAstrologerBase/verify';
  static const String askAstrologerRequests = '$askAstrologerBase/requests';
  static const String askAstrologerPendingAnswerPopup =
      '$askAstrologerBase/pending-answer-popup';
  static const String astrologerAskRequests = '$astrologer/ask-requests';

  // Feature discovery (WhatsApp + Ask Astrologer popup)
  static const String featureDiscoveryStatus = '$profile/feature-discovery';
  static const String featureDiscoveryDismiss =
      '$profile/feature-discovery/dismiss';
}
