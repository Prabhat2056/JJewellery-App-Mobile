
//-----------------------------------------



import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/QrResult/qr_result_bloc.dart';

import 'package:jjewellery/models/qr_data_model.dart';

class ExpectedAmount extends StatefulWidget { 
  final TextEditingController controller;
  final double total;
  final void Function(double)? onDiscountCalculated;
  final void Function(String)? onChanged;
  final void Function(double)? onExpectedAmountEntered;
  final QrDataModel qrData; // Add qrData to pass it to the BLoC

  const ExpectedAmount({
    super.key,
    required this.controller,
    required this.total,
    required this.qrData, // Make qrData required
    this.onDiscountCalculated,
    this.onChanged,
    this.onExpectedAmountEntered,
  });

  @override
  State<ExpectedAmount> createState() => _ExpectedAmountState();
}

class _ExpectedAmountState extends State<ExpectedAmount> {
  bool showDiscountText = false;
  double discount = 0.0;
  String savedValue = "";
  bool discountCalculatedOnce = false;
  

  @override
  void initState() {
    super.initState();
    savedValue = widget.controller.text;
  }

  // void _calculateDiscount() {
  //   final expectedText = widget.controller.text.trim();
  //   if (expectedText.isEmpty) {
  //     setState(() => discount = 0.0);
  //     return;
  //   }

  //   final expectedAmount = double.tryParse(expectedText) ?? 0.0;
  //   final total = widget.total;
  //   final calculated = total - expectedAmount;
    

  //   setState(() {
  //     discount = calculated < 0 ? 0 : calculated;
  //   });

  //   widget.onDiscountCalculated?.call(discount);
  //   widget.onExpectedAmountEntered?.call(expectedAmount);
  // }

  void _calculateDiscount() {
  final text = widget.controller.text.trim();

  log("Starting _calculateDiscount with input text: '$text'");

  // 1️⃣ If no input, reset discount and exit
  if (text.isEmpty) {
    setState(() => discount = 0.0);
    widget.onDiscountCalculated?.call(0.0);
    widget.onExpectedAmountEntered?.call(0.0);
    log("Input is empty; discount reset to 0.0");
    return;
  }

  // 2️⃣ Convert text to double safely
  final expectedAmount = double.tryParse(text) ?? 0.0;
  widget.qrData.expectedAmount = expectedAmount.toString();
  log("Parsed expected amount: $expectedAmount");

  // 3️⃣ Calculate discount = total – expectedAmount
  final calculatedDiscount = widget.total - expectedAmount;
  log("Calculated discount (total - expectedAmount): $calculatedDiscount");

  

  // 4️⃣ Prevent negative discount
  final finalDiscount = calculatedDiscount < 0 ? 0.0 : calculatedDiscount;
  log("Final discount after preventing negatives: $finalDiscount");

  // ⭐ Store raw value (ALWAYS parseable)
widget.qrData.expectedAmountDiscount = finalDiscount.toString();

  // 5️⃣ Update UI
  setState(() => discount = finalDiscount);

  // 6️⃣ Notify parent widget
  widget.onDiscountCalculated?.call(finalDiscount);
  widget.onExpectedAmountEntered?.call(expectedAmount);
  log("Discount Calculated → $discount | Expected Amount → $expectedAmount");
}

//   void _onChanged(String value) {
//   savedValue = value.trim();
//   widget.qrData.expectedAmount = savedValue;

//   // Optional callback to parent
//   widget.onChanged?.call(savedValue);

//   // // Dispatch event to BLoC
//   // final bloc = BlocProvider.of<QrResultBloc>(context);
//   // bloc.add(QrResultExpectedAmountChangedEvent(qrData: widget.qrData));

//   log("_onChanged: ExpectedAmount updated and event dispatched to BLoC");
// }

void _onChanged(String value) {
  savedValue = value.trim();
  widget.qrData.expectedAmount = savedValue;

  // 🔥 NEW: If expected amount is cleared, reset to original data
  // if (savedValue.isEmpty) {
  //   print("🟢 Expected amount cleared, triggering reset");
  //   final bloc = BlocProvider.of<QrResultBloc>(context);
  //   bloc.add(QrResultResetToOriginalEvent());
  //   return;
  // }

  // Optional callback to parent
  widget.onChanged?.call(savedValue);

  // Dispatch event to BLoC for calculation
  final bloc = BlocProvider.of<QrResultBloc>(context);
  bloc.add(QrResultExpectedAmountChangedEvent(
    widget.qrData.expectedAmount, 
    qrData: widget.qrData
  ));

  log("_onChanged: ExpectedAmount updated and event dispatched to BLoC");
}

  @override
  void didUpdateWidget(ExpectedAmount oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restore the saved user input after any rebuild
    widget.controller.text = savedValue;
    // Update savedValue to the current controller text to avoid overriding new values
    // savedValue = widget.controller.text;
  }

  void _toggleDiscount() {
    log("_toggleDiscount called. Current showDiscountText: $showDiscountText, discountCalculatedOnce: $discountCalculatedOnce");
    setState(() {
      showDiscountText = !showDiscountText;
    });
    log("showDiscountText toggled to: $showDiscountText");
  
    // Calculate ONLY the first time dropdown is opened
    if (showDiscountText && !discountCalculatedOnce) {
      log("Calling _calculateDiscount inside _toggleDiscount for the first time");
      _calculateDiscount();
      discountCalculatedOnce = false;
      log("discountCalculatedOnce set to true");
    }
  }

  @override
  Widget build(BuildContext context) {
      double jyala = double.tryParse(widget.qrData.jyala.toString()) ?? 0.0;
      double newJyala = double.tryParse(widget.qrData.newJyala.toString()) ?? 0.0;
      double jartiAmount = double.tryParse(widget.qrData.jartiAmount.toString()) ?? 0.0;
      double newJartiAmount = double.tryParse(widget.qrData.newJartiAmount.toString()) ?? 0.0;
      double jarti = double.tryParse(widget.qrData.jarti.toString()) ?? 0.0;
    // double jartiAmount = stringToDouble(qrData.jartiAmount);
    //double newJyala = jyala - discount;
    
    // return BlocBuilder<QrResultBloc, QrResultState>(
    //   builder: (context, state) {
    //     // Use updated qrData if state has changed
    //     final qrData = (state is QrResultPriceChangedState) ? state.qrData : widget.qrData;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Expected Amount",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),

   // *************** KEY LOGIC HERE ***************
          // onChanged: (value) {
          //   if (value.isEmpty) {
          //     // USER CLEARED THE TEXT → RESET PAGE TO ORIGINAL DATA
          //     context.read<QrResultBloc>().add(QrResultResetToOriginalEvent());
          //     return;
          //   }

          //   // WHEN USER ENTERS VALUE → NORMAL FLOW
          //   context.read<QrResultBloc>().add(
          //         QrResultExpectedAmountChangedEvent(
          //           qrData: widget.qrData,
          //           expectedAmount: value,
          //         ),
          //       );
          // },

                   onChanged: _onChanged,
                  
                  //  onChanged: (value){
                  //    state.qrData.expectedAmount = value;
                  //  }
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _toggleDiscount,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    size: 28,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          if (showDiscountText) ...[
            const SizedBox(height: 8),
            Text(
              "Discount: Rs ${discount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Jyala: Rs ${jyala.toStringAsFixed(2)}",
              //"Jyala : Rs ${qrData.jyala}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Jyala After Discount: Rs ${newJyala.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Jarti : Rs ${jartiAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Jarti After Discount: Rs ${newJartiAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
             Text(
              "Jarti (Gram): Rs ${jarti.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              //"Expected Amount: Rs ${widget.controller.text.trim().isEmpty ? '0.00' : double.tryParse(widget.controller.text.trim())?.toStringAsFixed(2) ?? '0.00'}",
              "Expected Amount : Rs ${widget.qrData.expectedAmount.toString()}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
    //   }
    // );
  }
}



