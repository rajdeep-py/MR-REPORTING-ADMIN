import 'package:flutter_riverpod/legacy.dart';
import '../models/about_us.dart';

class AboutUsNotifier extends StateNotifier<AboutUs> {
  AboutUsNotifier()
    : super(
        const AboutUs(
          companyName: 'MR Corporation',
          tagline: 'Innovating Healthcare, Enhancing Lives.',
          description:
              'We are a leading medical representative organization dedicated to bridging the gap between pharmaceutical innovations and healthcare professionals. Our extensive network ensures the timely delivery of vital medical supplies and accurate product information.',
          mission:
              'To empower healthcare providers with the best medical products and information, enabling them to offer superior care to patients.',
          vision:
              'To be the most trusted and efficient medical representative network globally, setting the standard for quality and reliability in the healthcare supply chain.',
          directorMessage:
              'Our commitment to excellence drives us every day. We believe that by supporting healthcare professionals, we are making a direct impact on patient well-being. Thank you for being a part of our journey towards a healthier future.',
          directorName: 'Dr. Robert Williams',
          directorPhotoPath:
              'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&q=80',
          email: 'contact@mrcorp.com',
          address: '123 Health Avenue, Medical District, NY 10001',
          website: 'www.mrcorp.com',
          phoneNo: '+1 (555) 123-4567',
        ),
      );

  void updateAboutUs(AboutUs updated) {
    state = updated;
  }
}
