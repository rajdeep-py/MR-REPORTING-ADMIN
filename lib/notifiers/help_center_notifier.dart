import 'package:flutter_riverpod/legacy.dart';
import '../models/help_center.dart';

class HelpCenterNotifier extends StateNotifier<HelpCenter> {
  HelpCenterNotifier()
    : super(
        const HelpCenter(
          phoneNo: '+1234567890',
          email: 'support@mrcorp.com',
          address: '123 Health Avenue, Medical District, NY 10001',
          mapUrl: 'https://maps.google.com/?q=New+York',
          officeHours: '10 AM to 7 PM (Mon to Sat)',
        ),
      );

  void updateHelpCenter(HelpCenter updated) {
    state = updated;
  }
}
