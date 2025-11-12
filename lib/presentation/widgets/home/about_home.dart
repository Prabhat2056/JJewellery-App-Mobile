// import 'package:flutter/material.dart';
// import 'package:jjewellery/utils/color_constant.dart';

// class AboutSection extends StatelessWidget {
//   AboutSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _buildLogoSection(),
//           const SizedBox(height: 12),
//           _buildFeatureGrid(),
//           const SizedBox(height: 20),
//           _buildContactSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildLogoSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset(
//           "assets/images/playstore.png",
//           height: 100,
//           width: 100,
//           fit: BoxFit.contain,
//         ),
//         const SizedBox(height: 8),
//         _buildText(
//           title: "J-Jewellery Software",
//           textSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ],
//     );
//   }

//   Widget _buildFeatureGrid() {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//       ),
//       itemCount: _features.length,
//       itemBuilder: (context, index) {
//         final feature = _features[index];
//         return _buildFeatureItem(
//             title: feature['title']!, icon: feature['icon']!);
//       },
//     );
//   }

//   Widget _buildFeatureItem({required String title, required IconData icon}) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white30,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: ColorConstant.primaryColor,
//             size: 22,
//           ),
//           const SizedBox(height: 8),
//           _buildText(
//             title: title,
//             textSize: 11,
//             fontWeight: FontWeight.w600,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContactSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         _buildText(
//           title: "Simplify Your Jewellery Business With Us:",
//           textSize: 14,
//           fontWeight: FontWeight.w600,
//         ),
//         const SizedBox(height: 8),
//         Container(
//           height: 2,
//           width: 100,
//           color: ColorConstant.primaryColor,
//         ),
//         const SizedBox(height: 8),
//         _buildText(title: "info@matrikatec.com.np", textSize: 13),
//         const SizedBox(height: 8),
//         _buildText(
//           title: "9852044102 | 9811346311 | 01-5925122",
//           textSize: 13,
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildText(title: "Copyright © 2025", textSize: 12),
//             const SizedBox(width: 4),
//             const CircleAvatar(
//               radius: 10,
//               backgroundImage: AssetImage("assets/images/mtech_logo.jpg"),
//             ),
//             const SizedBox(width: 4),
//             _buildText(
//               title: "Matrika Technology Pvt. Ltd.",
//               textSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildText({
//     required String title,
//     double textSize = 14,
//     FontWeight fontWeight = FontWeight.normal,
//     TextAlign textAlign = TextAlign.center,
//   }) {
//     return Text(
//       title,
//       style: TextStyle(
//         color: ColorConstant.primaryColor,
//         fontWeight: fontWeight,
//         fontSize: textSize,
//       ),
//       textAlign: textAlign,
//     );
//   }

//   final List<Map<String, dynamic>> _features = [
//     {'title': "Online Billing", 'icon': Icons.receipt_long},
//     {'title': "Jewellery Tag", 'icon': Icons.local_offer},
//     {'title': "Stock & Kaligad Management", 'icon': Icons.inventory},
//   ];
// }
