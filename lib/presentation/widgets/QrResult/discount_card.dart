// import 'package:flutter/material.dart';
// import 'package:jjewellery/models/qr_data_model.dart';

// class DiscountCard extends StatefulWidget {
//   const DiscountCard({
//     super.key,
//     required this.qrData,
//     required this.originalQrData,


//   });
//   final QrDataModel qrData;
//   final QrDataModel originalQrData;

//   @override
//   State<DiscountCard> createState() => _DiscountCardState();
// }
// class _DiscountCardState extends State<DiscountCard> {
//   bool isExpanded = false;
 
//   double stringToDouble(String value) {
//     String sanitizedValue = value.replaceAll(',', '').trim();
//     return double.tryParse(sanitizedValue) ?? 0.0;
//   }



//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width * 0.3;
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               isExpanded = !isExpanded;
//             });
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Rs. ${(stringToDouble(widget.originalQrData.price) - stringToDouble(widget.qrData.price)).toStringAsFixed(2)}",
                

//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//               Icon(
//                 isExpanded
//                     ? Icons.arrow_circle_up_rounded
//                     : Icons.arrow_circle_down_rounded,
//                 color: Colors.grey,
//               )
//             ],
//           ),
//         ),
//         !isExpanded
//             ? const SizedBox()
//             : Column(
//                 children: [
//                   const Divider(),
//                   const SizedBox(height: 2),
//                   _buildDiscountRow(
//                     t1: "Title",
//                     t2: "Actual",
//                     t3: "Discounted",
//                     width: width,
//                     isTitle: true,
//                   ),
//                   const SizedBox(height: 2),
//                   Divider(),
//                   _buildDiscountRow(
//                     t1: "Rate",
//                     t2: widget.originalQrData.rate,
//                     t3: widget.qrData.rate,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Net Wt.",
//                     t2: widget.originalQrData.netWeight,
//                     t3: widget.qrData.netWeight,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Jarti",
//                     t2: widget.originalQrData.jarti,
//                     t3: widget.qrData.jarti,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Jyala",
//                     t2: widget.originalQrData.jyala,
//                     t3: widget.qrData.jyala,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 1",
//                     t2: widget.originalQrData.stone1Price,
//                     t3: widget.qrData.stone1Price,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 2",
//                     t2: widget.originalQrData.stone2Price,
//                     t3: widget.qrData.stone2Price,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 3",
//                     t2: widget.originalQrData.stone3Price,
//                     t3: widget.qrData.stone3Price,
//                     width: width,
//                   ),
//                    Divider(color: const Color.fromARGB(255, 156, 69, 62),),
//                   _buildDiscountRow(
//                     t1: "Luxury Tax",
//                     t2: widget.originalQrData.luxuryAmount.toStringAsFixed(2),
//                     t3: widget.qrData.luxuryAmount.toStringAsFixed(2),
//                     width: width,
//                   ),
//                   Divider(color: const Color.fromARGB(255, 156, 69, 62),),
                  
//                   _buildDiscountRow(
//                       t1: "Total",
//                       t2: widget.originalQrData.total.toStringAsFixed(2),
//                       t3: widget.qrData.total.toStringAsFixed(2),
//                       width: width,
//                       isTitle: true),
//                 ],
//               )
//       ],
//     );
//   }

//   Widget _buildDiscountRow(
//       {required String t1,
//       required String t2,
//       required String t3,
//       required double width,
//       bool isTitle = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           width: width,
//           child: Text(
//             t1,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width,
//           child: Text(
//             t2,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width,
//           child: Text(
//             t3,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:jjewellery/models/qr_data_model.dart';

// class DiscountSummaryWidget extends StatefulWidget {

// const DiscountSummaryWidget({
//     super.key,
//     required this.originalQrData,
//     required this.qrData,
//   });

//   final QrDataModel originalQrData;
//   final QrDataModel qrData;

  

//   @override
//   State<DiscountSummaryWidget> createState() => _DiscountSummaryWidgetState();
// }

// class _DiscountSummaryWidgetState extends State<DiscountSummaryWidget> {
//   bool isExpanded = false;

//   double stringToDouble(String value) {
//     return double.tryParse(value) ?? 0.0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width * 0.3;

//     // From second code
//     double itemDiscount =
//         // stringToDouble(widget.originalQrData.price) - stringToDouble(widget.qrData.price);
//         stringToDouble(widget.originalQrData.price).toStringAsFixed(2) - stringToDouble(widget.qrData.price).toStringAsFixed(2);

//     double expectedDiscount = widget.qrData.expectedAmountDiscount;
//     double totalDiscount = itemDiscount + expectedDiscount;


//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ----------------------------------------------------
//         //  UPPER ROW (summary total difference)
//         // ----------------------------------------------------
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               isExpanded = !isExpanded;
//             });
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 //"Rs. ${itemDiscount.toStringAsFixed(2)}",
//                 "Rs. ${totalDiscount.toStringAsFixed(2)}",

//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//               Icon(
//                 isExpanded
//                     ? Icons.arrow_circle_up_rounded
//                     : Icons.arrow_circle_down_rounded,
//                 color: Colors.grey,
//               )
//             ],
//           ),
//         ),

//         // ----------------------------------------------------
//         //  EXPANDED DETAILS
//         // ----------------------------------------------------
//         !isExpanded
//             ? const SizedBox()
//             : Column(
//                 children: [
//                   const Divider(),
//                   const SizedBox(height: 2),
//                   _buildDiscountRow(
//                     t1: "Title",
//                     t2: "Actual",
//                     t3: "Discounted",
//                     width: width,
//                     isTitle: true,
//                   ),
//                   const Divider(),

//                   _buildDiscountRow(
//                     t1: "Rate",
//                     t2: widget.originalQrData.rate,
//                     t3: widget.qrData.rate,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Net Wt.",
//                     t2: widget.originalQrData.netWeight,
//                     t3: widget.qrData.netWeight,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Jarti",
//                     t2: widget.originalQrData.jarti,
//                     t3: widget.qrData.jarti,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Jyala",
//                     t2: widget.originalQrData.jyala,
//                     t3: widget.qrData.jyala,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 1",
//                     t2: widget.originalQrData.stone1Price,
//                     t3: widget.qrData.stone1Price,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 2",
//                     t2: widget.originalQrData.stone2Price,
//                     t3: widget.qrData.stone2Price,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 3",
//                     t2: widget.originalQrData.stone3Price,
//                     t3: widget.qrData.stone3Price,
//                     width: width,
//                   ),

//                   const Divider(color: Color.fromARGB(255, 156, 69, 62)),
//                   _buildDiscountRow(
//                     t1: "Luxury Tax",
//                     t2: widget.originalQrData.luxuryAmount.toStringAsFixed(2),
//                     t3: widget.qrData.luxuryAmount.toStringAsFixed(2),
//                     width: width,
//                   ),
//                   const Divider(color: Color.fromARGB(255, 156, 69, 62)),

//                   _buildDiscountRow(
//                     t1: "Total",
//                     t2: widget.originalQrData.total.toStringAsFixed(2),
//                     t3: widget.qrData.total.toStringAsFixed(2),
//                     width: width,
//                     isTitle: true,
//                   ),

//                   //const SizedBox(height: 12),

//                   // ----------------------------------------------------
//                   //  MERGED PART FROM THE SECOND CODE (TOTAL DISCOUNT)
//                   // ----------------------------------------------------
//                   // Container(
//                   //   padding: const EdgeInsets.all(14),
//                   //   decoration: BoxDecoration(
//                   //     color: Colors.white,
//                   //     borderRadius: BorderRadius.circular(16),
//                   //     boxShadow: const [
//                   //       BoxShadow(
//                   //         color: Colors.black12,
//                   //         blurRadius: 6,
//                   //         offset: Offset(0, 2),
//                   //       ),
//                   //     ],
//                   //   ),
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //     children: [
//                   //       const Text(
//                   //         "Discount",
//                   //         style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//                   //       ),
//                   //       Text(
//                   //         "Rs. ${totalDiscount.toStringAsFixed(2)}",
//                   //         style: const TextStyle(
//                   //           fontWeight: FontWeight.w600,
//                   //           fontSize: 16,
//                   //           color: Colors.green,
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               )
//       ],
//     );
//   }

//   Widget _buildDiscountRow({
//     required String t1,
//     required String t2,
//     required String t3,
//     required double width,
//     bool isTitle = false,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           width: width,
//           child: Text(
//             t1,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width,
//           child: Text(
//             t2,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width,
//           child: Text(
//             t3,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:jjewellery/models/qr_data_model.dart';

class DiscountSummaryWidget extends StatefulWidget {
  const DiscountSummaryWidget({
    super.key,
    required this.originalQrData,
    required this.qrData,
  });

  final QrDataModel originalQrData;
  final QrDataModel qrData;

  @override
  State<DiscountSummaryWidget> createState() => _DiscountSummaryWidgetState();
}

class _DiscountSummaryWidgetState extends State<DiscountSummaryWidget> {
  bool isExpanded = false;

  // ✅ Converts string to double safely
  double stringToDouble(String value) {
    String sanitized = value.replaceAll(',', '').trim();
    return double.tryParse(sanitized) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.3;

    // Calculate item discount
    double originalPrice = stringToDouble(widget.originalQrData.price);
    double discountedPrice = stringToDouble(widget.qrData.price);
    double itemDiscount = originalPrice - discountedPrice;

    // Extra discount entered via ExpectedAmount
    double expectedDiscount = widget.qrData.expectedAmountDiscount;

    // Total discount
    double totalDiscount = itemDiscount + expectedDiscount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ----------------------------------------------------
        //  Summary row (total difference)
        // ----------------------------------------------------
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rs. ${totalDiscount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.arrow_circle_up_rounded
                    : Icons.arrow_circle_down_rounded,
                color: Colors.grey,
              ),
            ],
          ),
        ),

        // ----------------------------------------------------
        //  Expanded details
        // ----------------------------------------------------
        if (isExpanded)
          Column(
            children: [
              const Divider(),
              const SizedBox(height: 2),
              _buildDiscountRow(
                t1: "Title",
                t2: "Actual",
                t3: "Discounted",
                width: width,
                isTitle: true,
              ),
              const Divider(),
              _buildDiscountRow(
                t1: "Rate",
                t2: widget.originalQrData.rate,
                t3: widget.qrData.rate,
                width: width,
              ),
              _buildDiscountRow(
                t1: "Net Wt.",
                t2: widget.originalQrData.netWeight,
                t3: widget.qrData.netWeight,
                width: width,
              ),
              _buildDiscountRow(
                t1: "Jarti",
                t2: widget.originalQrData.jarti,
                t3: widget.qrData.jarti,
                width: width,
              ),
              _buildDiscountRow(
                t1: "Jyala",
                t2: widget.originalQrData.jyala,
                t3: widget.qrData.jyala,
                width: width,
              ),
              _buildDiscountRow(
                t1: "Stone 1",
                t2: widget.originalQrData.stone1Price,
                t3: widget.qrData.stone1Price,
                width: width,
              ),
              _buildDiscountRow(
                t1: "Stone 2",
                t2: widget.originalQrData.stone2Price,
                t3: widget.qrData.stone2Price,
                width: width,
              ),
              _buildDiscountRow(
                t1: "Stone 3",
                t2: widget.originalQrData.stone3Price,
                t3: widget.qrData.stone3Price,
                width: width,
              ),
              const Divider(color: Color.fromARGB(255, 156, 69, 62)),
              _buildDiscountRow(
                t1: "Luxury Tax",
                t2: widget.originalQrData.luxuryAmount.toStringAsFixed(2),
                t3: widget.qrData.luxuryAmount.toStringAsFixed(2),
                width: width,
              ),
              const Divider(color: Color.fromARGB(255, 156, 69, 62)),
              _buildDiscountRow(
                t1: "Total",
                t2: widget.originalQrData.total.toStringAsFixed(2),
                t3: widget.qrData.total.toStringAsFixed(2),
                width: width,
                isTitle: true,
              ),

              const SizedBox(height: 12),

              // ----------------------------------------------------
              //  Total discount display
              // ----------------------------------------------------
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Discount",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      "Rs. ${totalDiscount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDiscountRow({
    required String t1,
    required String t2,
    required String t3,
    required double width,
    bool isTitle = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width,
          child: Text(
            t1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: Text(
            t2,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: Text(
            t3,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

