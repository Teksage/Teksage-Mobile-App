import 'package:get/get.dart';
import 'package:astro_prompt/config/textConfig.dart';

class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          //Home page
          'Good day': 'Good day',
          'Astrologer': 'Astrologer',
          'Home': 'Home',
          'Panchang': 'Panchang',
          'Horoscope': 'Horoscope',
          'Settings': 'Settings',
          'My Profile': 'My Profile',
          'Marriage\nMatch Making': 'Marriage\nMatch Making',
          'Explore Other Predictions': 'Explore Other Predictions',
          PlatformTextConfig.yearlyPrediction: 'Yearly\nPrediction',
          PlatformTextConfig.weeklyPrediction: 'Weekly\nPrediction',
          PlatformTextConfig.lifePrediction: 'Life\nPrediction',
          PlatformTextConfig.dailyPrediction: 'Daily\nPrediction',
          PlatformTextConfig.chatHomePage: 'AI Voice Astro Chat',
          'ChatTitle': 'AI Voice Astro Chat',
          'Chat Now': 'Chat Now',
          'Thara Bala': 'Thara Bala',
          'Chandra Bala': 'Chandra Bala',
          'Astrologer\nConsultation': 'Astrologer\nConsultation',
          'Astrologer Consultation': 'Astrologer Consultation',
          //settings
          'Profile': 'Profile',
          'Push Notifications': 'Push Notifications',
          'Language': 'Language',
          'Subscriptions': 'Subscriptions',
          'Terms & Conditions': 'Terms & Conditions',
          'Privacy Policy': 'Privacy Policy',
          'Support': 'Support',
          'FAQs': 'FAQs',
          'Rate us': 'Rate us',
          'Rate': 'Rate',
          'Delete Account': 'Delete Account',
          'Logout': 'Logout',
          'WhatsApp Updates': 'WhatsApp Updates',
          'Ask Astrologer': 'Ask Astrologer',
          'Book Consultation': 'Book Consultation',
          'Your question': 'Your question',
          'Select your preferred language': 'Select your preferred language',
          'We will match you with an astrologer who speaks your language.':
              'We will match you with an astrologer who speaks your language.',
          'Please select a language': 'Please select a language',
          'Notes': 'Notes',
          'Your answer will be delivered within 4 hours.':
              'Your answer will be delivered within 4 hours.',
          'An expert astrologer will review your question and horoscope, then reply with a personalized voice message.':
              'An expert astrologer will review your question and horoscope, then reply with a personalized voice message.',
          'Continue to Payment': 'Continue to Payment',
          'Booking Details': 'Booking Details',
          'Question details': 'Question details',
          'Language': 'Language',
          'Answer within': 'Answer within',
          '4 hours': '4 hours',
          'Payment summary': 'Payment summary',
          'Consultation fee': 'Consultation fee',
          'CGST': 'CGST',
          'SGST': 'SGST',
          'Total': 'Total',
          'Pay & Ask': 'Pay & Ask',
          'Processing…': 'Processing…',
          'Could not load pricing. Please try again.':
              'Could not load pricing. Please try again.',
          'Could not initiate payment. Please try again.':
              'Could not initiate payment. Please try again.',
          'Verification failed. Please contact support.':
              'Verification failed. Please contact support.',
          'Get Updates on WhatsApp': 'Get Updates on WhatsApp',
          'WhatsApp notifications': 'WhatsApp notifications',
          'Enable WhatsApp status updates': 'Enable WhatsApp status updates',
          'We\'ll send a confirmation message to your WhatsApp. Reply to opt in for alerts.':
              'We\'ll send a confirmation message to your WhatsApp. Reply to opt in for alerts.',
          'Alert when your astrologer\'s answer is ready':
              'Alert when your astrologer\'s answer is ready',
          'Updates when your request status changes':
              'Updates when your request status changes',
          'Confirm on WhatsApp': 'Confirm on WhatsApp',
          'Open WhatsApp and reply to our message to turn on alerts.':
              'Open WhatsApp and reply to our message to turn on alerts.',
          'Send confirmation message': 'Send confirmation message',
          'Sending…': 'Sending…',
          'Skip for now': 'Skip for now',
          'You are all set!': 'You are all set!',
          'Your question is with our team. An expert astrologer will answer within 4 hours.':
              'Your question is with our team. An expert astrologer will answer within 4 hours.',
          'Status': 'Status',
          'Received': 'Received',
          'Track in Notifications → Consultation':
              'Track in Notifications → Consultation',
          'Back to Chat': 'Back to Chat',
          'Your answer is ready': 'Your answer is ready',
          'An astrologer has replied to your question.':
              'An astrologer has replied to your question.',
          'Read or listen to the answer now — or find it later in Notifications.':
              'Read or listen to the answer now — or find it later in Notifications.',
          'Open answer': 'Open answer',
          'Not now': 'Not now',
          'Ask Requests': 'Ask Requests',
          'Review client details and submit text or voice answers.':
              'Review client details and submit text or voice answers.',
          'Failed to load requests': 'Failed to load requests',
          'No Ask Astrologer requests yet.': 'No Ask Astrologer requests yet.',
          'Answer': 'Answer',
          'Cancel': 'Cancel',
          'Submit Answer': 'Submit Answer',
          'Submitting…': 'Submitting…',
          'AI Answer (for reference)': 'AI Answer (for reference)',
          'Your Answer': 'Your Answer',
          'Client details': 'Client details',
          'Record voice': 'Record voice',
          'Re-record': 'Re-record',
          'Tap stop when finished': 'Tap stop when finished',
          'Pause voice answer': 'Pause voice answer',
          'Recording voice answer…': 'Recording voice answer…',
          'Stop': 'Stop',
          'Remove': 'Remove',
          'Voice recorded': 'Voice recorded',
          'Provide an answer (text and/or voice).':
              'Provide an answer (text and/or voice).',
          'Submit failed. Please try again.':
              'Submit failed. Please try again.',
          'Awaiting answer': 'Awaiting answer',
          'Answered': 'Answered',
          'Optional written notes': 'Optional written notes',
          'Type your answer here…': 'Type your answer here…',
          'Tap Record voice and share your personalized reply. You may add optional written notes below.':
              'Tap Record voice and share your personalized reply. You may add optional written notes below.',
          'Answer submitted': 'Answer submitted',
          'Never Miss an Important Astrological Opportunity':
              'Never Miss an Important Astrological Opportunity',
          'Get timely WhatsApp alerts about important planetary movements, favorable periods, and personalized horoscope updates.':
              'Get timely WhatsApp alerts about important planetary movements, favorable periods, and personalized horoscope updates.',
          'Major Planetary Transits': 'Major Planetary Transits',
          'Important movements that impact your life.':
              'Important movements that impact your life.',
          'Favorable Periods': 'Favorable Periods',
          'Best times for important decisions and activities.':
              'Best times for important decisions and activities.',
          'Personalized Horoscope Highlights':
              'Personalized Horoscope Highlights',
          'Key insights based on your unique birth chart.':
              'Key insights based on your unique birth chart.',
          'WhatsApp alerts enabled': 'WhatsApp alerts enabled',
          'You will receive astrology updates on WhatsApp.':
              'You will receive astrology updates on WhatsApp.',
          'Disable WhatsApp Alerts': 'Disable WhatsApp Alerts',
          'Disabling…': 'Disabling…',
          'WhatsApp alerts disabled': 'WhatsApp alerts disabled',
          'Tap below to enable alerts again.':
              'Tap below to enable alerts again.',
          'Resend message': 'Resend message',
          'Enable WhatsApp Astrology Alerts':
              'Enable WhatsApp Astrology Alerts',
          'You can unsubscribe anytime by sending STOP on WhatsApp.':
              'You can unsubscribe anytime by sending STOP on WhatsApp.',
          'Could not send WhatsApp message. Try again later.':
              'Could not send WhatsApp message. Try again later.',
          'Could not disable WhatsApp alerts. Try again later.':
              'Could not disable WhatsApp alerts. Try again later.',
          'Assigned': 'Assigned',
          'Answer ready': 'Answer ready',
          'Expected within 4 hours': 'Expected within 4 hours',
          'Includes voice answer': 'Includes voice answer',
          'View Answer →': 'View Answer →',
          'View Answer': 'View Answer',
          "Astrologer's Answer": "Astrologer's Answer",
          'Answered by:': 'Answered by:',
          'Voice answer': 'Voice answer',
          'Play voice answer': 'Play voice answer',
          'No answer content available yet.':
              'No answer content available yet.',
          'Could not load answer. Please try again.':
              'Could not load answer. Please try again.',
          'Session expired. Please try again.':
              'Session expired. Please try again.',
          'Never Miss an': 'Never Miss an',
          'Important Astrological Opportunity':
              'Important Astrological Opportunity',
          'Get timely WhatsApp alerts about important planetary movements, favorable periods, and personalized horoscope updates that can help you make better decisions at the right time.':
              'Get timely WhatsApp alerts about important planetary movements, favorable periods, and personalized horoscope updates that can help you make better decisions at the right time.',
          'What You\'ll Receive': 'What You\'ll Receive',
          'Important Alerts': 'Important Alerts',
          'Special days, events and astrological updates.':
              'Special days, events and astrological updates.',
          'Use my verified profile number': 'Use my verified profile number',
          'Use a different WhatsApp number': 'Use a different WhatsApp number',
          'Enter a valid mobile number.': 'Enter a valid mobile number.',
          'Sent to': 'Sent to',
          'Try again in': 'Try again in',
          'Please wait a moment before resending':
              'Please wait a moment before resending',
          'Message still missing? Try another number or start over below.':
              'Message still missing? Try another number or start over below.',
          'Use another number': 'Use another number',
          'Start over': 'Start over',
          'Starting over…': 'Starting over…',
          'Resend message': 'Resend message',
          'Verify your mobile number': 'Verify your mobile number',
          'Verify your phone to receive the WhatsApp consent message.':
              'Verify your phone to receive the WhatsApp consent message.',
          'We will send a new confirmation message on WhatsApp.':
              'We will send a new confirmation message on WhatsApp.',
          'You will no longer receive astrology updates on WhatsApp. Tap the button below to enable alerts again.':
              'You will no longer receive astrology updates on WhatsApp. Tap the button below to enable alerts again.',
          ' on WhatsApp.': ' on WhatsApp.',
          'Language Updated': 'Language Updated',
          'App language has been changed successfully':
              'App language has been changed successfully',
          'Click to view':'Click to view',
          //Profile
          'First Name': 'First Name',
          'Last Name': 'Last Name',
          'Email': 'Email',
          'Phone Number': 'Phone Number',
          'AI Chat Language': 'AI Chat Language',
          'Date of Birth': 'Date of Birth',
          'Time of Birth': 'Time of Birth',
          'Place of Birth': 'Place of Birth',
          'Current Location': 'Current Location',
          'Rasi': 'Rasi',
          'Nakshatram': 'Nakshatram',
          'Edit': 'Edit',
          'Profile Details': 'Profile Details',
          'Complete Profile': 'Complete Profile',
          'Save': 'Save',
          'Hi (name)!': 'Hi (name)!',
          'Verify': 'Verify',
          'Change': 'Change',
          'Enter place of birth': 'Enter place of birth',
          'Enter Current location': 'Enter Current location',
          'Select a place': 'Select a place',
          'Select any one Option': 'Select any one Option',
          'How did you first hear about Teksage':
              'How did you first hear about Teksage',
          'How did you first hear about Teksage?':
              'How did you first hear about Teksage?',
          'Select a language': 'Select a language',
          "Google Play Store / App Store": "Google Play Store / App Store",
          "Google Search": "Google Search",
          "Quora": "Quora",
          "Facebook / Instagram": "Facebook / Instagram",
          "YouTube": "YouTube",
          "WhatsApp / Telegram (friends or groups)":
              "WhatsApp / Telegram (friends or groups)",
          "Word of mouth (friends/family)": "Word of mouth (friends/family)",
          "Product Hunt": "Product Hunt",
          "Other": "Other",
          //Push Notification
          'Push Notification': 'Push Notification',
          PlatformTextConfig.dailyTitle: 'Daily Predictions',
          PlatformTextConfig.weeklyTitle: 'Weekly Predictions',
          PlatformTextConfig.yearlyTitle: 'Yearly Prediction',
          PlatformTextConfig.lifePredictionLanding: 'Life Prediction',
          'Promotions & Offers': 'Promotions & Offers',
          'Warnings': 'Warnings',
          'Consultation': 'Consultation',
          'General': 'General',
          'Astrologer appointment on': 'Astrologer appointment on',
          'You have an appointment on': 'You have an appointment on',
          'Your Daily Prediction have been generated':
              'Your Daily Prediction have been generated',
          'Your Weekly Prediction have been generated':
              'Your Weekly Prediction have been generated',
          'Your Yearly Prediction have been generated':
              'Your Yearly Prediction have been generated',
          'Daily Prediction': 'Daily Prediction',
          'Weekly Prediction': 'Weekly Prediction',
          'Yearly Prediction': 'Yearly Prediction',
          'Notifications': 'Notifications',
          'There are no Consultation updates.':
              'There are no Consultation updates.',
          'There are no recent general updates from your astrological guidance':
              'There are no recent general updates from your astrological guidance',
          //support
          'Got a question?\nOur support team is here to guide your path':
              'Got a question?\nOur support team is here to guide your path',
          'Enter feedback or query here...': 'Enter feedback or query here...',
          'Submit': 'Submit',
          //FAQs
          'Find answers to common questions\nabout our astrology services.':
              'Find answers to common questions\nabout our astrology services.',
          'Still have questions?': 'Still have questions?',
          'Contact Support': 'Contact Support',
          'search_help': 'search_help',
          //panchang
          PlatformTextConfig.panchangPageTitle: 'Personalized Panchang',
          'WeekDay': 'WeekDay',
          'Thithi': 'Thithi',
          'Karna': 'Karna',
          'Yoga': 'Yoga',
          'Sunrise': 'Sunrise',
          'Sunset': 'Sunset',
          'Rahu Kalam': 'Rahu Kalam',
          'Yama Kanda': 'Yama Kanda',
          'Auspicious Time': 'Auspicious Time',
          'Paksha': 'Paksha',
          'Amirthathi Yoga': 'Amirthathi Yoga',
          'COMING SOON': 'COMING SOON',
          "panchang_single_format": "(name) upto (time) (next)",
          'otp_response': "(title) Verification\n(message)",
          //Horoscope
          PlatformTextConfig.horoscope: 'Horoscope',
          'Name': 'Name',
          'Place': 'Place',
          'Lagna': 'Lagna',
          'South Indian Chart': 'South Indian Chart',
          'North Indian Chart': 'North Indian Chart',
          //weekly predictions
          "Hope you're having a wonderful start to your day.":
              "Hope you're having a wonderful start to your day.",
          "Good morning,": 'Good morning,',
          'Sunday': 'Sunday',
          'Monday': 'Monday',
          'Tuesday': 'Tuesday',
          'Wednesday': 'Wednesday',
          'Thursday': 'Thursday',
          'Friday': 'Friday',
          'Saturday': 'Saturday',
          'Chandrashtama': 'Chandrashtama',
          'Predictions are based on birth details in your profile section':
              'Predictions are based on birth details in your profile section',
          //yearly prediction
          'Planetary Transits': 'Planetary Transits',
          'Categorized Predictions': 'Categorized Predictions',
          'Jupiter': 'Jupiter',
          'Saturn': 'Saturn',
          'Rahu': 'Rahu',
          'Ketu': 'Ketu',
          'Current_Dasa': 'Current_Dasa',
          'Career Overview': 'Career Overview',
          'Finance Overview': 'Finance Overview',
          'Health Overview': 'Health Overview',
          'Marriage/Relationship Overview': 'Marriage/Relationship Overview',
          'Remedies': 'Remedies',
          'Chanting': 'Chanting',
          'Puja': 'Puja',
          'Charity': 'Charity',
          'Regenerate': 'Regenerate',
          'Consult Astrologer': 'Consult Astrologer',
          'Astrology Consultation': 'Astrology Consultation',
          'First Half of': 'First Half of',
          'Second Half of': 'Second Half of',
          //Life predictions
          PlatformTextConfig.lifeTitle: 'Life Predictions',
          'General\nCharacteristics': 'General\nCharacteristics',
          'Career\nPredictions': 'Career\nPredictions',
          'Relationship\nPredictions': 'Relationship\nPredictions',
          'Wealth\nPredictions': 'Wealth\nPredictions',
          'Health\nPredictions': 'Health\nPredictions',
          'Current\nTime Period': 'Current\nTime Period',
          //Daily Predictions
          'Upgrade to receive daily predictions at 6 AM':
              'Upgrade to receive daily predictions at 6 AM',
          'Your daily predictions was scheduled for 6 AM':
              'Your daily predictions was scheduled for 6 AM',
          'Career': 'Career',
          'Relationship': 'Relationship',
          'Wealth': 'Wealth',
          'Health': 'Health',
          //Marriage Match Making
          'Marriage Match Making': 'Marriage Match Making',
          'Boy Name': 'Boy Name',
          'Girl Name': 'Girl Name',
          'Total Compatibility Score': 'Total Compatibility Score',
          'Kuta': 'Kuta',
          'Gained': 'Gained',
          'Max': 'Max',
          'Present': 'Present',
          'Absent': 'Absent',
          'Expert Connect': 'Expert Connect',
          'Check astrological compatibility for a perfect match':
              'Check astrological compatibility for a perfect match',
          'Boy Details': 'Boy Details',
          'Girl Details': 'Girl Details',
          'Calculate Match': 'Calculate Match',
          'Enter boy\'s name': 'Enter boy\'s name',
          'Enter girl\'s name': 'Enter girl\'s name',
          //Subscriptions
          'Subscription': 'Subscription',
          'Auto Schedule Daily Predictions': 'Auto Schedule Daily Predictions',
          'Auto Schedule Weekly Predictions':
              'Auto Schedule Weekly Predictions',
          'Book Consultations': 'Book Consultations',
          'Basic Horoscope Chart': 'Basic Horoscope Chart',
          'Edit Horoscope Details': 'Edit Horoscope Details',
          'Unlimited Number Of Chat Per Week':
              'Unlimited Number Of Chat Per Week',
          'Download Chat History': 'Download Chat History',
          'Pick Chat Avatar': 'Pick Chat Avatar',
          'Pick Chat Style': 'Pick Chat Style',
          'Life Predictions': 'Life Predictions',
          'Yearly Predictions': 'Yearly Predictions',
          'Personalized Panchang': 'Personalized Panchang',
          'Continue': 'Continue',
          'Payment Summary': 'Payment Summary',
          'Pay Now': 'Pay Now',
          'Plan Cost': 'Plan Cost',
          'Discount': 'Discount',
          'Total Cost': 'Total Cost',
          'Payment Successful': 'Payment Successful',
          'Try Premium Plan': 'Try Premium Plans',
          '1 month': '1 month',
          'month': 'month',
          'months': 'months',
          'year': 'year',
          'Compare the plans': 'Compare the plans',
          'Welcome to\nTeksage!': 'Welcome to\nTeksage!',
          'Your 24/7 Personal Astrologer is here\n—now at just':
              'Your 24/7 Personal Astrologer is here\n—now at just',
          'per month': 'per month',
          'Unlock premium features': 'Unlock premium features',
          'Unlimited AI voice chat in your own language':
              'Unlimited AI voice chat in your own language',
          'Yearly insights & life predictions':
              'Yearly insights & life predictions',
          'Personalised Panchang for your horoscope':
              'Personalised Panchang for your horoscope',
          'Upgrade Plan': 'Upgrade Plan',
          'Skip': 'Skip',
          'Your Current Plan': 'Your Current Plan',
          'days left': 'days left',
          'Recommended': 'Recommended',
          'membership': 'membership',
          //Dialog box
          'Plan Expired': 'Plan Expired',
          'Premium Feature': 'Premium Feature',
          'Unlock all features by choosing a plan':
              'Unlock all features by choosing a plan',
          'Purchase Plan': 'Purchase Plan',
          'Plan': 'Plan',
          'Slots Selected': 'Slots Selected',
          'Selected slots will be lost if you change the date. Would you like to save them first?':
              'Selected slots will be lost if you change the date. Would you like to save them first?',
          'Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!':
              'Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!',
          'Rate Now': 'Rate Now',
          'Allow Location Access': 'Allow Location Access',
          'We need your location to get prices in your local currency (INR, USD, etc.)':
              'We need your location to get prices in your local currency (INR, USD, etc.)',
          'Allow': 'Allow',
          'Not Allow': 'Not Allow',
          'Go to Settings': 'Go to Settings',
          'Are you sure you want to logout?':
              'Are you sure you want to logout?',
          'Discard': 'Discard',
          'You have unsaved changes.\nDo you want to discard them and go back?':
              'You have unsaved changes.\nDo you want to discard them and go back?',
          //Error Validate
          'Please Enter the First Name': 'Please Enter the First Name',
          'Please Enter the Second Name': 'Please Enter the Second Name',
          'Please enter a valid Email': 'Please enter a valid Email',
          'Please verify your Email': 'Please verify your Email',
          'Enter a valid Email': 'Enter a valid Email',
          'Select country code': 'Select country code',
          'Enter valid (mobileLengthLimit)-digit number':
              'Enter valid (mobileLengthLimit)-digit number',
          'cannot be empty': 'cannot be empty',
          'Please enter the AI Chat Language':
              'Please enter the AI Chat Language',
          'Please enter the Date of birth': 'Please enter the Date of birth',
          'Please enter the Time of birth': 'Please enter the Time of birth',
          'Please enter the Place of birth': 'Please enter the Place of birth',
          'Please select one value': 'Please select one value',
          'Please fill all the required fields':
              'Please fill all the required fields',
          'Please Enter the valid Mobile Number':
              'Please Enter the valid Mobile Number',
          'Choose a preferred language to continue':
              'Choose a preferred language to continue',
          '*This slot is already booked!': '*This slot is already booked!',
          '* Choose a preferred timing': '* Choose a preferred timing',
          'Kindly select one or more categories':
              'Kindly select one or more categories',
          'Error loading questions': 'Error loading questions',
          'No questions found': 'No questions found',
          "Please enter Boy's name": "Please enter Boy's name",
          "Please select Boy's Nakshatram": "Please select Boy's Nakshatram",
          "Please select Girl's Nakshatram": "Please select Girl's Nakshatram",
          "Please enter Girl's name": "Please enter Girl's name",
          "Please select Girl's Rasi": "Please select Girl's Rasi",
          "Please select Boy's Rasi": "Please select Boy's Rasi",
          'Second language must be different from first':
              'Second language must be different from first',
          //Snack bar
          'Permission permanently denied. Please enable it in settings.':
              'Permission permanently denied. Please enable it in settings.',
          'Permission Denied': 'Permission Denied',
          'Payment verification failed. Please try again.':
              'Payment verification failed. Please try again.',
          'Payment failed. Please try again.':
              'Payment failed. Please try again.',
          'Please Contact Support team!': 'Please Contact Support team!',
          'Payment Error, Contact Support team!.':
              'Payment Error, Contact Support team!.',
          'Payment successful!': 'Payment successful!',
          'Please enable location permission to access this feature.':
              'Please enable location permission to access this feature.',
          'Select valid country code and number':
              'Select valid country code and number',
          'Please contact Teksage Admin': 'Please contact Teksage Admin',
          'Error in Fetching Country code': 'Error in Fetching Country code',
          'Please select a country code first':
              'Please select a country code first',
          'Failed to fetch country list': 'Failed to fetch country list',
          'Please select the first language first':
              'Please select the first language first',
          'Failed to save Questions': 'Failed to save Questions',
          'Error creating slots, Please try again.':
              'Error creating slots, Please try again.',
          'Slot Updated Successfully.': 'Slot Updated Successfully.',
          'At least one category must be selected.':
              'At least one category must be selected.',
          'At least one language must be selected.':
              'At least one language must be selected.',
          'We couldn’t fetch your horoscope. Please try again.':
              'We couldn’t fetch your horoscope. Please try again.',
          'Failed to fetch data. Please try again.':
              'Failed to fetch data. Please try again.',
          'Failed to update notification status':
              'Failed to update notification status',
          'Please try again after sometime': 'Please try again after sometime',
          'All Notification has been cleared':
              'All Notification has been cleared',
          'Please enable location access to view relevant subscription plans':
              'Please enable location access to view relevant subscription plans',
          'Failed to regenerate prediction. Please try again.':
              'Failed to regenerate prediction. Please try again',
          'An error occurred while regenerating. Please try again.':
              'An error occurred while regenerating. Please try again.',
          'Prediction regenerated successfully':
              'Prediction regenerated successfully',
          'Please enter a valid OTP': 'Please enter a valid OTP',
          'Choose your Style, Avatar and Language to begin your cosmic journey.':
              'Choose your Style, Avatar and Language to begin your cosmic journey.',
          'Select a Style and Avatar to begin your cosmic journey.':
              'Select a Style and Avatar to begin your cosmic journey.',
          'Select a Style for your answer’s flow.':
              'Select a Style for your answer’s flow.',
          'Select an Avatar that reflects your spirit.':
              'Select an Avatar that reflects your spirit.',
          'Select a Language for your answer’s flow.':
              'Select a Language for your answer’s flow.',
          'Keep it short and cosmic — max 300 characters':
              'Keep it short and cosmic — max 300 characters',
          'You can answer only after completing the consultation.':
              'You can answer only after completing the consultation.',
          'Timeout. Please retry.': 'Timeout. Please retry.',
          'Kindly enter your question.': 'Kindly enter your question.',
          'Your subscription has expired. Subscribe to continue.':
              'Your subscription has expired. Subscribe to continue.',
          'You’ve reached your message limit. Subscribe to continue.':
              'You’ve reached your message limit. Subscribe to continue.',
          'Retry response timed out.': 'Retry response timed out',
          'Response is taking longer than expected. Please check your network.':
              'Response is taking longer than expected. Please check your network.',
          'Thanks for reaching out! Your query has been received — our team will respond shortly.':
              'Thanks for reaching out! Your query has been received — our team will respond shortly.',
          'Something went wrong. Please try again.':
              'Something went wrong. Please try again.',
          'Logout failed. Please try again.':
              'Logout failed. Please try again.',
          'Thanks for using Teksage': 'Thanks for using Teksage',
          'Your message looks empty after removing hidden characters. Try typing or paste plain text.':
              'Your message looks empty after removing hidden characters. Try typing or paste plain text.',
          'Error in sending OTP': 'Error in sending OTP',
          'Network error. Please check your connection and try again.':'Network error. Please check your connection and try again.',
          'OTP Verified':'OTP Verified',
          //Astrology consultations
          'What do you\nneed guidance on?': 'What do you\nneed guidance on?',
          'Select the categories and continue':
              'Select the categories and continue',
          'Marriage & relationships': 'Marriage & relationships',
          'Marriage & Relationships': 'Marriage & Relationships',
          'All': 'All',
          'Choose your\npreferred language': 'Choose your\npreferred language',
          'This will help us to match the best astrologer':
              'This will help us to match the best astrologer',
          'First Preference': 'First Preference',
          'Second Preference': 'Second Preference',
          'Select language': 'Select language',
          'Top 5 astrologers\nbased on preferences':
              'Top 5 astrologers\nbased on preferences',
          'Expert Profile': 'Expert Profile',
          'Reviews': 'Reviews',
          'No reviews available': 'No reviews available',
          'Book Consultation': 'Book Consultation',
          'No slots available': 'No slots available',
          'Find & Consult Astrologers': 'Find & Consult Astrologers',
          '100+ Astrologers': '100+ Astrologers',
          'Explore and find your perfect match':
              'Explore and find your perfect match',
          'Upcoming': 'Upcoming',
          'Completed': 'Completed',
          'View Details': 'View Details',
          'View\nDetails': 'View\nDetails',
          'Meeting Link': 'Meeting Link',
          'Choose your avatar': 'Choose your avatar',
          'Choose how AI replies': 'Choose how AI replies',
          'Concise': 'Concise',
          'Book Now': 'Book Now',
          'Booking Details': 'Booking Details',
          'Consultation Fee': 'Consultation Fee',
          'Total Fee': 'Total Fee',
          'Confirm & Proceed to Pay': 'Confirm & Proceed to Pay',
          'Consultation Details': 'Consultation Details',
          'Consulting On': 'Consulting On',
          'Give Rating': 'Give Rating',
          'Ratings': 'Ratings',
          'You have no upcoming meetings at the moment.':
              'You have no upcoming meetings at the moment.',
          'You have no completed meetings at the moment.':
              'You have no completed meetings at the moment.',
          'Yes': 'Yes',
          'No': 'No',
          'Queries you asked': 'Queries you asked',
          'Enter Promo Code': 'Enter Promo Code',
          'Applied': 'Applied',
          'Apply': 'Apply',
          'I consent to share my personal information & horoscope with the astrologer':
              'I consent to share my personal information & horoscope with the astrologer',
          'I consent to share my personal information & star chart with the advisor':
              'I consent to share my personal information & star chart with the advisor',
          'Kindly select your preferred language':
              'Kindly select your preferred language',
          'Write your consultation query here':
              'Write your consultation query here',
          'Enter your question here...': 'Enter your question here...',
          'Next': 'Next',
          'Previous': 'Previous',
          '* All questions are required to help us serve you better.':
              '* All questions are required to help us serve you better.',
          'Slots': 'Slots',
          '30 mins each': '30 mins each',
          'Astrologer submitted answers for your queries':
              'Astrologer submitted answers for your queries',
          'Meet Again': 'Meet Again',
          'Rate your experience with this astrologer appointment':
              'Rate your experience with this astrologer appointment',
          'Save & Submit': 'Save & Submit',
          'Type your answer here...': 'Type your answer here...',
          'Done': 'Done',
          'booked a slot on': 'booked a slot on',
          "meeting_with": "Meeting with {name}",
          //Voice chat
          'Jyotish voice guide for all your needs. Start you conversation today':
              'Jyotish voice guide for all your needs. Start you conversation today',
          'Jyotish voice guide for all your needs':
              'Jyotish voice guide for all your needs',
          'The Seeker': 'The Seeker',
          'The Luminary': 'The Luminary',
          'The Guardian': 'The Guardia',
          'The Pathfinder': 'The Pathfinder',
          'Ideal for those who want in-depth astrological analysis and clear reasoning':
              'Ideal for those who want in-depth astrological analysis and clear reasoning',
          'Ideal for those who seek joyful and engaging astrology guidance':
              'Ideal for those who seek joyful and engaging astrology guidance',
          'Ideal for those looking for reassurance and personal connection in predictions':
              'Ideal for those looking for reassurance and personal connection in predictions',
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions':
              'Ideal for those seeking career growth, success strategies, or clear-cut solutions',
          'Tap the mic': 'Tap the mic',
          'Start speaking in your own language':
              'Start speaking in your own language',
          'Chat or record your thoughts...': 'Chat or record your thoughts...',
          'AI can understand all languages': 'AI can understand all languages',
          'Got it, typing that up for you…': 'Got it, typing that up for you…',
          'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology.':
              'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology',
          'Generate Yearly Prediction': 'Generate Yearly Prediction',
          'Generate Life Prediction': 'Generate Life Prediction',
          'Quick, direct replies without extra details — ideal for instant answers.':
              'Quick, direct replies without extra details — ideal for instant answers.',
          'Explanatory': 'Explanatory',
          'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.':
              'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.',
          'Choose an avatar for AI': 'Choose an avatar for AI',
          'Related questions': 'Related questions',
          'No response.': 'No response.',
          'Retry': 'Retry',
          'Subscribe Now': 'Subscribe Now',
          //Delete Account
          'We value your experience.\nWhat made you decide to leave?':
              'We value your experience.\nWhat made you decide to leave?',
          'I am having another account': 'I am having another account',
          'App not working properly': 'App not working properly',
          'I don’t like the app': 'I don’t like the app',
          'I am worried about my privacy': 'I am worried about my privacy',
          'You are about to delete\nyour account':
              'You are about to delete\nyour account',
          'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days':
              'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days',
          'Delete Account Now': 'Delete Account Now',
          'No, I have changed my mind': 'No, I have changed my mind',
          //Astrologer
          'You logged in as Astrologer': 'You logged in as Astrologer',
          'Meetings': 'Meetings',
          'View your scheduled appointments & completed ones':
              'View your scheduled appointments & completed ones',
          'My Availability': 'My Availability',
          'Set your available time slots.': 'Set your available time slots.',
          'Select the slots that you are available':
              'Select the slots that you are available',
          'Showing the available time that you picked':
              'Showing the available time that you picked',
          'Morning': 'Morning',
          'Afternoon': 'Afternoon',
          'Horoscope Details': 'Horoscope Details',
          'Horoscope details are not available':
              'Horoscope details are not available',
          'Answer': 'Answer',
          'View': 'View',
          "Queries asked - Time to share your thoughts!":
              "Queries asked - Time to share your thoughts!",
          "Queries asked - You’ve already shared your thoughts!":
              "Queries asked - You’ve already shared your thoughts!",
          'Date': 'Date',
          'Time': 'Time',
          'Fees Paid': 'Fees Paid',
          'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.':
              'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.',
          'Tamil': 'தமிழ்',
          'English': 'English',
          'Telugu': 'తెలుగు',
          'Malayalam': 'മലയാളം',
          'Kannada': 'ಕನ್ನಡ',
          'Hindi': 'हिन्दी',
          'Bengali': 'বাংলা',
          'Marathi': 'मराठी',
          'Urdu': 'اردو',
          'Gujarati': 'ગુજરાતી',
          'Odia': 'ଓଡ଼ିଆ',
          'Punjabi': 'ਪੰਜਾਬੀ',
          'Assamese': 'অসমীয়া',
          'Bhojpuri': 'भोजपुरी',
          'Kashmiri': 'کٲشُر',
          'Nepali': 'नेपाली',
          'Sindhi': 'سنڌي',
          'Sinhala': 'සිංහල',
          'Maithili': 'मैथिली',
          'Manipuri': 'মৈতৈলোন্',
          'Santali': 'ᱥᱟᱱᱛᱟᱲᱤ',
          'Years of Experience': 'Years of Experience',
          'years': 'years',
          'Showing Availability': 'Showing Availability',
          //OTP Screen
          "resend_otp_in_seconds": "Resend OTP in {seconds} sec",
          'Enter Mobile Number': 'Enter Mobile Number',
          'Enter Email': 'Enter Email',
          'Enter your new email and verify it using OTP':
              'Enter your new email and verify it using OTP',
          'Enter your new phone number and verify it using OTP':
              'Enter your new phone number and verify it using OTP',
          'Verify Email': 'Verify Email',
          'Verify Phone Number': 'Verify Phone Number',
          'Verify Existing Phone Number': 'Verify Existing Phone Number',
          'Verify Existing Email': 'Verify Existing Email',
          'For security reasons, kindly verify your existing phone number':
              'For security reasons, kindly verify your phone number',
          'For security reasons, kindly verify your existing email':
              'For security reasons, kindly verify your email',
          'We have sent OTP to': 'We have sent OTP to',
          'OTP is valid for 5 Minutes.': 'OTP is valid for 5 Minutes.',
          'Resend OTP': 'Resend OTP',
          //Internet
          'No Internet Connection': 'No Internet Connection',
          'Please check your\nnetwork settings':
              'Please check your\nnetwork settings',
        },
        'ta': {
          'Good day': 'வணக்கம்',
          'Astrologer': 'ஜோதிடர் ',
          'Home': 'முகப்பு',
          'Panchang': 'பஞ்சாங்கம்',
          'Horoscope': 'ஜாதகம்',
          'Settings': 'அமைப்புகள்',
          'Marriage\nMatch Making': 'திருமண\nபொருத்தம்',
          'Explore Other Predictions': 'பிற கணிப்புகள் ',
          PlatformTextConfig.yearlyPrediction: 'வருட\nபலன்கள்',
          PlatformTextConfig.weeklyPrediction: 'வார\nபலன்கள்',
          PlatformTextConfig.lifePrediction: 'வாழ்க்கை\nபலன்கள்',
          PlatformTextConfig.dailyPrediction: 'தின\nபலன்கள்',
          PlatformTextConfig.chatHomePage: 'AI - யுடன்\nவாய்ஸ் சாட் செய்ய',
          'ChatTitle': 'AI குரல் அரட்டை',
          // PlatformTextConfig.chatTitle: 'AI வாய்ஸ் சாட்',
          'Chat Now': 'அரட்டை',
          'Thara Bala': 'தாரா பலம்',
          'Chandra Bala': 'சந்திர பலம்',
          'Astrologer\nConsultation': 'ஜோதிடர்\nஆலோசனை',
          'Astrologer Consultation': 'ஜோதிடர் ஆலோசனை',
          'My Profile': 'எனது சுயவிவரம்',
          //settings
          'Profile': 'சுயவிவரம்',
          'Push Notifications': 'அறிவிப்புகள்',
          'Language': 'மொழி',
          'Subscriptions': 'சந்தாக்கள்',
          'Terms & Conditions': 'பயன்பாட்டு விதிகள்',
          'Privacy Policy': 'தனியுரிமைக் கொள்கை',
          'Support': 'ஆதரவு',
          'FAQs': 'பொதுக் கேள்விகள்',
          'Rate us': 'எங்களை மதிப்பிடுங்கள்',
          'Rate': 'மதிப்பிடு',
          'Delete Account': 'கணக்கை நீக்கு',
          'Logout': 'வெளியேறு',
          'Language Updated': 'மொழி மாற்றப்பட்டது',
          'App language has been changed successfully':
              'பயன்பாட்டின் மொழி வெற்றிகரமாக மாற்றப்பட்டது.',
               'Click to view':'பார்க்க கிளிக் செய்யவும்',
          //Profile
          'First Name': 'பெயர் (முதல் பகுதி)',
          'Last Name': 'பெயர் (பிற்பகுதி)',
          'Email': 'மின்னஞ்சல்',
          'Phone Number': 'கைபேசி எண்',
          'AI Chat Language': 'AI chat மொழி',
          'Date of Birth': 'பிறந்த தேதி',
          'Time of Birth': 'பிறந்த நேரம்',
          'Place of Birth': 'பிறந்த இடம்',
          'Current Location': 'தற்போது வசிக்கும் இடம்',
          'Rasi': 'இராசி',
          'Nakshatram': 'நட்சத்திரம்',
          'Edit': 'திருத்து',
          'Profile Details': 'சுயவிவரம்',
          'Complete Profile': 'முழு சுயவிவரம்',
          'Save': 'சேமி',
          'Hi (name)!': 'வணக்கம் (name)!',
          'Verify': 'சரிபார்க்க',
          'Change': 'மாற்று',
          'Enter place of birth': 'பிறந்த இடத்தைப் உள்ளிடவும்',
          'Enter Current location': 'தற்போதைய இருப்பிடத்தை உள்ளிடவும்',
          'Select a place': 'ஒரு இடத்தைத் தேர்ந்தெடுக்கவும்',
          'Select any one Option':
              'ஏதேனும் ஒரு விருப்பத்தைத் தேர்ந்தெடுக்கவும்',
          'How did you first hear about Teksage?':
              'Teksage பற்றி நீங்கள் முதன்முதலில் எப்படித்\nதெரிந்துகொண்டீர்கள்?',
          'How did you first hear about Teksage':
              'Teksage பற்றி நீங்கள் முதன்முதலில் எப்படித்\nதெரிந்துகொண்டீர்கள்',
          'Select a language': 'ஒரு மொழியைத் தேர்ந்தெடுக்கவும்',
          "Google Play Store / App Store": "Google Play Store / App Store",
          "Google Search": "Google தேடல்",
          "Quora": "Quora",
          "Facebook / Instagram": "Facebook / Instagram",
          "YouTube": "YouTube",
          "WhatsApp / Telegram (friends or groups)": "WhatsApp / Telegram",
          "Word of mouth (friends/family)":
              "வாய்மொழி பரிந்துரை (நண்பர்கள் / குடும்பம்)",
          "Product Hunt": "Product Hunt மூலம் கண்டறியப்பட்டது",
          "Other": "மற்றவை",
          //Push Notification
          'Push Notification': 'அறிவிப்பு',
          PlatformTextConfig.dailyTitle: 'தின பலன்கள்',
          PlatformTextConfig.weeklyTitle: 'வார பலன்கள்',
          PlatformTextConfig.yearlyTitle: 'வருட பலன்கள்',
          PlatformTextConfig.lifePredictionLanding: 'வாழ்க்கை பலன்',
          'Promotions & Offers': 'விளம்பரம் & சலுகைகள்',
          'Warnings': 'எச்சரிக்கைகள்',
          'Consultation': 'ஆலோசனை',
          'General': 'பொதுவான',
          'Astrologer appointment on': 'ஜோதிடர் சந்திப்பு தேதி',
          'You have an appointment on': 'உங்களுக்கு\nஒரு சந்திப்பு உள்ளது',
          'Your Daily Prediction have been generated':
              'உங்கள் தினசரி கணிப்பு உருவாக்கப்பட்டுள்ளது',
          'Your Weekly Prediction have been generated':
              'உங்கள் வார கணிப்பு உருவாக்கப்பட்டுள்ளது',
          'Your Yearly Prediction have been generated':
              'உங்கள் வருட கணிப்பு உருவாக்கப்பட்டுள்ளது',
          'Clear All': 'அனைத்தையும்\nஅழிக்கவும்',
          'Daily Prediction': 'தின பலன்கள்',
          'Weekly Prediction': 'வார பலன்கள்',
          'Yearly Prediction': 'வருட பலன்கள்',
          'Notifications': 'அறிவிப்புகள்',
          'There are no Consultation updates.':
              'ஆலோசனை தொடர்பான புதிய தகவல்கள் எதுவும் இல்லை.',
          'There are no recent general updates from your astrological guidance':
              'உங்கள் ஜோதிட வழிகாட்டுதலிலிருந்து சமீபத்திய பொதுவான புதுப்பிப்புகள் எதுவும் இல்லை.',
          //support
          'Got a question?\nOur support team is here to guide your path':
              'கேள்விகள் உள்ளதா?\nஉங்களை வழிநடத்த எங்கள் குழுவினர் உள்ளனர்',
          'Enter feedback or query here...': 'உங்கள் கேள்வியை இங்கே உள்ளிடவும்',
          'Submit': 'சமர்ப்பிக்க',
          //FAQs
          'Find answers to common questions\nabout our astrology services.':
              'எங்கள் ஜோதிட சேவைகள் பற்றிய பொதுவான கேள்விகளுக்கான\nபதில்களைக் கண்டறியவும்.',
          'Still have questions?': 'இன்னும் கேள்விகள் உள்ளதா?',
          'Contact Support': 'எங்கள் support டீம்-ஐ தொடர்பு கொள்ளவும்',
          'search_help': 'தேடல் உதவி',
          //panchang
          'WeekDay': 'கிழமை',
          'Thithi': 'திதி',
          'Karna': 'கரணம்',
          'Yoga': 'யோகம்',
          'Sunrise': 'சூர்யோதயம்',
          'Sunset': 'சூர்யாஸ்தமனம்',
          'Rahu Kalam': 'ராகு காலம்',
          'Yama Kanda': 'எம கண்டம்',
          'Auspicious Time': 'நல்ல நேரம்',
          'Paksha': 'பக்ஷம்',
          'Amirthathi Yoga': 'அமிர்தாதி யோகம்',
          'COMING SOON': 'விரைவில் வருகிறது',
          "panchang_single_format": "(name) (time) வரை (next)",
          'otp_response': "(title) சரிபார்ப்பு\nOTP வெற்றிகரமாக அனுப்பப்பட்டது",
          //Horoscope
          PlatformTextConfig.horoscope: 'ஜாதகம்',
          'Name': 'பெயர்',
          'Place': 'இடம்',
          'Lagna': 'லக்னம்',
          'South Indian Chart': 'தென்னிந்திய ஜாதகம்',
          'North Indian Chart': 'வட இந்திய ஜாதகம்',
          //weekly predictions
          "Hope you're having a wonderful start to your day.":
              "உங்கள் நாளை அற்புதமாகத் தொடங்குவீர்கள் என்று நம்புகிறேன்.",
          'Good morning,': 'காலை வணக்கம்,',
          'Sunday': 'ஞாயிறு',
          'Monday': 'திங்கள்',
          'Tuesday': 'செவ்வாய்',
          'Wednesday': 'புதன்',
          'Thursday': 'வியாழன்',
          'Friday': 'வெள்ளி',
          'Saturday': 'சனி',
          'Chandrashtama': 'சந்திராஷ்டமம்',
          'Predictions are based on birth details in your profile section':
              'இந்த கணிப்புகள், உங்கள் profile-ல் உள்ள பிறப்பு விவரங்களை அடிப்படையாகக் கொண்டு உருவாக்கப்பட்டுள்ளது.',
          //yearly prediction
          'Planetary Transits': 'கிரக கோச்சாரம்',
          'Categorized Predictions': 'வகைப்படுத்தப்பட்ட\nகணிப்புகள்',
          'Jupiter': 'குரு',
          'Saturn': 'சனி',
          'Rahu': 'ராகு',
          'Ketu': 'கேது ',
          'Current_Dasa': 'நடப்பு திசை',
          'Career Overview': 'தொழில் கண்ணோட்டம்',
          'Finance Overview': 'நிதி கண்ணோட்டம்',
          'Health Overview': 'ஆரோக்கியம்',
          'Marriage/Relationship Overview': 'திருமணம்/உறவு கண்ணோட்டம்',
          'Remedies': 'பரிகாரங்கள்',
          'Chanting': 'மந்திரங்கள்',
          'Puja': 'பூஜை',
          'Charity': 'தொண்டு',
          'Regenerate': 'திரும்ப கணிப்புகளை உருவாக்கு',
          'Consult Astrologer': 'ஜோதிடர்\nஆலோசனை',
          'Astrology Consultation': 'ஜோதிட ஆலோசனை',
          'First Half of': 'முதல் பாதி',
          'Second Half of': 'இரண்டாம் பாதி',
          //Life predictions
          PlatformTextConfig.lifeTitle: 'வாழ்க்கை பலன்கள்',
          'General\nCharacteristics': 'பொதுவான\nபண்புகள்   ',
          'Career\nPredictions': 'தொழில்\nகணிப்புகள்',
          'Relationship\nPredictions': 'உறவு\nகணிப்புகள்',
          'Wealth\nPredictions': 'செல்வ\nகணிப்புகள்',
          'Health\nPredictions': 'ஆரோக்கிய\nகணிப்புகள்',
          'Current\nTime Period': 'தற்போதைய\nகாலகட்டம்',
          //Daily Predictions
          'Upgrade to receive daily predictions at 6 AM':
              'தினசரி கணிப்புகளை காலை 6 மணிக்குப் பெற upgrade செய்யவும் ',
          'Your daily predictions was scheduled for 6 AM':
              'உங்கள் தினசரி கணிப்புகள் காலை 6 மணிக்கு வந்தடையும்',
          'Career': 'தொழில்',
          'Relationship': 'உறவுகள்',
          'Wealth': 'செல்வம்',
          'Health': 'ஆரோக்கியம்',
          //Marriage Match Making
          'Marriage Match Making': 'திருமண பொருத்தம்',
          'Boy Name': 'ஆண் பெயர்',
          'Girl Name': 'பெண் பெயர்',
          'Total Compatibility Score': 'மொத்த பொருந்தக்கூடிய மதிப்பெண்',
          'Kuta': 'பொருத்தம்',
          'Gained': 'பெற்றது',
          'Max': 'அதிக\nபட்சம்',
          'Present': 'உள்ளது',
          'Absent': 'இல்லை',
          'Expert Connect': 'ஜோதிடர் ஆலோசனை',
          'Check astrological compatibility for a perfect match':
              'சரியான பொருத்தத்திற்கான ஜோதிடப் பொருத்தம்',
          'Boy Details': 'ஆண் விவரங்கள்',
          'Girl Details': 'பெண் விவரங்கள்',
          'Calculate Match': 'பொருத்தத்தைக் கணக்கிடு',
          'Enter boy\'s name': 'ஆணின் பெயர்',
          'Enter girl\'s name': 'பெண்ணின் பெயர்',

          //Subscriptions
          'Subscription': 'சந்தாக்கள்',
          'Auto Schedule Daily Predictions': 'தானியங்கு தினசரி கணிப்புகள்',
          'Auto Schedule Weekly Predictions': 'தானியங்கு வார கணிப்புகள்',
          'Book Consultations': 'ஜோதிடர் ஆலோசனை',
          'Basic Horoscope Chart': 'ஜாதக கட்டம்',
          'Edit Horoscope Details': 'ஜாதக விவரங்கள் திருத்த ',
          'Unlimited Number Of Chat Per Week': 'வரம்பற்ற AI வாய்ஸ் chat ',
          'Download Chat History': 'Chat History-ஐ பதிவிறக்கவும்',
          'Pick Chat Avatar': 'Chat அவதார் தேர்ந்தெடுக்க ',
          'Pick Chat Style': 'Chat ஸ்டைல் தேர்ந்தெடுக்க ',
          'Life Predictions': 'வாழ்க்கை பலன்கள்',
          'Yearly Predictions': 'வருட பலன்கள்',
          'Personalized Panchang': 'தனித்துவமான பஞ்சாங்கம்',
          'Continue': 'தொடரவும்',
          'Payment Summary': 'கட்டணச் சுருக்கம்',
          'Pay Now': 'பணம் செலுத்து ',
          'Plan Cost': 'திட்டச் செலவு',
          'Discount': 'தள்ளுபடி',
          'Total Cost': 'மொத்த செலவு',
          'Payment Successful': 'பணம் வெற்றிகரமாகப் பெறப்பட்டது',
          'Try Premium Plan': 'பிரீமியம் திட்டங்கள்',
          '1 month': '1 மாதம்',
          'month': 'மாதம்',
          'months': 'மாதங்கள்',
          'year': 'ஆண்டு',
          'Compare the plans': 'திட்டங்கள் ஒப்பீடு',
          'Welcome to\nTeksage!': 'Teksage-க்கு வருக!',
          'Your 24/7 Personal Astrologer is here\n—now at just':
              'உங்கள் 24/7 தனிப்பட்ட ஜோதிடர் இங்கே இருக்கிறார் - இப்போது வெறும்',
          'per month': 'மாதத்திற்கு',
          'Unlock premium features': 'பிரீமியம் அம்சங்களைத் திறக்கவும்',
          'Unlimited AI voice chat in your own language':
              'உங்கள் தாய்மொழியில் வரம்பற்ற AI குரல் அரட்டை',
          'Yearly insights & life predictions':
              'வருடாந்திர & வாழ்க்கை கணிப்புகள்',
          'Personalised Panchang for your horoscope':
              'உங்கள் ஜாதகத்திற்கு ஏற்றவாறு தனிப்பயனாக்கப்பட்ட பஞ்சாங்கம்',
          'Upgrade Plan': 'பிளான் upgrade செய் ',
          'Skip': 'தவிர்க்கவும்',
          'Your Current Plan': 'உங்கள்\nதற்போதைய\nPlan',
          'days left': 'மீதமுள்ள நாட்கள்',
          'Recommended': 'பரிந்துரைக்கப்படுகிறது',
          'membership': 'உறுப்பினர் நிலை',
          //Dialog box
          'Plan Expired': 'plan காலாவதி ஆகிவிட்டது',
          'Premium Feature': 'பிரீமியம் அம்சங்கள்',
          'Unlock all features by choosing a plan':
              'ஒரு திட்டத்தைத் தேர்ந்தெடுப்பதன் மூலம் அனைத்து அம்சங்களையும் பெறுங்கள்.',
          'Purchase Plan': 'திட்டத்தைத் பெறுங்கள்',
          'Plan': 'திட்டம்',
          'Slots Selected': 'Slots தேர்ந்தெடுக்கப்பட்டன',
          'Selected slots will be lost if you change the date. Would you like to save them first?':
              'தேதியை மாற்றினால் தேர்ந்தெடுக்கப்பட்ட இடங்கள் இழக்கப்படும். முதலில் அவற்றைச் சேமிக்க விரும்புகிறீர்களா?',
          'Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!':
              'உங்கள் நட்சத்திரங்கள் உங்களுக்கு வழிகாட்டுவதைப்போல, உங்கள் கருத்து எங்களுக்கு வழிகாட்டுகிறது ⭐\nஇன்றே Teksage-ஐ மதிப்பிடுங்கள்!',
          'Rate Now': 'மதிப்பிடவும்',
          'Allow Location Access': 'இருப்பிட தகவலை அனுமதிக்கவும்',
          'We need your location to get prices in your local currency (INR, USD, etc.)':
              'உங்கள் உள்ளூர் currency-ல் விலைகளைப் பெற, உங்கள் இருப்பிடம் எங்களுக்குத் தேவை.',
          'Allow': 'அனுமதி',
          'Not Allow': 'அனுமதிக்காதே',
          'Go to Settings': 'Settings செல்லவும்',
          'Are you sure you want to logout?':
              'நீங்கள் வெளியேற விரும்புகிறீர்கள் என்பதில் உறுதியாக இருக்கிறீர்களா?',
          'Discard': 'நிராகரிக்கவும்',
          'You have unsaved changes.\nDo you want to discard them and go back?':
              'நீங்கள் சேமிக்காத மாற்றங்கள் உள்ளன.\nஅவற்றை நிராகரித்துவிட்டுத் திரும்பிச் செல்ல விரும்புகிறீர்களா?',
          //Error Validate
          'Please Enter the First Name': 'பெயர் முதல் பகுதி உள்ளிடவும்',
          'Please Enter the Second Name': 'பெயர் பிற்பகுதி உள்ளிடவும்',
          'Please enter a valid Email':
              'தயவுசெய்து சரியான மின்னஞ்சலை உள்ளிடவும்.',
          'Please verify your Email': 'உங்கள் மின்னஞ்சலைச் சரிபார்க்கவும்.',
          'Enter a valid Email': 'சரியான மின்னஞ்சலை உள்ளிடவும்.',
          'Select country code': 'நாட்டின் குறியீட்டைத் தேர்ந்தெடுக்கவும்',
          'Enter valid (mobileLengthLimit)-digit number':
              'சரியான (mobileLengthLimit)-இலக்க எண்ணை உள்ளிடவும்',
          'cannot be empty': 'காலியாக உள்ளது ',
          'Please enter the AI Chat Language':
              'தயவுசெய்து AI Chat மொழியை உள்ளிடவும்.',
          'Please enter the Date of birth': 'பிறந்த தேதியை உள்ளிடவும்.',
          'Please enter the Time of birth': 'பிறந்த நேரத்தை உள்ளிடவும்.',
          'Please enter the Place of birth': 'பிறந்த இடத்தை உள்ளிடவும்.',
          'Please select one value': 'ஒரு மதிப்பைத் தேர்ந்தெடுக்கவும்.',
          'Please fill all the required fields':
              'கோரப்பட்ட அனைத்து விவரங்களையும் பதிவு செய்யவும்.',
          'Please Enter the valid Mobile Number':
              'தயவுசெய்து சரியான மொபைல் எண்ணை உள்ளிடவும்.',
          'Choose a preferred language to continue':
              'தொடர விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்.',
          '*This slot is already booked!':
              'இந்த slot ஏற்கனவே முன்பதிவு செய்யப்பட்டுள்ளது.',
          '* Choose a preferred timing':
              'உங்களுக்கு விருப்பமான நேரத்தைத் தேர்வுசெய்யவும்.',
          'Kindly select one or more categories':
              'ஒன்று அல்லது அதற்கு மேற்பட்ட category-யை தேர்ந்தெடுக்கவும்.',
          'Error loading questions': 'கேள்விகளை ஏற்றுவதில் பிழை ஏற்பட்டது',
          'No questions found': 'கேள்விகள் எதுவும் காணப்படவில்லை.',
          "Please enter Boy's name": 'தயவுசெய்து ஆணின் பெயரை உள்ளிடவும்',
          "Please select Boy's Nakshatram":
              'தயவுசெய்து ஆணின் நட்சத்திரத்தைத் தேர்ந்தெடுக்கவும்',
          "Please select Girl's Nakshatram":
              'தயவுசெய்து பெண்ணின் நட்சத்திரத்தைத் தேர்ந்தெடுக்கவும்.',
          "Please enter Girl's name": 'தயவுசெய்து பெண்ணின் பெயரை உள்ளிடவும்',
          "Please select Girl's Rasi":
              'தயவுசெய்து பெண்ணின் ராசியைத் தேர்ந்தெடுக்கவும்.',
          "Please select Boy's Rasi":
              'தயவுசெய்து ஆணின் ராசியைத் தேர்ந்தெடுக்கவும்.',
          'Second language must be different from first':
              'இரண்டாவது மொழி முதல் மொழியிலிருந்து வேறுபட்டதாக இருக்க வேண்டும்.',

          //Snack bar
          'Permission permanently denied. Please enable it in settings.':
              'அனுமதி நிரந்தரமாக மறுக்கப்பட்டுள்ளது. settings-ல் அதை enable செய்யவும். ',
          'Permission Denied': 'அனுமதி மறுக்கப்பட்டுள்ளது',
          'Payment verification failed. Please try again.':
              'கட்டணச் சரிபார்ப்பு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.',
          'Payment failed. Please try again.':
              'பணம் செலுத்த முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
          'Please Contact Support team!': 'Support குழுவைத் தொடர்பு கொள்ளவும்!',
          'Payment Error, Contact Support team!.':
              'கட்டணப் பிழை, Support குழுவைத் தொடர்பு கொள்ளவும்!.',
          'Payment successful!': 'பணம் செலுத்தப்பட்டது!',
          'Please enable location permission to access this feature.':
              'இந்த அம்சத்தை பயன்படுத்த இருப்பிட அனுமதியை enable செய்யவும்.',
          'Select valid country code and number':
              'சரியான நாட்டுக் குறியீடு மற்றும் எண்ணைத் தேர்ந்தெடுக்கவும்.',
          'Please contact Teksage Admin':
              'Teksage நிர்வாகியைத் தொடர்பு கொள்ளவும்.',
          'Error in Fetching Country code':
              'நாட்டின் குறியீட்டைப் பெறுவதில் பிழை ஏற்பட்டுள்ளது.',
          'Please select a country code first':
              'முதலில் நாட்டின் குறியீட்டைத் தேர்ந்தெடுக்கவும்.',
          'Failed to fetch country list': 'நாட்டின் list எடுக்க முடியவில்லை',
          'Please select the first language first':
              'முதலில் first language தேர்ந்தெடுக்கவும்.',
          'Failed to save Questions': 'கேள்விகளைச் சேமிக்க முடியவில்லை',
          'Error creating slots, Please try again.':
              'Slots உருவாக்குவதில் பிழை, மீண்டும் முயற்சிக்கவும்.',
          'Slot Updated Successfully.':
              'Slots வெற்றிகரமாக புதுப்பிக்கப்பட்டது.',
          'At least one category must be selected.':
              'குறைந்தது category-யைத் தேர்ந்தெடுக்க வேண்டும்.',
          'At least one language must be selected.':
              'குறைந்தது ஒரு மொழியையாவது தேர்ந்தெடுக்க வேண்டும்.',
          'We couldn’t fetch your horoscope. Please try again.':
              'உங்க ஜாதகத்தை எடுக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
          'Failed to fetch data. Please try again.':
              'தரவை மீட்டெடுக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
          'Failed to update notification status':
              'அறிவிப்பு நிலையைப் புதுப்பிக்க முடியவில்லை.',
          'Please try again after sometime':
              'சிறிது நேரம் கழித்து மீண்டும் முயற்சிக்கவும்.',
          'All Notification has been cleared':
              'அனைத்து அறிவிப்புகளும் நீக்கப்பட்டது',
          'Please enable location access to view relevant subscription plans':
              'தொடர்புடைய சந்தா திட்டங்களைக் காண இருப்பிட அனுமதியை enable செய்யவும்.',
          'Failed to regenerate prediction. Please try again.':
              'கணிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
          'An error occurred while regenerating. Please try again.':
              'பிழை ஏற்பட்டது. மீண்டும் முயற்சிக்கவும்.',
          'Prediction regenerated successfully':
              'கணிப்பு வெற்றிகரமாக மீண்டும் உருவாக்கப்பட்டது',
          'Please enter a valid OTP': 'தயவுசெய்து சரியான OTP-ஐ உள்ளிடவும்.',
          'Choose your Style, Avatar and Language to begin your cosmic journey.':
              'உங்கள் பயணத்தைத் தொடங்க உங்கள் chat பாணி, அவதாரம் மற்றும் மொழியைத் தேர்வுசெய்யவும்.',
          'Select a Style and Avatar to begin your cosmic journey.':
              'உங்கள் பயணத்தைத் தொடங்க ஒரு பாணியையும் அவதாரத்தையும் தேர்ந்தெடுக்கவும்.',
          'Select a Style for your answer’s flow.':
              'உங்கள் பதிலின் அமைப்பிற்கேற்ற பாணியைத் தேர்ந்தெடுக்கவும்.',
          'Select an Avatar that reflects your spirit.':
              'உங்கள் ஆன்மாவைப் பிரதிபலிக்கும் ஒரு அவதாரத்தைத் தேர்ந்தெடுக்கவும்.',
          'Select a Language for your answer’s flow.':
              'உங்கள் பதிலின் அமைப்பிற்கேற்ற மொழியைத் தேர்ந்தெடுக்கவும்.',
          'Keep it short and cosmic — max 300 characters':
              'சுருக்கமாக வைத்திருங்கள் - அதிகபட்சம் 300 எழுத்துகள்.',
          'You can answer only after completing the consultation.':
              'Consultation முடிந்த பின்னரே நீங்கள் பதிலளிக்க முடியும்.',
          'Timeout. Please retry.':
              'நேரம் முடிந்தது. தயவுசெய்து மீண்டும் முயற்சிக்கவும்',
          'Kindly enter your question.':
              'தயவுசெய்து உங்கள் கேள்வியை உள்ளிடவும்.',
          'Your subscription has expired. Subscribe to continue.':
              'உங்கள் சந்தா காலாவதியாகிவிட்டது. தொடர மீண்டும் சந்தாவை செலுத்துங்கள். ',
          'You’ve reached your message limit. Subscribe to continue.':
              'உங்கள் chat வரம்பை அடைந்துவிட்டீர்கள். தொடர சந்தாவை செலுத்துங்கள்',
          'Retry response timed out.':
              'பதில் நேரம் முடிந்தது. மீண்டும் முயற்சிக்கவும்',
          'Response is taking longer than expected. Please check your network.':
              'பதில் எதிர்பார்த்ததை விட அதிக நேரம் எடுக்கிறது. உங்கள் நெட்வொர்க்கைச் சரிபார்க்கவும்.',
          'Thanks for reaching out! Your query has been received — our team will respond shortly.':
              'தொடர்பு கொண்டதற்கு நன்றி! உங்கள் கேள்வி வந்தடைந்தது - எங்கள்  support குழு விரைவில் பதிலளிப்பார்கள்.',
          'Something went wrong. Please try again.':
              'ஏதோ தவறாகிவிட்டது. மீண்டும் முயற்சிக்கவும்.',
          'Logout failed. Please try again.':
              'வெளியேறுதல் தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.',
          'Thanks for using Teksage': 'Teksage-ஐ பயன்படுத்தியதற்கு நன்றி.',
          'Your message looks empty after removing hidden characters. Try typing or paste plain text.':
              'மறைக்கப்பட்ட எழுத்துக்களை நீக்கிய பிறகு உங்கள் செய்தி காலியாகத் தெரிகிறது. தட்டச்சு செய்யவோ அல்லது சாதாரண உரையை ஒட்டவோ முயற்சிக்கவும்.',
          'Error in sending OTP': 'OTP அனுப்புவதில் பிழை ஏற்பட்டது.',
          'Network error. Please check your connection and try again.':'இணையப் பிழை. உங்கள் இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.',
          'OTP Verified':'OTP சரிபார்க்கப்பட்டது',
          //Astrology consultations
          'What do you\nneed guidance on?':
              'உங்களுக்கு\nஎதில் வழிகாட்டுதல் தேவை?',
          'Select the categories and continue':
              'வகையைத் தேர்ந்தெடுத்து தொடரவும்.',
          'Marriage & relationships': 'திருமணம் & உறவுகள்',
          'Marriage & Relationships': 'திருமணம் & உறவுகள்',
          'All': 'அனைத்தும்',
          'Choose your\npreferred language':
              'உங்களுக்கு விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்.',
          'This will help us to match the best astrologer':
              'இது உங்களுக்கான சிறந்த ஜோதிடரைப் பரிந்துரைக்க உதவும்',
          'First Preference': 'முதல் விருப்பம்',
          'Second Preference': 'இரண்டாவது விருப்பம்',
          'Select language': 'மொழியைத்\nதேர்ந்தெடுக்கவும்',
          'Top 5 astrologers\nbased on preferences':
              'உங்கள் விருப்பங்களின் அடிப்படையில் நாங்கள் பரிந்துரைக்கும் 5 ஜோதிடர்கள் ',
          'Expert Profile': 'நிபுணர் சுயவிவரம்',
          'Reviews': 'மதிப்பாய்வு',
          'No reviews available': 'மதிப்பாய்வு இல்லை',
          'Book Consultation': 'ஆலோசனை முன்பதிவு ',
          'No slots available': 'Slots இல்லை.',
          'Find & Consult Astrologers':
              'ஜோதிடர்களைக் கண்டுபிடித்து\nஆலோசனை பெறுங்கள்',
          '100+ Astrologers': '100+ ஜோதிடர்கள்',
          'Explore and find your perfect match':
              'உங்கள் சரியான\nஜோதிடரை கண்டறியவும்',
          'Upcoming': 'வரவிருக்கும்',
          'Completed': 'நிறைவுப் பெற்ற',
          'View Details': 'விவரங்களைப்\nபார்க்கவும்',
          'View\nDetails': 'விவரங்களைப்\nபார்க்கவும்',
          'Meeting Link': 'meeting\nஇணைப்பு',
          'Choose your avatar': 'உங்கள் அவதாரத்தைத் தேர்வு செய்யவும்',
          'Choose how AI replies':
              'AI எவ்வாறு பதிலளிக்கவேண்டும் என்பதைத் தேர்வுசெய்யவும் ',
          'Concise': 'சுருக்கமான',
          'Book Now': 'முன்பதிவு\nசெய்யுங்கள்',
          'Booking Details': 'முன்பதிவு விவரங்கள்',
          'Consultation Fee': 'ஆலோசனை கட்டணம்',
          'Total Fee': 'மொத்த கட்டணம்',
          'Confirm & Proceed to Pay': 'உறுதிப்படுத்தி பணம் செலுத்தவும் ',
          'Consultation Details': 'ஆலோசனை விவரங்கள்',
          'Consulting On': 'ஆலோசனை வகை',
          'Give Rating': 'மதிப்பீடு கொடுங்கள்',
          'Ratings': 'மதிப்பீடுகள்',
          'You have no upcoming meetings at the moment.':
              'தற்போது உங்களுக்கு வரவிருக்கும் சந்திப்புகள் எதுவும் இல்லை.',
          'You have no completed meetings at the moment.':
              'தற்போது உங்களிடம் நிறைவடைந்த சந்திப்புகள் எதுவும் இல்லை.',
          'Yes': 'ஆம்',
          'No': 'இல்லை',
          'Queries you asked': 'நீங்கள் கேட்ட கேள்விகள்',
          'Enter Promo Code': 'Promo குறியீட்டை உள்ளிடவும்',
          'Applied': 'விண்ணப்பிக்கப்பட்டது',
          'Apply': 'Apply செய்',
          'I consent to share my personal information & horoscope with the astrologer':
              'எனது தனிப்பட்ட தகவல்களையும் ஜாதகத்தையும் ஜோதிடருடன் பகிர்ந்து கொள்ள ஒப்புக்கொள்கிறேன்',
          'I consent to share my personal information & star chart with the advisor':
              'எனது தனிப்பட்ட தகவல்களையும் நட்சத்திர அட்டவணையையும் ஆலோசகருடன் பகிர்ந்துகொள்ள நான் சம்மதிக்கிறேன்',
          'Kindly select your preferred language':
              'தயவுசெய்து உங்களுக்கு விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்',
          'Write your consultation query here':
              'உங்கள் ஆலோசனை கேள்வியை இங்கே எழுதுங்கள்',
          'Enter your question here...': 'உங்கள் கேள்வியை இங்கே உள்ளிடவும்...',
          'Next': 'அடுத்து',
          'Previous': 'முந்தையது',
          '* All questions are required to help us serve you better.':
              '* உங்களுக்குச் சிறந்த சேவையை வழங்க எங்களுக்கு உதவுவதற்காக, அனைத்துக் கேள்விகளுக்கும் பதிலளிப்பது அவசியமாகும்.',
          'Slots': 'Slots',
          '30 mins each': 'ஒவ்வொன்றும்\n30 நிமிடங்கள்',
          'Astrologer submitted answers for your queries':
              'ஜோதிடர் உங்கள் கேள்விகளுக்குப் பதில்களைச் சமர்ப்பித்துள்ளார்.',
          'Meet Again': 'மீண்டும்\nசந்திப்போம்',
          'Rate your experience with this astrologer appointment':
              'இந்த ஜோதிடர் சந்திப்புடனான உங்கள் அனுபவத்தை மதிப்பிடுங்கள்',
          'Save & Submit': 'சேமித்து சமர்ப்பிக்கவும்',
          'Type your answer here...':
              'உங்கள் பதிலை இங்கே தட்டச்சு செய்யவும்...',
          'Done': 'முடிந்தது',
          'booked a slot on': 'ஒரு\nஇடத்தைப் பதிவு\nசெய்துள்ளார்',
          "meeting_with": "{name} உடன் சந்திப்பு",
          //Voice chat
          'Jyotish voice guide for all your needs. Start you conversation today':
              'உங்கள் அனைத்து தேவைகளுக்கும் ஜோதிட குரல் வழிகாட்டி. இன்றே உங்கள் உரையாடலைத் தொடங்குங்கள்.',
          'Jyotish voice guide for all your needs':
              'உங்கள் அனைத்து தேவைகளுக்கும்\nஜோதிட குரல் வழிகாட்டி.',
          'The Seeker': 'தேடுபவர்',
          'The Luminary': 'ஒளிர்பவர்',
          'The Guardian': 'பாதுகாவலர்',
          'The Pathfinder': 'பாதையை தேடுபவர்',
          'Ideal for those who want in-depth astrological analysis and clear reasoning':
              'ஆழமான ஜோதிட பகுப்பாய்வு மற்றும் தெளிவான விளக்கத்தை விரும்புவோருக்கு ஏற்றது',
          'Ideal for those who seek joyful and engaging astrology guidance':
              'மகிழ்ச்சியான மற்றும் ஈடுபாட்டுடன் கூடிய ஜோதிட வழிகாட்டுதலை நாடுபவர்களுக்கு ஏற்றது',
          'Ideal for those looking for reassurance and personal connection in predictions':
              'கணிப்புகளில் உறுதியையும் தனிப்பட்ட தொடர்பையும் தேடுபவர்களுக்கு ஏற்றது',
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions':
              'தொழில் வளர்ச்சி, வெற்றி உத்திகள் அல்லது தெளிவான தீர்வுகளைத் தேடுபவர்களுக்கு ஏற்றது',
          'Tap the mic': 'மைக்கை அழுத்தவும்',
          'Start speaking in your own language':
              'உங்கள் தாய்மொழியில் பேசத் தொடங்குங்கள்',
          'Chat or record your thoughts...': 'Chat or record your thoughts...',
          'AI can understand all languages':
              'AI அனைத்து மொழிகளையும் புரிந்துகொள்ள முடியும்.',
          'Got it, typing that up for you…':
              'புரிந்தது, அதை உங்களுக்காகத் தட்டச்சு செய்கிறேன்...',
          'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology.':
              'விளக்கம் - AI ஜோதிடத்தின் மூலம் உங்கள் எதிர்காலம், தொழில், உறவுகள் மற்றும் பலவற்றைப் பற்றிய தனிப்பயனாக்கப்பட்ட கணிப்புகளை திறக்கவும்',
          'Generate Yearly Prediction': 'வருடாந்திர கணிப்பை\nஉருவாக்குங்கள்',
          'Generate Life Prediction': 'வாழ்க்கை கணிப்பை\nஉருவாக்குங்கள்',
          'Quick, direct replies without extra details — ideal for instant answers.':
              'கூடுதல் விவரங்கள் இல்லாமல் விரைவான, நேரடி பதில்கள் — உடனடி பதில்களுக்கு ஏற்றது',
          'Explanatory': 'விளக்கமளிக்கும்',
          'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.':
              'படிப்படியான தெளிவுடன் கூடிய ஆழமான பதில்கள் - கற்றல் அல்லது விரிவான தகவலுக்கு ஏற்றது.',
          'Choose an avatar for AI': 'AI-க்கு ஒரு அவதாரத்தைத் தேர்வுசெய்யவும்',
          'Related questions': 'தொடர்புடைய கேள்விகள்',
          'No response.': 'பதில் இல்லை.',
          'Retry': 'மீண்டும் முயற்சிக்கவும்',
          'Subscribe Now': 'சந்தா பெறுங்கள்',
          //Delete Account
          'We value your experience.\nWhat made you decide to leave?':
              'உங்கள் அனுபவத்தை நாங்கள் மதிக்கிறோம்.\nநீங்கள் வெளியேற முடிவு செய்தது ஏன்?',
          "I am having another account": 'எனக்கு வேறொரு கணக்கு இருக்கிறது',
          'App not working properly': 'App சரியாக வேலை செய்யவில்லை',
          'I don’t like the app': 'எனக்கு இந்த App பிடிக்கவில்லை',
          'I am worried about my privacy':
              'எனது Privacy குறித்து நான் கவலைப்படுகிறேன்',
          'You are about to delete\nyour account':
              'உங்கள் கணக்கை நீக்கப் போகிறீர்கள்',
          'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days':
              'இந்தக் கணக்குடன் தொடர்புடைய அனைத்து தரவுகளும் (உங்கள் சுயவிவரம், சேவை, முன்பதிவுகள், ஜாதகங்கள், கணிப்புகள் உட்பட) 45 நாட்களில் நிரந்தரமாக நீக்கப்படும்',
          'Delete Account Now': 'இப்போது கணக்கை நீக்கு',
          'No, I have changed my mind':
              'இல்லை, நான் என் மனதை மாற்றிக்கொள்கிறேன்',
          //Astrologer
          'You logged in as Astrologer':
              'நீங்கள் ஜோதிடராக\nஉள்நுழைந்துள்ளீர்கள்',
          'Meetings': 'முன்பதிவுகள்',
          'View your scheduled appointments & completed ones':
              'உங்கள் திட்டமிடப்பட்ட சந்திப்புகளையும் நிறைவடைந்த சந்திப்புகளையும் பார்க்கவும்.',
          'My Availability': 'எனது அட்டவணை',
          'Set your available time slots.': 'உங்கள் நேர இடங்களை அமைக்கவும்.',
          'Showing the available time that you picked':
              'நீங்கள் தேர்ந்தெடுத்த நேர இடங்கள்',
          'Morning': 'காலை',
          'Afternoon': 'மதியம்',
          'Select the slots that you are available':
              'உங்களுக்குக் கிடைக்கும் நேரங்களைத் தேர்ந்தெடுக்கவும்.',
          'Horoscope Details': 'ஜாதக விவரங்கள்',
          'Horoscope details are not available': 'ஜாதக விவரங்கள் கிடைக்கவில்லை',
          'Answer': 'பதில்',
          'View': 'பார்க்க',

          "Queries asked - Time to share your thoughts!":
              "கேள்விகள் கேட்கப்பட்டுள்ளன - உங்கள் எண்ணங்களைப் பகிர்ந்துகொள்ள இதுவே நேரம்!",

          "Queries asked - You've already shared your thoughts!":
              "கேட்கப்பட்ட கேள்விகள் - உங்கள் கருத்துக்களை நீங்கள் ஏற்கனவே பகிர்ந்துவிட்டீர்கள்!",
          'Date': 'தேதி',
          'Time': 'நேரம்',
          'Fees Paid': 'செலுத்தப்பட்ட கட்டணங்கள்',
          'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.':
              'உங்கள் வாழ்க்கையின் இந்த அர்த்தமுள்ள கட்டத்தில், உங்கள் ஜாதக கணிப்பு மூலம் உங்களை வழிநடத்துவது ஒரு பாக்கியம்',
          'Tamil': 'தமிழ்',
          'English': 'English',
          'Telugu': 'తెలుగు',
          'Malayalam': 'മലയാളം',
          'Kannada': 'ಕನ್ನಡ',
          'Hindi': 'हिन्दी',
          'Bengali': 'বাংলা',
          'Marathi': 'मराठी',
          'Urdu': 'اردو',
          'Gujarati': 'ગુજરાતી',
          'Odia': 'ଓଡ଼ିଆ',
          'Punjabi': 'ਪੰਜਾਬੀ',
          'Assamese': 'অসমীয়া',
          'Bhojpuri': 'भोजपुरी',
          'Kashmiri': 'کٲشُر',
          'Nepali': 'नेपाली',
          'Sindhi': 'سنڌي',
          'Sinhala': 'සිංහල',
          'Maithili': 'मैथिली',
          'Manipuri': 'মৈতৈলোন্',
          'Santali': 'ᱥᱟᱱᱛᱟᱲᱤ',
          'Years of Experience': 'அனுபவம்',
          'years': 'ஆண்டுகள்',
          'Showing Availability': 'Availability\nகாட்டுகிறது',
          //OTP Screen
          "resend_otp_in_seconds": "OTP மீண்டும் அனுப்ப {seconds} விநாடிகள்",
          'Enter Mobile Number': 'கைபேசி எண்ணை உள்ளிடவும்',
          'Enter Email': 'மின்னஞ்சலை உள்ளிடவும்',
          'Enter your new email and verify it using OTP':
              'உங்கள் புதிய மின்னஞ்சல் முகவரியை உள்ளிட்டு, OTP ஐப் பயன்படுத்தி அதைச் சரிபார்க்கவும்.',
          'Enter your new phone number and verify it using OTP':
              'உங்கள் புதிய தொலைபேசி எண்ணை உள்ளிட்டு, OTP ஐப் பயன்படுத்தி அதைச் சரிபார்க்கவும்.',
          'Verify Phone Number': 'தொலைபேசி எண்ணைச் சரிபார்க்கவும்',
          'Verify Existing Phone Number':
              'ஏற்கனவே உள்ள தொலைபேசி எண்ணைச் சரிபார்க்கவும்',
          'Verify Existing Email': 'ஏற்கனவே உள்ள மின்னஞ்சலைச் சரிபார்க்கவும்',
          'Verify Email': 'மின்னஞ்சலைச் சரிபார்க்கவும்',
          'For security reasons, kindly verify your existing phone number':
              'பாதுகாப்புக் காரணங்களுக்காக, தயவுசெய்து உங்கள் தற்போதைய தொலைபேசி எண்ணைச் சரிபார்க்கவும்.',
          'For security reasons, kindly verify your existing email':
              'பாதுகாப்புக் காரணங்களுக்காக, உங்கள் தற்போதைய மின்னஞ்சலைச் சரிபார்க்கவும்.',
          'We have sent OTP to': 'நாங்கள் OTP-ஐ அனுப்பியுள்ளோம்',
          'OTP is valid for 5 Minutes.':
              'ஓடிபி 5 நிமிடங்களுக்குச் செல்லுபடியாகும்.',
          'Resend OTP': 'OTP-ஐ மீண்டும் அனுப்பவும்',
          //Internet
          'No Internet Connection': 'இணைய இணைப்பு இல்லை',
          'Please check your\nnetwork settings':
              'தயவுசெய்து உங்கள்\nநெட்வொர்க் அமைப்புகளைச் சரிபார்க்கவும்.',
        },
        'te_IN': {
          'Good day': 'శుభదినం',
          'Astrologer': 'జ్యోతిష్కుడు',
          'Home': 'హోమ్',
          'Panchang': 'పంచాంగం',
          'Horoscope': 'జాతకం',
          'Settings': 'సెట్టింగ్స్',
          'Marriage\nMatch Making': 'వివాహ\nపొంతన',
          'Explore Other Predictions': 'ఇతర భవిష్యవాణులను\nఅన్వేషించండి',
          PlatformTextConfig.yearlyPrediction: 'వార్షిక\nఫలితాలు',
          PlatformTextConfig.weeklyPrediction: 'వార\nభవిష్యవాణులు',
          PlatformTextConfig.lifePrediction: 'జీవిత\nభవిష్యవాణులు',
          PlatformTextConfig.dailyPrediction: 'రోజువారీ\nభవిష్యవాణులు',
          PlatformTextConfig.chatHomePage: 'AI వాయిస్\nజ్యోతిష్య చాట్',
          'ChatTitle': 'AI వాయిస్ చాట్',
          'Chat Now': 'చాట్ చేయండి',
          'Thara Bala': 'తారాబలం',
          'Chandra Bala': 'చంద్రబలం',
          'Astrologer\nConsultation': 'పుష్\nనోటిఫికేషన్',
          'Astrologer Consultation': 'పుష్ నోటిఫికేషన్',
          'My Profile': 'నా వివరాలు',
          //settings
          'Profile': 'ప్రొఫైల్',
          'Push Notifications': 'పుష్ నోటిఫికేషన్',
          'Language': 'భాష',
          'Subscriptions': 'సభ్యత్వాలు',
          'Terms & Conditions': 'నిబంధనలు & షరతులు',
          'Privacy Policy': 'గోప్యతా విధానం',
          'Support': 'సహాయం',
          'FAQs': 'తరచుగా అడిగే ప్రశ్నలు',
          'Rate us': 'మాకు రేటింగ్ ఇవ్వండి',
          'Rate': 'మూల్యాంకనం\nచేయండి',
          'Delete Account': 'ఖాతా తొలగించండి',
          'Logout': 'లాగ్ఔట్',
          'Language Updated': 'భాష మార్చబడింది',
          'App language has been changed successfully':
              'యాప్ భాష విజయవంతంగా మార్చబడింది.',
               'Click to view':'చూడటానికి క్లిక్ చేయండి',
          //Profile
          'First Name': 'మొదటి పేరు',
          'Last Name': 'చివరి పేరు',
          'Email': 'ఈమెయిల్',
          'Phone Number': 'ఫోన్ నంబర్',
          'AI Chat Language': 'AI చాట్ భాష',
          'Date of Birth': 'జన్మ తేదీ',
          'Time of Birth': 'జన్మ సమయం',
          'Place of Birth': 'జన్మ స్థలం',
          'Current Location': 'ప్రస్తుత స్థానం',
          'Rasi': 'రాశి',
          'Nakshatram': 'నక్షత్రం',
          'Edit': 'ఎడిట్',
          'Profile Details': 'ప్రొఫైల్ వివరాలు',
          'Complete Profile': 'ప్రొఫైల్‌ను పూర్తి చేయండి',
          'Save': 'సేవ్ ',
          'Hi (name)!': 'హలో (name)!',
          'Verify': 'ధృవీకరించండి',
          'Change': 'మార్చు',
          'Enter place of birth': 'జన్మస్థలాన్ని నమోదు చేయండి',
          'Enter Current location': 'ప్రస్తుత స్థానాన్ని నమోదు చేయండి',
          'Select a place': 'ఒక స్థలాన్ని ఎంచుకోండి',
          'Select any one Option': 'ఏదైనా ఒక ఎంపికను ఎంచుకోండి',
          'How did you first hear about Teksage':
              'మీరు Teksage గురించి తొలిసారిగా ఎలా తెలుసుకున్నారు',
          'How did you first hear about Teksage?':
              'మీరు Teksage గురించి తొలిసారిగా ఎలా తెలుసుకున్నారు?',
          'Select a language': 'ఒక భాషను ఎంచుకోండి',
          "Google Play Store / App Store": "Google Play Store / App Store",
          "Google Search": "Google శోధన",
          "Quora": "Quora",
          "Facebook / Instagram": "Facebook / Instagram",
          "YouTube": "YouTube",
          "WhatsApp / Telegram (friends or groups)": "WhatsApp / Telegram",
          "Word of mouth (friends/family)":
              "నోటి మాట ద్వారా (స్నేహితులు / కుటుంబం)",
          "Product Hunt": "Product Hunt",
          "Other": "ఇతరవి",
          //Push Notification
          'Push Notification': 'పుష్ నోటిఫికేషన్',
          PlatformTextConfig.dailyTitle: 'దినఫలితాలు',
          PlatformTextConfig.weeklyTitle: 'వారఫలితాలు',
          PlatformTextConfig.yearlyTitle: 'వార్షిక ఫలితాలు',
          PlatformTextConfig.lifePredictionLanding: 'జీవిత ఫలితం',
          'Promotions & Offers': 'ప్రచారాలు & ఆఫర్లు',
          'Warnings': 'హెచ్చరికలు',
          'Consultation': 'సంప్రదింపులు',
          'General': 'జనరల్',
          'Astrologer appointment on': 'జ్యోతిష్కుడి\nఅపాయింట్‌మెంట్ ఈ తేదీన',
          'You have an appointment on': 'మీకు ఈ తేదీన\nఅపాయింట్‌మెంట్ ఉంది',
          'Your Daily Prediction have been generated':
              'మీ రోజువారీ అంచనా రూపొందించబడింది',
          'Your Weekly Prediction have been generated':
              'మీ వారపు అంచనా రూపొందించబడింది',
          'Your Yearly Prediction have been generated':
              'మీ వార్షిక అంచనా రూపొందించబడింది',
          'Clear All': 'అన్నీ క్లియర్\nచేయండి',
          'Daily Prediction': 'రోజువారీ భవిష్యవాణులు',
          'Weekly Prediction': 'వారపు భవిష్యవాణులు',
          'Yearly Prediction': 'వార్షిక భవిష్యవాణులు',
          'Notifications': 'నోటిఫికేషన్‌లు',
          'There are no Consultation updates.':
              'సంప్రదింపులకు సంబంధించిన ఎలాంటి నవీకరణలు లేవు.',
          'There are no recent general updates from your astrological guidance':
              'మీ జ్యోతిష్య మార్గదర్శకత్వం నుండి ఇటీవల ఎలాంటి సాధారణ నవీకరణలు లేవు.',
          //support
          'Got a question?\nOur support team is here to guide your path':
              'మీకు ఏమైనా ప్రశ్న ఉందా?\nమీకు మార్గనిర్దేశం చేయడానికి మా సహాయక బృందం సిద్ధంగా ఉంది',
          'Enter feedback or query here...':
              'ఇక్కడ మీ అభిప్రాయం లేదా ప్రశ్నని నమోదు చేయండి',
          'Submit': 'సమర్పించండి',
          //FAQs
          'Find answers to common questions\nabout our astrology services.':
              'మా జ్యోతిష్య సేవల గురించి సాధారణ ప్రశ్నలకు సమాధానాలు కనుగొనండి',
          'Still have questions?': 'ఇంకా ప్రశ్నలున్నాయా?',
          'Contact Support': 'సపోర్ట్‌ను సంప్రదించండి',
          'search_help': 'సహాయం కోసం శోధించండి',
          //panchang
          'WeekDay': 'వారం',
          'Thithi': 'తిథి',
          'Karna': 'కరణం',
          'Yoga': 'యోగం',
          'Sunrise': 'సూర్యోదయం',
          'Sunset': 'సూర్యాస్తమయం',
          'Rahu Kalam': 'రాహు కాలం',
          'Yama Kanda': 'యమ గండం',
          'Auspicious Time': 'శుభ ముహూర్తం',
          'Paksha': 'పక్ష',
          'Amirthathi Yoga': 'అమృత యోగం',
          'COMING SOON': 'త్వరలో వస్తుంది',
          "panchang_single_format": "(name) వరకు (time) (next)",
          'otp_response': "(title) ధృవీకరణ\nOTP విజయవంతంగా పంపబడింది.",

          //Horoscope
          PlatformTextConfig.horoscope: 'జాతకం',
          'Name': 'పేరు',
          'Place': 'స్థలం',
          'Lagna': 'లగ్నం',
          'South Indian Chart': 'దక్షిణ భారత జాతక పట్టిక',
          'North Indian Chart': 'ఉత్తర భారత జాతక పట్టిక',
          //weekly predictions
          "Hope you're having a wonderful start to your day.":
              "మీ రోజును అద్భుతంగా ప్రారంభించాలని ఆశిస్తున్నాను.",
          "Good morning,": 'శుభోదయం,',
          'Sunday': 'ఆదివారం',
          'Monday': 'సోమవారం',
          'Tuesday': 'మంగళవారం',
          'Wednesday': 'బుధవారం',
          'Thursday': 'గురువారం',
          'Friday': 'శుక్రవారం',
          'Saturday': 'శనివారం',
          'Chandrashtama': 'చంద్రాష్టమం',
          'Predictions are based on birth details in your profile section':
              'మీ ప్రొఫైల్ విభాగంలో ఉన్న జన్మ వివరాల ఆధారంగా భవిష్యవాణులు ఇవ్వబడతాయి',
          //yearly prediction
          'Planetary Transits': 'గ్రహ సంచారాలు',
          'Categorized Predictions': 'వర్గీకృత భవిష్యవాణులు',
          'Jupiter': 'గురువు',
          'Saturn': 'శని',
          'Rahu': 'రాహువు',
          'Ketu': 'కేతువు',
          'Current_Dasa': 'ప్రస్తుత దశ',
          'Career Overview': 'వృత్తి సమీక్ష',
          'Finance Overview': 'ఆర్థిక స్థితి సమీక్ష',
          'Health Overview': 'ఆరోగ్య స్థితి సమీక్ష',
          'Marriage/Relationship Overview': 'వివాహం / సంబంధాల సమీక్ష',
          'Remedies': 'ఉపాయాలు',
          'Chanting': 'జపం',
          'Puja': 'పూజ',
          'Charity': 'దానం',
          'Regenerate': 'పునఃసృష్టించండి',
          'Consult Astrologer': 'జ్యోతిష్కుడిని\nసంప్రదించండి',
          'Astrology Consultation': 'జ్యోతిష్య సంప్రదింపులు',
          'First Half of': 'మొదటి సగం',
          'Second Half of': 'రెండవ సగం',
          //Life predictions
          PlatformTextConfig.lifeTitle: 'జీవిత భవిష్యవాణులు',
          'General\nCharacteristics': 'సాధారణ\nలక్షణాలు',
          'Career\nPredictions': 'వృత్తి\nభవిష్యవాణులు',
          'Relationship\nPredictions': 'సంబంధ\nభవిష్యవాణులు',
          'Wealth\nPredictions': 'సంపద\nభవిష్యవాణులు',
          'Health\nPredictions': 'ఆరోగ్య\nభవిష్యవాణులు',
          'Current\nTime Period': 'ప్రస్తుత\nకాలం',
          //Daily Predictions
          'Upgrade to receive daily predictions at 6 AM':
              'రోజువారీ అంచనాలను ఉదయం 6 గంటలకు స్వీకరించడానికి అప్‌గ్రేడ్ చేయండి',
          'Your daily predictions was scheduled for 6 AM':
              'మీ రోజువారీ భవిష్యవాణులు ఉదయం 6 గంటలకు షెడ్యూల్ చేయబడ్డాయి.',
          'Career': 'వృత్తి',
          'Relationship': 'సంబంధాలు',
          'Wealth': 'సంపద',
          'Health': 'ఆరోగ్యం',
          //Marriage Match Making
          'Marriage Match Making': 'వివాహ పొంతన',
          'Boy Name': 'వరుని పేరు',
          'Girl Name': 'వధువు పేరు',
          'Total Compatibility Score': 'మొత్తం అనుకూలత స్కోరు',
          'Kuta': 'కూట',
          'Gained': 'పొందింది',
          'Max': 'గరిష్టం',
          'Present': 'ప్రస్తుతం',
          'Absent': 'గైర్హాజరు',
          'Expert Connect': 'నిపుణుల కనెక్ట్',
          'Check astrological compatibility for a perfect match':
              'పరిపూర్ణమైన జంట కోసం జ్యోతిష్య అనుకూలత',
          'Boy Details': 'వరుని వివరాలు',
          'Girl Details': 'వధువు వివరాలు',
          'Calculate Match': 'జాతకం పోల్చు',
          'Enter boy\'s name': 'పురుషుడి పేరు',
          'Enter girl\'s name': 'మహిళ పేరు',
          //Subscriptions
          'Subscription': 'సభ్యత్వాలు',
          'Auto Schedule Daily Predictions':
              'రోజువారీ ఫలితాలను ఆటో షెడ్యూల్ చేయండి',
          'Auto Schedule Weekly Predictions':
              'వారపు ఫలితాలను ఆటో షెడ్యూల్ చేయండి',
          'Book Consultations': 'కన్సల్టేషన్ బుక్ చేయండి',
          'Basic Horoscope Chart': 'ప్రాథమిక జాతక చార్ట్',
          'Edit Horoscope Details': 'జాతక వివరాలను సవరించండి',
          'Unlimited Number Of Chat Per Week': 'ప్రతి వారానికి అపరిమిత చాట్‌',
          'Download Chat History': 'చాట్ హిస్టరీ డౌన్‌లోడ్ చేయండి',
          'Pick Chat Avatar': 'చాట్ అవతార్ ఎంచుకోండి',
          'Pick Chat Style': 'చాట్ స్టైల్ ఎంచుకోండి',
          'Life Predictions': 'జీవిత భవిష్యవాణులు',
          'Yearly Predictions': 'వార్షిక భవిష్యవాణులు',
          'Personalized Panchang': 'వ్యక్తిగత పంచాంగం',
          'Continue': 'కొనసాగించండి',
          'Payment Summary': 'చెల్లింపు సారాంశం',
          'Pay Now': 'ఇప్పుడే చెల్లించండి',
          'Plan Cost': 'ప్రణాళిక వ్యయం',
          'Discount': 'డిస్కౌంట్',
          'Total Cost': 'మొత్తం ఖర్చు',
          'Payment Successful': 'చెల్లింపు విజయవంతం అయింది',
          'Try Premium Plan': 'ప్రీమియం ప్లాన్‌ను ప్రయత్నించండి',
          '1 month': '1 నెల',
          'month': 'నెల',
          'months': 'నెలలు',
          'year': 'సంవత్సరం',
          'Compare the plans': 'ప్లాన్‌లను పోల్చండి',
          'Welcome to\nTeksage!': 'Teksage-కు స్వాగతం!',
          'Your 24/7 Personal Astrologer is here\n—now at just':
              'మీ 24/7 వ్యక్తిగత జ్యోతిష్కుడు ఇక్కడ ఉన్నారు - ఇప్పుడే',
          'per month': 'నెలకు',
          'Unlock premium features': 'ప్రీమియం ఫీచర్లను అన్‌లాక్ చేయండి',
          'Unlimited AI voice chat in your own language':
              'మీ మాతృభాషలో అపరిమిత AI వాయిస్ Chat',
          'Yearly insights & life predictions':
              'వార్షిక అంతర్దృష్టులు & జీవిత అంచనాలు',
          'Personalised Panchang for your horoscope':
              'మీ జాతకం కోసం వ్యక్తిగతీకరించిన పంచాంగ్',
          'Upgrade Plan': 'Upgrade ప్రణాళిక',
          'Skip': 'దాటవేయండి',
          'Your Current Plan': 'మీ ప్రస్తుత plan',
          'days left': 'రోజులు మిగిలాయి',
          'Recommended': 'సిఫార్సు చేయబడింది',
          'membership': 'సభ్యత్వం',
          //Dialog box
          'Plan Expired': 'ప్లాన్ గడువు ముగిసింది',
          'Premium Feature': 'ప్రీమియం ఫీచర్',
          'Unlock all features by choosing a plan':
              'ప్లాన్ ఎంచుకొని అన్ని ఫీచర్లను అన్‌లాక్ చేయండి',
          'Purchase Plan': 'ప్లాన్ కొనుగోలు చేయండి',
          'Plan': 'ప్రణాళిక',
          'Slots Selected': 'ఎంపిక చేసిన స్లాట్లు',
          'Selected slots will be lost if you change the date. Would you like to save them first?':
              'తేదీ మార్చినట్లయితే ఎంపిక చేసిన స్లాట్లు కోల్పోతారు. ముందుగా వాటిని సేవ్ చేయాలనుకుంటున్నారా?',
          'Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!':
              'మీ నక్షత్రాలు మిమ్మల్ని దారి చూపుతాయి, మీ ఫీడ్‌బ్యాక్ మాకు మార్గం చూపుతుంది ⭐ \nఈ రోజు Teksageకి రేటింగ్ ఇవ్వండి!',
          'Rate Now': 'ఇప్పుడే రేట్ చేయండి',
          'Allow Location Access': 'లొకేషన్ యాక్సెస్‌ను అనుమతించండి',
          'We need your location to get prices in your local currency (INR, USD, etc.)':
              'మీ స్థానిక కరెన్సీలో ధరలను చూపడానికి మీ లొకేషన్ అవసరం',
          'Allow': 'అనుమతించు',
          'Not Allow': 'అనుమతించవద్దు',
          'Go to Settings': 'సెట్టింగ్‌లకు వెళ్లండి',
          'Are you sure you want to logout?':
              'మీరు లాగౌట్ చేయాలనుకుంటున్నారని ఖచ్చితంగా అనుకుంటున్నారా?',
          'Discard': 'విస్మరించండి',
          'You have unsaved changes.\nDo you want to discard them and go back?':
              'మీరు సేవ్ చేయని మార్పులు ఉన్నాయి.\nమీరు వాటిని విస్మరించి వెనక్కి వెళ్లాలనుకుంటున్నారా?',
          //Error Validate
          'Please Enter the First Name': 'దయచేసి మొదటి పేరును నమోదు చేయండి',
          'Please Enter the Second Name': 'దయచేసి చివరి పేరును నమోదు చేయండి',
          'Please enter a valid Email': 'దయచేసి సరైన ఈమెయిల్‌ను నమోదు చేయండి',
          'Please verify your Email': 'దయచేసి మీ ఈమెయిల్‌ను ధృవీకరించండి',
          'Enter a valid Email': 'సరైన ఈమెయిల్‌ను నమోదు చేయండి',
          'Select country code': 'దేశ కోడ్‌ను ఎంచుకోండి',
          'Enter valid (mobileLengthLimit)-digit number':
              'సరైన (mobileLengthLimit) అంకెల మొబైల్ నంబర్ ను నమోదు చేయండి',
          'cannot be empty': 'ఖాళీగా ఉండకూడదు',
          'Please enter the AI Chat Language':
              'దయచేసి AI చాట్ భాషను నమోదు చేయండి',
          'Please enter the Date of birth': 'దయచేసి జన్మ తేదీని నమోదు చేయండి',
          'Please enter the Time of birth': 'దయచేసి జన్మ సమయాన్ని నమోదు చేయండి',
          'Please enter the Place of birth':
              'దయచేసి జన్మ సమయాన్ని నమోదు చేయండి',
          'Please select one value': 'దయచేసి ఒక విలువను ఎంచుకోండి',
          'Please fill all the required fields':
              'దయచేసి అవసరమైన అన్ని వివరాలను పూరించండి',
          'Please Enter the valid Mobile Number':
              'దయచేసి సరైన మొబైల్ నంబర్ నమోదు చేయండి',
          'Choose a preferred language to continue':
              'కొనసాగడానికి మీకు ఇష్టమైన భాషను ఎంచుకోండి',
          '*This slot is already booked!': 'ఈ స్లాట్ ఇప్పటికే బుక్ చేయబడింది',
          '* Choose a preferred timing': 'మీకు అనుకూలమైన సమయాన్ని ఎంచుకోండి',
          'Kindly select one or more categories':
              'దయచేసి ఒకటి లేదా అంతకంటే ఎక్కువ కేటగిరీలను ఎంచుకోండి',
          'Error loading questions': 'ప్రశ్నలను లోడ్ చేయడంలో లోపం ఏర్పడింది',
          'No questions found': 'ప్రశ్నలు ఏవీ కనుగొనబడలేదు',
          "Please enter Boy's name": 'దయచేసి అబ్బాయి పేరు నమోదు చేయండి',
          "Please select Boy's Nakshatram":
              'దయచేసి అబ్బాయి నక్షత్రాన్ని ఎంచుకోండి',
          "Please select Girl's Nakshatram":
              'దయచేసి అమ్మాయి నక్షత్రాన్ని ఎంచుకోండి',
          "Please enter Girl's name": 'దయచేసి అమ్మాయి పేరు నమోదు చేయండి',
          "Please select Girl's Rasi": 'దయచేసి అమ్మాయిల రాశిని ఎంచుకోండి',
          "Please select Boy's Rasi": 'దయచేసి అబ్బాయిల రాశిని ఎంచుకోండి.',
          'Second language must be different from first':
              'రెండవ భాష మొదటి భాష నుండి భిన్నంగా ఉండాలి.',
          //Snack bar
          'Permission permanently denied. Please enable it in settings.':
              'అనుమతి శాశ్వతంగా నిరాకరించబడింది. దయచేసి సెట్టింగ్స్‌లో ఎనేబుల్ చేయండి',
          'Permission Denied': 'అనుమతి నిరాకరించబడింది',
          'Payment verification failed. Please try again.':
              'చెల్లింపు ధృవీకరణ విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి',
          'Payment failed. Please try again.':
              'చెల్లింపు విఫలమైంది. మళ్లీ ప్రయత్నించండి',
          'Please Contact Support team!':
              'దయచేసి సపోర్ట్ టీమ్‌ను సంప్రదించండి!',
          'Payment Error, Contact Support team!.':
              'చెల్లింపు లోపం, సపోర్ట్ టీమ్‌ను సంప్రదించండి!',
          'Payment successful!': 'చెల్లింపు విజయవంతంైంది',
          'Please enable location permission to access this feature.':
              'ఈ ఫీచర్‌ను ఉపయోగించడానికి దయచేసి లోకేషన్ అనుమతిని ఎనేబుల్ చేయండి',
          'Select valid country code and number':
              'సరైన దేశ కోడ్ మరియు నంబర్‌ను ఎంచుకోండి',
          'Please contact Teksage Admin':
              'దయచేసి టెక్సేజ్ అడ్మిన్‌ను సంప్రదించండి',
          'Error in Fetching Country code': 'దేశ కోడ్ పొందడంలో లోపం',
          'Please select a country code first': 'ముందుగా దేశ కోడ్‌ను ఎంచుకోండి',
          'Failed to fetch country list':
              'దేశాల జాబితా తెచ్చుకోవడంలో విఫలమైంది',
          'Please select the first language first':
              'దయచేసి ముందుగా మొదటి భాషను ఎంచుకోండి',
          'Failed to save Questions': 'ప్రశ్నలను సేవ్ చేయడంలో విఫలమైంది',
          'Error creating slots, Please try again.':
              'స్లాట్లు సృష్టించడంలో లోపం, మళ్లీ ప్రయత్నించండి',
          'Slot Updated Successfully.': 'స్లాట్ విజయవంతంగా నవీకరించబడింది',
          'At least one category must be selected.':
              'కనీసం ఒక కేటగిరీని ఎంచుకోవాలి',
          'At least one language must be selected.':
              'కనీసం ఒక భాషను ఎంచుకోవాలి',
          'We couldn’t fetch your horoscope. Please try again.':
              'మీ జాతకాన్ని పొందలేకపోయాము. దయచేసి మళ్లీ ప్రయత్నించండి',
          'Failed to fetch data. Please try again.':
              'డేటాను పొందడంలో విఫలమైంది. మళ్లీ ప్రయత్నించండి',
          'Failed to update notification status':
              'నోటిఫికేషన్ స్థితి అప్డేట్ చేయడంలో విఫలమైంది',
          'Please try again after sometime':
              'దయచేసి కొంతసేపటి తర్వాత మళ్లీ ప్రయత్నించండి',
          'All Notification has been cleared':
              'అన్ని నోటిఫికేషన్లు క్లియర్ చేయబడ్డాయి',
          'Please enable location access to view relevant subscription plans':
              'సంబంధిత సబ్‌స్క్రిప్షన్ ప్లాన్లను చూడడానికి లోకేషన్ యాక్సెస్‌ను ఎనేబుల్ చేయండి',
          'Failed to regenerate prediction. Please try again.':
              'ఫలితాన్ని మళ్లీ సృష్టించడం విఫలమైంది. మళ్లీ ప్రయత్నించండి',
          'An error occurred while regenerating. Please try again.':
              'మళ్లీ సృష్టించే సమయంలో లోపం వచ్చింది. మళ్లీ ప్రయత్నించండి',
          'Prediction regenerated successfully':
              'ఫలితం విజయవంతంగా మళ్లీ సృష్టించబడింది',
          'Please enter a valid OTP': 'దయచేసి సరైన OTP నమోదు చేయండి',
          'Choose your Style, Avatar and Language to begin your cosmic journey.':
              'మీ ఖగోళ ప్రయాణాన్ని ప్రారంభించడానికి స్టైల్, అవతార్ మరియు భాషను ఎంచుకోండి',
          'Select a Style and Avatar to begin your cosmic journey.':
              'మీ ఖగోళ ప్రయాణాన్ని ప్రారంభించడానికి స్టైల్ మరియు అవతార్‌ను ఎంచుకోండి',
          'Select a Style for your answer’s flow.':
              'మీ సమాధానం ప్రవాహానికి స్టైల్‌ను ఎంచుకోండి',
          'Select an Avatar that reflects your spirit.':
              'మీ ఆత్మను ప్రతిబింబించే అవతార్‌ ఎంచుకోండి',
          'Select a Language for your answer’s flow.':
              'మీ సమాధాన ప్రవాహానికి భాషను ఎంచుకోండి',
          'Keep it short and cosmic — max 300 characters':
              'సంక్షిప్తంగా మరియు ఖగోళంగా ఉంచండి — గరిష్టం 300 అక్షరాలు',
          'You can answer only after completing the consultation.':
              'కన్సల్టేషన్ పూర్తయిన తర్వాత మాత్రమే మీరు సమాధానం ఇవ్వవచ్చు',
          'Timeout. Please retry.': 'టైమ్ ఔట్. దయచేసి మళ్లీ ప్రయత్నించండి',
          'Kindly enter your question.': 'దయచేసి మీ ప్రశ్నను నమోదు చేయండి',
          'Your subscription has expired. Subscribe to continue.':
              'మీ సబ్‌స్క్రిప్షన్ గడువు ముగిసింది. కొనసాగడానికి సబ్‌స్క్రైబ్ చేయండి',
          'You’ve reached your message limit. Subscribe to continue.':
              'మీరు సందేశ పరిమితికి చేరుకున్నారు. కొనసాగడానికి సబ్‌స్క్రైబ్ చేయండి',
          'Retry response timed out.': 'రీట్రై స్పందన టైమ్ అవుట్ అయింది',
          'Response is taking longer than expected. Please check your network.':
              'స్పందన ఆశించిన దానికంటే ఎక్కువ సమయం తీసుకుంటోంది. దయచేసి మీ నెట్‌వర్క్‌ని తనిఖీ చేయండి',
          'Thanks for reaching out! Your query has been received — our team will respond shortly.':
              'సంప్రదించినందుకు ధన్యవాదాలు! మీ ప్రశ్న అందుకుంది — మా బృందం త్వరలో స్పందిస్తుంది',
          'Something went wrong. Please try again.':
              'ఏదో తప్పు జరిగింది. మళ్లీ ప్రయత్నించండి',
          'Logout failed. Please try again.':
              'లాగ్అవుట్ విఫలమైంది. మళ్లీ ప్రయత్నించండి',
          'Thanks for using Teksage': 'Teksage ఉపయోగించినందుకు ధన్యవాదాలు',
          'Your message looks empty after removing hidden characters. Try typing or paste plain text.':
              'దాచిన అక్షరాలను తొలగించిన తర్వాత మీ సందేశం ఖాళీగా కనిపిస్తోంది. సాదా వచనాన్ని టైప్ చేయడానికి లేదా అతికించడానికి ప్రయత్నించండి.',
          'Error in sending OTP': 'OTP పంపడంలో లోపం ఏర్పడింది.',
          'Network error. Please check your connection and try again.':'నెట్‌వర్క్ లోపం. దయచేసి మీ కనెక్షన్‌ను తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.',
          'OTP Verified':'OTP ధృవీకరించబడింది',
          //Astrology consultations
          'What do you\nneed guidance on?':
              'మీకు ఏ విషయంలో మార్గదర్శనం కావాలి?',
          'Select the categories and continue': 'వర్గాలను ఎంచుకొని కొనసాగండి',
          'Marriage & relationships': 'వివాహం & సంబంధాలు',
          'Marriage & Relationships': 'వివాహం & సంబంధాలు',
          'All': 'అన్ని',
          'Choose your\npreferred language': 'మీకు ఇష్టమైన భాషను ఎంచుకోండి',
          'This will help us to match the best astrologer':
              'ఇది మీకు సరైన జ్యోతిష్కుడిని ఎంపిక చేయడానికి సహాయపడుతుంది',
          'First Preference': 'మొదటి ప్రాధాన్యత',
          'Second Preference': 'రెండవ ప్రాధాన్యత',
          'Select language': 'భాషను ఎంచుకోండి',
          'Top 5 astrologers\nbased on preferences':
              'మీ ప్రాధాన్యతల ఆధారంగా టాప్ 5 జ్యోతిష్కులు',
          'Expert Profile': 'నిపుణుడి ప్రొఫైల్',
          'Reviews': 'సమీక్షలు',
          'No reviews available': 'సమీక్షలు లేవు',
          'Book Consultation': 'కన్సల్టేషన్ బుక్ చేయండి',
          'No slots available': 'స్లాట్లు లభ్యం కావు',
          'Find & Consult Astrologers': 'జ్యోతిష్కులను కనుగొని సంప్రదించండి',
          '100+ Astrologers': '100+ జ్యోతిష్కులు',
          'Explore and find your perfect match':
              'అన్వేషించండి మరియు మీ పరిపూర్ణ సరిపోలికను కనుగొనండి',
          'Upcoming': 'రాబోయే',
          'Completed': 'పూర్తయింది',
          'View Details': 'వివరాలను\nవీక్షించండి',
          'View\nDetails': 'వివరాలను\nవీక్షించండి',
          'Meeting Link': 'meeting\nలింక్',
          'Choose your avatar': 'మీ అవతార్‌ను ఎంచుకోండి',
          'Choose how AI replies': 'AI ఎలా ప్రత్యుత్తరమిస్తుందో ఎంచుకోండి',
          'Concise': 'సంక్షిప్తమైనది',
          'Book Now': 'ఇప్పుడే బుక్\nచేయండి',
          'Booking Details': 'Booking వివరాలు',
          'Consultation Fee': 'కన్సల్టేషన్ ఫీజు',
          'Total Fee': 'మొత్తం రుసుము',
          'Confirm & Proceed to Pay': 'నిర్ధారించి చెల్లించండి',
          'Consultation Details': 'సంప్రదింపుల వివరాలు',
          'Consulting On': 'కన్సల్టేషన్ విషయం',
          'Give Rating': 'రేటింగ్ ఇవ్వండి',
          'Ratings': 'రేటింగ్‌లు',
          'You have no upcoming meetings at the moment.':
              'ప్రస్తుతానికి మీకు రాబోయే సమావేశాలు ఏవీ లేవు.',
          'You have no completed meetings at the moment.':
              'ప్రస్తుతానికి మీకు పూర్తయిన సమావేశాలు ఏవీ లేవు.',
          'Yes': 'అవును',
          'No': 'లేదు',
          'Queries you asked': 'మీరు అడిగిన ప్రశ్నలు',
          'Enter Promo Code': 'ప్రోమో కోడ్ నమోదు చేయండి',
          'Applied': 'వర్తింపజేయబడింది',
          'Apply': 'అప్లై చేయండి',
          'I consent to share my personal information & horoscope with the astrologer':
              'నా వ్యక్తిగత వివరాలు & జాతకాన్ని జ్యోతిష్కుడితో పంచుకోవడానికి నేను అంగీకరిస్తున్నాను',
          'I consent to share my personal information & star chart with the advisor':
              'నా వ్యక్తిగత సమాచారాన్ని మరియు జాతక చక్రాన్ని సలహాదారుతో పంచుకోవడానికి నేను అంగీకరిస్తున్నాను',
          'Kindly select your preferred language':
              'దయచేసి మీకు నచ్చిన భాషను ఎంచుకోండి',
          'Write your consultation query here':
              'మీ సంప్రదింపు ప్రశ్నను ఇక్కడ వ్రాయండి',
          'Enter your question here...': 'మీ ప్రశ్నను ఇక్కడ నమోదు చేయండి...',
          'Next': 'తరువాత',
          'Previous': 'మునుపటి',
          '* All questions are required to help us serve you better.':
              '* మీకు మెరుగైన సేవ అందించడంలో మాకు సహాయపడటానికి అన్ని ప్రశ్నలకు సమాధానం ఇవ్వడం తప్పనిసరి.',
          'Slots': 'స్లాట్లు',
          '30 mins each': 'ప్రతిదానికి 30 నిమిషాలు',
          'Astrologer submitted answers for your queries':
              'జ్యోతిష్యుడు మీ ప్రశ్నలకు సమాధానాలు సమర్పించారు.',
          'Meet Again': 'మళ్ళీ\nకలుద్దాం',
          'Rate your experience with this astrologer appointment':
              'ఈ జ్యోతిష్కుల అపాయింట్‌మెంట్‌తో మీ అనుభవాన్ని రేట్ చేయండి',
          'Save & Submit': 'సేవ్ చేసి సమర్పించండి',
          'Type your answer here...': 'మీ సమాధానాన్ని ఇక్కడ టైప్ చేయండి...',
          'Done': 'పూర్తయింది',
          'booked a slot on': 'లో స్లాట్‌ను\nబుక్ చేసుకున్నారు',
          "meeting_with": "{name} తో సమావేశం",
          //Voice chat
          'Jyotish voice guide for all your needs. Start you conversation today':
              'మీ అన్ని అవసరాలకు జ్యోతిష్ వాయిస్ గైడ్. ఈరోజే మీ సంభాషణను ప్రారంభించండి.',
          'Jyotish voice guide for all your needs':
              'మీ అన్ని అవసరాలకు జ్యోతిష్ వాయిస్ గైడ్',
          'The Seeker': 'అన్వేషి',
          'The Luminary': 'ప్రకాశించేవాడు',
          'The Guardian': 'సంరక్షకుడు',
          'The Pathfinder': 'పాత్‌ఫైండర్',
          'Ideal for those who want in-depth astrological analysis and clear reasoning':
              'లోతైన జ్యోతిష విశ్లేషణ మరియు స్పష్టమైన తార్కికం కోరుకునే వారికి అనువైనది',
          'Ideal for those who seek joyful and engaging astrology guidance':
              'ఆనందకరమైన మరియు ఆకర్షణీయమైన జ్యోతిషశాస్త్ర మార్గదర్శకత్వం కోరుకునే వారికి అనువైనది',
          'Ideal for those looking for reassurance and personal connection in predictions':
              'అంచనాలలో భరోసా మరియు వ్యక్తిగత సంబంధం కోసం చూస్తున్న వారికి అనువైనది',
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions':
              'కెరీర్ వృద్ధి, విజయ వ్యూహాలు లేదా స్పష్టమైన పరిష్కారాలను కోరుకునే వారికి అనువైనది',
          'Tap the mic': 'మైక్‌ను నొక్కండి',
          'Start speaking in your own language':
              'మీ మాతృభాషలో మాట్లాడటం ప్రారంభించండి',
          'Chat or record your thoughts...': 'Chat or record your thoughts...',
          'AI can understand all languages':
              'ఏఐ అన్ని భాషలను అర్థం చేసుకోగలదు.',
          'Got it, typing that up for you…':
              'అర్థమైంది, మీ కోసం అది టైప్ చేస్తున్నాను...',
          'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology.':
              'వివరణ - అల్-పవర్డ్ జ్యోతిషశాస్త్రంతో మీ భవిష్యత్తు, కెరీర్, సంబంధాలు మరియు మరిన్నింటిపై వ్యక్తిగతీకరించిన అంతర్దృష్టులను అన్‌లాక్ చేయండి',
          'Generate Yearly Prediction': 'వార్షిక అంచనాను రూపొందించండి',
          'Generate Life Prediction': 'జీవిత అంచనాను రూపొందించండి',
          'Quick, direct replies without extra details — ideal for instant answers.':
              'అదనపు వివరాలు లేకుండా త్వరిత, ప్రత్యక్ష ప్రత్యుత్తరాలు — తక్షణ సమాధానాలకు అనువైనవి',
          'Explanatory': 'వివరణాత్మకమైనది',
          'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.':
              'దశల వారీ స్పష్టతతో లోతైన, నిర్మాణాత్మక ప్రత్యుత్తరాలు - నేర్చుకోవడానికి లేదా వివరణాత్మక అంతర్దృష్టులకు సరైనవి',
          'Choose an avatar for AI': 'AI కోసం అవతార్‌ను ఎంచుకోండి',
          'Related questions': 'సంబంధిత ప్రశ్నలు',
          'No response.': 'ఎటువంటి స్పందన లేదు.',
          'Retry': 'మళ్ళీ ప్రయత్నించండి',
          'Subscribe Now': 'ఇప్పుడే సబ్స్క్రయిబ్ చేయండి',
          //Delete Account
          'We value your experience.\nWhat made you decide to leave?':
              'మేము మీ అనుభవానికి విలువ ఇస్తున్నాము.\nమీరు వెళ్ళిపోవాలని నిర్ణయించుకున్నది ఏమిటి?',
          "I am having another account": 'నాకు వేరే ఖాతా ఉంది',
          'App not working properly': 'యాప్ సరిగ్గా పని చేయడం లేదు',
          'I don’t like the app': 'నాకు యాప్ నచ్చలేదు',
          'I am worried about my privacy':
              'నా గోప్యత గురించి నేను ఆందోళన చెందుతున్నాను',
          'You are about to delete\nyour account':
              'మీరు మీ ఖాతాను తొలగించబోతున్నారు',
          'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days':
              'ఈ ఖాతాతో అనుబంధించబడిన మొత్తం డేటా (మీ ప్రొఫైల్, సర్వీస్, బుకింగ్‌లు, జాతకచక్రాలు, అంచనాలతో సహా) 45 రోజుల్లో శాశ్వతంగా తొలగించబడుతుంది',
          'Delete Account Now': 'ఇప్పుడు ఖాతాను తొలగించండి',
          'No, I have changed my mind': 'లేదు, నేను నా మనసు మార్చుకుంటున్నాను',
          //Astrologer
          'You logged in as Astrologer': 'మీరు జ్యోతిష్యుడిగా లాగిన్\nఅయ్యారు',
          'Meetings': 'బుకింగ్‌లు',
          'View your scheduled appointments & completed ones':
              'మీ షెడ్యూల్ చేయబడిన అపాయింట్‌మెంట్‌లు & పూర్తయిన వాటిని వీక్షించండి',
          'My Availability': 'నా షెడ్యూల్',
          'Select the slots that you are available':
              'మీకు అందుబాటులో ఉన్న స్లాట్‌లను ఎంచుకోండి',
          'Showing the available time that you picked':
              'మీరు ఎంచుకున్న సమయ స్లాట్‌లు',
          'Morning': 'ఉదయం',
          'Afternoon': 'మధ్యాహ్నం',
          'Set your available time slots.': 'మీ సమయ స్లాట్‌లను సెట్ చేసుకోండి.',
          'Horoscope Details': 'జాతక వివరాలు',
          'Horoscope details are not available': 'జాతక వివరాలు అందుబాటులో లేవు',
          'Answer': 'సమాధానం',
          'View': 'చూడండి',
          "Queries asked - Time to share your thoughts!":
              "అడిగిన ప్రశ్నలు - మీ ఆలోచనలను పంచుకోవడానికి ఇదే సమయం!",
          "Queries asked - You've already shared your thoughts!":
              "అడిగిన ప్రశ్నలు - మీరు ఇప్పటికే మీ ఆలోచనలను పంచుకున్నారు!",
          'Date': 'తేదీ',
          'Time': 'సమయం',
          'Fees Paid': 'చెల్లించిన రుసుములు',
          'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.':
              'మీ జీవితంలోని ఈ అర్థవంతమైన దశలో, మీ చార్ట్ అందించే అంతర్దృష్టుల ద్వారా మీకు మార్గనిర్దేశం చేయడం ఒక గౌరవం',
          'Tamil': 'தமிழ்',
          'English': 'English',
          'Telugu': 'తెలుగు',
          'Malayalam': 'മലയാളം',
          'Kannada': 'ಕನ್ನಡ',
          'Hindi': 'हिन्दी',
          'Bengali': 'বাংলা',
          'Marathi': 'मराठी',
          'Urdu': 'اردو',
          'Gujarati': 'ગુજરાતી',
          'Odia': 'ଓଡ଼ିଆ',
          'Punjabi': 'ਪੰਜਾਬੀ',
          'Assamese': 'অসমীয়া',
          'Bhojpuri': 'भोजपुरी',
          'Kashmiri': 'کٲشُر',
          'Nepali': 'नेपाली',
          'Sindhi': 'سنڌي',
          'Sinhala': 'සිංහල',
          'Maithili': 'मैथिली',
          'Manipuri': 'মৈতৈলোন্',
          'Santali': 'ᱥᱟᱱᱛᱟᱲᱤ',
          'Years of Experience': 'అనుభవ సంవత్సరాలు',
          'years': 'సంవత్సరాలు',
          'Showing Availability': 'లభ్యతను\nచూపుతోంది',
          //OTP Screen
          "resend_otp_in_seconds": "OTP మళ్లీ పంపడానికి {seconds} సెకన్లు",
          'Enter Mobile Number': 'మొబైల్ నంబర్‌ను నమోదు చేయండి',
          'Enter Email': 'ఇమెయిల్‌ను నమోదు చేయండి',
          'Enter your new email and verify it using OTP':
              'మీ కొత్త ఇమెయిల్‌ను నమోదు చేసి, OTP ఉపయోగించి దానిని ధృవీకరించండి.',
          'Enter your new phone number and verify it using OTP':
              'మీ కొత్త ఫోన్ నంబర్‌ను నమోదు చేసి, OTP ఉపయోగించి దానిని ధృవీకరించండి.',
          'Verify Phone Number': 'ఫోన్ నంబర్‌ను ధృవీకరించండి',
          'Verify Email': 'ఇమెయిల్ ధృవీకరించండి',
          'Verify Existing Phone Number':
              'ఇప్పటికే ఉన్న ఫోన్ నంబర్‌ను ధృవీకరించండి',
          'Verify Existing Email': 'ఉన్న ఇమెయిల్‌ను ధృవీకరించండి',
          'For security reasons, kindly verify your existing phone number':
              'భద్రతా కారణాల దృష్ట్యా, దయచేసి మీ ప్రస్తుత ఫోన్ నంబర్‌ను ధృవీకరించండి.r',
          'For security reasons, kindly verify your existing email':
              'భద్రతా కారణాల దృష్ట్యా, దయచేసి మీ ఇమెయిల్‌ను ధృవీకరించండి.',
          'We have sent OTP to': 'మేము OTPని దీనికి పంపాము',
          'OTP is valid for 5 Minutes.':
              'OTP 5 నిమిషాల పాటు చెల్లుబాటు అవుతుంది.',
          'Resend OTP': 'ఓటీపీని మళ్లీ పంపండి',
          //Internet
          'No Internet Connection': 'ఇంటర్నెట్ కనెక్షన్ లేదు',
          'Please check your\nnetwork settings':
              'దయచేసి మీ నెట్‌వర్క్ సెట్టింగ్‌లను తనిఖీ చేయండి.',
        },
        'kn_IN': {
          'Good day': 'ಶುಭ ದಿನ',
          'Astrologer': 'ಜ್ಯೋತಿಷ್ಯರು',
          'Home': 'ಮುಖಪುಟ',
          'Panchang': 'ಪಂಚಾಂಗ',
          'Horoscope': 'ರಾಶಿಫಲ',
          'Settings': 'ಸಂಯೋಜನೆಗಳು',
          'Marriage\nMatch Making': 'ವಿವಾಹ\nಹೊಂದಾಣಿಕೆ',
          'Explore Other Predictions': 'ಇತರೆ ಭವಿಷ್ಯವಾಣಿಗಳನ್ನು ನೋಡಿ',
          PlatformTextConfig.yearlyPrediction: 'ವಾರ್ಷಿಕ\nಭವಿಷ್ಯವಾಣಿ',
          PlatformTextConfig.weeklyPrediction: 'ವಾರದ\nಭವಿಷ್ಯವಾಣಿ',
          PlatformTextConfig.lifePrediction: 'ಜೀವನ\nಭವಿಷ್ಯವಾಣಿ',
          PlatformTextConfig.dailyPrediction: 'ದೈನಂದಿನ\nಭವಿಷ್ಯವಾಣಿಗಳು',
          PlatformTextConfig.chatHomePage: 'AI ಜ್ಯೋತಿಷ್ಯ\nಧ್ವನಿ ಚಾಟ್',
          'ChatTitle': 'AI ವಾಯ್ಸ್ ಚಾಟ್',
          'Chat Now': 'ಈಗ ಚಾಟ್ ಮಾಡಿ',
          'Thara Bala': 'ತಾರಾ ಬಲ',
          'Chandra Bala': 'ಚಂದ್ರ ಬಲ',
          'Astrologer\nConsultation': 'ಜ್ಯೋತಿಷ್ಯರನ್ನು\nಸಂಪರ್ಕಿಸಿ',
          'Astrologer Consultation': 'ಜ್ಯೋತಿಷ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ',
          'My Profile': 'ನನ್ನ ಪ್ರೊಫೈಲ್',
          //settings
          'Profile': 'ಪ್ರೊಫೈಲ್',
          'Push Notifications': 'ಪುಶ್ ಸೂಚನೆಗಳು',
          'Language': 'ಭಾಷೆ',
          'Subscriptions': 'ಚಂದಾದಾರಿಕೆಗಳು',
          'Terms & Conditions': 'ನಿಯಮಗಳು ಮತ್ತು ಷರತ್ತುಗಳು',
          'Privacy Policy': 'ಗೌಪ್ಯತಾ ನೀತಿ',
          'Support': 'ಬೆಂಬಲ',
          'FAQs': 'ಪದೇಪದೇ ಕೇಳುವ ಪ್ರಶ್ನೆಗಳು',
          'Rate us': 'ನಮಗೆ ಮೌಲ್ಯಮಾಪನ ನೀಡಿ',
          'Rate': 'ಅಂಕ\nನೀಡಿ',
          'Delete Account': 'ಖಾತೆ ಅಳಿಸಿ',
          'Logout': 'ಲಾಗ್ ಔಟ್',
          'Language Updated': 'ಭಾಷೆ ಬದಲಾಗಿದೆ',
          'App language has been changed successfully':
              'ಅಪ್ಲಿಕೇಶನ್ ಭಾಷೆಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಬದಲಾಯಿಸಲಾಗಿದೆ.',
               'Click to view':'ವೀಕ್ಷಿಸಲು ಕ್ಲಿಕ್ ಮಾಡಿ',
          //Profile
          'First Name': 'ಮೊದಲ ಹೆಸರು',
          'Last Name': 'ಕೊನೆಯ ಹೆಸರು',
          'Email': 'ಇಮೇಲ್',
          'Phone Number': 'ದೂರವಾಣಿ ಸಂಖ್ಯೆ',
          'AI Chat Language': 'AI ಚಾಟ್ ಭಾಷೆ',
          'Date of Birth': 'ಜನ್ಮ ದಿನಾಂಕ',
          'Time of Birth': 'ಜನ್ಮ ಸಮಯ',
          'Place of Birth': 'ಜನ್ಮ ಸ್ಥಳ',
          'Current Location': 'ಪ್ರಸ್ತುತ ಸ್ಥಳ',
          'Rasi': 'ರಾಶಿ',
          'Nakshatram': 'ನಕ್ಷತ್ರ',
          'Edit': 'ತಿದ್ದು',
          'Profile Details': 'ಪ್ರೊಫೈಲ್ ವಿವರಗಳು',
          'Complete Profile': 'ಸಂಪೂರ್ಣ ಪ್ರೊಫೈಲ್',
          'Save': 'ಉಳಿಸಿ',
          'Hi (name)!': 'ಹಲೋ (name)!',
          'Verify': 'ಪರಿಶೀಲಿಸಿ',
          'Change': 'ಬದಲಾವಣೆ',
          'Enter place of birth': 'ಜನ್ಮಸ್ಥಳವನ್ನು ನಮೂದಿಸಿ',
          'Enter Current location': 'ಪ್ರಸ್ತುತ ಸ್ಥಳವನ್ನು ನಮೂದಿಸಿ',
          'Select a place': 'ಸ್ಥಳವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Select any one Option': 'ಯಾವುದೇ ಒಂದು ಆಯ್ಕೆಯನ್ನು ಆರಿಸಿ',
          'How did you first hear about Teksage':
              'ನೀವು Teksage ಬಗ್ಗೆ ಮೊದಲ ಬಾರಿ ಹೇಗೆ ತಿಳಿದುಕೊಂಡಿರಿ',
          'How did you first hear about Teksage?':
              'ನೀವು Teksage ಬಗ್ಗೆ ಮೊದಲ ಬಾರಿ ಹೇಗೆ ತಿಳಿದುಕೊಂಡಿರಿ?',
          'Select a language': 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          "Google Play Store / App Store": "Google Play Store / App Store",
          "Google Search": "Google ಹುಡುಕಾಟ",
          "Quora": "Quora",
          "Facebook / Instagram": "Facebook / Instagram",
          "YouTube": "YouTube",
          "WhatsApp / Telegram (friends or groups)": "WhatsApp / Telegram",
          "Word of mouth (friends/family)":
              "ಬಾಯ್ಬಾರದ ಶಿಫಾರಸು (ಸ್ನೇಹಿತರು / ಕುಟುಂಬ)",
          "Product Hunt": "Product Hunt",
          "Other": "ಇತರೆ",
          //Push Notification
          'Push Notification': 'ಪುಶ್ ಸೂಚನೆಗಳು',
          PlatformTextConfig.dailyTitle: 'ದೈನಂದಿನ ಭವಿಷ್ಯವಾಣಿ',
          PlatformTextConfig.weeklyTitle: 'ವಾರದ ಭವಿಷ್ಯವಾಣಿ',
          PlatformTextConfig.yearlyTitle: 'ವಾರ್ಷಿಕ ಭವಿಷ್ಯವಾಣಿ',
          PlatformTextConfig.lifePredictionLanding: 'ಜೀವನ ಭವಿಷ್ಯವಾಣಿ',
          'Promotions & Offers': 'ಪ್ರಚಾರಗಳು ಮತ್ತು ಆಫರ್‌ಗಳು',
          'Warnings': 'ಎಚ್ಚರಿಕೆಗಳು',
          'Consultation': 'ಸಮಾಲೋಚನೆ',
          'General': 'ಜನರಲ್',
          'Astrologer appointment on': 'ಜ್ಯೋತಿಷಿ\nಅಪಾಯಿಂಟ್ಮೆಂಟ್ ದಿನಾಂಕ',
          'You have an appointment on': 'ನಿಮಗೆ ಅಪಾಯಿಂಟ್ಮೆಂಟ್ ಇದೆ',
          'Your Daily Prediction have been generated':
              'ನಿಮ್ಮ ದೈನಂದಿನ ಭವಿಷ್ಯವಾಣಿಯನ್ನು ರಚಿಸಲಾಗಿದೆ.',
          'Your Weekly Prediction have been generated':
              'ನಿಮ್ಮ ವಾರದ ಭವಿಷ್ಯವಾಣಿಯನ್ನು ರಚಿಸಲಾಗಿದೆ',
          'Your Yearly Prediction have been generated':
              'ನಿಮ್ಮ ವಾರ್ಷಿಕ ಭವಿಷ್ಯವಾಣಿಯನ್ನು ರಚಿಸಲಾಗಿದೆ',
          'Clear All': 'ಎಲ್ಲವನ್ನೂ\nತೆರವುಗೊಳಿಸಿ',
          'Daily Prediction': 'ದೈನಂದಿನ ಭವಿಷ್ಯವಾಣಿಗಳು',
          'Weekly Prediction': 'ಸಾಪ್ತಾಹಿಕ ಭವಿಷ್ಯವಾಣಿಗಳು',
          'Yearly Prediction': 'ವಾರ್ಷಿಕ ಭವಿಷ್ಯ',
          'Notifications': 'ಅಧಿಸೂಚನೆಗಳು',
          'There are no Consultation updates.': 'ಯಾವುದೇ ಸಮಾಲೋಚನೆ ನವೀಕರಣಗಳಿಲ್ಲ.',
          'There are no recent general updates from your astrological guidance':
              'ನಿಮ್ಮ ಜ್ಯೋತಿಷ್ಯ ಮಾರ್ಗದರ್ಶನದಿಂದ ಯಾವುದೇ ಇತ್ತೀಚಿನ ಸಾಮಾನ್ಯ ನವೀಕರಣಗಳಿಲ್ಲ.',
          //support
          'Got a question?\nOur support team is here to guide your path':
              'ಪ್ರಶ್ನೆಯಿದೆಯೇ?\nನಿಮ್ಮ ದಾರಿಯನ್ನು ಮಾರ್ಗದರ್ಶನ ಮಾಡಲು ನಮ್ಮ ಬೆಂಬಲ ತಂಡ ಇಲ್ಲಿದೆ',
          'Enter feedback or query here...':
              'ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆ ಅಥವಾ ಪ್ರಶ್ನೆಯನ್ನು ಇಲ್ಲಿ ನಮೂದಿಸಿ',
          'Submit': 'ಸಲ್ಲಿಸಿ',
          //FAQs
          'Find answers to common questions\nabout our astrology services.':
              'ನಮ್ಮ ಜ್ಯೋತಿಷ್ಯ ಸೇವೆಗಳ ಬಗ್ಗೆ ಸಾಮಾನ್ಯವಾಗಿ ಕೇಳಲಾಗುವ ಪ್ರಶ್ನೆಗಳ ಉತ್ತರಗಳನ್ನು ಇಲ್ಲಿ ಕಂಡುಹಿಡಿಯಿರಿ',
          'Still have questions?': 'ಇನ್ನೂ ಪ್ರಶ್ನೆಗಳಿವೆಯೇ?',
          'Contact Support': 'ಬೆಂಬಲ ತಂಡವನ್ನು ಸಂಪರ್ಕಿಸಿ',
          'search_help': 'ಸಹಾಯ ಹುಡುಕಿ',
          //panchang
          'WeekDay': 'ವಾರ',
          'Thithi': 'ತಿಥಿ',
          'Karna': 'ಕರಣ',
          'Yoga': 'ಯೋಗ',
          'Sunrise': 'ಸೂರ್ಯೋದಯ',
          'Sunset': 'ಸೂರ್ಯಾಸ್ತ',
          'Rahu Kalam': 'ರಾಹು ಕಾಲ',
          'Yama Kanda': 'ಯಮ ಗಂಡ',
          'Auspicious Time': 'ಶುಭ ಮುಹೂರ್ತ',
          'Paksha': 'ಪಕ್ಷ',
          'Amirthathi Yoga': 'ಅಮೃತ ಯೋಗ',
          'COMING SOON': 'ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ',
          "panchang_single_format": "(name) ವರೆಗೆ (time) (next)",
          'otp_response': "(title) ಪರಿಶೀಲನೆ\nOTP ಯಶಸ್ವಿಯಾಗಿ ಕಳುಹಿಸಲಾಗಿದೆ.",

          //Horoscope
          PlatformTextConfig.horoscope: 'ರಾಶಿಫಲ',
          'Name': 'ಹೆಸರು',
          'Place': 'ಜನ್ಮ ಸ್ಥಳ',
          'Lagna': 'ಲಗ್ನ',
          'South Indian Chart': 'ದಕ್ಷಿಣ ಭಾರತೀಯ ಕುಂಡಲಿ',
          'North Indian Chart': 'ಉತ್ತರ ಭಾರತೀಯ ಕುಂಡಲಿ',
          //weekly predictions
          "Hope you're having a wonderful start to your day.":
              "ನಿಮ್ಮ ದಿನದ ಆರಂಭ ಅದ್ಭುತವಾಗಿರಲಿ ಎಂದು ಆಶಿಸುತ್ತೇನೆ.",
          "Good morning,": 'ಶುಭೋದಯ,',
          'Sunday': 'ಭಾನುವಾರ',
          'Monday': 'ಸೋಮವಾರ',
          'Tuesday': 'ಮಂಗಳವಾರ',
          'Wednesday': 'ಬುಧವಾರ',
          'Thursday': 'ಗುರುವಾರ',
          'Friday': 'ಶುಕ್ರವಾರ',
          'Saturday': 'ಶನಿವಾರ',
          'Chandrashtama': 'ಚಂದ್ರಾಷ್ಟಮ',
          'Predictions are based on birth details in your profile section':
              'ಭವಿಷ್ಯವಾಣಿಗಳು ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ವಿಭಾಗದಲ್ಲಿನ ಜನನ ವಿವರಗಳನ್ನು ಆಧರಿಸಿವೆ.',
          //yearly prediction
          'Planetary Transits': 'ಗ್ರಹಗಳ ಸಂಚಾರ',
          'Categorized Predictions': 'ವರ್ಗೀಕರಿಸಿದ ಭವಿಷ್ಯವಾಣಿಗಳು',
          'Jupiter': 'ಗುರು',
          'Saturn': 'ಶನಿ',
          'Rahu': 'ರಾಹು',
          'Ketu': 'ಕೇತು',
          'Current_Dasa': 'ಪ್ರಸ್ತುತ ದಶೆ',
          'Career Overview': 'ವೃತ್ತಿಜೀವನದ ಅವಲೋಕನ',
          'Finance Overview': 'ಹಣಕಾಸು ಅವಲೋಕನ',
          'Health Overview': 'ಆರೋಗ್ಯದ ಅವಲೋಕನ',
          'Marriage/Relationship Overview': 'ಮದುವೆ/ಸಂಬಂಧದ ಅವಲೋಕನ',
          'Remedies': 'ಪರಿಹಾರಗಳು',
          'Chanting': 'ಜಪ ಮಾಡುವುದು',
          'Puja': 'ಪೂಜೆ',
          'Charity': 'ದಾನ',
          'Regenerate': 'ಪುನರುತ್ಪಾದಿಸು',
          'Consult Astrologer': 'ಜ್ಯೋತಿಷ್ಯರನ್ನು ಸಂಪರ್ಕಿಸಿ',
          'Astrology Consultation': 'ಜ್ಯೋತಿಷ್ಯ ಸಮಾಲೋಚನೆ',
          'First Half of': 'ಮೋಡಲರ್ಧ',
          'Second Half of': 'ದ್ವಿತೀಯಾರ್ಧ',
          //Life predictions
          PlatformTextConfig.lifeTitle: 'ಜೀವನದ ಭವಿಷ್ಯವಾಣಿಗಳು',
          'General\nCharacteristics': 'ಸಾಮಾನ್ಯ\nಗುಣಲಕ್ಷಣಗಳು',
          'Career\nPredictions': 'ವೃತ್ತಿ\nಭವಿಷ್ಯ',
          'Relationship\nPredictions': 'ಸಂಬಂಧದ\nಮುನ್ಸೂಚನೆಗಳು',
          'Wealth\nPredictions': 'ಸಂಪತ್ತಿನ\nಮುನ್ಸೂಚನೆಗಳು',
          'Health\nPredictions': 'ಆರೋಗ್ಯ\nಮುನ್ಸೂಚನೆಗಳು',
          'Current\nTime Period': 'ಪ್ರಸ್ತುತ\nಸಮಯದ ಅವಧಿ',
          //Daily Predictions
          'Upgrade to receive daily predictions at 6 AM':
              'ದಿನನಿತ್ಯದ ಭವಿಷ್ಯವಾಣಿಗಳನ್ನು ಬೆಳಿಗ್ಗೆ 6 ಗಂಟೆಗೆ ಸ್ವೀಕರಿಸಲು ಅಪ್‌ಗ್ರೇಡ್ ಮಾಡಿ',
          'Your daily predictions was scheduled for 6 AM':
              'ನಿಮ್ಮ ದೈನಂದಿನ ಭವಿಷ್ಯವಾಣಿಗಳನ್ನು ಬೆಳಿಗ್ಗೆ 6 ಗಂಟೆಗೆ ನಿಗದಿಪಡಿಸಲಾಗಿತ್ತು',
          'Career': 'ವೃತ್ತಿ',
          'Relationship': 'ಸಂಬಂಧಗಳು',
          'Wealth': 'ಸಂಪತ್ತಿನ',
          'Health': 'ಆರೋಗ್ಯ',
          //Marriage Match Making
          'Marriage Match Making': 'ವಿವಾಹ ಹೊಂದಾಣಿಕೆ',
          'Boy Name': 'ವರನ ಹೆಸರು',
          'Girl Name': 'ವಧುವಿನ ಹೆಸರು',
          'Total Compatibility Score': 'ಒಟ್ಟು ಹೊಂದಾಣಿಕೆ ಸ್ಕೋರ್',
          'Kuta': 'ಕೂಟ',
          'Gained': 'ಗಳಿಸಲಾಗಿದೆ',
          'Max': 'ಗರಿಷ್ಠ',
          'Present': 'ಪ್ರಸ್ತುತ',
          'Absent': 'ಗೈರು',
          'Expert Connect': 'ತಜ್ಞ ಸಂಪರ್ಕ',
          'Check astrological compatibility for a perfect match':
              'ಪರಿಪೂರ್ಣ ಹೊಂದಾಣಿಕೆಗೆ ಜ್ಯೋತಿಷ್ಯ ಹೊಂದಾಣಿಕೆ',
          'Boy Details': 'ವರನ ವಿವರಗಳು',
          'Girl Details': 'ವಧುವಿನ ವಿವರಗಳು',
          'Calculate Match': 'ಹೊಂದಾಣಿಕೆ ಲೆಕ್ಕಹಾಕಿ',
          'Enter boy\'s name': 'ಪುರುಷನ ಹೆಸರು',
          'Enter girl\'s name': 'ಮಹಿಳೆಯ ಹೆಸರು',
          //Subscriptions
          'Subscription': 'ಚಂದಾದಾರಿಕೆಗಳು',
          'Auto Schedule Daily Predictions':
              'ದೈನಂದಿನ ಭವಿಷ್ಯವಾಣಿಗಳನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ವೇಳಾಪಡಿಸಿ',
          'Auto Schedule Weekly Predictions':
              'ವಾರದ ಭವಿಷ್ಯವಾಣಿಗಳನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ವೇಳಾಪಡಿಸಿ',
          'Book Consultations': 'ಸಲಹೆ ಬುಕ್ ಮಾಡಿ',
          'Basic Horoscope Chart': 'ಮೂಲ ಜಾತಕ ಚಾರ್ಟ್',
          'Edit Horoscope Details': 'ಜಾತಕ ವಿವರಗಳನ್ನು ಸಂಪಾದಿಸಿ',
          'Unlimited Number Of Chat Per Week': 'ವಾರಕ್ಕೆ ಅನಿಯಮಿತ ಚಾಟ್‌ಗಳು',
          'Download Chat History': 'ಚಾಟ್ ಇತಿಹಾಸವನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ',
          'Pick Chat Avatar': 'ಚಾಟ್ ಅವತಾರವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Pick Chat Style': 'ಚಾಟ್ ಶೈಲಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Life Predictions': 'ಜೀವನ ಭವಿಷ್ಯವಾಣಿಗಳು',
          'Yearly Predictions': 'ವಾರ್ಷಿಕ ಭವಿಷ್ಯವಾಣಿಗಳು',
          'Personalized Panchang': 'ವೈಯಕ್ತಿಕ ಪಂಚಾಂಗ',
          'Continue': 'ಮುಂದುವರಿಸಿ',
          'Payment Summary': 'ಪಾವತಿ ಸಾರಾಂಶ',
          'Pay Now': 'ಈಗ ಪಾವತಿಸಿ',
          'Plan Cost': 'ಯೋಜನಾ ವೆಚ್ಚ',
          'Discount': 'ರಿಯಾಯಿತಿ',
          'Total Cost': 'ಒಟ್ಟು ವೆಚ್ಚ',
          'Payment Successful': 'Payment Successful',
          'Try Premium Plan': 'ಪ್ರೀಮಿಯಂ ಯೋಜನೆಗಳನ್ನು ಪ್ರಯತ್ನಿಸಿ',
          '1 month': '೧ ತಿಂಗಳು',
          'month': 'ತಿಂಗಳು',
          'months': 'ತಿಂಗಳುಗಳು',
          'year': 'ವರ್ಷ',
          'Compare the plans': 'ಯೋಜನೆಗಳನ್ನು ಹೋಲಿಸಿ',
          'Welcome to\nTeksage!': 'Teksage-ಗೆ ಸುಸ್ವಾಗತ!',
          'Your 24/7 Personal Astrologer is here\n—now at just':
              'ನಿಮ್ಮ 24/7 ವೈಯಕ್ತಿಕ ಜ್ಯೋತಿಷಿ ಇಲ್ಲಿದ್ದಾರೆ - ಇದೀಗ',
          'per month': 'ತಿಂಗಳಿಗೆ',
          'Unlock premium features': 'ಪ್ರೀಮಿಯಂ ವೈಶಿಷ್ಟ್ಯಗಳನ್ನು ಅನ್ಲಾಕ್ ಮಾಡಿ',
          'Unlimited AI voice chat in your own language':
              'ನಿಮ್ಮ ಮಾತೃಭಾಷೆಯಲ್ಲಿ ಅನಿಯಮಿತ AI ಧ್ವನಿ Chat',
          'Yearly insights & life predictions':
              'ವಾರ್ಷಿಕ ಒಳನೋಟಗಳು ಮತ್ತು ಜೀವನ ಭವಿಷ್ಯವಾಣಿಗಳು',
          'Personalised Panchang for your horoscope':
              'ನಿಮ್ಮ ಜಾತಕಕ್ಕಾಗಿ ವೈಯಕ್ತಿಕಗೊಳಿಸಿದ ಪಂಚಾಂಗ',
          'Upgrade Plan': 'Upgrade ಯೋಜನೆ',
          'Skip': 'ಬಿಟ್ಟುಬಿಡಿ',
          'Your Current Plan': 'ನಿಮ್ಮ ಪ್ರಸ್ತುತ\nಯೋಜನೆ',
          'days left': 'ದಿನಗಳು ಉಳಿದಿವೆ',
          'Recommended': 'ಶಿಫಾರಸು ಮಾಡಲಾಗಿದೆ',
          'membership': 'ಸದಸ್ಯತ್ವ',
          //Dialog box
          'Plan Expired': 'ಯೋಜನೆ ಅವಧಿ ಮುಗಿದಿದೆ',
          'Premium Feature': 'ಪ್ರೀಮಿಯಂ ವೈಶಿಷ್ಟ್ಯ',
          'Unlock all features by choosing a plan':
              'ಯೋಜನೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ ಎಲ್ಲಾ ವೈಶಿಷ್ಟ್ಯಗಳನ್ನು ಅನ್ಲಾಕ್ ಮಾಡಿ',
          'Purchase Plan': 'ಯೋಜನೆಯನ್ನು ಖರೀದಿಸಿ',
          'Plan': 'ಯೋಜನೆ',
          'Slots Selected': 'ಸ್ಲಾಟ್‌ಗಳನ್ನು ಆಯ್ಕೆಮಾಡಲಾಗಿದೆ',
          'Selected slots will be lost if you change the date. Would you like to save them first?':
              'ದಿನಾಂಕವನ್ನು ಬದಲಿಸಿದರೆ ಆಯ್ಕೆಮಾಡಿದ ಸ್ಲಾಟ್‌ಗಳು ಕಳೆದುಕೊಳ್ಳುತ್ತವೆ. ಮೊದಲು ಅವುಗಳನ್ನು ಉಳಿಸಬೇಕೇ?',
          'Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!':
              'ನಿಮ್ಮ ನಕ್ಷತ್ರಗಳು ನಿಮಗೆ ಮಾರ್ಗದರ್ಶನ ನೀಡುತ್ತವೆ, ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆ ನಮಗೆ ಮಾರ್ಗದರ್ಶನ ನೀಡುತ್ತದೆ ⭐\nಇಂದು Teksageಗೆ ಮೌಲ್ಯಮಾಪನ ನೀಡಿ!',
          'Rate Now': 'ಈಗ ಮೌಲ್ಯಮಾಪನ ಮಾಡಿ',
          'Allow Location Access': 'ಸ್ಥಳ ಪ್ರವೇಶವನ್ನು ಅನುಮತಿಸಿ',
          'We need your location to get prices in your local currency (INR, USD, etc.)':
              'ನಿಮ್ಮ ಸ್ಥಳೀಯ ಕರೆನ್ಸಿಯಲ್ಲಿ ಬೆಲೆಗಳನ್ನು ಪಡೆಯಲು ನಮಗೆ ನಿಮ್ಮ ಸ್ಥಳ ಅಗತ್ಯವಿದೆ',
          'Allow': 'ಅನುಮತಿಸಿ',
          'Not Allow': 'ಅನುಮತಿಸಬೇಡಿ',
          'Go to Settings': 'ಸೆಟ್ಟಿಂಗ್‌ಗಳಿಗೆ ಹೋಗಿ',
          'Are you sure you want to logout?':
              'ನೀವು ಲಾಗ್ ಔಟ್ ಮಾಡಲು ಖಚಿತವಾಗಿ ಬಯಸುತ್ತೀರಾ?',
          'Discard': 'ತ್ಯಜಿಸಿ',
          'You have unsaved changes.\nDo you want to discard them and go back?':
              'మీరు సేవ్ చేయని మార్పులు ఉన్నాయి.\nమీరు వాటిని విస్మరించి వెనక్కి వెళ్లాలనుకుంటున్నారా?',
          //Error Validate
          'Please Enter the First Name': 'ದಯವಿಟ್ಟು ಮೊದಲ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
          'Please Enter the Second Name': 'ದಯವಿಟ್ಟು ಎರಡನೇ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
          'Please enter a valid Email': 'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಇಮೇಲ್ ಅನ್ನು ನಮೂದಿಸಿ',
          'Please verify your Email': 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇಮೇಲ್ ಅನ್ನು ದೃಢೀಕರಿಸಿ',
          'Enter a valid Email': 'ಮಾನ್ಯವಾದ ಇಮೇಲ್ ಅನ್ನು ನಮೂದಿಸಿ',
          'Select country code': 'ದೇಶದ ಕೋಡ್ ಅನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Enter valid (mobileLengthLimit)-digit number':
              'ಮಾನ್ಯವಾದ (mobileLengthLimit) ಅಂಕಿಯ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'cannot be empty': 'ಖಾಲಿಯಾಗಿರಬಾರದು',
          'Please enter the AI Chat Language':
              'ದಯವಿಟ್ಟು AI ಚಾಟ್ ಭಾಷೆಯನ್ನು ನಮೂದಿಸಿ',
          'Please enter the Date of birth': 'ದಯವಿಟ್ಟು ಜನ್ಮ ದಿನಾಂಕವನ್ನು ನಮೂದಿಸಿ',
          'Please enter the Time of birth': 'ದಯವಿಟ್ಟು ಜನ್ಮ ಸಮಯವನ್ನು ನಮೂದಿಸಿ',
          'Please enter the Place of birth': 'ದಯವಿಟ್ಟು ಜನ್ಮ ಸ್ಥಳವನ್ನು ನಮೂದಿಸಿ',
          'Please select one value': 'ದಯವಿಟ್ಟು ಒಂದು ಮೌಲ್ಯವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Please fill all the required fields':
              'ದಯವಿಟ್ಟು ಅಗತ್ಯವಿರುವ ಎಲ್ಲಾ ವಿವರಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ',
          'Please Enter the valid Mobile Number':
              'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'Choose a preferred language to continue':
              'ಮುಂದುವರಿಯಲು ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          '*This slot is already booked!': 'ಈ ಸಮಯ ಈಗಾಗಲೇ ಬುಕ್ ಮಾಡಲಾಗಿದೆ',
          '* Choose a preferred timing': 'ಆದ್ಯತೆಯ ಸಮಯವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Kindly select one or more categories':
              'ದಯವಿಟ್ಟು ಒಂದು ಅಥವಾ ಹೆಚ್ಚಿನ ವರ್ಗಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Error loading questions': 'ಪ್ರಶ್ನೆಗಳನ್ನು ಲೋಡ್ ಮಾಡುವಲ್ಲಿ ದೋಷ',
          'No questions found': 'ಯಾವುದೇ ಪ್ರಶ್ನೆಗಳು ಕಂಡುಬಂದಿಲ್ಲ',
          "Please enter Boy's name": 'ದಯವಿಟ್ಟು ಹುಡುಗನ ಹೆಸರನ್ನು ನಮೂದಿಸಿ.',
          "Please select Boy's Nakshatram":
              'ದಯವಿಟ್ಟು ಹುಡುಗನ ನಕ್ಷತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ.',
          "Please select Girl's Nakshatram":
              'ದಯವಿಟ್ಟು ಹುಡುಗಿಯರ ನಕ್ಷತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          "Please enter Girl's name": 'ದಯವಿಟ್ಟು ಹುಡುಗಿಯ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
          "Please select Girl's Rasi": 'ದಯವಿಟ್ಟು ಹುಡುಗಿಯರ ರಾಶಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          "Please select Boy's Rasi": 'ದಯವಿಟ್ಟು ಹುಡುಗನ ರಾಶಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Second language must be different from first':
              'ಎರಡನೇ ಭಾಷೆ ಮೊದಲನೆಯದಕ್ಕಿಂತ ಭಿನ್ನವಾಗಿರಬೇಕು.',
          //Snack bar
          'Permission permanently denied. Please enable it in settings.':
              'ಅನುಮತಿ ಶಾಶ್ವತವಾಗಿ ನಿರಾಕರಿಸಲಾಗಿದೆ. ದಯವಿಟ್ಟು ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ಸಕ್ರಿಯಗೊಳಿಸಿ.',
          'Permission Denied': 'ಅನುಮತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ',
          'Payment verification failed. Please try again.':
              'ಪಾವತಿ ದೃಢೀಕರಣ ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Payment failed. Please try again.':
              'ಪಾವತಿ ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Please Contact Support team!': 'ದಯವಿಟ್ಟು ಸಹಾಯ ತಂಡವನ್ನು ಸಂಪರ್ಕಿಸಿ!',
          'Payment Error, Contact Support team!.':
              'ಪಾವತಿ ದೋಷ, ದಯವಿಟ್ಟು ಸಹಾಯ ತಂಡವನ್ನು ಸಂಪರ್ಕಿಸಿ!',
          'Payment successful!': 'ಪಾವತಿ ಯಶಸ್ವಿಯಾಗಿದೆ!',
          'Please enable location permission to access this feature.':
              'ಈ ವೈಶಿಷ್ಟ್ಯವನ್ನು ಬಳಸಲು ಸ್ಥಳ ಅನುಮತಿಯನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ.',
          'Select valid country code and number':
              'ಮಾನ್ಯವಾದ ದೇಶದ ಕೋಡ್ ಮತ್ತು ಸಂಖ್ಯೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Please contact Teksage Admin':
              'ದಯವಿಟ್ಟು Teksage ನಿರ್ವಾಹಕರನ್ನು ಸಂಪರ್ಕಿಸಿ',
          'Error in Fetching Country code': 'ದೇಶದ ಕೋಡ್ ಪಡೆಯುವಲ್ಲಿ ದೋಷವಾಗಿದೆ',
          'Please select a country code first':
              'ಮೊದಲು ದೇಶದ ಕೋಡ್ ಅನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Failed to fetch country list': 'ದೇಶಗಳ ಪಟ್ಟಿಯನ್ನು ಪಡೆಯಲು ವಿಫಲವಾಗಿದೆ',
          'Please select the first language first':
              'ಮೊದಲು ಪ್ರಥಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Failed to save Questions': 'ಪ್ರಶ್ನೆಗಳನ್ನು ಉಳಿಸಲು ವಿಫಲವಾಗಿದೆ',
          'Error creating slots, Please try again.':
              'ಸ್ಲಾಟ್‌ಗಳನ್ನು ರಚಿಸುವಲ್ಲಿ ದೋಷವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Slot Updated Successfully.': 'ಸ್ಲಾಟ್ ಯಶಸ್ವಿಯಾಗಿ ನವೀಕರಿಸಲಾಗಿದೆ..',
          'At least one category must be selected.':
              'ಕನಿಷ್ಠ ಒಂದು ವರ್ಗವನ್ನು ಆಯ್ಕೆಮಾಡಬೇಕು.',
          'At least one language must be selected.':
              'ಕನಿಷ್ಠ ಒಂದು ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಬೇಕು.',
          'We couldn’t fetch your horoscope. Please try again.':
              'ನಿಮ್ಮ ಜಾತಕವನ್ನು ಪಡೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Failed to fetch data. Please try again.':
              'ಡೇಟಾ ಪಡೆಯಲು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Failed to update notification status':
              'ಅಧಿಸೂಚನೆ ಸ್ಥಿತಿಯನ್ನು ನವೀಕರಿಸಲು ವಿಫಲವಾಗಿದೆ',
          'Please try again after sometime':
              'ದಯವಿಟ್ಟು ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ',
          'All Notification has been cleared':
              'ಎಲ್ಲಾ ಅಧಿಸೂಚನೆಗಳನ್ನು ತೆರವುಗೊಳಿಸಲಾಗಿದೆ',
          'Please enable location access to view relevant subscription plans':
              'ಸಂಬಂಧಿತ ಚಂದಾದಾರಿಕೆ ಯೋಜನೆಗಳನ್ನು ನೋಡಲು ಸ್ಥಳ ಪ್ರವೇಶವನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ',
          'Failed to regenerate prediction. Please try again.':
              'ಭವಿಷ್ಯವಾಣಿಯನ್ನು ಮರುಸೃಷ್ಟಿಸಲು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'An error occurred while regenerating. Please try again.':
              'ಮರುಸೃಷ್ಟಿಸುವ ವೇಳೆ ದೋಷ ಸಂಭವಿಸಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Prediction regenerated successfully':
              'ಭವಿಷ್ಯವಾಣಿ ಯಶಸ್ವಿಯಾಗಿ ಮರುಸೃಷ್ಟಿಸಲಾಗಿದೆ',
          'Please enter a valid OTP': 'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ OTP ಅನ್ನು ನಮೂದಿಸಿ',
          'Choose your Style, Avatar and Language to begin your cosmic journey.':
              'ನಿಮ್ಮ ಬ್ರಹ್ಮಾಂಡೀಯ ಪ್ರಯಾಣವನ್ನು ಆರಂಭಿಸಲು ಶೈಲಿ, ಅವತಾರ ಮತ್ತು ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ.',
          'Select a Style and Avatar to begin your cosmic journey.':
              'ನಿಮ್ಮ ಬ್ರಹ್ಮಾಂಡೀಯ ಪ್ರಯಾಣವನ್ನು ಆರಂಭಿಸಲು ಶೈಲಿ ಮತ್ತು ಅವತಾರವನ್ನು ಆಯ್ಕೆಮಾಡಿ.',
          'Select a Style for your answer’s flow.':
              'ನಿಮ್ಮ ಉತ್ತರದ ಹರಿವಿಗಾಗಿ ಒಂದು ಶೈಲಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ.',
          'Select an Avatar that reflects your spirit.':
              'ನಿಮ್ಮ ಆತ್ಮವನ್ನು ಪ್ರತಿಬಿಂಬಿಸುವ ಅವತಾರವನ್ನು ಆಯ್ಕೆಮಾಡಿ.',
          'Select a Language for your answer’s flow.':
              'ನಿಮ್ಮ ಉತ್ತರದ ಹರಿವಿಗಾಗಿ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ.',
          'Keep it short and cosmic — max 300 characters':
              'ಸಂಕ್ಷಿಪ್ತವಾಗಿರಲಿ ಮತ್ತು ಬ್ರಹ್ಮಾಂಡೀಯವಾಗಿರಲಿ — ಗರಿಷ್ಠ 300 ಅಕ್ಷರಗಳು',
          'You can answer only after completing the consultation.':
              'ಸಲಹೆ ಪೂರ್ಣಗೊಳಿಸಿದ ನಂತರ ಮಾತ್ರ ನೀವು ಉತ್ತರಿಸಬಹುದು.',
          'Timeout. Please retry.': 'ಸಮಯ ಮೀರಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Kindly enter your question.': 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಪ್ರಶ್ನೆಯನ್ನು ನಮೂದಿಸಿ.',
          'Your subscription has expired. Subscribe to continue.':
              'ನಿಮ್ಮ ಚಂದಾದಾರಿಕೆ ಅವಧಿ ಮುಗಿದಿದೆ. ಮುಂದುವರಿಯಲು ಚಂದಾದಾರರಾಗಿರಿ.',
          'You’ve reached your message limit. Subscribe to continue.':
              'ನೀವು ಸಂದೇಶ ಮಿತಿಯನ್ನು ತಲುಪಿದ್ದೀರಿ. ಮುಂದುವರಿಯಲು ಚಂದಾದಾರರಾಗಿರಿ.',
          'Retry response timed out.': 'ಮರುಪ್ರಯತ್ನದ ಪ್ರತಿಕ್ರಿಯೆಗೆ ಸಮಯ ಮೀರಿದೆ.',
          'Response is taking longer than expected. Please check your network.':
              'ಪ್ರತಿಕ್ರಿಯೆ ನಿರೀಕ್ಷೆಗಿಂತ ಹೆಚ್ಚು ಸಮಯ ತೆಗೆದುಕೊಳ್ಳುತ್ತಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ನೆಟ್ವರ್ಕ್ ಪರಿಶೀಲಿಸಿ.',
          'Thanks for reaching out! Your query has been received — our team will respond shortly.':
              'ಸಂಪರ್ಕಿಸಿದಕ್ಕಾಗಿ ಧನ್ಯವಾದಗಳು! ನಿಮ್ಮ ಪ್ರಶ್ನೆ ಸ್ವೀಕರಿಸಲಾಗಿದೆ — ನಮ್ಮ ತಂಡ ಶೀಘ್ರದಲ್ಲೇ ಪ್ರತಿಕ್ರಿಯಿಸುತ್ತದೆ.',
          'Something went wrong. Please try again.':
              'ಏನೋ ತಪ್ಪಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Logout failed. Please try again.':
              'ಲಾಗೌಟ್ ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'Thanks for using Teksage': 'Teksage ಬಳಸಿದ್ದಕ್ಕಾಗಿ ಧನ್ಯವಾದಗಳು',
          'Your message looks empty after removing hidden characters. Try typing or paste plain text.':
              'ಮರೆಮಾಡಿದ ಅಕ್ಷರಗಳನ್ನು ತೆಗೆದುಹಾಕಿದ ನಂತರ ನಿಮ್ಮ ಸಂದೇಶ ಖಾಲಿಯಾಗಿ ಕಾಣುತ್ತದೆ. ಸರಳ ಪಠ್ಯವನ್ನು ಟೈಪ್ ಮಾಡಲು ಅಥವಾ ಅಂಟಿಸಲು ಪ್ರಯತ್ನಿಸಿ.',
          'Error in sending OTP': 'OTP ಕಳುಹಿಸುವಲ್ಲಿ ದೋಷ',
          'Network error. Please check your connection and try again.':'ನೆಟ್‌ವರ್ಕ್ ದೋಷ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಸಂಪರ್ಕವನ್ನು ಪರಿಶೀಲಿಸಿ ಹಾಗೂ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
          'OTP Verified':'OTP ಪರಿಶೀಲಿಸಲಾಗಿದೆ',
          //Astrology consultations
          'What do you\nneed guidance on?':
              'ನೀವು ಯಾವ ವಿಷಯದಲ್ಲಿ ಮಾರ್ಗದರ್ಶನ ಬಯಸುತ್ತೀರಿ?',
          'Select the categories and continue':
              'ವರ್ಗಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ ಮುಂದುವರಿಯಿರಿ',
          'Marriage & relationships': 'ವಿವಾಹ ಮತ್ತು ಸಂಬಂಧಗಳು',
          'Marriage & Relationships': 'ವಿವಾಹ ಮತ್ತು ಸಂಬಂಧಗಳು',
          'All': 'ಎಲ್ಲಾ',
          'Choose your\npreferred language':
              'ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'This will help us to match the best astrologer':
              'ಇದು ನಿಮ್ಮಿಗೆ ಸೂಕ್ತವಾದ ಜ್ಯೋತಿಷಿಯನ್ನು ಹೊಂದಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ',
          'First Preference': 'ಮೊದಲ ಆದ್ಯತೆ',
          'Second Preference': 'ಎರಡನೇ ಆದ್ಯತೆ',
          'Select language': 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
          'Top 5 astrologers\nbased on preferences':
              'ಆದ್ಯತೆಗಳ ಆಧಾರದ ಮೇಲೆ ಟಾಪ್ 5 ಜ್ಯೋತಿಷಿಗಳು',
          'Expert Profile': 'ತಜ್ಞರ ಪ್ರೊಫೈಲ್',
          'Reviews': 'ವಿಮರ್ಶೆಗಳು',
          'No reviews available': 'ಯಾವುದೇ ವಿಮರ್ಶೆಗಳು ಲಭ್ಯವಿಲ್ಲ',
          'Book Consultation': 'ಸಲಹೆ ಬುಕ್ ಮಾಡಿ',
          'No slots available': 'ಯಾವುದೇ ಸ್ಲಾಟ್‌ಗಳು ಲಭ್ಯವಿಲ್ಲ',
          'Find & Consult Astrologers': 'ಜ್ಯೋತಿಷಿಗಳನ್ನು ಹುಡುಕಿ ಮತ್ತು ಸಮಾಲೋಚಿಸಿ',
          '100+ Astrologers': '100+ ಜ್ಯೋತಿಷಿಗಳು',
          'Explore and find your perfect match':
              'ನಿಮ್ಮ ಪರಿಪೂರ್ಣ ಹೊಂದಾಣಿಕೆಯನ್ನು ಅನ್ವೇಷಿಸಿ ಮತ್ತು ಹುಡುಕಿ',
          'Upcoming': 'ಮುಂಬರುವ',
          'Completed': 'ಪೂರ್ಣಗೊಂಡಿದೆ',
          'View Details': 'ವಿವರಗಳನ್ನು\nವೀಕ್ಷಿಸಿ',
          'View\nDetails': 'ವಿವರಗಳನ್ನು\nವೀಕ್ಷಿಸಿ',
          'Meeting Link': 'meeting\nಲಿಂಕ್',
          'Choose your avatar': 'ನಿಮ್ಮ ಅವತಾರವನ್ನು ಆರಿಸಿ',
          'Choose how AI replies': 'AI ಹೇಗೆ ಉತ್ತರಿಸುತ್ತದೆ ಎಂಬುದನ್ನು ಆರಿಸಿ',
          'Concise': 'ಸಂಕ್ಷಿಪ್ತ',
          'Booking Details': 'Booking ವಿವರಗಳು',
          'Consultation Fee': 'ಸಲಹೆ ಶುಲ್ಕ',
          'Total Fee': 'ಒಟ್ಟು ಶುಲ್ಕ',
          'Confirm & Proceed to Pay': 'ದೃಢೀಕರಿಸಿ ಮತ್ತು ಪಾವತಿಗೆ ಮುಂದುವರಿಯಿರಿ',
          'Consultation Details': 'ಸಮಾಲೋಚನೆ ವಿವರಗಳು',
          'Consulting On': 'ಸಲಹೆ ನೀಡುತ್ತಿರುವ ವಿಷಯ',
          'Give Rating': 'ರೇಟಿಂಗ್ ನೀಡಿ',
          'Ratings': 'ರೇಟಿಂಗ್‌ಗಳು',
          'You have no upcoming meetings at the moment.':
              'ನೀವು ಈ ಸಮಯದಲ್ಲಿ ಯಾವುದೇ ಮುಂಬರುವ ಸಭೆಗಳನ್ನು ಹೊಂದಿಲ್ಲ.',
          'You have no completed meetings at the moment.':
              'ನೀವು ಈ ಸಮಯದಲ್ಲಿ ಯಾವುದೇ ಪೂರ್ಣಗೊಂಡ ಸಭೆಗಳನ್ನು ಹೊಂದಿಲ್ಲ.',
          'Book Now': 'ಈಗ ಬುಕ್ ಮಾಡಿ',
          'Yes': 'ಹೌದು',
          'No': 'ಇಲ್ಲ',
          'Queries you asked': 'ನೀವು ಕೇಳಿದ ಪ್ರಶ್ನೆಗಳು',
          'Enter Promo Code': 'ಪ್ರೋಮೋ ಕೋಡ್ ನಮೂದಿಸಿ',
          'Applied': 'ಅನ್ವಯಿಸಲಾಗಿದೆ',
          'Apply': 'ಅನ್ವಯಿಸಿ',
          'I consent to share my personal information & horoscope with the astrologer':
              'ನನ್ನ ವೈಯಕ್ತಿಕ ಮಾಹಿತಿ ಮತ್ತು ಜಾತಕವನ್ನು ಜ್ಯೋತಿಷಿಯೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳಲು ನಾನು ಒಪ್ಪಿಗೆ ನೀಡುತ್ತೇನೆ.',
          'I consent to share my personal information & star chart with the advisor':
              'ನನ್ನ ವೈಯಕ್ತಿಕ ಮಾಹಿತಿ ಮತ್ತು ನಕ್ಷತ್ರ ಪಟ್ಟಿಯನ್ನು ಸಲಹೆಗಾರರೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳಲು ನಾನು ಸಮ್ಮತಿಸುತ್ತೇನೆ',
          'Kindly select your preferred language':
              'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆರಿಸಿ',
          'Write your consultation query here':
              'ನಿಮ್ಮ ಸಮಾಲೋಚನೆ ಪ್ರಶ್ನೆಯನ್ನು ಇಲ್ಲಿ ಬರೆಯಿರಿ',
          'Enter your question here...': 'ನಿಮ್ಮ ಪ್ರಶ್ನೆಯನ್ನು ಇಲ್ಲಿ ನಮೂದಿಸಿ...',
          'Next': 'ಮುಂದೆ',
          'Previous': 'ಹಿಂದಿನದು',
          '* All questions are required to help us serve you better.':
              '* ನಿಮಗೆ ಉತ್ತಮವಾಗಿ ಸೇವೆ ಸಲ್ಲಿಸಲು ನಮಗೆ ಸಹಾಯ ಮಾಡಲು ಎಲ್ಲಾ ಪ್ರಶ್ನೆಗಳು ಅಗತ್ಯವಿದೆ.',
          'Slots': 'ಸ್ಲಾಟ್‌ಗಳು',
          '30 mins each': 'ತಲಾ\n30 ನಿಮಿಷಗಳು',
          'Astrologer submitted answers for your queries':
              'ನಿಮ್ಮ ಪ್ರಶ್ನೆಗಳಿಗೆ ಜ್ಯೋತಿಷಿಗಳು ಉತ್ತರಗಳನ್ನು ಸಲ್ಲಿಸಿದ್ದಾರೆ.',
          'Meet Again': 'ಮತ್ತೆ\nಭೇಟಿಯಾಗೋಣ',
          'Rate your experience with this astrologer appointment':
              'ಈ ಜ್ಯೋತಿಷಿ ನೇಮಕಾತಿಯೊಂದಿಗೆ ನಿಮ್ಮ ಅನುಭವವನ್ನು ರೇಟ್ ಮಾಡಿ',
          'Save & Submit': 'ಉಳಿಸಿ ಮತ್ತು ಸಲ್ಲಿಸಿ',
          'Type your answer here...': 'ನಿಮ್ಮ ಉತ್ತರವನ್ನು ಇಲ್ಲಿ ಟೈಪ್ ಮಾಡಿ...',
          'Done': 'ಮುಗಿದಿದೆ',
          'booked a slot on': 'ಸ್ಲಾಟ್\nಬುಕ್ ಮಾಡಲಾಗಿದೆ',
          "meeting_with": "{name} ಜೊತೆ ಸಭೆ",
          //Voice chat
          'Jyotish voice guide for all your needs. Start you conversation today':
              'ನಿಮ್ಮ ಎಲ್ಲಾ ಅಗತ್ಯಗಳಿಗಾಗಿ ಜ್ಯೋತಿಷ ಧ್ವನಿ ಮಾರ್ಗದರ್ಶಿ. ಇಂದು ನಿಮ್ಮ ಸಂಭಾಷಣೆಯನ್ನು ಪ್ರಾರಂಭಿಸಿ',
          'Jyotish voice guide for all your needs':
              'ನಿಮ್ಮ ಎಲ್ಲಾ ಅಗತ್ಯಗಳಿಗಾಗಿ ಜ್ಯೋತಿಷ್ ಧ್ವನಿ ಮಾರ್ಗದರ್ಶಿ',
          'The Seeker': 'ಅನ್ವೇಷಕ',
          'The Luminary': 'ಪ್ರಕಾಶಕ',
          'The Guardian': 'ರಕ್ಷಕ',
          'The Pathfinder': 'ಮಾರ್ಗಶೋಧಕ',
          'Ideal for those who want in-depth astrological analysis and clear reasoning':
              'ಆಳವಾದ ಜ್ಯೋತಿಷ್ಯ ವಿಶ್ಲೇಷಣೆ ಮತ್ತು ಸ್ಪಷ್ಟ ತಾರ್ಕಿಕತೆಯನ್ನು ಬಯಸುವವರಿಗೆ ಸೂಕ್ತವಾಗಿದೆ.',
          'Ideal for those who seek joyful and engaging astrology guidance':
              'ಸಂತೋಷದಾಯಕ ಮತ್ತು ಆಕರ್ಷಕ ಜ್ಯೋತಿಷ್ಯ ಮಾರ್ಗದರ್ಶನವನ್ನು ಬಯಸುವವರಿಗೆ ಸೂಕ್ತವಾಗಿದೆ',
          'Ideal for those looking for reassurance and personal connection in predictions':
              'ಭವಿಷ್ಯವಾಣಿಗಳಲ್ಲಿ ಧೈರ್ಯ ಮತ್ತು ವೈಯಕ್ತಿಕ ಸಂಪರ್ಕವನ್ನು ಬಯಸುವವರಿಗೆ ಸೂಕ್ತವಾಗಿದೆ',
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions':
              'ವೃತ್ತಿ ಬೆಳವಣಿಗೆ, ಯಶಸ್ಸಿನ ತಂತ್ರಗಳು ಅಥವಾ ಸ್ಪಷ್ಟ ಪರಿಹಾರಗಳನ್ನು ಬಯಸುವವರಿಗೆ ಸೂಕ್ತವಾಗಿದೆ',
          'Tap the mic': 'ಮೈಕ್ ಟ್ಯಾಪ್ ಮಾಡಿ',
          'Start speaking in your own language':
              'ನಿಮ್ಮ ಮಾತೃಭಾಷೆಯಲ್ಲಿ ಮಾತನಾಡಲು ಪ್ರಾರಂಭಿಸಿ',
          'Chat or record your thoughts...': 'Chat or record your thoughts...',
          'AI can understand all languages':
              'AI ಎಲ್ಲಾ ಭಾಷೆಗಳನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಬಲ್ಲದು.',
          'Got it, typing that up for you…':
              'ಅರ್ಥವಾಯಿತು, ನಿಮಗಾಗಿ ಅದನ್ನು ಟೈಪ್ ಮಾಡುತ್ತಿದ್ದೇನೆ...',
          'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology.':
              'ವಿವರಣೆ - ಆಲ್-ಪವರ್ಡ್ ಜ್ಯೋತಿಷ್ಯದೊಂದಿಗೆ ನಿಮ್ಮ ಭವಿಷ್ಯ, ವೃತ್ತಿ, ಸಂಬಂಧಗಳು ಮತ್ತು ಹೆಚ್ಚಿನವುಗಳ ಬಗ್ಗೆ ವೈಯಕ್ತಿಕಗೊಳಿಸಿದ ಒಳನೋಟಗಳನ್ನು ಅನ್ಲಾಕ್ ಮಾಡಿ',
          'Generate Yearly Prediction': 'ವಾರ್ಷಿಕ ಭವಿಷ್ಯವಾಣಿಯನ್ನು ರಚಿಸಿ',
          'Generate Life Prediction': 'ಜೀವನ ಭವಿಷ್ಯವಾಣಿಯನ್ನು ರಚಿಸಿ',
          'Quick, direct replies without extra details — ideal for instant answers.':
              'ಹೆಚ್ಚುವರಿ ವಿವರಗಳಿಲ್ಲದೆ ತ್ವರಿತ, ನೇರ ಪ್ರತ್ಯುತ್ತರಗಳು - ತ್ವರಿತ ಉತ್ತರಗಳಿಗೆ ಸೂಕ್ತವಾಗಿದೆ',
          'Explanatory': 'ವಿವರಣಾತ್ಮಕ',
          'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.':
              'ಹಂತ-ಹಂತದ ಸ್ಪಷ್ಟತೆಯೊಂದಿಗೆ ಆಳವಾದ, ರಚನಾತ್ಮಕ ಪ್ರತ್ಯುತ್ತರಗಳು - ಕಲಿಕೆ ಅಥವಾ ವಿವರವಾದ ಒಳನೋಟಗಳಿಗೆ ಪರಿಪೂರ್ಣ',
          'Choose an avatar for AI': 'AI ಗಾಗಿ ಅವತಾರವನ್ನು ಆರಿಸಿ',
          'Related questions': 'ಸಂಬಂಧಿತ ಪ್ರಶ್ನೆಗಳು',
          'No response.': 'ಯಾವುದೇ ಪ್ರತಿಕ್ರಿಯೆ ಇಲ್ಲ.',
          'Retry': 'ಮರುಪ್ರಯತ್ನಿಸಿ',
          'Subscribe Now': 'ಈಗ ಚಂದಾದಾರರಾಗಿ',
          //Delete Account
          'We value your experience.\nWhat made you decide to leave?':
              'ನಿಮ್ಮ ಅನುಭವವನ್ನು ನಾವು ಗೌರವಿಸುತ್ತೇವೆ.\nನೀವು ಬಿಡಲು ನಿರ್ಧರಿಸಲು ಕಾರಣವೇನು?',
          "I am having another account": 'ನನಗೆ ಬೇರೆ ಖಾತೆ ಇದೆ',
          'App not working properly':
              'ಅಪ್ಲಿಕೇಶನ್ ಸರಿಯಾಗಿ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತಿಲ್ಲ',
          'I don’t like the app': 'ನನಗೆ ಈ ಆ್ಯಪ್ ಇಷ್ಟವಿಲ್ಲ',
          'I am worried about my privacy':
              'ನನ್ನ ಗೌಪ್ಯತೆಯ ಬಗ್ಗೆ ನನಗೆ ಚಿಂತೆಯಾಗಿದೆ',
          'You are about to delete\nyour account':
              'ನೀವು ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಅಳಿಸಲಿದ್ದೀರಿ',
          'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days':
              'ಈ ಖಾತೆಗೆ ಸಂಬಂಧಿಸಿದ ಎಲ್ಲಾ ಡೇಟಾವನ್ನು (ನಿಮ್ಮ ಪ್ರೊಫೈಲ್, ಸೇವೆ, ಬುಕಿಂಗ್‌ಗಳು, ಜಾತಕಗಳು, ಭವಿಷ್ಯವಾಣಿಗಳು ಸೇರಿದಂತೆ) 45 ದಿನಗಳಲ್ಲಿ ಶಾಶ್ವತವಾಗಿ ಅಳಿಸಲಾಗುತ್ತದೆ',
          'Delete Account Now': 'ಈಗ ಖಾತೆಯನ್ನು ಅಳಿಸಿ',
          'No, I have changed my mind':
              'ಇಲ್ಲ, ನಾನು ನನ್ನ ಮನಸ್ಸನ್ನು ಬದಲಾಯಿಸುತ್ತಿದ್ದೇನೆ',
          //Astrologer
          'You logged in as Astrologer': 'ನೀವು ಜ್ಯೋತಿಷಿಯಾಗಿ\nಲಾಗಿನ್ ಆಗಿದ್ದೀರಿ.',
          'Meetings': 'ಬುಕಿಂಗ್‌ಗಳು',
          'View your scheduled appointments & completed ones':
              'ನಿಮ್ಮ ನಿಗದಿತ ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್‌ಗಳು ಮತ್ತು ಪೂರ್ಣಗೊಂಡವುಗಳನ್ನು ವೀಕ್ಷಿಸಿ',
          'My Availability': 'ನನ್ನ ವೇಳಾಪಟ್ಟಿ',
          'Set your available time slots.':
              'നിങ്ങളുടെ സമയ സ്ലോട്ടുകൾ സജ്ജമാക്കുക.',
          'Select the slots that you are available':
              'ನಿಮ್ಮ ಲಭ್ಯವಿರುವ ಸ್ಲಾಟ್‌ಗಳನ್ನು ಆರಿಸಿ',
          'Showing the available time that you picked':
              'ನಿಮ್ಮ ಆಯ್ಕೆ ಮಾಡಿದ ಸಮಯ ಸ್ಲಾಟ್‌ಗಳು',
          'Morning': 'ಬೆಳಗ್ಗೆ',
          'Afternoon': 'ಮಧ್ಯಾಹ್ನ',
          'Horoscope Details': 'ಜಾತಕ ವಿವರಗಳು',
          'Horoscope details are not available': 'ಜಾತಕ ವಿವರಗಳು ಲಭ್ಯವಿಲ್ಲ.',
          'Answer': 'ಉತ್ತರ',
          'View': 'ನೋಡಿ',
          "Queries asked - Time to share your thoughts!":
              "ಕೇಳಿದ ಪ್ರಶ್ನೆಗಳು - ನಿಮ್ಮ ಆಲೋಚನೆಗಳನ್ನು ಹಂಚಿಕೊಳ್ಳಲು ಇದು ಸಮಯ.",
          "Queries asked - You've already shared your thoughts!":
              "ಕೇಳಿದ ಪ್ರಶ್ನೆಗಳು - ನೀವು ಈಗಾಗಲೇ ನಿಮ್ಮ ಆಲೋಚನೆಗಳನ್ನು ಹಂಚಿಕೊಂಡಿದ್ದೀರಿ!",
          'Date': 'ದಿನಾಂಕ',
          'Time': 'ಸಮಯ',
          'Fees Paid': 'ಪಾವತಿಸಿದ ಶುಲ್ಕಗಳು',
          'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.':
              'ನಿಮ್ಮ ಜೀವನದ ಈ ಅರ್ಥಪೂರ್ಣ ಹಂತದಲ್ಲಿ ನಿಮ್ಮ ಚಾರ್ಟ್ ನೀಡುವ ಒಳನೋಟಗಳ ಮೂಲಕ ನಿಮಗೆ ಮಾರ್ಗದರ್ಶನ ನೀಡುವುದು ಒಂದು ಸವಲತ್ತು',
          'Tamil': 'தமிழ்',
          'English': 'English',
          'Telugu': 'తెలుగు',
          'Malayalam': 'മലയാളം',
          'Kannada': 'ಕನ್ನಡ',
          'Hindi': 'हिन्दी',
          'Bengali': 'বাংলা',
          'Marathi': 'मराठी',
          'Urdu': 'اردو',
          'Gujarati': 'ગુજરાતી',
          'Odia': 'ଓଡ଼ିଆ',
          'Punjabi': 'ਪੰਜਾਬੀ',
          'Assamese': 'অসমীয়া',
          'Bhojpuri': 'भोजपुरी',
          'Kashmiri': 'کٲشُر',
          'Nepali': 'नेपाली',
          'Sindhi': 'سنڌي',
          'Sinhala': 'සිංහල',
          'Maithili': 'मैथिली',
          'Manipuri': 'মৈতৈলোন্',
          'Santali': 'ᱥᱟᱱᱛᱟᱲᱤ',
          'Years of Experience': 'ಅನುಭವದ ವರ್ಷಗಳು',
          'years': 'ವರ್ಷಗಳು',
          'Showing Availability': 'ಲಭ್ಯತೆಯನ್ನು\nತೋರಿಸಲಾಗುತ್ತಿದೆ',
          //OTP Screen
          "resend_otp_in_seconds": "OTP ಮರುಕಳುಹಿಸಲು {seconds} ಸೆಕೆಂಡುಗಳು",
          'Enter Mobile Number': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
          'Enter Email': 'ಇಮೇಲ್ ನಮೂದಿಸಿ',
          'Enter your new email and verify it using OTP':
              'ನಿಮ್ಮ ಹೊಸ ಇಮೇಲ್ ಅನ್ನು ನಮೂದಿಸಿ ಮತ್ತು OTP ಬಳಸಿ ಅದನ್ನು ಪರಿಶೀಲಿಸಿ.',
          'Enter your new phone number and verify it using OTP':
              'ನಿಮ್ಮ ಹೊಸ ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ ಮತ್ತು OTP ಬಳಸಿ ಅದನ್ನು ಪರಿಶೀಲಿಸಿ.',
          'Verify Phone Number': 'ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ಪರಿಶೀಲಿಸಿ',
          'Verify Email': 'ಇಮೇಲ್ ಪರಿಶೀಲಿಸಿ',
          'Verify Existing Phone Number':
              'ಅಸ್ತಿತ್ವದಲ್ಲಿರುವ ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ಪರಿಶೀಲಿಸಿ',
          'Verify Existing Email': 'ಅಸ್ತಿತ್ವದಲ್ಲಿರುವ ಇಮೇಲ್ ಅನ್ನು ಪರಿಶೀಲಿಸಿ',
          'For security reasons, kindly verify your existing phone number':
              'ಭದ್ರತಾ ಕಾರಣಗಳಿಗಾಗಿ, ದಯವಿಟ್ಟು ನಿಮ್ಮ ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ಪರಿಶೀಲಿಸಿ.',
          'For security reasons, kindly verify your existing email':
              'ಭದ್ರತಾ ಕಾರಣಗಳಿಗಾಗಿ, ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇಮೇಲ್ ಅನ್ನು ಪರಿಶೀಲಿಸಿ.',
          'We have sent OTP to': 'ನಾವು OTP ಕಳುಹಿಸಿದ್ದೇವೆ',
          'OTP is valid for 5 Minutes.': 'OTP 5 ನಿಮಿಷಗಳವರೆಗೆ ಮಾನ್ಯವಾಗಿರುತ್ತದೆ.',
          'Resend OTP': 'OTP ಮತ್ತೆ ಕಳುಹಿಸಿ',
          //Internet
          'No Internet Connection': 'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವಿಲ್ಲ',
          'Please check your\nnetwork settings':
              'ದಯವಿಟ್ಟು ನಿಮ್ಮ ನೆಟ್‌ವರ್ಕ್ ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.',
        },
        'ml_IN': {
          'Good day': 'നമസ്കാരം',
          'Astrologer': 'ജ്യോതിഷി',
          'Home': 'വീട്',
          'Panchang': 'പഞ്ചാംഗം',
          'Horoscope': 'ജാതകം',
          'Settings': 'ക്രമീകരണം ',
          'Marriage\nMatch Making': 'വിവാഹ\nപൊരുത്തം',
          'Explore Other Predictions': 'മറ്റ് പ്രവചനങ്ങൾ\nപര്യവേക്ഷണം ചെയ്യുക',
          PlatformTextConfig.yearlyPrediction: 'വാർഷിക\nപ്രവചനങ്ങൾ',
          PlatformTextConfig.weeklyPrediction: 'പ്രതിവാര\nപ്രവചനങ്ങൾ',
          PlatformTextConfig.lifePrediction: 'ജീവിത\nപ്രവചനങ്ങൾ',
          PlatformTextConfig.dailyPrediction: 'പ്രതിദിന\nപ്രവചനങ്ങൾ',
          PlatformTextConfig.chatHomePage: 'AI വോയ്‌സ്\nആസ്ട്രോ ചാറ്റ് ചെയ്യൂ',
          'ChatTitle': 'AI വോയ്‌സ് ചാറ്റ്',
          'Chat Now': 'ഇപ്പോൾ\nചാറ്റ്',
          'Thara Bala': 'താര ഭലം',
          'Chandra Bala': 'ചന്ദ്ര ബലം',
          'Astrologer\nConsultation': 'ജ്യോതിഷിയെ\nസമീപിക്കുക',
          'Astrologer Consultation': 'ജ്യോതിഷിയെ സമീപിക്കുക',
          'My Profile': 'എൻ്റെ\nപ്രൊഫൈൽ',
          //settings
          'Profile': 'പ്രൊഫൈൽ',
          'Push Notifications': 'പുഷ് അറിയിപ്പുകൾ',
          'Language': 'ഭാഷ',
          'Subscriptions': 'സബ്സ്ക്രിപ്ഷനുകൾ',
          'Terms & Conditions': 'ഉപാധികളും നിബന്ധനകളും',
          'Privacy Policy': 'സ്വകാര്യതാ നയം',
          'Support': 'പിന്തുണ',
          'FAQs': 'പതിവായി ചോദ്യങ്ങൾ',
          'Rate us': 'ഞങ്ങളെ റേറ്റുചെയ്യുക',
          'Rate': 'റേറ്റ്',
          'Delete Account': 'അക്കൗണ്ട് ഇല്ലാതാക്കുക',
          'Logout': 'പുറത്തുകടക്കുക',
          'Language Updated': 'ഭാഷ മാറി',
          'App language has been changed successfully':
              'ആപ്പ് ഭാഷ വിജയകരമായി മാറ്റി.',
               'Click to view':'കാണാൻ ക്ലിക്ക് ചെയ്യുക',
          //Profile
          'First Name': 'പേരിന്റെ ആദ്യഭാഗം',
          'Last Name': 'പേരിന്റെ അവസാന ഭാഗം',
          'Email': 'ഇമെയിൽ',
          'Phone Number': 'ഫോൺ നമ്പർ',
          'AI Chat Language': 'AI ചാറ്റ് ഭാഷ',
          'Date of Birth': 'ജനനത്തീയതി',
          'Time of Birth': 'ജനന സമയം',
          'Place of Birth': 'ജനനസ്ഥലം',
          'Current Location': 'നിലവിലെ സ്ഥാനം',
          'Rasi': 'രാശി',
          'Nakshatram': 'നക്ഷത്രം',
          'Edit': 'തിരുത്തുക',
          'Profile Details': 'പ്രൊഫൈൽ വിശദാംശങ്ങൾ',
          'Complete Profile': 'പൂർണ്ണ പ്രൊഫൈൽ',
          'Save': 'സംരക്ഷിക്കുക',
          'Hi (name)!': 'ഹായ് (name)!',
          'Verify': 'സ്ഥിരീകരിക്കുക',
          'Change': 'നവാംസം',
          'Enter place of birth': 'ജനന സ്ഥലം നൽകുക',
          'Enter Current location': 'നിലവിലെ സ്ഥലം നൽകുക',
          'Select a place': 'ഒരു സ്ഥലം തിരഞ്ഞെടുക്കുക',
          'Select any one Option': '',
          'How did you first hear about Teksage':
              'Teksageയെക്കുറിച്ച് നിങ്ങൾ ആദ്യമായി എങ്ങനെ അറിഞ്ഞു',
          'How did you first hear about Teksage?':
              'Teksageയെക്കുറിച്ച് നിങ്ങൾ ആദ്യമായി എങ്ങനെ അറിഞ്ഞു?',
          'Select a language': 'ഒരു ഭാഷ തിരഞ്ഞെടുക്കുക',
          "Google Play Store / App Store": "Google Play Store / App Store",
          "Google Search": "Google തിരയൽ",
          "Quora": "Quora",
          "Facebook / Instagram": "Facebook / Instagram",
          "YouTube": "YouTube",
          "WhatsApp / Telegram (friends or groups)": "WhatsApp / Telegram",
          "Word of mouth (friends/family)":
              "വായ്മൊഴി ശുപാർശ (സുഹൃത്തുകൾ / കുടുംബം)",
          "Product Hunt": "Product Hunt",
          "Other": "മറ്റ്",
          //Push Notification
          'Push Notification': 'പുഷ് അറിയിപ്പുകൾ',
          PlatformTextConfig.dailyTitle: 'ദൈനംദിന പ്രവചനങ്ങൾ',
          PlatformTextConfig.weeklyTitle: 'പ്രതിവാര പ്രവചനങ്ങൾ',
          PlatformTextConfig.yearlyTitle: 'വാർഷിക പ്രവചനങ്ങൾ',
          PlatformTextConfig.lifePredictionLanding: 'ജീവിത പ്രവചനം',
          'Promotions & Offers': 'പ്രമോഷനും ഓഫറുകളും',
          'Warnings': 'മുന്നറിയിപ്പ്',
          'Consultation': 'കൺസൾട്ടേഷൻ',
          'General': 'ജനറൽ',
          'Astrologer appointment on': 'ജ്യോതിഷി\nഅപ്പോയിന്റ്മെന്റ് ഇന്ന്',
          'You have an appointment on':
              'നിങ്ങൾക്ക് ഒരു\nഅപ്പോയിന്റ്മെന്റ് ഉണ്ട്',
          'Your Daily Prediction have been generated':
              'നിങ്ങളുടെ ദൈനംദിന പ്രവചനം സൃഷ്ടിക്കപ്പെട്ടു',
          'Your Weekly Prediction have been generated':
              'നിങ്ങളുടെ ആഴ്ചതോറുമുള്ള പ്രവചനം തയ്യാറാക്കി',
          'Your Yearly Prediction have been generated':
              'നിങ്ങളുടെ വാർഷിക പ്രവചനം തയ്യാറാക്കി',
          'Clear All': 'എല്ലാം\nമായ്‌ക്കുക',
          'Daily Prediction': 'പ്രതിദിന പ്രവചനങ്ങൾ',
          'Weekly Prediction': 'പ്രതിവാര പ്രവചനങ്ങൾ',
          'Yearly Prediction': 'വാർഷിക പ്രവചനം',
          'Notifications': 'അറിയിപ്പുകൾ',
          'There are no Consultation updates.':
              'കൺസൾട്ടേഷൻ അപ്‌ഡേറ്റുകളൊന്നുമില്ല.',
          'There are no recent general updates from your astrological guidance':
              'നിങ്ങളുടെ ജ്യോതിഷ മാർഗ്ഗനിർദ്ദേശത്തിൽ നിന്ന് അടുത്തിടെ പൊതുവായ അപ്‌ഡേറ്റുകളൊന്നുമില്ല.',
          //support
          'Got a question?\nOur support team is here to guide your path':
              'ഒരു ചോദ്യമുണ്ടോ?\nനിങ്ങളുടെ പാതയെ നയിക്കാൻ ഞങ്ങളുടെ പിന്തുണാ ടീം ഇവിടെയുണ്ട്.',
          'Enter feedback or query here...': 'ഇവിടെ ഫീഡ്‌ബാക്കോ ചോദ്യമോ നൽകുക',
          'Submit': 'സമർപ്പിക്കുക',
          //FAQs
          'Find answers to common questions\nabout our astrology services.':
              'ഞങ്ങളുടെ ജ്യോതിഷ സേവനങ്ങളെക്കുറിച്ചുള്ള പതിവ്\nചോദ്യങ്ങൾക്ക് ഉത്തരം കണ്ടെത്തുക',
          'Still have questions?': 'ഇപ്പോഴും ചോദ്യങ്ങളുണ്ടോ?',
          'Contact Support': 'പിന്തുണയ്ക്കായി ബന്ധപ്പെടുക',
          'search_help': 'തിരയൽ സഹായം',
          //panchang
          'WeekDay': 'ആഴ്ച',
          'Thithi': 'തിഥി',
          'Karna': 'കരണം',
          'Yoga': 'യോഗം',
          'Sunrise': 'സൂര്യോദയം',
          'Sunset': 'സൂര്യാസ്തമയം',
          'Rahu Kalam': 'രാഹു കാലം',
          'Yama Kanda': 'യമ ഗണ്ഡം',
          'Auspicious Time': 'ശുഭ മുഹൂർത്തം',
          'Paksha': 'പക്ഷ',
          'Amirthathi Yoga': 'അമൃത യോഗം',
          'COMING SOON': 'ഉടൻ വരുന്നു',
          "panchang_single_format": "(name) വരെ (time) (next)",
          'otp_response': "(title) പരിശോധന\nOTP വിജയകരമായി അയച്ചു.",

          //Horoscope
          PlatformTextConfig.horoscope: 'ജാതകം',
          'Name': 'പേര്',
          'Place': 'സ്ഥലം',
          'Lagna': 'ലഗ്നം',
          'South Indian Chart': 'ദക്ഷിണേന്ത്യൻ ചാർട്ട്',
          'North Indian Chart': 'ഉത്തരേന്ത്യൻ ചാർട്ട്',
          //weekly predictions
          "Hope you're having a wonderful start to your day.":
              "നിങ്ങളുടെ ദിവസത്തിന് ഒരു മികച്ച തുടക്കം ആശംസിക്കുന്നു.",
          "Good morning,": 'സുപ്രഭാതം,',
          'Sunday': 'ഞായറാഴ്‌ച',
          'Monday': 'തിങ്കളാഴ്‌ച',
          'Tuesday': 'ചൊവ്വാഴ്‌ച',
          'Wednesday': 'ബുധനാഴ്‌ച',
          'Thursday': 'വ്യാഴാഴ്‌ച',
          'Friday': 'വെള്ളിയാഴ്‌ച',
          'Saturday': 'ശനിയാഴ്‌ച',
          'Chandrashtama': 'ചന്ദ്രാഷ്ടമ',
          'Predictions are based on birth details in your profile section':
              'നിങ്ങളുടെ പ്രൊഫൈൽ വിഭാഗത്തിലെ ജനന വിശദാംശങ്ങളെ അടിസ്ഥാനമാക്കിയാണ് പ്രവചനങ്ങൾ',
          //yearly prediction
          'Planetary Transits': 'ഗ്രഹ സംക്രമണം',
          'Categorized Predictions': 'വർഗ്ഗീകരിച്ച പ്രവചനങ്ങൾ',
          'Jupiter': 'ഗുരു',
          'Saturn': 'ശനി',
          'Rahu': 'രാഹു',
          'Ketu': 'കേതു',
          'Current_Dasa': 'ഇപ്പോഴത്തെ ദശ',
          'Career Overview': 'തൊഴില് അവലോകനം',
          'Finance Overview': 'സാമ്പത്തിക അവലോകനം',
          'Health Overview': 'ആരോഗ്യ അവലോകനം',
          'Marriage/Relationship Overview': 'വിവാഹം/ബന്ധങ്ങളുടെ അവലോകനം',
          'Remedies': 'പരിഹാരം',
          'Chanting': 'ജപിക്കുന്നു',
          'Puja': 'പൂജ',
          'Charity': 'അനുകൻവ',
          'Regenerate': 'പുനരുജ്ജീവിപ്പിക്കുക',
          'Consult Astrologer': 'ജ്യോതിഷിയെ\nസമീപിക്കുക',
          'Astrology Consultation': 'ജ്യോതിഷ കൺസൾട്ടേഷൻ',
          'First Half of': 'ആദ്യ പകുതി',
          'Second Half of': 'രണ്ടാം പകുതി',
          //Life predictions
          PlatformTextConfig.lifeTitle: 'ജീവിത പ്രവചനങ്ങൾ',
          'General\nCharacteristics': 'പൊതു\nസ്വഭാവസ',
          'Career\nPredictions': 'തൊഴില്\nപ്രവചനങ്ങൾ',
          'Relationship\nPredictions': 'ബന്ധ\nപ്രവചനങ്ങൾ',
          'Wealth\nPredictions': 'സമ്പത്തിൻ്റെ\nപ്രവചനങ്ങൾ',
          'Health\nPredictions': 'ആരോഗ്യ\nപ്രവചനങ്ങൾ',
          'Current\nTime Period': 'നിലവിലെ\nസമയ കാലയളവ്',
          //Daily Predictions
          'Upgrade to receive daily predictions at 6 AM':
              'രാവിലെ 6 മണിക്ക് ദൈനംദിന പ്രവചനങ്ങൾ സ്വീകരിക്കുന്നതിന് അപ്‌ഗ്രേഡ് ചെയ്യുക',
          'Your daily predictions was scheduled for 6 AM':
              'നിങ്ങളുടെ ദൈനംദിന പ്രവചനങ്ങൾ രാവിലെ 6 മണിക്ക് ഷെഡ്യൂൾ ചെയ്‌തിരുന്നു',
          'Career': 'തൊഴില്',
          'Relationship': 'ബന്ധങ്ങൾ',
          'Wealth': 'സമ്പത്തിൻ്റെ',
          'Health': 'ആരോഗ്യം',
          //Marriage Match Making
          'Marriage Match Making': 'വിവാഹ പൊരുത്തം',
          'Boy Name': 'വരന്റെ പേര്',
          'Girl Name': 'വധുവിന്റെ പേര്',
          'Total Compatibility Score': 'ആകെ അനുയോജ്യതാ സ്കോർ',
          'Kuta': 'കൂടം',
          'Gained': 'നേടി',
          'Max': 'പരമാവധി',
          'Present': 'ഹാജർ',
          'Absent': 'ഇല്ല',
          'Expert Connect': 'വിദഗ്ദ്ധ കണക്റ്റ്',
          'Check astrological compatibility for a perfect match':
              'ഒരു പൂർണ്ണ പൊരുത്തത്തിനുള്ള ജ്യോതിഷ പൊരുത്തം',
          'Boy Details': 'വരന്റെ വിശദാംശങ്ങൾ',
          'Girl Details': 'വധുവിന്റെ വിവരങ്ങൾ',
          'Calculate Match': 'പൊരുത്തം കണക്കാക്കുക',
          'Enter boy\'s name': 'പുരുഷ നാമം',
          'Enter girl\'s name': 'സ്ത്രീ നാമം',
          //Subscriptions
          'Subscription': 'സബ്സ്ക്രിപ്ഷനുകൾ',
          'Auto Schedule Daily Predictions':
              'ദൈനംദിന പ്രവചനങ്ങൾ സ്വയം ഷെഡ്യൂൾ ചെയ്യുക',
          'Auto Schedule Weekly Predictions':
              'ആഴ്ച്ചാപ്രവചനങ്ങൾ സ്വയം ഷെഡ്യൂൾ ചെയ്യുക',
          'Book Consultations': 'കൺസൾട്ടേഷനുകൾ ബുക്ക് ചെയ്യുക',
          'Basic Horoscope Chart': 'അടിസ്ഥാന ജാതക ചാർട്ട്',
          'Edit Horoscope Details': 'ജാതക വിവരങ്ങൾ തിരുത്തുക',
          'Unlimited Number Of Chat Per Week':
              'ആഴ്ചയിൽ പരിധിയില്ലാത്ത ചാറ്റുകൾ',
          'Download Chat History': 'ചാറ്റ് ചരിത്രം ഡൗൺലോഡ് ചെയ്യുക',
          'Pick Chat Avatar': 'ചാറ്റ് അവതാർ തിരഞ്ഞെടുക്കുക',
          'Pick Chat Style': 'ചാറ്റ് ശൈലി തിരഞ്ഞെടുക്കുക',
          'Life Predictions': 'ജീവിത പ്രവചനങ്ങൾ',
          'Yearly Predictions': 'വാർഷിക പ്രവചനങ്ങൾ',
          'Personalized Panchang': 'വ്യക്തിഗത പഞ്ചാംഗം',
          'Continue': 'തുടരുക',
          'Payment Summary': 'പേയ്മെന്റ് സംഗ്രഹം',
          'Pay Now': 'ഇപ്പോൾ പണമടയ്ക്കുക',
          'Plan Cost': 'പ്ലാൻ ചെലവ്',
          'Discount': 'കിഴിവ്',
          'Total Cost': 'ആകെ ചെലവ്',
          'Payment Successful': 'പേയ്മെന്റ് വിജയകരമായി പൂർത്തിയായി',
          'Try Premium Plan': 'പ്രീമിയം പ്ലാനുകൾ പരീക്ഷിക്കുക',
          '1 month': '1 മാസം',
          'month': 'മാസം',
          'months': 'മാസങ്ങൾ',
          'year': 'വർഷം',
          'Compare the plans': 'പ്ലാനുകൾ താരതമ്യം ചെയ്യുക',
          'Welcome to\nTeksage!': 'Teksage-ക്ക് സ്വാഗതം!',
          'Your 24/7 Personal Astrologer is here\n—now at just':
              'നിങ്ങളുടെ 24/7 വ്യക്തിഗത ജ്യോതിഷി ഇവിടെയുണ്ട് - ഇപ്പോൾ മാത്രം',
          'per month': 'പ്രതിമാസം',
          'Unlock premium features': 'പ്രീമിയം ഫീച്ചറുകൾ അൺലോക്ക് ചെയ്യുക',
          'Unlimited AI voice chat in your own language':
              'നിങ്ങളുടെ മാതൃഭാഷയിൽ പരിധിയില്ലാത്ത AI വോയ്‌സ് Chat',
          'Yearly insights & life predictions': 'വാർഷിക ഉൾക്കാഴ്ചകളും ജീവിത ',
          'Personalised Panchang for your horoscope':
              'നിങ്ങളുടെ ജാതകത്തിനായി വ്യക്തിഗതമാക്കിയ പഞ്ചാംഗം',
          'Upgrade Plan': 'നവീകരിക്കുക Plan',
          'Skip': 'ചാടിക്കുക',
          'Your Current Plan': 'നിങ്ങളുടെ\nനിലവിലെ\nplan',
          'days left': 'ദിവസങ്ങൾ ബാക്കി',
          'Recommended': 'ശുപാർശ ചെയ്തത്',
          'membership': 'അംഗത്വം',
          //Dialog box
          'Plan Expired': 'പ്ലാൻ കാലാവധി അവസാനിച്ചു',
          'Premium Feature': 'പ്രീമിയം സവിശേഷത',
          'Unlock all features by choosing a plan':
              'ഒരു പ്ലാൻ തിരഞ്ഞെടുക്കുന്നതിലൂടെ എല്ലാ സവിശേഷതകളും അൺലോക്ക് ചെയ്യുക',
          'Purchase Plan': 'പ്ലാൻ വാങ്ങുക',
          'Plan': 'പ്ലാൻ ചെയ്യുക',
          'Slots Selected': 'തിരഞ്ഞെടുക്കപ്പെട്ട സ്ലോട്ടുകൾ',
          'Selected slots will be lost if you change the date. Would you like to save them first?':
              'തീയതി മാറ്റുകയാണെങ്കിൽ തിരഞ്ഞെടുക്കപ്പെട്ട സ്ലോട്ടുകൾ നഷ്ടപ്പെടും. ആദ്യം അവ സേവ് ചെയ്യണോ?',
          'Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!':
              'നിങ്ങളുടെ നക്ഷത്രങ്ങൾ നിങ്ങളെ വഴിനടത്തുന്നു, നിങ്ങളുടെ പ്രതികരണമാണ് ഞങ്ങളെ വഴിനടത്തുന്നത് ⭐\nഇന്ന് തന്നെ Teksage-ന് റേറ്റിംഗ് നൽകൂ!',
          'Rate Now': 'ഇപ്പോൾ റേറ്റ് ചെയ്യുക',
          'Allow Location Access': 'ലൊക്കേഷൻ ആക്‌സസ് അനുവദിക്കുക',
          'We need your location to get prices in your local currency (INR, USD, etc.)':
              'നിങ്ങളുടെ പ്രാദേശിക കറൻസിയിൽ വിലകൾ ലഭ്യമാക്കാൻ നിങ്ങളുടെ ലൊക്കേഷൻ ആവശ്യമാണ്',
          'Allow': 'അനുവദിക്കുക',
          'Not Allow': 'അനുവദിക്കരുത്',
          'Go to Settings': 'ക്രമീകരണങ്ങളിലേക്ക് പോകുക',
          'Are you sure you want to logout?':
              'നിങ്ങൾക്ക് ലോഗ്ഔട്ട് ചെയ്യണമെന്ന് ഉറപ്പാണോ?',
          'Discard': 'ഉപേക്ഷിക്കുക',
          'You have unsaved changes.\nDo you want to discard them and go back?':
              'നിങ്ങൾക്ക് സംരക്ഷിക്കാത്ത മാറ്റങ്ങളുണ്ട്.\nഅവ ഉപേക്ഷിച്ച് തിരികെ പോകണോ?',
          //Error Validate
          'Please Enter the First Name': 'ദയവായി ആദ്യ പേര് നൽകുക',
          'Please Enter the Second Name': 'ദയവായി രണ്ടാം പേര് നൽകുക',
          'Please enter a valid Email': 'ദയവായി സാധുവായ ഇമെയിൽ നൽകുക',
          'Please verify your Email': 'ദയവായി നിങ്ങളുടെ ഇമെയിൽ സ്ഥിരീകരിക്കുക',
          'Enter a valid Email': 'സാധുവായ ഇമെയിൽ നൽകുക',
          'Select country code': 'രാജ്യ കോഡ് തിരഞ്ഞെടുക്കുക',
          'Enter valid (mobileLengthLimit)-digit number':
              'സാധുവായ (mobileLengthLimit) അക്കമുള്ള നമ്പർ നൽകുക',
          'cannot be empty': 'ശൂന്യമായിരിക്കരുത്',
          'Please enter the AI Chat Language': 'ദയവായി AI ചാറ്റിന്റെ ഭാഷ നൽകുക',
          'Please enter the Date of birth': 'ദയവായി ജനന തീയതി നൽകുക',
          'Please enter the Time of birth': 'ദയവായി ജനന സമയം നൽകുക',
          'Please enter the Place of birth': 'ദയവായി ജനന സ്ഥലം നൽകുക',
          'Please select one value': 'ദയവായി ഒരു മൂല്യം തിരഞ്ഞെടുക്കുക',
          'Please fill all the required fields':
              'ദയവായി ആവശ്യമായ എല്ലാ ഫീൽഡുകളും പൂരിപ്പിക്കുക',
          'Please Enter the valid Mobile Number':
              'ദയവായി സാധുവായ മൊബൈൽ നമ്പർ നൽകുക',
          'Choose a preferred language to continue':
              'തുടരാൻ ഇഷ്ടപ്പെട്ട ഭാഷ തിരഞ്ഞെടുക്കുക',
          '*This slot is already booked!':
              'ഈ സ്ലോട്ട് ഇതിനകം ബുക്ക് ചെയ്തിരിക്കുന്നു',
          '* Choose a preferred timing': 'ഇഷ്ടപ്പെട്ട സമയം തിരഞ്ഞെടുക്കുക',
          'Kindly select one or more categories':
              'ദയവായി ഒന്നോ അതിലധികമോ വിഭാഗങ്ങൾ തിരഞ്ഞെടുക്കുക',
          'Error loading questions': 'ചോദ്യങ്ങൾ ലോഡ് ചെയ്യുന്നതിൽ പിശക്',
          'No questions found': 'ചോദ്യങ്ങളൊന്നും കണ്ടെത്തിയില്ല',
          "Please enter Boy's name": 'ആൺകുട്ടിയുടെ പേര് നൽകുക',
          "Please select Boy's Nakshatram":
              'ആൺകുട്ടികളുടെ നക്ഷത്രം തിരഞ്ഞെടുക്കുക',
          "Please select Girl's Nakshatram":
              'പെൺകുട്ടികളുടെ നക്ഷത്രം തിരഞ്ഞെടുക്കുക',
          "Please enter Girl's name": 'പെൺകുട്ടിയുടെ പേര് നൽകുക',
          "Please select Girl's Rasi": 'പെൺകുട്ടികളുടെ റാസി തിരഞ്ഞെടുക്കുക',
          "Please select Boy's Rasi": 'ആൺകുട്ടികളുടെ രാശി തിരഞ്ഞെടുക്കുക',
          'Second language must be different from first':
              'രണ്ടാമത്തെ ഭാഷ ആദ്യത്തേതിൽ നിന്ന് വ്യത്യസ്തമായിരിക്കണം.',
          //Snack bar
          'Permission permanently denied. Please enable it in settings.':
              'അനുമതി സ്ഥിരമായി നിഷേധിച്ചിരിക്കുന്നു. ദയവായി സെറ്റിംഗ്സിൽ നിന്ന് അത് പ്രവർത്തനക്ഷമമാക്കുക.',
          'Permission Denied': 'അനുമതി നിഷേധിച്ചു',
          'Payment verification failed. Please try again.':
              'പേയ്മെന്റ് സ്ഥിരീകരണം പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Payment failed. Please try again.':
              'പേയ്മെന്റ് പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Please Contact Support team!':
              'ദയവായി സപ്പോർട്ട് ടീമിനെ ബന്ധപ്പെടുക!',
          'Payment Error, Contact Support team!.':
              'പേയ്മെന്റ് പിശക്, സപ്പോർട്ട് ടീമിനെ ബന്ധപ്പെടുക!',
          'Payment successful!': 'പേയ്മെന്റ് വിജയകരമായി പൂർത്തിയായി!',
          'Please enable location permission to access this feature.':
              'ഈ ഫീച്ചർ ഉപയോഗിക്കാൻ ദയവായി ലൊക്കേഷൻ അനുമതി പ്രവർത്തനക്ഷമമാക്കുക.',
          'Select valid country code and number':
              'സാധുവായ രാജ്യ കോഡും നമ്പറും തിരഞ്ഞെടുക്കുക',
          'Please contact Teksage Admin':
              'ദയവായി Teksage അഡ്മിനുമായി ബന്ധപ്പെടുക',
          'Error in Fetching Country code':
              'രാജ്യ കോഡ് ലഭ്യമാക്കുന്നതിൽ പിശക് സംഭവിച്ചു',
          'Please select a country code first':
              'ദയവായി ആദ്യം ഒരു രാജ്യ കോഡ് തിരഞ്ഞെടുക്കുക',
          'Failed to fetch country list':
              'രാജ്യങ്ങളുടെ പട്ടിക ലഭ്യമാക്കാൻ കഴിഞ്ഞില്ല',
          'Please select the first language first':
              'ദയവായി ആദ്യം ആദ്യ ഭാഷ തിരഞ്ഞെടുക്കുക',
          'Failed to save Questions':
              'ചോദ്യങ്ങൾ സേവ് ചെയ്യുന്നതിൽ പരാജയപ്പെട്ടു',
          'Error creating slots, Please try again.':
              'സ്ലോട്ടുകൾ സൃഷ്ടിക്കുന്നതിൽ പിശക്. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Slot Updated Successfully.':
              'സ്ലോട്ട് വിജയകരമായി അപ്‌ഡേറ്റ് ചെയ്തു.',
          'At least one category must be selected.':
              'കുറഞ്ഞത് ഒരു വിഭാഗമെങ്കിലും തിരഞ്ഞെടുക്കണം.',
          'At least one language must be selected.':
              'കുറഞ്ഞത് ഒരു ഭാഷയെങ്കിലും തിരഞ്ഞെടുക്കണം.',
          'We couldn’t fetch your horoscope. Please try again.':
              'നിങ്ങളുടെ ജാതകം ലഭ്യമാക്കാൻ കഴിഞ്ഞില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Failed to fetch data. Please try again.':
              'ഡാറ്റ ലഭ്യമാക്കാൻ പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Failed to update notification status':
              'നോട്ടിഫിക്കേഷൻ നില അപ്‌ഡേറ്റ് ചെയ്യുന്നതിൽ പരാജയപ്പെട്ടു',
          'Please try again after sometime':
              'ദയവായി കുറച്ച് സമയം കഴിഞ്ഞ് വീണ്ടും ശ്രമിക്കുക',
          'All Notification has been cleared':
              'എല്ലാ നോട്ടിഫിക്കേഷനുകളും നീക്കം ചെയ്തിരിക്കുന്നു',
          'Please enable location access to view relevant subscription plans':
              'ബന്ധപ്പെട്ട സബ്സ്ക്രിപ്ഷൻ പ്ലാനുകൾ കാണാൻ ദയവായി ലൊക്കേഷൻ ആക്‌സസ് പ്രവർത്തനക്ഷമമാക്കുക',
          'Failed to regenerate prediction. Please try again.':
              'പ്രവചനം വീണ്ടും സൃഷ്ടിക്കുന്നതിൽ പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'An error occurred while regenerating. Please try again.':
              'വീണ്ടും സൃഷ്ടിക്കുമ്പോൾ ഒരു പിശക് സംഭവിച്ചു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Prediction regenerated successfully':
              'പ്രവചനം വിജയകരമായി വീണ്ടും സൃഷ്ടിച്ചു',
          'Please enter a valid OTP': 'ദയവായി സാധുവായ OTP നൽകുക',
          'Choose your Style, Avatar and Language to begin your cosmic journey.':
              'നിങ്ങളുടെ കോസ്മിക് യാത്ര ആരംഭിക്കാൻ ശൈലി, അവതാർ, ഭാഷ എന്നിവ തിരഞ്ഞെടുക്കുക.',
          'Select a Style and Avatar to begin your cosmic journey.':
              'നിങ്ങളുടെ കോസ്മിക് യാത്ര ആരംഭിക്കാൻ ഒരു ശൈലിയും അവതാറും തിരഞ്ഞെടുക്കുക.',
          'Select a Style for your answer’s flow.':
              'നിങ്ങളുടെ ഉത്തരങ്ങളുടെ പ്രവാഹത്തിനായി ഒരു ശൈലി തിരഞ്ഞെടുക്കുക.',
          'Select an Avatar that reflects your spirit.':
              'നിങ്ങളുടെ ആത്മാവിനെ പ്രതിഫലിപ്പിക്കുന്ന ഒരു അവതാർ തിരഞ്ഞെടുക്കുക.',
          'Select a Language for your answer’s flow.':
              'നിങ്ങളുടെ ഉത്തരങ്ങളുടെ പ്രവാഹത്തിനായി ഒരു ഭാഷ തിരഞ്ഞെടുക്കുക.',
          'Keep it short and cosmic — max 300 characters':
              'ചുരുക്കവും കോസ്മിക് ഭാവവും പാലിക്കുക — പരമാവധി 300 അക്ഷരങ്ങൾ',
          'You can answer only after completing the consultation.':
              'കൺസൾട്ടേഷൻ പൂർത്തിയാക്കിയതിന് ശേഷം മാത്രമേ നിങ്ങൾക്ക് മറുപടി നൽകാൻ കഴിയൂ.',
          'Timeout. Please retry.': 'സമയം കഴിഞ്ഞു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Kindly enter your question.': 'ദയവായി നിങ്ങളുടെ ചോദ്യം നൽകുക.',
          'Your subscription has expired. Subscribe to continue.':
              'നിങ്ങളുടെ സബ്സ്ക്രിപ്ഷൻ കാലാവധി അവസാനിച്ചു. തുടരാൻ സബ്സ്ക്രൈബ് ചെയ്യുക.',
          'You’ve reached your message limit. Subscribe to continue.':
              'നിങ്ങൾ സന്ദേശ പരിധിയിൽ എത്തിയിരിക്കുന്നു. തുടരാൻ സബ്സ്ക്രൈബ് ചെയ്യുക.',
          'Retry response timed out.':
              'വീണ്ടും ശ്രമിക്കാനുള്ള പ്രതികരണ സമയം കഴിഞ്ഞു.',
          'Response is taking longer than expected. Please check your network.':
              'പ്രതികരണം പ്രതീക്ഷിച്ചതിലും കൂടുതൽ സമയം എടുക്കുന്നു. ദയവായി നിങ്ങളുടെ നെറ്റ്‌വർക്ക് പരിശോധിക്കുക.',
          'Thanks for reaching out! Your query has been received — our team will respond shortly.':
              'ഞങ്ങളെ ബന്ധപ്പെട്ടതിന് നന്ദി! നിങ്ങളുടെ ചോദ്യം ലഭിച്ചു — ഞങ്ങളുടെ ടീം ഉടൻ മറുപടി നൽകുന്നതായിരിക്കും.',
          'Something went wrong. Please try again.':
              'ഏതോ ഒരു പിശക് സംഭവിച്ചു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Logout failed. Please try again.':
              'ലോഗ്‌ഔട്ട് പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.',
          'Thanks for using Teksage': 'Teksage ഉപയോഗിച്ചതിന് നന്ദി',
          'Your message looks empty after removing hidden characters. Try typing or paste plain text.':
              'മറഞ്ഞിരിക്കുന്ന പ്രതീകങ്ങൾ നീക്കം ചെയ്തതിനുശേഷം നിങ്ങളുടെ സന്ദേശം ശൂന്യമായി തോന്നുന്നു. പ്ലെയിൻ ടെക്സ്റ്റ് ടൈപ്പ് ചെയ്യുകയോ ഒട്ടിക്കുകയോ ചെയ്യുക.',
          'Error in sending OTP': 'OTP അയയ്ക്കുന്നതിൽ പിശക്',
          'Network error. Please check your connection and try again.':'നെറ്റ്‌വർക്ക് പിശക്. നിങ്ങളുടെ കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.',
          'OTP Verified':'OTP പരിശോധിച്ചുറപ്പിച്ചു',
          //Astrology consultations
          'What do you\nneed guidance on?':
              'നിങ്ങൾക്ക് ഏത് വിഷയത്തിൽ മാർഗനിർദ്ദേശം ആവശ്യമാണ്?',
          'Select the categories and continue':
              'വിഭാഗങ്ങൾ തിരഞ്ഞെടുക്കുകയും തുടരുകയും ചെയ്യുക',
          'Marriage & relationships': 'വിവാഹവും ബന്ധങ്ങളും',
          'Marriage & Relationships': 'വിവാഹവും ബന്ധങ്ങളും',
          'All': 'എല്ലാം',
          'Choose your\npreferred language':
              'നിങ്ങളുടെ ഇഷ്ടപ്പെട്ട ഭാഷ തിരഞ്ഞെടുക്കുക',
          'This will help us to match the best astrologer':
              'ഏറ്റവും അനുയോജ്യമായ ജ്യോതിഷനെ കണ്ടെത്താൻ ഇത് ഞങ്ങളെ സഹായിക്കും',
          'First Preference': 'ആദ്യ മുൻഗണന',
          'Second Preference': 'രണ്ടാം മുൻഗണന',
          'Select language': 'ഭാഷ തിരഞ്ഞെടുക്കുക',
          'Top 5 astrologers\nbased on preferences':
              'മുൻഗണനകളുടെ അടിസ്ഥാനത്തിൽ മികച്ച 5 ജ്യോതിഷന്മാർ',
          'Expert Profile': 'വിദഗ്ധന്റെ പ്രൊഫൈൽ',
          'Reviews': 'അവലോകനങ്ങൾ',
          'No reviews available': 'അവലോകനങ്ങൾ ലഭ്യമല്ല',
          'Book Consultation': 'കൺസൾട്ടേഷൻ ബുക്ക് ചെയ്യുക',
          'No slots available': 'സ്ലോട്ടുകൾ ലഭ്യമല്ല',
          'Find & Consult Astrologers': 'ജ്യോതിഷികളെ കണ്ടെത്തി ഉപദേശം തേടുക',
          '100+ Astrologers': '100+ ജ്യോതിഷികൾ',
          'Explore and find your perfect match':
              'നിങ്ങളുടെ പൂർണ പൊരുത്തം പര്യവേക്ഷണം ചെയ്ത് കണ്ടെത്തുക',
          'Upcoming': 'വരാനിരിക്കുന്ന',
          'Completed': 'പൂർത്തിയാക്കി',
          'View Details': 'വിശദാംശങ്ങൾ\nകാണുക',
          'View\nDetails': 'വിശദാംശങ്ങൾ\nകാണുക',
          'Meeting Link': 'meeting\nലിങ്ക്',
          'Choose your avatar': 'നിങ്ങളുടെ അവതാർ തിരഞ്ഞെടുക്കുക',
          'Choose how AI replies': 'AI എങ്ങനെ മറുപടി നൽകണമെന്ന് തിരഞ്ഞെടുക്കുക',
          'Concise': 'സംക്ഷിപ്തമായ',
          'Booking Details': 'Booking വിശദാംശങ്ങൾ',
          'Consultation Fee': 'കൺസൾട്ടേഷൻ ഫീസ്',
          'Total Fee': 'ആകെ ഫീസ്',
          'Confirm & Proceed to Pay': 'സ്ഥിരീകരിച്ച് പണമടയ്ക്കുക',
          'Consultation Details': 'കൺസൾട്ടേഷൻ വിശദാംശങ്ങൾ',
          'Consulting On': 'കൺസൾട്ടേഷൻ വിഷയം',
          'Give Rating': 'റേറ്റിംഗ് നൽകുക',
          'Ratings': 'റേറ്റിംഗുകൾ',
          'You have no upcoming meetings at the moment.':
              'നിങ്ങൾക്ക് ഇപ്പോൾ വരാനിരിക്കുന്ന മീറ്റിംഗുകളൊന്നുമില്ല.',
          'You have no completed meetings at the moment.':
              'നിങ്ങൾക്ക് ഇപ്പോൾ പൂർത്തിയാക്കിയ മീറ്റിംഗുകളൊന്നുമില്ല.',
          'Book Now': 'റിസർവേഷൻ\nനടത്തുക',
          'Yes': 'അതെ',
          'No': 'ഇല്ല',
          'Queries you asked': 'നിങ്ങൾ ചോദിച്ച ചോദ്യങ്ങൾ',
          'Enter Promo Code': 'പ്രമോ കോഡ് നൽകുക',
          'Applied': 'പ്രയോഗിച്ചു',
          'Apply': 'പ്രയോഗിക്കുക',
          'I consent to share my personal information & horoscope with the astrologer':
              'എന്റെ വ്യക്തിഗത വിവരങ്ങളും ജാതകവും ജ്യോതിഷനുമായി പങ്കിടുന്നതിനായി ഞാൻ സമ്മതിക്കുന്നു.',
          'I consent to share my personal information & star chart with the advisor':
              'എന്റെ സ്വകാര്യ വിവരങ്ങളും സ്റ്റാർ ചാർട്ടും ഉപദേഷ്ടാവുമായി പങ്കിടാൻ ഞാൻ സമ്മതിക്കുന്നു.',
          'Kindly select your preferred language':
              'ദയവായി നിങ്ങളുടെ ഇഷ്ടപ്പെട്ട ഭാഷ തിരഞ്ഞെടുക്കുക',
          'Write your consultation query here':
              'നിങ്ങളുടെ കൺസൾട്ടേഷൻ അന്വേഷണം ഇവിടെ എഴുതുക',
          'Enter your question here...': 'നിങ്ങളുടെ ചോദ്യം ഇവിടെ നൽകുക...',
          'Next': 'അടുത്തത്',
          'Previous': 'മുമ്പത്തേത്',
          '* All questions are required to help us serve you better.':
              '* നിങ്ങളെ മികച്ച രീതിയിൽ സേവിക്കാൻ ഞങ്ങളെ സഹായിക്കുന്നതിന് എല്ലാ ചോദ്യങ്ങളും ആവശ്യമാണ്.',
          'Slots': 'സ്ലോട്ടുകൾ',
          '30 mins each': 'ഓരോന്നിനും\n30 മിനിറ്റ്',
          'Astrologer submitted answers for your queries':
              'നിങ്ങളുടെ സംശയങ്ങൾക്ക് ജ്യോതിഷി ഉത്തരങ്ങൾ സമർപ്പിച്ചു.',
          'Meet Again': 'വീണ്ടും\nകണ്ടുമുട്ടുക',
          'Rate your experience with this astrologer appointment':
              'ഈ ജ്യോതിഷി അപ്പോയിന്റ്മെന്റിലെ നിങ്ങളുടെ അനുഭവം റേറ്റ് ചെയ്യുക',
          'Save & Submit': 'സേവ് ചെയ്ത് സമർപ്പിക്കുക',
          'Type your answer here...':
              'നിങ്ങളുടെ ഉത്തരം ഇവിടെ ടൈപ്പ് ചെയ്യുക...',
          'Done': 'ചെയ്തുകഴിഞ്ഞു',
          'booked a slot on': 'ഒരു സ്ലോട്ട്\nബുക്ക് ചെയ്തു',
          "meeting_with": "{name} നോടുള്ള യോഗം",
          //Voice chat
          'Jyotish voice guide for all your needs. Start you conversation today':
              'നിങ്ങളുടെ എല്ലാ ആവശ്യങ്ങൾക്കുമുള്ള ജ്യോതിഷ് വോയ്‌സ് ഗൈഡ്. ഇന്ന് തന്നെ നിങ്ങളുടെ സംഭാഷണം ആരംഭിക്കൂ',
          'Jyotish voice guide for all your needs':
              'നിങ്ങളുടെ എല്ലാ ആവശ്യങ്ങൾക്കുമുള്ള\nജ്യോതിഷ് വോയ്‌സ് ഗൈഡ്.',
          'The Seeker': 'അന്വേഷകൻ',
          'The Luminary': 'പ്രകാശകൻ',
          'The Guardian': 'രക്ഷാകര്ത്താവ്',
          'The Pathfinder': 'പാത്ത്ഫൈൻഡർ',
          'Ideal for those who want in-depth astrological analysis and clear reasoning':
              'ആഴത്തിലുള്ള ജ്യോതിഷ വിശകലനവും വ്യക്തമായ യുക്തിയും ആഗ്രഹിക്കുന്നവർക്ക് അനുയോജ്യം',
          'Ideal for those who seek joyful and engaging astrology guidance':
              'സന്തോഷകരവും ആകർഷകവുമായ ജ്യോതിഷ മാർഗ്ഗനിർദ്ദേശം തേടുന്നവർക്ക് അനുയോജ്യം',
          'Ideal for those looking for reassurance and personal connection in predictions':
              'പ്രവചനങ്ങളിൽ ആത്മവിശ്വാസവും വ്യക്തിപരമായ ബന്ധവും ആഗ്രഹിക്കുന്നവർക്ക് അനുയോജ്യം',
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions':
              'കരിയർ വളർച്ച, വിജയ തന്ത്രങ്ങൾ അല്ലെങ്കിൽ വ്യക്തമായ പരിഹാരങ്ങൾ തേടുന്നവർക്ക് അനുയോജ്യം',
          'Tap the mic': 'മൈക്ക് ടാപ്പ് ചെയ്യുക',
          'Start speaking in your own language':
              'നിങ്ങളുടെ മാതൃഭാഷയിൽ സംസാരിച്ചു തുടങ്ങുക',
          'Chat or record your thoughts...': 'Chat or record your thoughts...',
          'AI can understand all languages':
              'AI-ക്ക് എല്ലാ ഭാഷകളും മനസ്സിലാകും.',
          'Got it, typing that up for you…':
              'മനസ്സിലായി, അത് നിങ്ങൾക്കായി ടൈപ്പ് ചെയ്യുന്നു...',
          'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology.':
              'വിവരണം - അൽ-പവേർഡ് ജ്യോതിഷം ഉപയോഗിച്ച് നിങ്ങളുടെ ഭാവി, കരിയർ, ബന്ധങ്ങൾ എന്നിവയിലേക്കും അതിലേറെ കാര്യങ്ങളിലേക്കും വ്യക്തിഗതമാക്കിയ ഉൾക്കാഴ്ചകൾ അൺലോക്ക് ചെയ്യുക',
          'Generate Yearly Prediction': 'വാർഷിക പ്രവചനം സൃഷ്ടിക്കുക',
          'Generate Life Prediction': 'ജീവിത പ്രവചനം സൃഷ്ടിക്കുക',
          'Quick, direct replies without extra details — ideal for instant answers.':
              'അധിക വിശദാംശങ്ങളില്ലാതെ വേഗത്തിലുള്ളതും നേരിട്ടുള്ളതുമായ മറുപടികൾ — തൽക്ഷണ ഉത്തരങ്ങൾക്ക് അനുയോജ്യം',
          'Explanatory': 'വിശദീകരണം',
          'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.':
              'ഘട്ടം ഘട്ടമായുള്ള വ്യക്തതയോടെ ആഴത്തിലുള്ളതും ഘടനാപരവുമായ മറുപടികൾ - പഠനത്തിനോ വിശദമായ ഉൾക്കാഴ്ചകൾക്കോ ​​അനുയോജ്യം',
          'Choose an avatar for AI': 'AI-യ്‌ക്കായി ഒരു അവതാർ തിരഞ്ഞെടുക്കുക',
          'Related questions': 'ബന്ധപ്പെട്ട ചോദ്യങ്ങൾ',
          'No response.': 'പ്രതികരണമില്ല.',
          'Retry': 'വീണ്ടും ശ്രമിക്കുക',
          'Subscribe Now': 'സബ്സ്ക്രൈബ് ചെയ്യുക',
          //Delete Account
          'We value your experience.\nWhat made you decide to leave?':
              'നിങ്ങളുടെ അനുഭവത്തെ ഞങ്ങൾ വിലമതിക്കുന്നു.\nനിങ്ങളെ പോകാൻ തീരുമാനിച്ചതിന്റെ കാരണം എന്താണ്?',
          "I am having another account": 'എനിക്ക് വേറെ ഒരു അക്കൗണ്ട് ഉണ്ട്',
          'App not working properly': 'ആപ്പ് ശരിയായി പ്രവർത്തിക്കുന്നില്ല',
          'I don’t like the app': 'എനിക്ക് ആപ്പ് ഇഷ്ടമല്ല',
          'I am worried about my privacy':
              'എന്റെ സ്വകാര്യതയെക്കുറിച്ച് എനിക്ക് ആശങ്കയുണ്ട്',
          'You are about to delete\nyour account':
              'നിങ്ങൾ അക്കൗണ്ട് ഇല്ലാതാക്കാൻ പോകുകയാണ്',
          'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days':
              'ഈ അക്കൗണ്ടുമായി ബന്ധപ്പെട്ട എല്ലാ ഡാറ്റയും (നിങ്ങളുടെ പ്രൊഫൈൽ, സേവനം, ബുക്കിംഗുകൾ, ജാതകം, പ്രവചനങ്ങൾ ഉൾപ്പെടെ) 45 ദിവസത്തിനുള്ളിൽ ശാശ്വതമായി ഇല്ലാതാക്കപ്പെടും',
          'Delete Account Now': 'അക്കൗണ്ട് ഇപ്പോൾ ഇല്ലാതാക്കുക',
          'No, I have changed my mind': 'ഇല്ല, ഞാൻ എന്റെ മനസ്സ് മാറ്റുകയാണ്',
          //Astrologer
          'You logged in as Astrologer': 'നിങ്ങൾ ജ്യോതിഷിയായി\nലോഗിൻ ചെയ്‌തു.',
          'Meetings': 'ബുക്കിംഗുകൾ',
          'View your scheduled appointments & completed ones':
              'നിങ്ങളുടെ ഷെഡ്യൂൾ ചെയ്ത അപ്പോയിന്റ്മെന്റുകളും പൂർത്തിയാക്കിയവയും കാണുക',
          'My Availability': 'എന്റെ ഷെഡ്യൂൾ',
          'Set your available time slots.':
              'നിങ്ങളുടെ സമയ സ്ലോട്ടുകൾ സജ്ജമാക്കുക.',
          'Select the slots that you are available':
              'നിങ്ങളുടെ ലഭ്യമായ സ്ലോട്ടുകൾ തിരഞ്ഞെടുക്കുക',
          'Showing the available time that you picked':
              'നിങ്ങളുടെ തിരഞ്ഞെടുത്ത സമയ സ്ലോട്ടുകൾ',
          'Morning': 'രാവിലെ',
          'Afternoon': 'ഉച്ചകഴിഞ്ഞ്',
          'Horoscope Details': 'ജാതക വിശദാംശങ്ങൾ',
          'Horoscope details are not available': 'ജാതക വിശദാംശങ്ങൾ ലഭ്യമല്ല.',
          'Answer': 'ഉത്തരം',
          'View': 'കാണുക',
          "Queries asked - Time to share your thoughts!":
              "ചോദ്യങ്ങൾ ചോദിച്ചു - നിങ്ങളുടെ ചിന്തകൾ പങ്കിടാൻ സമയമായി!",
          "Queries asked - You've already shared your thoughts!":
              "ചോദ്യങ്ങൾ ചോദിച്ചു - നിങ്ങൾ ഇതിനകം നിങ്ങളുടെ ചിന്തകൾ പങ്കുവെച്ചു കഴിഞ്ഞു!",
          'Date': 'തീയതി',
          'Time': 'സമയം',
          'Fees Paid': 'ഫീസ് അടച്ചു',
          'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.':
              'നിങ്ങളുടെ ജീവിതത്തിലെ ഈ അർത്ഥവത്തായ ഘട്ടത്തിൽ, നിങ്ങളുടെ ചാർട്ട് നൽകുന്ന ഉൾക്കാഴ്ചകളിലൂടെ നിങ്ങളെ നയിക്കാൻ കഴിയുന്നത് ഒരു പദവിയാണ്',
          'Tamil': 'தமிழ்',
          'English': 'English',
          'Telugu': 'తెలుగు',
          'Malayalam': 'മലയാളം',
          'Kannada': 'ಕನ್ನಡ',
          'Hindi': 'हिन्दी',
          'Bengali': 'বাংলা',
          'Marathi': 'मराठी',
          'Urdu': 'اردو',
          'Gujarati': 'ગુજરાતી',
          'Odia': 'ଓଡ଼ିଆ',
          'Punjabi': 'ਪੰਜਾਬੀ',
          'Assamese': 'অসমীয়া',
          'Bhojpuri': 'भोजपुरी',
          'Kashmiri': 'کٲشُر',
          'Nepali': 'नेपाली',
          'Sindhi': 'سنڌي',
          'Sinhala': 'සිංහල',
          'Maithili': 'मैथिली',
          'Manipuri': 'মৈতৈলোন্',
          'Santali': 'ᱥᱟᱱᱛᱟᱲᱤ',
          'Years of Experience': 'പരിചയ വർഷങ്ങൾ',
          'years': 'വർഷങ്ങൾ',
          'Showing Availability': 'ലഭ്യത\nകാണിക്കുന്നു',
          //OTP Screen
          "resend_otp_in_seconds": "OTP വീണ്ടും അയയ്ക്കാൻ {seconds} സെക്കൻഡ്",
          'Enter Mobile Number': 'മൊബൈൽ നമ്പർ നൽകുക',
          'Enter Email': 'ഇമെയിൽ നൽകുക',
          'Enter your new email and verify it using OTP':
              'നിങ്ങളുടെ പുതിയ ഇമെയിൽ വിലാസം നൽകി OTP ഉപയോഗിച്ച് അത് പരിശോധിച്ചുറപ്പിക്കുക.',
          'Enter your new phone number and verify it using OTP':
              'നിങ്ങളുടെ പുതിയ ഫോൺ നമ്പർ നൽകി OTP ഉപയോഗിച്ച് അത് പരിശോധിച്ചുറപ്പിക്കുക.',
          'Verify Phone Number': 'ഫോൺ നമ്പർ പരിശോധിക്കുക',
          'Verify Email': 'ഇമെയിൽ സ്ഥിരീകരിക്കുക',
          'Verify Existing Phone Number': 'നിലവിലുള്ള ഫോൺ നമ്പർ പരിശോധിക്കുക',
          'Verify Existing Email': 'നിലവിലുള്ള ഇമെയിൽ പരിശോധിക്കുക',
          'For security reasons, kindly verify your existing phone number':
              'സുരക്ഷാ കാരണങ്ങളാൽ, ദയവായി നിങ്ങളുടെ ഫോൺ നമ്പർ പരിശോധിക്കുക.',
          'For security reasons, kindly verify your existing email':
              'സുരക്ഷാ കാരണങ്ങളാൽ, ദയവായി നിങ്ങളുടെ ഇമെയിൽ പരിശോധിക്കുക.',
          'We have sent OTP to': 'ഞങ്ങൾ OTP അയച്ചു',
          'OTP is valid for 5 Minutes.': 'OTP 5 മിനിറ്റ് വരെ സാധുവാണ്.',
          'Resend OTP': 'OTP വീണ്ടും അയയ്ക്കുക',
          //Internet
          'No Internet Connection': 'ഇന്റർനെറ്റ് കണക്ഷൻ ഇല്ല',
          'Please check your\nnetwork settings':
              'നിങ്ങളുടെ നെറ്റ്‌വർക്ക് ക്രമീകരണങ്ങൾ പരിശോധിക്കുക.',
        },
        'hi': {
          'Good day': 'शुभ दिन',
          'Astrologer': 'ज्योतिषी',
          'Home': 'होम',
          'Panchang': 'पंचांग',
          'Horoscope': 'राशिफल',
          'Settings': 'सेटिंग्स',
          'Marriage\nMatch Making': 'विवाह\nमिलान',
          'Explore Other Predictions': 'अन्य भविष्यवाणी',
          PlatformTextConfig.yearlyPrediction: 'वार्षिक\nभविष्यवाणी',
          PlatformTextConfig.weeklyPrediction: 'साप्ताहिक\nभविष्यवाणी',
          PlatformTextConfig.lifePrediction: 'जीवन\nभविष्यवाणी',
          PlatformTextConfig.dailyPrediction: 'दैनिक\nभविष्यवाणी',
          PlatformTextConfig.chatHomePage: 'AI वॉयस ज्योतिष चैट',
          'ChatTitle': 'AI वॉयस चैट',
          'Chat Now': 'चैट करें',
          'Thara Bala': 'तारा बल',
          'Chandra Bala': 'चंद्र बल',
          'Astrologer\nConsultation': 'ज्योतिषी\nपरामर्श',
          'Astrologer Consultation': 'ज्योतिषी परामर्श',
          'My Profile': 'मेरी प्रोफ़ाइल',
          //Settings
          'Profile': 'प्रोफ़ाइल',
          'Push Notifications': 'पुश नोटिफिकेशन',
          'Language': 'भाषा',
          'Subscriptions': 'सदस्यताएँ',
          'Terms & Conditions': 'नियम एवं शर्तें',
          'Privacy Policy': 'गोपनीयता नीति',
          'Support': 'सहायता',
          'FAQs': 'सामान्य प्रश्न',
          'Rate us': 'हमें रेट करें',
          'Rate': 'रेट करें',
          'Delete Account': 'खाता हटाएँ',
          'Logout': 'लॉगआउट',
          'Language Updated': 'भाषा बदल गई',
          'App language has been changed successfully':
              'ऐप की भाषा सफलतापूर्वक बदल दी गई है।',
               'Click to view':'देखने के लिए क्लिक करें',
          //Profile
          'First Name': 'पहला नाम',
          'Last Name': 'अंतिम नाम',
          'Email': 'ईमेल',
          'Phone Number': 'फोन नंबर',
          'AI Chat Language': 'एआई चैट भाषा',
          'Date of Birth': 'जन्म तिथि',
          'Time of Birth': 'जन्म समय',
          'Place of Birth': 'जन्म स्थान',
          'Current Location': 'वर्तमान स्थान',
          'Rasi': 'राशि',
          'Nakshatram': 'नक्षत्र',
          'Edit': 'एडिट',
          'Profile Details': 'प्रोफ़ाइल विवरण',
          'Complete Profile': 'पूरी प्रोफ़ाइल',
          'Save': 'सेव',
          'Hi (name)!': 'नमस्ते (name)!',
          'Verify': 'सत्यापित करें',
          'Change': 'बदलें',
          'Enter place of birth': 'जन्म स्थान दर्ज करें',
          'Enter Current location': 'वर्तमान स्थान दर्ज करें',
          'Select a place': 'एक जगह चुनें',
          'Select any one Option': 'कोई एक विकल्प चुनें',
          'How did you first hear about Teksage':
              'आपको Teksage के बारे में पहली बार कैसे पता चला',
          'How did you first hear about Teksage?':
              'आपको Teksage के बारे में पहली बार कैसे पता चला?',
          'Select a language': 'भाषा चुनें',
          "Google Play Store / App Store": "Google Play Store / App Store",
          "Google Search": "Google खोज",
          "Quora": "Quora",
          "Facebook / Instagram": "Facebook / Instagram",
          "YouTube": "YouTube",
          "WhatsApp / Telegram (friends or groups)": "WhatsApp / Telegram",
          "Word of mouth (friends/family)": "मुंहज़ुबानी (दोस्त / परिवार)",
          "Product Hunt": "Product Hunt",
          "Other": "अन्य",
          //Push Notification
          'Push Notification': 'पुश नोटिफिकेशन',
          PlatformTextConfig.dailyTitle: 'दैनिक भविष्यफल',
          PlatformTextConfig.weeklyTitle: 'साप्ताहिक भविष्यफल',
          PlatformTextConfig.yearlyTitle: 'वार्षिक भविष्यफल',
          PlatformTextConfig.lifePredictionLanding: 'जीवन भविष्यवाणी',
          'Promotions & Offers': 'प्रमोशन और ऑफ़र',
          'Warnings': 'चेतावनी',
          'Consultation': 'परामर्श',
          'General': 'सामान्य',
          'Astrologer appointment on': 'ज्योतिषी से मिलने का समय',
          'You have an appointment on': 'आपकी अपॉइंटमेंट इस तारीख को है।',
          'Your Daily Prediction have been generated':
              'आपकी दैनिक भविष्यवाणी तैयार हो गई है।',
          'Your Weekly Prediction have been generated':
              'आपकी साप्ताहिक भविष्यवाणी तैयार हो गई है।',
          'Your Yearly Prediction have been generated':
              'आपकी वार्षिक भविष्यवाणी तैयार हो गई है।',
          'Clear All': 'सभी साफ करें',
          'Daily Prediction': 'दैनिक भविष्यवाणियाँ',
          'Weekly Prediction': 'साप्ताहिक भविष्यवाणियाँ',
          'Yearly Prediction': 'वार्षिक भविष्यवाणियाँ',
          'Notifications': 'सूचनाएं',
          'There are no Consultation updates.': 'कोई कंसल्टेशन अपडेट नहीं हैं।',
          'There are no recent general updates from your astrological guidance':
              'आपकी ज्योतिषीय सलाह से कोई हालिया सामान्य अपडेट नहीं है।',
          //support
          'Got a question?\nOur support team is here to guide your path':
              'कोई प्रश्न है?\nआपकी सहायता के लिए हमारी सपोर्ट टीम यहाँ मौजूद है',
          'Enter feedback or query here...':
              'यहाँ अपना फीडबैक या प्रश्न दर्ज करें',
          'Submit': 'सबमिट करें',
          //FAQs
          'Find answers to common questions\nabout our astrology services.':
              'हमारी ज्योतिष सेवाओं के सामान्य\nप्रश्नों के उत्तर खोजें',
          'Still have questions?': 'अभी भी प्रश्न हैं?',
          'Contact Support': 'सपोर्ट से संपर्क करें',
          'search_help': 'सहायता खोजें',
          //panchang
          'WeekDay': 'वार',
          'Thithi': 'तिथि',
          'Karna': 'करण',
          'Yoga': 'योग',
          'Sunrise': 'सूर्योदय',
          'Sunset': 'सूर्यास्त',
          'Rahu Kalam': 'राहु काल',
          'Yama Kanda': 'यम गंड',
          'Auspicious Time': 'शुभ मुहूर्त',
          'Paksha': 'पक्ष',
          'Amirthathi Yoga': 'अमृत योग',
          'COMING SOON': 'जल्द आ रहा है',
          "panchang_single_format": "(name) तक (time) (next)",
          'otp_response': "(title) सत्यापन\nOTP सफलतापूर्वक भेजा गया।",

          //Horoscope
          PlatformTextConfig.horoscope: 'राशिफल',
          'Name': 'नाम',
          'Place': 'स्थान',
          'Lagna': 'लग्न',
          'South Indian Chart': 'दक्षिण भारतीय कुंडली',
          'North Indian Chart': 'उत्तर भारतीय कुंडली',
          //weekly predictions
          "Hope you're having a wonderful start to your day.":
              "आशा है आपके दिन की शुरुआत शानदार रही होगी.",
          "Good morning,": 'शुभ प्रभात,',
          'Sunday': 'रविवार',
          'Monday': 'सोमवार',
          'Tuesday': 'मंगलवार',
          'Wednesday': 'बुधवार',
          'Thursday': 'गुरुवार',
          'Friday': 'शुक्रवार',
          'Saturday': 'शनिवार',
          'Chandrashtama': 'चंद्राष्टम',
          'Predictions are based on birth details in your profile section':
              'भविष्यवाणियां आपकी प्रोफ़ाइल अनुभाग में मौजूद जन्म विवरण पर आधारित हैं।',
          //yearly prediction
          'Planetary Transits': 'ग्रहों का गोचर',
          'Categorized Predictions': 'श्रेणीबद्ध भविष्यवाणियाँ',
          'Jupiter': 'गुरु',
          'Saturn': 'शनि ',
          'Rahu': 'राहु',
          'Ketu': 'केतु',
          'Current_Dasa': 'वर्तमान दशा',
          'Career Overview': 'आजीविका अवलोकन',
          'Finance Overview': 'वित्त अवलोकन',
          'Health Overview': 'स्वास्थ्य अवलोकन',
          'Marriage/Relationship Overview': 'विवाह/संबंध का संक्षिप्त विवरण',
          'Remedies': 'उपाय',
          'Chanting': 'जप',
          'Puja': 'पूजा',
          'Charity': 'दान',
          'Regenerate': 'पुनः उत्पन्न करें',
          'Consult Astrologer': 'ज्योतिषी से संपर्क करें',
          'Astrology Consultation': 'ज्योतिष परामर्श',
          'First Half of': 'पहला भाग',
          'Second Half of': 'दूसरा भाग',
          //Life predictions
          PlatformTextConfig.lifeTitle: 'जीवन भविष्यवाणियाँ',
          'General\nCharacteristics': 'सामान्य\nविशेषताएँ',
          'Career\nPredictions': 'आजीविका\nभविष्यवाणियाँ',
          'Relationship\nPredictions': 'रिश्तों की\nभविष्यवाणियाँ',
          'Wealth\nPredictions': 'धन की\nभविष्यवाणियाँ',
          'Health\nPredictions': 'स्वास्थ्य\nभविष्यवाणियाँ',
          'Current\nTime Period': 'वर्तमान\nसमय अवधि',
          //Daily Predictions
          'Upgrade to receive daily predictions at 6 AM':
              'सुबह 6 बजे दैनिक भविष्यवाणियां प्राप्त करने के लिए अपग्रेड करें।',
          'Your daily predictions was scheduled for 6 AM':
              'आपकी दैनिक भविष्यवाणी सुबह 6 बजे के लिए निर्धारित थी।',
          'Career': 'करियर',
          'Relationship': 'रिश्ते',
          'Wealth': 'धन की ',
          'Health': 'स्वास्थ्य',
          //Marriage Match Making
          'Marriage Match Making': 'कुंडली मिलान',
          'Boy Name': 'लड़के नाम',
          'Girl Name': 'लड़की नाम',
          'Total Compatibility Score': 'कुल अनुकूलता स्कोर',
          'Kuta': 'कूट',
          'Gained': 'प्राप्त',
          'Max': 'अधिकतम',
          'Present': 'उपस्थित',
          'Absent': 'अनुपस्थित',
          'Expert Connect': 'visheshagy se sampark karen',
          'Check astrological compatibility for a perfect match':
              'एक परफेक्ट मैच के लिए ज्योतिषीय अनुकूलता',
          'Boy Details': 'लड़के का विवरण',
          'Girl Details': 'लड़की का विवरण',
          'Calculate Match': 'मिलान गणना करें',
          'Enter boy\'s name': 'पुरुष का नाम',
          'Enter girl\'s name': 'महिला का नाम',
          //Subscriptions
          'Subscription': 'सदस्यताएँ',
          'Auto Schedule Daily Predictions':
              'दैनिक भविष्यफल को ऑटो शेड्यूल करें',
          'Auto Schedule Weekly Predictions':
              'साप्ताहिक भविष्यफल को ऑटो शेड्यूल करें',
          'Book Consultations': 'परामर्श बुक करें',
          'Basic Horoscope Chart': 'बेसिक कुंडली चार्ट',
          'Edit Horoscope Details': 'कुंडली विवरण संपादित करें',
          'Unlimited Number Of Chat Per Week': 'प्रति सप्ताह असीमित चैट',
          'Download Chat History': 'चैट इतिहास डाउनलोड करें',
          'Pick Chat Avatar': 'चैट अवतार चुनें',
          'Pick Chat Style': 'चैट शैली चुनें',
          'Life Predictions': 'जीवन भविष्यफल',
          'Yearly Predictions': 'वार्षिक भविष्यफल',
          'Personalized Panchang': 'व्यक्तिगत पंचांग',
          'Continue': 'जारी रखें',
          'Payment Summary': 'भुगतान सारांश',
          'Pay Now': 'अभी भुगतान करें',
          'Plan Cost': 'योजना लागत',
          'Discount': 'छूट',
          'Total Cost': 'कुल लागत',
          'Payment Successful': 'भुगतान सफल',
          'Try Premium Plan': 'प्रीमियम प्लान आज़माएँ',
          '1 month': '१ महिना',
          'month': 'महिना',
          'months': 'महीने',
          'year': 'वर्ष',
          'Compare the plans': 'योजनाओं की तुलना करें',
          'Welcome to\nTeksage!': 'Teksage में आपका स्वागत है!',
          'Your 24/7 Personal Astrologer is here\n—now at just':
              'आपका 24/7 निजी ज्योतिषी यहाँ है - अब बस',
          'per month': 'प्रति महीने',
          'Unlock premium features': 'प्रीमियम सुविधाएँ अनलॉक करें',
          'Unlimited AI voice chat in your own language':
              'आपकी मातृभाषा में असीमित एआई वॉयस  Chat',
          'Yearly insights & life predictions':
              'वार्षिक अंतर्दृष्टि और जीवन की भविष्यवाणियाँ',
          'Personalised Panchang for your horoscope':
              'आपकी कुंडली के लिए व्यक्तिगत पंचांग',
          'Upgrade Plan': 'उन्नयन योजना',
          'Skip': 'छोडना',
          'Your Current Plan': 'आपकी वर्तमान योजना',
          'days left': 'दिन शेष',
          'Recommended': 'अनुशंसित',
          'membership': 'सदस्यता',
          //Dialog box
          'Plan Expired': 'प्लान समाप्त हो गया',
          'Premium Feature': 'प्रीमियम फीचर',
          'Unlock all features by choosing a plan':
              'एक प्लान चुनकर सभी फीचर्स अनलॉक करें',
          'Purchase Plan': 'प्लान खरीदें',
          'Plan': 'योजना',
          'Slots Selected': 'चुने गए स्लॉट्स',
          'Selected slots will be lost if you change the date. Would you like to save them first?':
              'यदि आप तारीख बदलते हैं तो चुने गए स्लॉट्स खो जाएंगे। क्या आप पहले उन्हें सेव करना चाहेंगे?',
          'Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!':
              'आपके सितारे आपको मार्गदर्शन करते हैं, और आपका फीडबैक हमें ⭐\nआज ही Teksage को रेट करें!',
          'Rate Now': 'अभी रेट करें',
          'Allow Location Access': 'लोकेशन एक्सेस की अनुमति दें',
          'We need your location to get prices in your local currency (INR, USD, etc.)':
              'आपकी स्थानीय मुद्रा में कीमतें दिखाने के लिए हमें आपकी लोकेशन की आवश्यकता है',
          'Allow': 'अनुमति दें',
          'Not Allow': 'अनुमति न दें',
          'Go to Settings': 'सेटिंग्स पर जाएं',
          'Are you sure you want to logout?': 'क्या आप लॉग आउट करना चाहते हैं?',
          'Discard': 'खारिज करना',
          'You have unsaved changes.\nDo you want to discard them and go back?':
              'आपके बदलाव सेव नहीं हुए हैं।\nक्या आप उन्हें छोड़ना चाहते हैं और वापस जाना चाहते हैं?',
          //Error Validate
          'Please Enter the First Name': 'कृपया पहला नाम दर्ज करें',
          'Please Enter the Second Name': 'कृपया अंतिम नाम दर्ज करें',
          'Please enter a valid Email': 'कृपया मान्य ईमेल दर्ज करें',
          'Please verify your Email': 'कृपया अपना ईमेल सत्यापित करें',
          'Enter a valid Email': 'मान्य ईमेल दर्ज करें',
          'Select country code': 'देश का कोड चुनें',
          'Enter valid (mobileLengthLimit)-digit number':
              'कृपया मान्य (mobileLengthLimit) अंकों का नंबर दर्ज करें',
          'cannot be empty': 'खाली नहीं हो सकता',
          'Please enter the AI Chat Language': 'कृपया AI चैट भाषा दर्ज करें',
          'Please enter the Date of birth': 'कृपया जन्म तिथि दर्ज करें',
          'Please enter the Time of birth': 'कृपया जन्म समय दर्ज करें',
          'Please enter the Place of birth': 'कृपया जन्म स्थान दर्ज करें',
          'Please select one value': 'कृपया एक मान चुनें',
          'Please fill all the required fields': 'कृपया सभी आवश्यक फ़ील्ड भरें',
          'Please Enter the valid Mobile Number':
              'कृपया मान्य मोबाइल नंबर दर्ज करें',
          'Choose a preferred language to continue':
              'आगे बढ़ने के लिए अपनी पसंदीदा भाषा चुनें',
          '*This slot is already booked!': 'यह स्लॉट पहले से बुक है',
          '* Choose a preferred timing': 'अपनी पसंद का समय चुनें',
          'Kindly select one or more categories':
              'कृपया एक या अधिक श्रेणियाँ चुनें',
          'Error loading questions': 'प्रश्न लोड करने में त्रुटि',
          'No questions found': 'कोई प्रश्न नहीं मिला',
          "Please enter Boy's name": 'कृपया लड़के का नाम दर्ज करें',
          "Please select Boy's Nakshatram": 'कृपया लड़के का नक्षत्र चुनें',
          "Please select Girl's Nakshatram": 'कृपया लड़की का नक्षत्र चुनें',
          "Please enter Girl's name": 'कृपया लड़की का नाम दर्ज करें',
          "Please select Girl's Rasi": 'कृपया लड़की की राशि चुनें',
          "Please select Boy's Rasi": 'कृपया लड़के की राशि चुनें',
          'Second language must be different from first':
              'दूसरी भाषा पहली भाषा से अलग होनी चाहिए',
          //Snack bar
          'Permission permanently denied. Please enable it in settings.':
              'अनुमति स्थायी रूप से अस्वीकृत. कृपया सेटिंग्स में सक्षम करें',
          'Permission Denied': 'अनुमति अस्वीकृत',
          'Payment verification failed. Please try again.':
              'भुगतान सत्यापन असफल. कृपया पुनः प्रयास करें',
          'Payment failed. Please try again.':
              'भुगतान असफल. कृपया पुनः प्रयास करें',
          'Please Contact Support team!': 'कृपया सपोर्ट टीम से संपर्क करें!',
          'Payment Error, Contact Support team!.':
              'भुगतान त्रुटि, सपोर्ट टीम से संपर्क करें!',
          'Payment successful!': 'भुगतान सफल!',
          'Please enable location permission to access this feature.':
              'इस सुविधा के लिए लोकेशन अनुमति सक्षम करें',
          'Select valid country code and number': 'मान्य देश कोड और नंबर चुनें',
          'Please contact Teksage Admin': 'कृपया टेकसेज एडमिन से संपर्क करें',
          'Error in Fetching Country code': 'देश कोड प्राप्त करने में त्रुटि',
          'Please select a country code first': 'कृपया पहले देश कोड चुनें',
          'Failed to fetch country list': 'देश सूची प्राप्त करने में विफल',
          'Please select the first language first':
              'कृपया पहले प्राथमिक भाषा चुनें',
          'Failed to save Questions': 'प्रश्न सहेजने में विफल',
          'Error creating slots, Please try again.':
              'स्लॉट बनाने में त्रुटि, पुनः प्रयास करें',
          'Slot Updated Successfully.': 'स्लॉट सफलतापूर्वक अपडेट हुआ',
          'At least one category must be selected.':
              'कम से कम एक श्रेणी चुनना आवश्यक है',
          'At least one language must be selected.':
              'कम से कम एक भाषा चुनना आवश्यक है',
          'We couldn’t fetch your horoscope. Please try again.':
              'आपकी कुंडली प्राप्त नहीं कर सके. पुनः प्रयास करें',
          'Failed to fetch data. Please try again.':
              'डेटा प्राप्त करने में विफल. पुनः प्रयास करें',
          'Failed to update notification status': 'सूचना स्थिति अपडेट असफल',
          'Please try again after sometime':
              'कृपया कुछ समय बाद पुनः प्रयास करें',
          'All Notification has been cleared': 'सभी सूचनाएँ साफ कर दी गई हैं',
          'Please enable location access to view relevant subscription plans':
              'संबंधित प्लान देखने हेतु लोकेशन सक्षम करें',
          'Failed to regenerate prediction. Please try again.':
              'भविष्यफल पुनः बनाने में विफल',
          'An error occurred while regenerating. Please try again.':
              'पुनः जनरेट करते समय त्रुटि हुई',
          'Prediction regenerated successfully':
              'भविष्यफल सफलतापूर्वक पुनः बनाया गया',
          'Please enter a valid OTP': 'कृपया मान्य OTP दर्ज करें',
          'Choose your Style, Avatar and Language to begin your cosmic journey.':
              'अपनी कॉस्मिक यात्रा शुरू करने के लिए स्टाइल, अवतार और भाषा चुनें',
          'Select a Style and Avatar to begin your cosmic journey.':
              'यात्रा शुरू करने के लिए स्टाइल और अवतार चुनें',
          'Select a Style for your answer’s flow.': 'उत्तर की शैली चुनें',
          'Select an Avatar that reflects your spirit.':
              'अपनी पहचान दर्शाने वाला अवतार चुनें',
          'Select a Language for your answer’s flow.':
              '– उत्तर के प्रवाह के लिए भाषा चुनें',
          'Keep it short and cosmic — max 300 characters':
              'छोटा और कॉस्मिक रखें — अधिकतम 300 अक्षर',
          'You can answer only after completing the consultation.':
              'परामर्श पूर्ण होने के बाद ही उत्तर दे सकते हैं',
          'Timeout. Please retry.': 'समय समाप्त. पुनः प्रयास करें',
          'Kindly enter your question.': 'कृपया अपना प्रश्न दर्ज करें',
          'Your subscription has expired. Subscribe to continue.':
              'आपकी सदस्यता समाप्त हो गई है. जारी रखने के लिए सदस्यता लें',
          'You’ve reached your message limit. Subscribe to continue.':
              'मैसेज सीमा पूरी हो चुकी है. जारी रखने के लिए सदस्यता लें',
          'Retry response timed out.': 'पुनः प्रयास की समय सीमा समाप्त',
          'Response is taking longer than expected. Please check your network.':
              'उत्तर में समय लग रहा है. नेटवर्क जांचें',
          'Thanks for reaching out! Your query has been received — our team will respond shortly.':
              'धन्यवाद! आपकी क्वेरी प्राप्त हो गई है — हमारी टीम शीघ्र उत्तर देगी',
          'Something went wrong. Please try again.':
              'कुछ गलत हो गया. पुनः प्रयास करें',
          'Logout failed. Please try again.': 'लॉगआउट असफल. पुनः प्रयास करें',
          'Thanks for using Teksage': 'Teksage उपयोग करने के लिए धन्यवाद',
          'Your message looks empty after removing hidden characters. Try typing or paste plain text.':
              'छिपे हुए कैरेक्टर हटाने के बाद आपका मैसेज खाली दिख रहा है। टाइप करने या सादा टेक्स्ट पेस्ट करने की कोशिश करें।',
          'Error in sending OTP': 'OTP भेजते समय एक एरर आ गया।',
          'Network error. Please check your connection and try again.':'नेटवर्क एरर। कृपया अपना कनेक्शन चेक करें और फिर से कोशिश करें।',
          'OTP Verified':'ओटीपी सत्यापित',
          //Astrology consultations
          'What do you\nneed guidance on?':
              'आपको किस विषय पर मार्गदर्शन चाहिए?',
          'Select the categories and continue': 'श्रेणियाँ चुनें और आगे बढ़ें',
          'Marriage & relationships': 'विवाह और संबंध',
          'Marriage & Relationships': 'विवाह और संबंध',
          'All': 'सभी',
          'Choose your\npreferred language': 'अपनी पसंदीदा भाषा चुनें',
          'This will help us to match the best astrologer':
              'यह हमें आपके लिए सर्वश्रेष्ठ ज्योतिषी से मिलाने में मदद करेगा',
          'First Preference': 'पहली पसंद',
          'Second Preference': 'दूसरी पसंद',
          'Select language': 'भाषा चुनें',
          'Top 5 astrologers\nbased on preferences':
              'आपकी पसंद के आधार पर शीर्ष 5 ज्योतिषी',
          'Expert Profile': 'विशेषज्ञ प्रोफ़ाइल',
          'Reviews': 'समीक्षाएँ',
          'No reviews available': 'कोई समीक्षा उपलब्ध नहीं',
          'Book Consultation': 'परामर्श बुक करें',
          'No slots available': 'कोई स्लॉट उपलब्ध नहीं',
          'Find & Consult Astrologers':
              'ज्योतिषियों को खोजें और उनसे परामर्श लें',
          '100+ Astrologers': '100+ ज्योतिषी',
          'Explore and find your perfect match':
              'खोजें और अपना आदर्श साथी खोजें',
          'Upcoming': 'आगामी',
          'Completed': 'पुरा होना',
          'View Details': 'विवरण देखें',
          'View\nDetails': 'विवरण देखें',
          'Meeting Link': 'meeting लिंक',
          'Choose your avatar': 'अपना अवतार चुनें',
          'Choose how AI replies': 'चुनें कि AI कैसे उत्तर देता है',
          'Concise': 'संक्षिप्त',
          'Booking Details': 'Booking विवरण',
          'Consultation Fee': 'परामर्श शुल्क',
          'Total Fee': 'कुल शुल्क',
          'Confirm & Proceed to Pay': 'पुष्टि करें और भुगतान करें',
          'Consultation Details': 'परामर्श विवरण',
          'Consulting On': 'परामर्श विषय',
          'Give Rating': 'रेटिंग दें',
          'Ratings': 'रेटिंग',
          'You have no upcoming meetings at the moment.':
              'अभी आपकी कोई आने वाली मीटिंग नहीं है।',
          'You have no completed meetings at the moment.':
              'अभी आपकी कोई मीटिंग पूरी नहीं हुई है।',
          'Book Now': 'अभी बुक करें',
          'Yes': 'हाँ',
          'No': 'नहीं',
          'Queries you asked': 'आपके द्वारा पूछे गए प्रश्न',
          'Enter Promo Code': 'प्रोमो कोड दर्ज करें',
          'Applied': 'लागू किया गया',
          'Apply': 'लागू करें',
          'I consent to share my personal information & horoscope with the astrologer':
              'मैं अपनी व्यक्तिगत जानकारी और कुंडली ज्योतिषी के साथ साझा करने की सहमति देता/देती हूँ',
          'I consent to share my personal information & star chart with the advisor':
              'मैं अपनी पर्सनल जानकारी और स्टार चार्ट एडवाइजर के साथ शेयर करने के लिए सहमत हूँ।',
          'Kindly select your preferred language':
              'कृपया अपनी पसंदीदा भाषा चुनें',
          'Write your consultation query here':
              'अपनी कंसल्टेशन क्वेरी यहाँ लिखें',
          'Enter your question here...': 'अपना प्रश्न यहाँ दर्ज करें...',
          'Next': 'अगला',
          'Previous': 'पहले का',
          '* All questions are required to help us serve you better.':
              '* सभी सवालों के जवाब देना ज़रूरी है ताकि हम आपको बेहतर सर्विस दे सकें।',
          'Slots': 'स्लॉट्स',
          '30 mins each': 'प्रत्येक 30 मिनट',
          'Astrologer submitted answers for your queries':
              'ज्योतिषी ने आपके सवालों के जवाब सबमिट कर दिए हैं।',
          'Meet Again': 'फिर\nमिलेंगे',
          'Rate your experience with this astrologer appointment':
              'इस ज्योतिषी अपॉइंटमेंट के साथ अपने अनुभव को रेट करें',
          'Save & Submit': 'सहेजें और सबमिट करें',
          'Type your answer here...': 'अपना जवाब यहाँ टाइप करें...',
          'Done': 'हो गया',
          'booked a slot on': 'पर एक\nस्लॉट बुक किया',
          "meeting_with": "{name} के साथ बैठक",
          //Voice chat
          'Jyotish voice guide for all your needs. Start you conversation today':
              'आपकी सभी जरूरतों के लिए ज्योतिषीय आवाज गाइड। आज ही अपनी बातचीत शुरू करें।',
          'Jyotish voice guide for all your needs':
              'आपकी सभी जरूरतों के लिए ज्योतिषीय आवाज गाइड',
          'The Seeker': 'ढूँढ़ने वाला',
          'The Luminary': 'प्रकाशक',
          'The Guardian': 'अभिभावक',
          'The Pathfinder': 'सलाई',
          'Ideal for those who want in-depth astrological analysis and clear reasoning':
              'गहन ज्योतिषीय विश्लेषण और स्पष्ट तर्क चाहने वालों के लिए आदर्श।',
          'Ideal for those who seek joyful and engaging astrology guidance':
              'जो लोग आनंददायक और आकर्षक ज्योतिषीय मार्गदर्शन चाहते हैं, उनके लिए आदर्श।',
          'Ideal for those looking for reassurance and personal connection in predictions':
              'भविष्यवाणियों में आश्वासन और व्यक्तिगत जुड़ाव चाहने वालों के लिए आदर्श।',
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions':
              'करियर में तरक्की, सफलता की रणनीतियों या स्पष्ट समाधान चाहने वालों के लिए आदर्श।',
          'Tap the mic': 'माइक टैप करें',
          'Start speaking in your own language':
              'अपनी मातृभाषा में बोलना शुरू करें',
          'Chat or record your thoughts...': 'Chat or record your thoughts...',
          'AI can understand all languages': 'AI सभी भाषाओं को समझ सकता है।',
          'Got it, typing that up for you…':
              'समझ गया, मैं आपके लिए इसे टाइप कर रहा हूँ...',
          'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology.':
              'विवरण - एआई-संचालित ज्योतिष के माध्यम से अपने भविष्य, करियर, रिश्तों और अन्य चीजों के बारे में व्यक्तिगत अंतर्दृष्टि प्राप्त करें।',
          'Generate Yearly Prediction': 'वार्षिक भविष्यवाणी प्राप्त करें',
          'Generate Life Prediction': 'जीवन भविष्यवाणी प्राप्त करें',
          'Quick, direct replies without extra details — ideal for instant answers.':
              'बिना अतिरिक्त विवरणों के त्वरित और सीधे उत्तर — तुरंत जवाब पाने के लिए आदर्श।',
          'Explanatory': 'व्याख्यात्मक',
          'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.':
              'चरण-दर-चरण स्पष्टता के साथ गहन, संरचित उत्तर — सीखने या विस्तृत जानकारी प्राप्त करने के लिए बिल्कुल उपयुक्त।',
          'Choose an avatar for AI': 'एआई के लिए एक अवतार चुनें',
          'Related questions': 'संबंधित प्रश्न',
          'No response.': 'कोई जबाव नहीं।',
          'Retry': 'पुन: प्रयास करें',
          'Subscribe Now': 'अब सदस्यता लें',
          //Delete Account
          'We value your experience.\nWhat made you decide to leave?':
              'हम आपके अनुभव को महत्व देते हैं.\nआपने जाने का फैसला क्यों किया?',
          "I am having another account": 'मेरा एक और खाता है',
          'App not working properly': 'ऐप ठीक से काम नहीं कर रहा',
          'I don’t like the app': 'मुझे यह ऐप पसंद नहीं है',
          'I am worried about my privacy': 'मुझे अपनी निजता की चिंता है।',
          'You are about to delete\nyour account':
              'आप अपना खाता हटाने वाले हैं',
          'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days':
              'इस खाते से संबंधित सभी डेटा (जिसमें आपकी प्रोफ़ाइल, सेवा, बुकिंग, राशिफल, भविष्यवाणियां शामिल हैं) 45 दिनों में स्थायी रूप से हटा दिए जाएंगे।',
          'Delete Account Now': 'अभी खाता हटाएं',
          'No, I have changed my mind': 'नहीं, मैं अपना मन बदल रहा हूँ।',
          //Astrologer
          'You logged in as Astrologer':
              'आपने ज्योतिषी के तौर पर\nलॉग इन किया है।',
          'Meetings': 'बुकिंग के',
          'View your scheduled appointments & completed ones':
              'अपनी शेड्यूल की गई अपॉइंटमेंट्स और पूरी हो चुकी अपॉइंटमेंट्स देखें',
          'My Availability': 'मेरी अनुसूची',
          'Set your available time slots.': 'अपने टाइम स्लॉट सेट करें।',
          'Select the slots that you are available': 'अपने उपलब्ध स्लॉट चुनें',
          'Showing the available time that you picked':
              'आपके चुने हुए टाइम स्लॉट',
          'Morning': 'सुबह',
          'Afternoon': 'दोपहर',
          'Horoscope details are not available':
              'राशिफल की जानकारी उपलब्ध नहीं है।',
          'Answer': 'उत्तर',
          'View': 'देखना',
          "Queries asked - Time to share your thoughts!":
              "सवाल पूछे गए - अपने विचार शेयर करने का समय!",
          "Queries asked - You've already shared your thoughts!":
              "पूछे गए सवाल - आप पहले ही अपने विचार शेयर कर चुके हैं!",
          'Date': 'तारीख',
          'Time': 'समय',
          'Fees Paid': 'फीस का भुगतान',
          'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.':
              'आपके जीवन के इस महत्वपूर्ण पड़ाव पर, आपकी कुंडली से मिलने वाली जानकारियों के माध्यम से आपका मार्गदर्शन करना मेरे लिए सौभाग्य की बात है।',
          'Tamil': 'தமிழ்',
          'English': 'English',
          'Telugu': 'తెలుగు',
          'Malayalam': 'മലയാളം',
          'Kannada': 'ಕನ್ನಡ',
          'Hindi': 'हिन्दी',
          'Bengali': 'বাংলা',
          'Marathi': 'मराठी',
          'Urdu': 'اردو',
          'Gujarati': 'ગુજરાતી',
          'Odia': 'ଓଡ଼ିଆ',
          'Punjabi': 'ਪੰਜਾਬੀ',
          'Assamese': 'অসমীয়া',
          'Bhojpuri': 'भोजपुरी',
          'Kashmiri': 'کٲشُر',
          'Nepali': 'नेपाली',
          'Sindhi': 'سنڌي',
          'Sinhala': 'සිංහල',
          'Maithili': 'मैथिली',
          'Manipuri': 'মৈতৈলোন্',
          'Santali': 'ᱥᱟᱱᱛᱟᱲᱤ',
          'Years of Experience': 'अनुभव के वर्ष',
          'years': 'वर्ष',
          'Showing Availability': 'उपलब्धता दिखाई\nजा रही है',
          //OTP Screen
          "resend_otp_in_seconds": "OTP दोबारा भेजने में {seconds} सेकंड",
          'Enter Mobile Number': 'मोबाइल नंबर दर्ज करें',
          'Enter Email': 'ईमेल दर्ज करें',
          'Enter your new email and verify it using OTP':
              'अपना नया ईमेल डालें और OTP का इस्तेमाल करके उसे वेरिफ़ाई करें।',
          'Enter your new phone number and verify it using OTP':
              'अपना नया फ़ोन नंबर डालें और OTP का इस्तेमाल करके उसे वेरिफ़ाई करें।',
          'Verify Phone Number': 'फ़ोन नंबर सत्यापित करें',
          'Verify Email': 'ईमेल सत्यापित करें',
          'Verify Existing Phone Number': 'मौजूदा फ़ोन नंबर सत्यापित करें',
          'Verify Existing Email': 'मौजूदा ईमेल सत्यापित करें',
          'For security reasons, kindly verify your existing phone number':
              'सुरक्षा कारणों से, कृपया अपना फ़ोन नंबर वेरिफ़ाई करें।',
          'For security reasons, kindly verify your existing email':
              'सुरक्षा कारणों से, कृपया अपना ईमेल वेरिफाई करें।',
          'We have sent OTP to': 'हमने OTP भेजा है',
          'OTP is valid for 5 Minutes.': 'OTP 5 मिनट के लिए वैलिड है।',
          'Resend OTP': 'ओटीपी दोबारा भेजें',
          //Internet
          'No Internet Connection': 'कोई इंटरनेट कनेक्शन नहीं',
          'Please check your\nnetwork settings':
              'कृपया अपनी नेटवर्क सेटिंग्स जांचें।',
        },
        'mr_IN': {
          'Good day': 'शुभ दिवस ',
          'Astrologer': 'ज्योतिषी',
          'Home': 'होम',
          'Panchang': 'पंचांग',
          'Horoscope': 'कुंडली',
          'Settings': 'सेटिंग्ज',
          'Marriage\nMatch Making': 'पत्रिका\nजुळवणी',
          'Explore Other Predictions': 'इतर भविष्यवाणांचा शोध घ्या',
          PlatformTextConfig.yearlyPrediction: 'वार्षिक\nभविष्य',
          PlatformTextConfig.weeklyPrediction: 'साप्ताहिक\nभविष्य',
          PlatformTextConfig.lifePrediction: 'जीवन\nफलित',
          PlatformTextConfig.dailyPrediction: 'दैनिक\nभविष्य',
          PlatformTextConfig.chatHomePage: 'एआय व्हॉइस\nज्योतिष चॅट',
          'ChatTitle': 'AI व्हॉइस चॅट',
          'Chat Now': 'आता चॅट करा',
          'Thara Bala': 'ताराबल',
          'Chandra Bala': 'चंद्रबल',
          'Astrologer\nConsultation': 'ज्योतिषाचा\nसल्ला घ्या',
          'Astrologer Consultation': 'ज्योतिषाचा सल्ला घ्या',
          'My Profile': 'माझे प्रोफाइल',
          //Settings
          'Profile': 'प्रोफाईल',
          'Push Notifications': 'पुश सूचना',
          'Language': 'भाषा',
          'Subscriptions': 'सदस्यता',
          'Terms & Conditions': 'नियम व अटी',
          'Privacy Policy': 'गोपनीयता धोरण',
          'Support': 'सहाय्यता',
          'FAQs': 'एफएक्यू',
          'Rate us': 'आम्हाला श्रेणी द्या',
          'Rate': 'मूल्यांकन\nकरा',
          'Delete Account': 'खाते रद्द करा',
          'Logout': 'लॉगआउट',
          'Language Updated': 'भाषा बदलली',
          'App language has been changed successfully':
              'अ‍ॅपची भाषा यशस्वीरित्या बदलली आहे.',
               'Click to view':'पाहण्यासाठी क्लिक करा',
          //Profile
          'First Name': 'पहिले नाव',
          'Last Name': 'आडनाव',
          'Email': 'ईमेल',
          'Phone Number': 'फोन नंबर',
          'AI Chat Language': 'एआय चॅट भाषा',
          'Date of Birth': 'जन्मदिनांक',
          'Time of Birth': 'जन्मवेळ',
          'Place of Birth': 'जन्मस्थान',
          'Current Location': 'वर्तमान स्थान',
          'Rasi': 'राशी',
          'Nakshatram': 'नक्षत्र',
          'Edit': 'संपादन करा',
          'Profile Details': 'प्रोफाइल तपशील',
          'Complete Profile': 'संपूर्ण प्रोफाइल',
          'Save': 'जतन करा',
          'Hi (name)!': 'नमस्कार (name)!',
          'Verify': 'पडताळणी करा',
          'Change': 'बदला',
          'Enter place of birth': 'जन्मस्थान प्रविष्ट करा',
          'Enter Current location': 'वर्तमान स्थान प्रविष्ट करा',
          'Select a place': 'एक जागा निवडा',
          'Select any one Option': 'कोणताही एक पर्याय निवडा',
          'How did you first hear about Teksage':
              'तुम्हाला Teksage बद्दल प्रथम कसे कळले',
          'How did you first hear about Teksage?':
              'तुम्हाला Teksage बद्दल प्रथम कसे कळले?',
          'Select a language': 'एक भाषा निवडा',
          "Google Play Store / App Store": "Google Play Store / App Store",
          "Google Search": "Google शोध",
          "Quora": "Quora",
          "Facebook / Instagram": "Facebook / Instagram",
          "YouTube": "YouTube",
          "WhatsApp / Telegram (friends or groups)": "WhatsApp / Telegram",
          "Word of mouth (friends/family)": "तोंडी शिफारस (मित्र / कुटुंब)",
          "Product Hunt": "Product Hunt",
          "Other": "इतर",
          //Push Notification
          'Push Notification': 'पुश सूचना',
          PlatformTextConfig.dailyTitle: 'दैनिक राशिभविष्य',
          PlatformTextConfig.weeklyTitle: 'साप्ताहिक भविष्य',
          PlatformTextConfig.yearlyTitle: 'वार्षिक भविष्य',
          PlatformTextConfig.lifePredictionLanding: 'जीवन फलित',
          'Promotions & Offers': 'जाहिराती आणि ऑफर',
          'Warnings': 'इशारा',
          'Consultation': 'सल्लामसलत',
          'General': 'सामान्य',
          'Astrologer appointment on': 'ज्योतिषींची भेट',
          'You have an appointment on': 'तुमची अपॉइंटमेंट आहे',
          'Your Daily Prediction have been generated':
              'तुमचा दैनिक अंदाज तयार झाला आहे',
          'Your Weekly Prediction have been generated':
              'तुमचा साप्ताहिक अंदाज तयार झाला आहे',
          'Your Yearly Prediction have been generated':
              'तुमचा वार्षिक अंदाज तयार झाला आहे',
          'Clear All': 'सर्व साफ करा',
          'Daily Prediction': 'दैनिक भविष्य',
          'Weekly Prediction': 'साप्ताहिक भविष्य',
          'Yearly Prediction': 'वार्षिक भविष्य',
          'Notifications': 'सूचना',
          'There are no Consultation updates.':
              'सल्लामसलतीबाबत कोणतेही नवीन अपडेट्स नाहीत.',
          'There are no recent general updates from your astrological guidance':
              'तुमच्या ज्योतिष मार्गदर्शनाकडून कोणतेही नवीन सामान्य अपडेट्स नाहीत.',
          //support
          'Got a question?\nOur support team is here to guide your path':
              'प्रश्न आहे का?\nआमची सपोर्ट टीम तुम्हाला मार्गदर्शन करण्यासाठी येथे आहे',
          'Enter feedback or query here...':
              'तुमची प्रतिक्रिया किंवा प्रश्न येथे प्रविष्ट करा',
          'Submit': 'सबमिट',
          //FAQs
          'Find answers to common questions\nabout our astrology services.':
              'आमच्या ज्योतिष सेवांबद्दलच्या सामान्य प्रश्नांची उत्तरे शोधा.',
          'Still have questions?': 'अजूनही काही प्रश्न आहेत का?',
          'Contact Support': 'सहाय्यता कक्षाशी संपर्क साधा',
          'search_help': 'शोध मदत',
          //panchang
          'WeekDay': 'वार',
          'Thithi': 'तिथि',
          'Karna': 'करण',
          'Yoga': 'योग',
          'Sunrise': 'सूर्योदय',
          'Sunset': 'सूर्यास्त',
          'Rahu Kalam': 'राहुकाळ',
          'Yama Kanda': 'यमगंड',
          'Auspicious Time': 'शुभ मुहूर्त',
          'Paksha': 'पक्ष',
          'Amirthathi Yoga': 'अमृत योग',
          'COMING SOON': 'लवकरच येत आहे',
          "panchang_single_format": "(name) पर्यंत (time) (next)",
          'otp_response': "(title) पडताळणी\nOTP यशस्वीरित्या पाठवला.",

          //Horoscope
          PlatformTextConfig.horoscope: 'कुंडली',
          'Name': 'नाव',
          'Place': 'जन्मस्थान',
          'Lagna': 'लग्न',
          'South Indian Chart': 'दक्षिण भारतीय कुंडली',
          'North Indian Chart': 'उत्तर भारतीय कुंडली',
          //weekly predictions
          "Hope you're having a wonderful start to your day.":
              "आशा आहे की तुमचा दिवसाची सुरुवात छान झाली असेल.",
          "Good morning,": 'शुभ प्रभात,',
          'Sunday': 'रविवार',
          'Monday': 'सोमवार',
          'Tuesday': 'मंगळवार',
          'Wednesday': 'बुधवार',
          'Thursday': 'गुरुवार',
          'Friday': 'शुक्रवार',
          'Saturday': 'शनिवार',
          'Chandrashtama': 'चंद्राष्टम',
          'Predictions are based on birth details in your profile section':
              'तुमची भविष्यवाणी तुमच्या प्रोफाइलमधील जन्म माहितीवर आधारित आहे.',
          //yearly prediction
          'Planetary Transits': 'ग्रह गोचर',
          'Categorized Predictions': 'विभागवार भविष्य',
          'Jupiter': 'गुरु',
          'Saturn': 'शनि',
          'Rahu': 'राहू',
          'Ketu': 'केतू',
          'Current_Dasa': 'सध्याची दशा',
          'Career Overview': 'व्यावसायिक आढावा',
          'Finance Overview': 'आर्थिक आढावा',
          'Health Overview': 'आरोग्य आढावा',
          'Marriage/Relationship Overview': 'विवाह आणि नातेसंबंध आढावा',
          'Remedies': 'उपाय',
          'Chanting': 'नामस्मरण',
          'Puja': 'पूजा',
          'Charity': 'दान-धर्म',
          'Regenerate': 'पुन्हा निर्माण करा',
          'Consult Astrologer': 'ज्योतिषाचा सल्ला घ्या',
          'Astrology Consultation': 'ज्योतिष सल्ला',
          'First Half of': 'पहिला भाग',
          'Second Half of': 'दुसरा भाग',
          //Life predictions
          PlatformTextConfig.lifeTitle: 'जीवन फलित',
          'General\nCharacteristics': 'सामान्य\nवैशिष्ट्ये',
          'Career\nPredictions': 'करिअर\nभविष्य',
          'Relationship\nPredictions': 'नातेसंबंध\nभविष्य',
          'Wealth\nPredictions': 'आर्थिक\nभविष्य',
          'Health\nPredictions': 'आरोग्य\nभविष्य',
          'Current\nTime Period': 'वर्तमान\nकाळ',
          //Daily Predictions
          'Upgrade to receive daily predictions at 6 AM':
              'सकाळी ६ वाजता दररोजचे अंदाज मिळविण्यासाठी अपग्रेड करा',
          'Your daily predictions was scheduled for 6 AM':
              'तुमचे दैनिक भविष्य सकाळी ६ वाजता नियोजित होते',
          'Career': 'करिअर',
          'Relationship': 'विवाह आणि नातेसंबंध',
          'Wealth': 'आर्थिक',
          'Health': 'आरोग्य',
          //Marriage Match Making
          'Marriage Match Making': 'विवाह जुळवणी',
          'Boy Name': 'मुलाची नाव',
          'Girl Name': 'मुलीची नाव',
          'Total Compatibility Score': 'एकूण सुसंगतता स्कोअर',
          'Kuta': 'कूट',
          'Gained': 'मिळवले',
          'Max': 'कमाल',
          'Present': 'उपस्थित',
          'Absent': 'अनुपस्थित',
          'Expert Connect': 'तज्ञांशी संपर्क साधा',
          'Check astrological compatibility for a perfect match':
              'उत्तम जुळणीसाठी ज्योतिषीय सुसंगतता',
          'Boy Details': 'मुलाची माहिती',
          'Girl Details': 'मुलीची माहिती',
          'Calculate Match': 'गुणमिलन करा',
          'Enter boy\'s name': 'पुरुषाचे नाव',
          'Enter girl\'s name': 'स्त्रीचे नाव',
          //Subscriptions
          'Subscription': 'सदस्यता',
          'Auto Schedule Daily Predictions':
              'दैनिक राशिभविष्य स्वयंचलितरित्या नियोजित करा',
          'Auto Schedule Weekly Predictions':
              'साप्ताहिक भविष्य स्वयंचलितरित्या नियोजित करा',
          'Book Consultations': 'सल्लामसलत बुक करा',
          'Basic Horoscope Chart': 'मूळ कुंडली तक्ता',
          'Edit Horoscope Details': 'कुंडलीचा तपशील संपादन करा',
          'Unlimited Number Of Chat Per Week': 'दर आठवड्याला अमर्यादित चॅट',
          'Download Chat History': 'चॅट इतिहास डाउनलोड करा',
          'Pick Chat Avatar': 'चॅट अवतार निवडा',
          'Pick Chat Style': 'चॅट शैली निवडा',
          'Life Predictions': 'जीवन फलित',
          'Yearly Predictions': 'वार्षिक भविष्य',
          'Personalized Panchang': 'वैयक्तिकृत पंचांग',
          'Continue': 'सुरू ठेवा',
          'Payment Summary': 'पेमेंटचा तपशील',
          'Pay Now': 'आता पैसे भरा',
          'Plan Cost': 'योजनेची किंमत',
          'Discount': 'सवलत',
          'Total Cost': 'एकूण खर्च',
          'Payment Successful': 'पेमेंट यशस्वी झाले',
          'Try Premium Plan': 'प्रीमियम प्लॅन्स वापरून पहा',
          '1 month': '१ महिना',
          'month': 'महिना',
          'months': 'महिने',
          'year': 'वर्ष',
          'Compare the plans': 'योजनांची तुलना करा',
          'Welcome to\nTeksage!': 'Teksage मध्ये आपले स्वागत आहे!',
          'Your 24/7 Personal Astrologer is here\n—now at just':
              'तुमचा २४/७ वैयक्तिक ज्योतिषी येथे आहे - आता फक्त',
          'per month': 'दरमहा',
          'Unlock premium features': 'प्रीमियम वैशिष्ट्ये अनलॉक करा',
          'Unlimited AI voice chat in your own language':
              'तुमच्या मातृभाषेत अमर्यादित एआय व्हॉइस  Chat',
          'Yearly insights & life predictions':
              'वार्षिक अंतर्दृष्टी आणि जीवन अंदाज',
          'Personalised Panchang for your horoscope':
              'तुमच्या कुंडलीसाठी वैयक्तिकृत पंचांग',
          'Upgrade Plan': 'अपग्रेड योजना',
          'Skip': 'वगळा',
          'Your Current Plan': 'तुमची सध्याची योजना',
          'days left': 'दिवस राहिले',
          'membership': 'सदस्यत्व',
          //Dialog box
          'Plan Expired': 'प्लॅन संपला आहे',
          'Premium Feature': 'प्रीमियम वैशिष्ट्य/प्रीमियम फीचर',
          'Unlock all features by choosing a plan':
              'प्लॅन निवडा आणि सर्व फीचर्स अनलॉक करा.',
          'Recommended': 'शिफारस केलेले',
          'Purchase Plan': 'खरेदी योजना',
          'Plan': 'योजना',
          'Slots Selected': 'निवडलेले स्लॉट्स',
          'Selected slots will be lost if you change the date. Would you like to save them first?':
              'तुम्ही तारीख बदलल्यास निवडलेले स्लॉट रद्द होतील. तुम्ही ते आधी सेव्ह करू इच्छिता का?',
          'Your stars guide you, and your feedback guides us ⭐ \nRate Teksage today!':
              'तुमचे तारे तुम्हाला मार्गदर्शन करतात आणि तुमचा अभिप्राय आम्हाला मार्गदर्शन करतो ⭐\nआजच टेक्ससेजला रेटिंग द्या!',
          'Rate Now': 'आता रेट करा',
          'Allow Location Access': 'स्थान प्रवेशास परवानगी द्या',
          'We need your location to get prices in your local currency (INR, USD, etc.)':
              'तुमच्या स्थानिक चलनातील किंमती पाहण्यासाठी आम्हाला तुमचे लोकेशन आवश्यक आहे',
          'Allow': 'परवानगी द्या',
          'Not Allow': 'परवानगी देऊ नका',
          'Go to Settings': 'सेटिंग्ज वर जा',
          'Are you sure you want to logout?':
              'तुम्हाला खात्री आहे की तुम्हाला लॉगआउट करायचे आहे?',
          'Discard': 'रद्द करा',
          'You have unsaved changes.\nDo you want to discard them and go back?':
              'तुमच्याकडे जतन न केलेले बदल आहेत.\nतुम्ही ते बदल रद्द करून मागे जाऊ इच्छिता का?',
          //Error Validate
          'Please Enter the First Name': 'कृपया पहिले नाव प्रविष्ट करा',
          'Please Enter the Second Name': 'कृपया आडनाव प्रविष्ट करा',
          'Please enter a valid Email': 'कृपया योग्य ईमेल प्रविष्ट करा',
          'Please verify your Email': 'कृपया तुमचा ईमेल सत्यापित करा',
          'Enter a valid Email': 'योग्य ईमेल प्रविष्ट करा',
          'Select country code': 'देशाचा कोड निवडा',
          'Enter valid (mobileLengthLimit)-digit number':
              'योग्य (mobileLengthLimit)-अंकी क्रमांक प्रविष्ट करा',
          'cannot be empty': 'रिकामे असू शकत नाही',
          'Please enter the AI Chat Language':
              'कृपया एआय चॅटची भाषा प्रविष्ट करा',
          'Please enter the Date of birth': 'कृपया जन्मतारीख प्रविष्ट करा',
          'Please enter the Time of birth': 'कृपया जन्माची वेळ प्रविष्ट करा',
          'Please enter the Place of birth': 'कृपया जन्म ठिकाण प्रविष्ट करा',
          'Please select one value': 'कृपया एक मूल्य निवडा',
          'Please fill all the required fields':
              'कृपया सर्व आवश्यक फील्ड्स भरा',
          'Please Enter the valid Mobile Number':
              'कृपया योग्य मोबाईल नंबर प्रविष्ट करा',
          'Choose a preferred language to continue':
              'पुढे जाण्यासाठी पसंतीची भाषा निवडा',
          '*This slot is already booked!': 'ही जागा आधीच बुक झाली आहे',
          '* Choose a preferred timing': 'पसंतीची वेळ निवडा',
          'Kindly select one or more categories':
              'कृपया एक किंवा अधिक श्रेणी निवडा',
          'Error loading questions': 'प्रश्न लोड करताना त्रुटी आली',
          'No questions found': 'कोणतेही प्रश्न आढळले नाहीत',
          "Please enter Boy's name": 'कृपया मुलाचे नाव प्रविष्ट करा.',
          "Please select Boy's Nakshatram": 'कृपया लड़के का नक्षत्र चुनें',
          "Please select Girl's Nakshatram": 'कृपया लड़की का नक्षत्र चुनें',
          "Please enter Girl's name": 'कृपया मुलीचे नाव प्रविष्ट करा',
          "Please select Girl's Rasi": 'कृपया मुलींची राशि निवडा',
          "Please select Boy's Rasi": 'कृपया मुलांची राशि निवडा',
          'Second language must be different from first':
              'दुसरी भाषा पहिल्यापेक्षा वेगळी असली पाहिजे.',
          //Snack bar
          'Permission permanently denied. Please enable it in settings.':
              'परवानगी कायमस्वरूपी नाकारली आहे. कृपया ती सेटिंग्जमध्ये सक्षम करा.',
          'Permission Denied': 'परवानगी नाकारली',
          'Payment verification failed. Please try again.':
              'पेमेंट पडताळणी अयशस्वी झाली. कृपया पुन्हा प्रयत्न करा.',
          'Payment failed. Please try again.':
              'पेमेंट अयशस्वी झाले. कृपया पुन्हा प्रयत्न करा.',
          'Please Contact Support team!': 'कृपया सपोर्ट टीमशी संपर्क साधा!',
          'Payment Error, Contact Support team!.':
              'पेमेंटमध्ये त्रुटी आली आहे, कृपया सपोर्ट टीमशी संपर्क साधा!',
          'Payment successful!': 'पेमेंट यशस्वी झाले!',
          'Please enable location permission to access this feature.':
              'हे वैशिष्ट्य वापरण्यासाठी कृपया लोकेशनची परवानगी द्या.',
          'Select valid country code and number':
              'योग्य देश कोड आणि क्रमांक निवडा.',
          'Please contact Teksage Admin': 'कृपया टेक्ससेज ॲडमिनशी संपर्क साधा.',
          'Error in Fetching Country code': 'देशाचा कोड मिळवण्यात त्रुटी आली.',
          'Please select a country code first': 'कृपया आधी देश कोड निवडा',
          'Failed to fetch country list': 'देशांची यादी मिळवण्यात अयशस्वी.',
          'Please select the first language first':
              'कृपया आधी पहिली भाषा निवडा.',
          'Failed to save Questions': 'प्रश्न जतन करण्यात अयशस्वी.',
          'Error creating slots, Please try again.':
              'स्लॉट तयार करताना त्रुटी आली, कृपया पुन्हा प्रयत्न करा.',
          'Slot Updated Successfully.': 'स्लॉट यशस्वीरित्या अद्यतनित झाला.',
          'At least one category must be selected.':
              'किमान एक श्रेणी निवडणे आवश्यक आहे.',
          'At least one language must be selected.':
              'किमान एक भाषा निवडणे आवश्यक आहे.',
          'We couldn’t fetch your horoscope. Please try again.':
              'आम्ही तुमची जन्मकुंडली मिळवू शकलो नाही. कृपया पुन्हा प्रयत्न करा.',
          'Failed to fetch data. Please try again.':
              'डेटा मिळवण्यात अयशस्वी. कृपया पुन्हा प्रयत्न करा.',
          'Failed to update notification status':
              'सूचना स्थिती अद्यतनित करण्यात अयशस्वी.',
          'Please try again after sometime':
              'कृपया काही वेळाने पुन्हा प्रयत्न करा.',
          'All Notification has been cleared':
              'सर्व सूचना साफ करण्यात आल्या आहेत.',
          'Please enable location access to view relevant subscription plans':
              'कृपया संबंधित सबस्क्रिप्शन प्लॅन्स पाहण्यासाठी लोकेशन ॲक्सेस सुरू करा.',
          'Failed to regenerate prediction. Please try again.':
              'भविष्यावाणी पुन्हा तयार करण्यात अयशस्वी. कृपया पुन्हा प्रयत्न करा.',
          'An error occurred while regenerating. Please try again.':
              'पुन्हा तयार करताना एक त्रुटी आली. कृपया पुन्हा प्रयत्न करा.',
          'Prediction regenerated successfully':
              'भविष्यवाणी यशस्वीरित्या पुन्हा तयार केली गेली',
          'Please enter a valid OTP': 'कृपया अचूक ओटीपी प्रविष्ट करा',
          'Choose your Style, Avatar and Language to begin your cosmic journey.':
              'तुमचा वैश्विक प्रवास सुरू करण्यासाठी तुमची शैली, अवतार आणि भाषा निवडा.',
          'Select a Style and Avatar to begin your cosmic journey.':
              'तुमचा वैश्विक प्रवास सुरू करण्यासाठी एक शैली आणि अवतार निवडा.',
          'Select a Style for your answer’s flow.':
              'तुमच्या उत्तराच्या प्रवाहासाठी एक शैली निवडा.',
          'Select an Avatar that reflects your spirit.':
              'तुमच्या व्यक्तिमत्त्वाला साजेसा एक अवतार निवडा.',
          'Select a Language for your answer’s flow.':
              'तुमच्या उत्तराच्या प्रवाहासाठी एक भाषा निवडा.',
          'Keep it short and cosmic — max 300 characters':
              'ते संक्षिप्त आणि वैश्विक ठेवा — जास्तीत जास्त ३०० वर्ण.',
          'You can answer only after completing the consultation.':
              'सल्लामसलत पूर्ण झाल्यावरच तुम्ही उत्तर देऊ शकता.',
          'Timeout. Please retry.': 'वेळ संपला. कृपया पुन्हा प्रयत्न करा.',
          'Kindly enter your question.': 'कृपया तुमचा प्रश्न प्रविष्ट करा.',
          'Your subscription has expired. Subscribe to continue.':
              'तुमचे सबस्क्रिप्शन संपले आहे. पुढे सुरू ठेवण्यासाठी पुन्हा सबस्क्राईब करा.',
          'You’ve reached your message limit. Subscribe to continue.':
              'तुमच्या मेसेजची मर्यादा संपली आहे. पुढे सुरू ठेवण्यासाठी सबस्क्राईब करा.',
          'Retry response timed out.':
              'पुन्हा प्रयत्न करण्याची वेळ मर्यादा संपली आहे.',
          'Response is taking longer than expected. Please check your network.':
              'प्रतिसाद मिळण्यास अपेक्षेपेक्षा जास्त वेळ लागत आहे. कृपया तुमचे नेटवर्क तपासा.',
          'Thanks for reaching out! Your query has been received — our team will respond shortly.':
              'संपर्क साधल्याबद्दल धन्यवाद! तुमची विचारणा आम्हाला मिळाली आहे — आमची टीम लवकरच प्रतिसाद देईल.',
          'Something went wrong. Please try again.':
              'काहीतरी चूक झाली आहे. कृपया पुन्हा प्रयत्न करा.',
          'Logout failed. Please try again.':
              'लॉगआउट अयशस्वी झाले. कृपया पुन्हा प्रयत्न करा.',
          'Thanks for using Teksage': 'टेक्ससेज वापरल्याबद्दल धन्यवाद.',
          'Your message looks empty after removing hidden characters. Try typing or paste plain text.':
              'लपवलेले वर्ण काढून टाकल्यानंतर तुमचा संदेश रिकामा दिसत आहे. टाइप करण्याचा किंवा साधा मजकूर पेस्ट करण्याचा प्रयत्न करा.',
          'Error in sending OTP': 'ओटीपी पाठवताना एक त्रुटी आली.',
          'Network error. Please check your connection and try again.':'नेटवर्कमध्ये त्रुटी आली आहे. कृपया तुमचे कनेक्शन तपासा आणि पुन्हा प्रयत्न करा.',
          'OTP Verified':'ओटीपी सत्यापित झाला',
          //Astrology consultations
          'What do you\nneed guidance on?':
              'तुम्हाला कोणत्या गोष्टीवर मार्गदर्शनाची गरज आहे?',
          'Select the categories and continue':
              'श्रेणी निवडा आणि पुढे सुरू ठेवा',
          'Marriage & relationships': 'विवाह आणि नातेसंबंध',
          'Marriage & Relationships': 'विवाह आणि नातेसंबंध',
          'All': 'सर्व',
          'Choose your\npreferred language': 'तुमची पसंतीची भाषा निवडा',
          'This will help us to match the best astrologer':
              'यामुळे आम्हाला सर्वोत्तम ज्योतिषी निवडण्यास मदत होईल.',
          'First Preference': 'पहिली पसंती',
          'Second Preference': 'दुसरी पसंती',
          'Select language': 'भाषा निवडा',
          'Top 5 astrologers\nbased on preferences':
              'पसंतीनुसार शीर्ष ५ ज्योतिषी',
          'Expert Profile': 'तज्ञांचे प्रोफाइल',
          'Reviews': 'अभिप्राय',
          'No reviews available': 'अभिप्राय उपलब्ध नाहीत',
          'Book Consultation': 'सल्लामसलत बुक करा',
          'No slots available': 'कोणतीही जागा उपलब्ध नाही',
          'Find & Consult Astrologers': 'ज्योतिषी शोधा आणि त्यांचा सल्ला घ्या',
          '100+ Astrologers': '100+ ज्योतिषी',
          'Explore and find your perfect match':
              'एक्सप्लोर करा आणि तुमचा परिपूर्ण जोडीदार शोधा',
          'Upcoming': 'आगामी',
          'Completed': 'पूर्ण',
          'View Details': 'तपशील पहा',
          'View\nDetails': 'तपशील पहा',
          'Meeting Link': 'meeting लिंक',
          'Choose your avatar': 'तुमचा अवतार निवडा',
          'Choose how AI replies': 'AI कसे उत्तर देते ते निवडा',
          'Concise': 'संक्षिप्त',
          'Booking Details': 'Booking तपशील',
          'Consultation Fee': 'सल्ला शुल्क',
          'Total Fee': 'एकूण शुल्क',
          'Confirm & Proceed to Pay': 'निश्चित करा आणि पेमेंट करा',
          'Consultation Details': 'सल्लामसलत तपशील',
          'Consulting On': 'सल्लामसलत विषय',
          'Give Rating': 'रेटिंग द्या',
          'Ratings': 'रेटिंग्ज',
          'You have no upcoming meetings at the moment.':
              'तुमच्या सध्या कोणतीही आगामी बैठक नाही.',
          'You have no completed meetings at the moment.':
              'तुमच्या सध्या एकही बैठक पूर्ण झालेली नाही.',
          'Book Now': 'आता बुक करा',
          'Yes': 'होय',
          'No': 'नाही',
          'Queries you asked': 'आपके द्वारा पूछे गए प्रश्न',
          'Enter Promo Code': 'प्रोमो कोड टाका',
          'Applied': 'अर्ज केला',
          'Apply': 'लागू करा',
          'I consent to share my personal information & horoscope with the astrologer':
              'माझी वैयक्तिक माहिती आणि कुंडली ज्योतिषासोबत शेअर करण्यासाठी माझी संमती आहे',
          'I consent to share my personal information & star chart with the advisor':
              'मी माझी वैयक्तिक माहिती आणि जन्मकुंडली सल्लागारासोबत शेअर करण्यास संमती देतो',
          'Kindly select your preferred language':
              'कृपया तुमची पसंतीची भाषा निवडा',
          'Write your consultation query here':
              'तुमचा सल्लाविषयक प्रश्न येथे लिहा.',
          'Enter your question here...': 'तुमचा प्रश्न येथे प्रविष्ट करा...',
          'Next': 'पुढील',
          'Previous': 'मागील',
          '* All questions are required to help us serve you better.':
              '* तुम्हाला अधिक चांगल्या प्रकारे सेवा देण्यासाठी सर्व प्रश्नांची उत्तरे देणे आवश्यक आहे.',
          'Slots': 'स्लॉट्स',
          '30 mins each': 'प्रत्येकी ३० मिनिटे',
          'Astrologer submitted answers for your queries':
              'ज्योतिषज्ञांनी तुमच्या प्रश्नांची उत्तरे सादर केली आहेत.',
          'Meet Again': 'पुन्हा भेटू',
          'Rate your experience with this astrologer appointment':
              'या ज्योतिषी भेटीबद्दल तुमचा अनुभव रेट करा',
          'Save & Submit': 'जतन करा आणि सबमिट करा',
          'Type your answer here...': 'तुमचे उत्तर येथे टाइप करा...',
          'Done': 'पूर्ण झाले',
          'booked a slot on': 'वर एक\nस्लॉट बुक केला',
          "meeting_with": "{name} सोबत बैठक",
          //Voice chat
          'Jyotish voice guide for all your needs. Start you conversation today':
              'तुमच्या सर्व गरजांसाठी ज्योतिषी व्हॉइस गाइड. आजच तुमचे संभाषण सुरू करा.',
          'Jyotish voice guide for all your needs':
              'तुमच्या सर्व गरजांसाठी ज्योतिषी व्हॉइस मार्गदर्शक',
          'The Seeker': 'साधक',
          'The Luminary': 'प्रकाशक',
          'The Guardian': 'पालक',
          'The Pathfinder': 'पाथफाइंडर',
          'Ideal for those who want in-depth astrological analysis and clear reasoning':
              'ज्यांना सखोल ज्योतिषीय विश्लेषण आणि स्पष्ट तर्क हवे आहेत त्यांच्यासाठी आदर्श',
          'Ideal for those who seek joyful and engaging astrology guidance':
              'आनंदी आणि आकर्षक ज्योतिष मार्गदर्शन शोधणाऱ्यांसाठी आदर्श',
          'Ideal for those looking for reassurance and personal connection in predictions':
              'भाकितांमध्ये आश्वासन आणि वैयक्तिक संबंध शोधणाऱ्यांसाठी आदर्श',
          'Ideal for those seeking career growth, success strategies, or clear-cut solutions':
              'करिअर वाढ, यशाची रणनीती किंवा स्पष्ट उपाय शोधणाऱ्यांसाठी आदर्श',
          'Tap the mic': 'माइकवर टॅप करा',
          'Start speaking in your own language':
              'तुमच्या मातृभाषेत बोलायला सुरुवात करा.',
          'Chat or record your thoughts...': 'Chat or record your thoughts...',
          'AI can understand all languages': 'एआय सर्व भाषा समजू शकते.',
          'Got it, typing that up for you…':
              'ठीक आहे, मी ते तुमच्यासाठी टाईप करत आहे...',
          'Description - Unlock personalized insights into your future, career, relationships, and more with AI-powered astrology.':
              'वर्णन - अल-पॉवर्ड ज्योतिषशास्त्राच्या मदतीने तुमचे भविष्य, करिअर, नातेसंबंध आणि बरेच काही याबद्दल वैयक्तिकृत अंतर्दृष्टी अनलॉक करा',
          'Generate Yearly Prediction': 'वार्षिक भाकिते तयार करा',
          'Generate Life Prediction': 'जीवन भाकिते तयार करा',
          'Quick, direct replies without extra details — ideal for instant answers.':
              'अतिरिक्त तपशीलांशिवाय जलद, थेट उत्तरे - त्वरित उत्तरांसाठी आदर्श.',
          'Explanatory': 'स्पष्टीकरणात्मक',
          'In-depth, structured replies with step-by-step clarity — perfect for learning or detailed insights.':
              'चरण-दर-चरण स्पष्टतेसह सखोल, संरचित उत्तरे — शिकण्यासाठी किंवा तपशीलवार अंतर्दृष्टीसाठी परिपूर्ण.',
          'Choose an avatar for AI': 'एआय साठी अवतार निवडा',
          'Related questions': 'संबंधित प्रश्न',
          'No response.': 'कोणताही प्रतिसाद नाही.',
          'Retry': 'पुन्हा प्रयत्न करा',
          'Subscribe Now': 'आता सदस्यता घ्या',
          //Delete Account
          'We value your experience.\nWhat made you decide to leave?':
              'आम्ही तुमच्या अनुभवाची कदर करतो.\nतुम्ही निघण्याचा निर्णय कशामुळे घेतला?',
          "I am having another account": 'माझे दुसरे खाते आहे',
          'App not working properly': 'ॲप नीट काम करत नाही',
          'I don’t like the app': 'मला अ‍ॅप आवडत नाही',
          'I am worried about my privacy': 'मला माझ्या गोपनीयतेची काळजी वाटते',
          'You are about to delete\nyour account':
              'तुम्ही तुमचे खाते हटवणार आहात',
          'All data associated with this account (including your profile, service, bookings, horoscopes, predictions) will be permanently deleted in 45 days':
              'या खात्याशी संबंधित सर्व डेटा (तुमचा प्रोफाइल, सेवा, बुकिंग, कुंडली, भाकिते यासह) ४५ दिवसांत कायमचा हटवला जाईल',
          'Delete Account Now': 'आता खाते हटवा',
          'No, I have changed my mind': 'नाही, मी माझा विचार बदलत आहे',
          //Astrologer
          'You logged in as Astrologer':
              'तुम्ही ज्योतिषी म्हणून लॉग\nइन केले आहे.',
          'Meetings': 'बुकिंग',
          'View your scheduled appointments & completed ones':
              'तुमच्या नियोजित भेटी आणि पूर्ण झालेल्या भेटी पहा.',
          'My Availability': 'माझे वेळापत्रक',
          'Set your available time slots.': 'तुमच्या वेळेचे स्लॉट निश्चित करा.',
          'Select the slots that you are available':
              'तुमच्या उपलब्ध स्लॉटची निवड करा',
          'Showing the available time that you picked':
              'तुमच्या निवडलेल्या वेळेच्या स्लॉट',
          'Morning': 'सकाळ',
          'Afternoon': 'दुपार',
          'Horoscope Details': 'कुंडली तपशील',
          'Horoscope details are not available':
              'राशीभविष्याची माहिती उपलब्ध नाही.',
          'Answer': 'उत्तर',
          'View': 'पहा',
          "Queries asked - Time to share your thoughts!":
              "विचारलेले प्रश्न - तुमच्या प्रतिक्रिया व्यक्त करण्याची वेळ आली आहे!",
          "Queries asked - You've already shared your thoughts!":
              "विचारलेले प्रश्न - तुम्ही तुमचे विचार आधीच मांडले आहेत!",
          'Date': 'तारीख',
          'Time': 'वेळ',
          'Fees Paid': 'फीस का भुगतान',
          'It’s a privilege to guide you through the insights that your chart offers, especially at this meaningful stage of your life.':
              'तुमच्या आयुष्याच्या या अर्थपूर्ण टप्प्यावर, तुमच्या चार्टमधून तुम्हाला मिळणाऱ्या अंतर्दृष्टींबद्दल मार्गदर्शन करणे हा एक भाग्य आहे',
          'Tamil': 'தமிழ்',
          'English': 'English',
          'Telugu': 'తెలుగు',
          'Malayalam': 'മലയാളം',
          'Kannada': 'ಕನ್ನಡ',
          'Hindi': 'हिन्दी',
          'Bengali': 'বাংলা',
          'Marathi': 'मराठी',
          'Urdu': 'اردو',
          'Gujarati': 'ગુજરાતી',
          'Odia': 'ଓଡ଼ିଆ',
          'Punjabi': 'ਪੰਜਾਬੀ',
          'Assamese': 'অসমীয়া',
          'Bhojpuri': 'भोजपुरी',
          'Kashmiri': 'کٲشُر',
          'Nepali': 'नेपाली',
          'Sindhi': 'سنڌي',
          'Sinhala': 'සිංහල',
          'Maithili': 'मैथिली',
          'Manipuri': 'মৈতৈলোন্',
          'Santali': 'ᱥᱟᱱᱛᱟᱲᱤ',
          'Years of Experience': 'अनुभवाची वर्षे',
          'years': 'वर्ष',
          'Showing Availability': 'उपलब्धता दर्शवित आहे',
          //OTP Screen
          "resend_otp_in_seconds": "OTP पुन्हा पाठवण्यासाठी {seconds} सेकंद",
          'Enter Mobile Number': 'मोबाइल नंबर टाका',
          'Enter Email': 'ईमेल प्रविष्ट करा',
          'Enter your new email and verify it using OTP':
              'तुमचा नवीन ईमेल प्रविष्ट करा आणि ओटीपी वापरून तो सत्यापित करा.',
          'Enter your new phone number and verify it using OTP':
              'तुमचा नवीन फोन नंबर टाका आणि ओटीपी वापरून तो सत्यापित करा.',
          'Verify Phone Number': 'फोन नंबर सत्यापित करा',
          'Verify Email': 'ईमेल सत्यापित करा',
          'Verify Existing Phone Number': 'विद्यमान फोन नंबर सत्यापित करा',
          'Verify Existing Email': 'विद्यमान ईमेलची पडताळणी करा',
          'For security reasons, kindly verify your existing phone number':
              'सुरक्षिततेच्या कारणास्तव, कृपया तुमचा फोन नंबर सत्यापित करा.',
          'For security reasons, kindly verify your existing email':
              'सुरक्षिततेच्या कारणास्तव, कृपया तुमचा ईमेल सत्यापित करा.',
          'We have sent OTP to': 'आम्ही ओटीपी पाठवला आहे',
          'OTP is valid for 5 Minutes.': 'ओटीपी ५ मिनिटांसाठी वैध आहे.',
          'Resend OTP': 'ओटीपी पुन्हा पाठवा',
          //Internet
          'No Internet Connection': 'इंटरनेट कनेक्शन नाही',
          'Please check your\nnetwork settings':
              'कृपया तुमच्या नेटवर्क सेटिंग्ज तपासा.',
        },
      };
}
