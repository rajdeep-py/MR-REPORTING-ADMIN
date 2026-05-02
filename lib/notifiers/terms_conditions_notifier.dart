import 'package:flutter_riverpod/legacy.dart';
import '../models/terms_conditions.dart';

class TermsConditionsNotifier extends StateNotifier<List<TermsCondition>> {
  TermsConditionsNotifier() : super([]) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = const [
      TermsCondition(
        id: '1',
        header: 'Acceptance of Terms',
        description: 'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. In addition, when using these particular services, you shall be subject to any posted guidelines or rules applicable to such services.',
      ),
      TermsCondition(
        id: '2',
        header: 'User Conduct',
        description: 'You agree to use our services only for lawful purposes. You must not use the platform to transmit any material that is offensive, defamatory, or infringes on any intellectual property rights.',
      ),
      TermsCondition(
        id: '3',
        header: 'Intellectual Property',
        description: 'All content included on this application, such as text, graphics, logos, and software, is the property of MR Corporation or its content suppliers and protected by international copyright laws.',
      ),
      TermsCondition(
        id: '4',
        header: 'Termination',
        description: 'We may terminate or suspend access to our service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
      ),
    ];
  }
}
