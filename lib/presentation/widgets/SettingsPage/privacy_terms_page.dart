import 'package:flutter/material.dart';
import 'package:jjewellery/presentation/widgets/Global/about_company.dart';
import 'package:jjewellery/utils/color_constant.dart';

class PrivacyTermsPage extends StatelessWidget {
  PrivacyTermsPage({
    super.key,
    required this.isTermsCondition,
  });
  final bool isTermsCondition;
  final privacyPolicyList = [
    {
      "title": "1. Information Collection and Use",
      "desc":
          '''The Application collects certain information to provide and improve its services. This information may include, but is not limited to:

- Device Information: Your device’s operating system and browser type.
- Usage Data: The pages of the Application you visit, the time and date of your visit, the time spent on those pages, and other usage statistics.
- Permissions: To enable specific functionalities, the Application may request access to the following:

* Camera: To capture images or videos for app features.
* Photos/Gallery: To access and upload images stored on your device.
* Wi-Fi and Data Network Access: To connect to the internet for app functionality.
* Notifications: To send you alerts and updates.
  
The Service Provider may use this information to:

- Provide, maintain, and improve the Application.
- Communicate with you, including sending important notices, updates, and promotional materials.
- Monitor and analyze usage trends to enhance user experience.'''
    },
    {
      "title": "2. Third-Party Services",
      "desc":
          '''The Application uses Firebase, a third-party service provided by Google, to collect and analyze usage data, monitor app performance, and improve functionality. Firebase may collect information such as device identifiers, usage patterns, and crash reports. This data is used to enhance the user experience and troubleshoot issues.

Below are links to the privacy policies of the third-party service providers used by the Application:

- Google Play Services
(https://www.google.com/policies/privacy/)
- Firebase (Google)
(https://firebase.google.com/support/privacy)

The Service Provider may share your information with third parties in the following circumstances:

- As required by law, such as to comply with a subpoena or similar legal process.
- When the Service Provider believes in good faith that disclosure is necessary to protect its rights, your safety, or the safety of others, investigate fraud, or respond to a government request.
- With trusted service providers who work on behalf of the Service Provider, provided they adhere to the terms of this Privacy Policy.'''
    },
    {
      "title": "3. Data Retention Policy",
      "desc":
          '''The Service Provider will retain your information for as long as necessary to provide the Application’s services and for a reasonable period thereafter. If you wish to delete your data, please contact the Service Provider at matrikatechnology@gmail.com, and they will respond within a reasonable timeframe.'''
    },
    {
      "title": "4. Opt-Out Rights",
      "desc":
          '''You can stop the collection of information by the Application by uninstalling it. You may use the standard uninstall processes available on your mobile device or through the app marketplace.'''
    },
    {
      "title": "5. Children’s Privacy",
      "desc":
          '''The Application is not intended for use by children under the age of 13. The Service Provider does not knowingly collect personally identifiable information from children under 13. If the Service Provider becomes aware that a child under 13 has provided personal information, they will promptly delete it from their servers. If you are a parent or guardian and believe your child has provided personal information, please contact the Service Provider at matrikatechnology@gmail.com for assistance.'''
    },
    {
      "title": "6. Security",
      "desc":
          '''The Service Provider is committed to protecting the confidentiality of your information. They implement physical, electronic, and procedural safeguards to secure the information they process and maintain. However, no method of transmission over the internet or electronic storage is 100% secure, and the Service Provider cannot guarantee absolute security.'''
    },
    {
      "title": "7. Changes to This Privacy Policy",
      "desc":
          '''The Service Provider may update this Privacy Policy from time to time. You will be notified of any changes by updating the "Effective Date" at the top of this policy. You are advised to review this Privacy Policy periodically for any changes. Your continued use of the Application after any modifications constitutes your acceptance of the updated policy.'''
    },
    {
      "title": "8. Your Consent",
      "desc":
          '''By using the Application, you consent to the collection and use of your information as outlined in this Privacy Policy.'''
    },
    {
      "title": "9. Contact Us",
      "desc":
          '''If you have any questions or concerns about this Privacy Policy or the Application’s practices, please contact the Service Provider at:

Email: matrikatechnology@gmail.com'''
    }
  ];

  final privacyPolicydesc = '''

This Privacy Policy applies to the JJewelery mobile application (hereinafter referred to as the "Application"), developed and provided by Matrika Technology Pvt. Ltd.(hereinafter referred to as the "Service Provider"). The Application is offered as a free service and is intended for use "AS IS."

By using the Application, you agree to the collection and use of your information in accordance with this Privacy Policy. If you do not agree with the terms of this policy, please do not use the Application.''';

  final termsAndConditionsList = [
    {
      "title": "1. Acceptance of Terms",
      "desc":
          '''By using the Application, you confirm that you have read, understood, and agree to these Terms. If you are using the Application on behalf of an organization, you represent that you have the authority to bind that organization to these Terms.'''
    },
    {
      "title": "2. Intellectual Property Rights",
      "desc":
          '''All intellectual property rights in the Application, including but not limited to copyrights, trademarks, and database rights, are owned by the Service Provider. You are granted a limited, non-exclusive, non-transferable license to use the Application for personal, non-commercial purposes only.

You agree not to:
- Copy, modify, or create derivative works of the Application.
- Reverse engineer, decompile, or attempt to extract the source code of the Application.
- Remove, alter, or obscure any copyright, trademark, or other proprietary notices in the Application.'''
    },
    {
      "title": "3. Permissions and Responsibilities",
      "desc":
          '''The Application may require certain permissions to function properly, including access to:
        - Camera: To capture images or videos.
        - Photos/Gallery: To access and upload images stored on your device.
        - Wi-Fi and Data Network Access: To connect to the internet.
        - Notifications: To send you alerts and updates.

You are responsible for:
- Maintaining the security of your device and access to the Application.
- Ensuring that your device is charged and has an active internet connection (Wi-Fi or mobile data).
- Any charges incurred from your mobile network provider for data usage while using the Application.'''
    },
    {
      "title": "4. Third-Party Services",
      "desc":
          '''The Application uses third-party services, including Firebase and Google Play Services, to provide functionality and improve user experience. These services have their own terms and conditions, which you can review at the following links:
- Google Play Services Terms
(https://policies.google.com/terms)
- Firebase Terms
(https://firebase.google.com/terms)

The Service Provider is not responsible for the content, policies, or practices of these third-party services.'''
    },
    {
      "title": "5. Disclaimer of Warranties",
      "desc":
          '''The Application is provided "AS IS" and "AS AVAILABLE" without any warranties of any kind, either express or implied. The Service Provider does not guarantee that:
- The Application will be error-free or uninterrupted.
- The Application will meet your specific requirements.
- The Application will be compatible with your device or operating system.'''
    },
    {
      "title": "6. Limitation of Liability",
      "desc":
          '''To the fullest extent permitted by law, the Service Provider shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to:
- Loss of data or profits.
- Damages arising from your use or inability to use the Application.
- Any unauthorized access to or use of the Application.'''
    },
    {
      "title": "7. Updates and Termination",
      "desc": '''The Service Provider may:
- Update the Application to improve functionality or address issues. You agree to install updates when prompted.
- Discontinue the Application or terminate your access to it at any time, without prior notice.

Upon termination:
- Your license to use the Application will end.
- You must stop using the Application and delete it from your device.'''
    },
    {
      "title": "8. Changes to These Terms",
      "desc":
          '''The Service Provider reserves the right to modify these Terms at any time. You will be notified of any changes by updating the "Effective Date" at the top of this document. Your continued use of the Application after any changes constitutes your acceptance of the updated Terms.'''
    },
    {
      "title": "9. Governing Law",
      "desc":
          '''These Terms shall be governed by and construed in accordance with the laws of Nepal. Any disputes arising from these Terms or your use of the Application shall be subject to the exclusive jurisdiction of the courts in Nepal.'''
    },
    {
      "title": "10. Contact Us",
      "desc":
          '''If you have any questions or concerns about these Terms, please contact the Service Provider at:

Email: matrikatechnology@gmail.com'''
    }
  ];

  final termsAndConditionsDesc = '''

These Terms and Conditions ("Terms") govern your use of the JJewelery mobile application (hereinafter referred to as the "Application"), developed and provided by Matrika Technology Pvt. Ltd. (hereinafter referred to as the "Service Provider"). The Application is offered as a free service. By downloading, accessing, or using the Application, you agree to be bound by these Terms. If you do not agree to these Terms, you must not use the Application.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(
              isTermsCondition ? "Terms & Conditions" : "Privacy Policy",
              textSize: 12,
              color: ColorConstant.primaryColor,
            ),
            buildText(
              "Effective Date: 2025-03-05",
              textSize: 12,
              color: ColorConstant.primaryColor,
            ),
            Text(
              isTermsCondition ? termsAndConditionsDesc : privacyPolicydesc,
              style: TextStyle(fontSize: 10),
            ),
            const SizedBox(height: 12),
            if (!isTermsCondition)
              ...privacyPolicyList.map((p) =>
                  buildPolicyAndTerms(title: p["title"]!, desc: p["desc"]!)),
            if (isTermsCondition)
              ...termsAndConditionsList.map((p) =>
                  buildPolicyAndTerms(title: p["title"]!, desc: p["desc"]!)),
          ],
        ),
      ),
    );
  }
}

Widget buildPolicyAndTerms({required String title, required String desc}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      buildText(
        title,
        color: ColorConstant.primaryColor,
        textSize: 12,
      ),
      Text(
        desc,
        style: TextStyle(
          fontSize: 10,
        ),
      ),
      const SizedBox(height: 12),
    ],
  );
}
