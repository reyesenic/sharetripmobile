const legalDocuments = {
  terms: {
    title: 'Terms & Conditions',
    lastUpdated: 'September 2026',
    intro:
      'Please read these terms carefully. They explain account eligibility, ride responsibilities, acceptable conduct, safety expectations, and how account concerns may be handled.',
    notice:
      'Prototype notice: This is detailed sample policy content for product design and is not legal advice or a final legal agreement.',
    sections: [
      {
        title: '1. Acceptance of These Terms',
        body:
          'By creating an account, requesting a ride, offering a ride, or otherwise using ShareTrip, you agree to these Terms and the Privacy Policy. If you do not agree, do not use the service. These terms describe the intended rules for this student prototype and should be reviewed by qualified legal counsel before any production launch.',
      },
      {
        title: '2. Student Eligibility and Accounts',
        body:
          'ShareTrip is intended for currently enrolled students with access to a supported school email address. You must provide accurate registration information, keep your password confidential, and use only your own account. Verification indicates that required account checks were completed; it is not a guarantee of a person’s conduct, driving ability, or future behavior.',
      },
      {
        title: '3. Role of ShareTrip',
        body:
          'ShareTrip helps students discover and coordinate rides. Unless explicitly stated otherwise, ShareTrip is not the transportation provider, vehicle owner, employer, insurer, or agent of a student driver. Drivers and passengers are responsible for deciding whether a ride is appropriate and for following applicable laws, school policies, and local transportation rules.',
      },
      {
        title: '4. Ride Listings and Requests',
        body:
          'Drivers must provide truthful route, schedule, vehicle, seat, plate, and fare information. Passengers should review all ride details before sending a request. A ride is not confirmed until the app displays a confirmed status. Users should communicate only through approved in-app tools and must not misuse ride requests for solicitation or unrelated contact.',
      },
      {
        title: '5. Fares and Payments',
        body:
          'The fare shown before booking is the expected amount per passenger unless the ride clearly states otherwise. Any permitted payment method, collection process, refund rule, or service fee must be shown before confirmation. Users should not be pressured to pay an amount that was not disclosed in the ride details.',
      },
      {
        title: '6. Cancellations, Delays, and No-Shows',
        body:
          'Cancel as early as possible when plans change. Drivers should update passengers about delays or route changes, and passengers should be ready at the agreed pickup point. Repeated no-shows, avoidable late cancellations, or misuse of the booking system may lead to warnings, temporary limits, or account review.',
      },
      {
        title: '7. Safety Responsibilities',
        body:
          'Before boarding, confirm the driver name, vehicle model, color, and plate number shown in the app. Use trip sharing and ride tracking when available, remain aware of your surroundings, and do not board if details do not match. In an immediate emergency, contact local emergency services first; ShareTrip safety tools are not a replacement for emergency responders.',
      },
      {
        title: '8. Respectful Conduct',
        body:
          'Users must treat one another respectfully and must not engage in harassment, discrimination, threats, violence, sexual misconduct, stalking, intimidation, or unwanted contact. Drivers must operate vehicles responsibly, and all users must follow reasonable safety instructions. Report serious concerns through the Safety Center or support channel.',
      },
      {
        title: '9. Prohibited Uses',
        body:
          'You may not create false accounts, impersonate another person, falsify verification or vehicle information, scrape user data, interfere with the service, distribute malware, arrange illegal activity, transport prohibited items, or use ShareTrip for commercial solicitation without permission. You may not expose another user’s private information or share trip details without a legitimate reason.',
      },
      {
        title: '10. Reports, Blocking, and Account Action',
        body:
          'Students may report or block another user through available safety controls. ShareTrip may review relevant account, ride, and message information when investigating a report. Depending on severity and available evidence, action may include a warning, feature restriction, temporary suspension, permanent removal, or referral to the appropriate school or public authority where legally permitted.',
      },
      {
        title: '11. Availability and Disclaimers',
        body:
          'Ride availability, arrival estimates, routes, and location information may be delayed, incomplete, or inaccurate. The service may be interrupted for maintenance or technical issues. To the extent permitted by law, ShareTrip is provided on an “as available” basis without a guarantee that every ride, user, vehicle, or feature will meet your expectations.',
      },
      {
        title: '12. Changes and Contact',
        body:
          'These terms may be updated when features, policies, or legal requirements change. Material updates should be communicated through the app or registered email before they take effect. Questions may be sent to support@sharetrip.edu.ph. Continued use after an effective update means you accept the revised terms.',
      },
    ],
  },
  privacy: {
    title: 'Privacy Policy',
    lastUpdated: 'September 2026',
    intro:
      'This policy describes the categories of student and ride information used by ShareTrip, why the information is needed, when it may be shared, and the choices available to users.',
    notice:
      'Prototype notice: This is detailed sample policy content for product design and is not legal advice or a final legal agreement.',
    sections: [
      {
        title: '1. Scope of This Policy',
        body:
          'This policy explains how ShareTrip would collect, use, store, and disclose information when students use the mobile service. It covers account registration, ride discovery, bookings, in-app messages, saved places, safety tools, and support requests. This prototype policy is sample product content and requires legal and institutional review before production use.',
      },
      {
        title: '2. Account and Verification Information',
        body:
          'We may collect your name, school email, contact number, course or year information when required for student eligibility, profile preferences, and account credentials. Verification information is used to confirm access eligibility. Sensitive identity documents should not be displayed to other students and should be collected only when necessary, with clear retention and access controls.',
      },
      {
        title: '3. Ride and Transaction Information',
        body:
          'We may store ride searches, pickup and destination selections, booking requests, confirmations, cancellations, fares, schedules, driver and passenger associations, ratings, reports, and trip status events. This information supports ride coordination, ride history, support requests, safety review, and fraud prevention.',
      },
      {
        title: '4. Location Information',
        body:
          'With device permission, ShareTrip may use precise or approximate location to suggest pickup points, show nearby rides, center maps, provide navigation, and support active trip tracking. You can deny or revoke device location permission, but some map and tracking features may become unavailable. Location should not be collected continuously when it is not needed for a feature you are using.',
      },
      {
        title: '5. Messages, Reviews, and Support Content',
        body:
          'We may process in-app messages, ratings, written reviews, support requests, uploaded evidence, and safety report descriptions. Do not include unnecessary private information in these fields. Content may be reviewed when needed to provide support, investigate abuse, enforce rules, or protect users.',
      },
      {
        title: '6. How We Use Information',
        body:
          'Information may be used to create and secure accounts, verify student eligibility, display relevant rides, process ride requests, enable communication, provide safety tools, send notifications, prevent fraud, investigate reports, troubleshoot errors, analyze feature performance, and comply with legal obligations. We should not use student information for unrelated advertising without a clear lawful basis and appropriate choice.',
      },
      {
        title: '7. When Information May Be Shared',
        body:
          'Information may be shared with another user only when needed for a ride, such as a display name, rating, pickup point, vehicle details, and trip status. It may also be shared with contracted service providers that support hosting, messaging, maps, analytics, or security under confidentiality and data-protection requirements. Information may be disclosed to a school or public authority when required by law or necessary to address a serious safety concern.',
      },
      {
        title: '8. Data Retention',
        body:
          'Account and ride information should be retained only as long as needed for service operation, safety, dispute handling, legal compliance, and fraud prevention. Different data categories may have different retention periods. When information is no longer needed, it should be deleted, anonymized, or securely archived where the law requires continued retention.',
      },
      {
        title: '9. Security',
        body:
          'ShareTrip should use reasonable administrative, technical, and organizational safeguards, such as access controls, secure transmission, limited staff access, monitoring, and protected backups. No digital service can guarantee complete security. Students should use a strong password, protect their device, and report suspected unauthorized access promptly.',
      },
      {
        title: '10. Your Choices and Rights',
        body:
          'You can update profile details, manage saved places and ride preferences, control notification and location permissions, block users, and request access to or correction of your data. Depending on applicable law and school policy, you may also request deletion, restriction, portability, or withdrawal of consent. Some information may be retained when required for safety, fraud prevention, disputes, or legal compliance.',
      },
      {
        title: '11. Children and Student Users',
        body:
          'ShareTrip is designed for eligible students and is not intended for children who cannot legally consent to account creation under applicable rules. If younger students may use the service, the operator must establish appropriate school authorization, guardian consent, age-appropriate notices, and additional safeguards before enabling access.',
      },
      {
        title: '12. Updates and Contact',
        body:
          'We may revise this policy to reflect product, legal, or security changes. Material changes should be communicated through the app or registered email and should identify the effective date. Privacy questions or requests may be sent to privacy@sharetrip.edu.ph or through Help & Support.',
      },
    ],
  },
};

const supportFaqs = [
  {
    question: 'Who can create a ShareTrip account?',
    answer:
      'ShareTrip is intended for currently enrolled students with a supported school email address. Sign up with your school email and verify it to get access.',
  },
  {
    question: 'How do I find a ride?',
    answer:
      'Open Find Ride, enter your pickup and destination, and choose a time. Browse the matching rides and review the driver, vehicle, fare, and departure time before sending a request.',
  },
  {
    question: 'How do I request and confirm a ride?',
    answer:
      'Open a ride, check all the details, and tap Request Ride. The ride is confirmed only when the app shows a Confirmed status. You will get a notification when the driver responds.',
  },
  {
    question: 'How do I know that I found the correct driver and vehicle?',
    answer:
      'Before boarding, compare the driver name, vehicle model, color, and plate number in the app with the actual vehicle. Do not board if any of these details do not match.',
  },
  {
    question: 'How do I track or share an active ride?',
    answer:
      'Open My Rides, go to the Active tab, and tap Track Ride to follow your driver on the map. Share your trip with a trusted contact when trip sharing is available.',
  },
  {
    question: 'How do fares and payments work?',
    answer:
      'The fare is shown on every ride before you request it and is the expected amount per passenger. Any payment method, refund rule, or service fee must be displayed before confirmation.',
  },
  {
    question: 'How do I cancel an upcoming ride?',
    answer:
      'Go to My Rides, select the Upcoming tab, locate the booking, and tap Cancel Ride. Review the confirmation message before completing the cancellation. Cancel as early as possible so the driver can offer the seat to another student. Repeated no-shows or very late cancellations may result in warnings or account limits under the service rules.',
  },
  {
    question: 'What should I do if the driver is late or the pickup point changes?',
    answer:
      'Check Notifications and use Contact Driver in My Rides for updates. If the pickup point changes, confirm the new location with your driver in the app. If the driver cannot be reached, cancel early or contact support.',
  },
  {
    question: 'What safety steps should I follow?',
    answer:
      'Verify the driver and vehicle, use ride tracking, stay aware of your surroundings, and avoid sharing private information. In an emergency, contact local emergency services first, then report the issue in the app.',
  },
  {
    question: 'How do I message, report, or block a driver?',
    answer:
      'Use Contact Driver in My Rides to send a message. To report or block a user, go to Profile > Settings > Privacy Settings and open Report a User or Blocked Users.',
  },
  {
    question: 'How do ratings and reviews work?',
    answer:
      'After a completed ride, open it in My Rides > Completed and tap the stars to leave a rating. Ratings help other students choose rides and help us spot safety concerns.',
  },
  {
    question: 'How do I add or edit Saved Places?',
    answer:
      'Open Saved Places from your profile to add a new place, or select an existing place to edit or remove it.',
  },
  {
    question: 'How can I manage my location and privacy?',
    answer:
      'Go to Profile > Settings > Privacy Settings to control location sharing and profile visibility. You can also change location permission in your device settings, although some map features may stop working.',
  },
  {
    question: 'How do I contact support or report an account problem?',
    answer:
      'Tap Contact Support below or email support@sharetrip.edu.ph. Include your school email and a short description of the problem so we can help faster.',
  },
];

module.exports = { legalDocuments, supportFaqs };
