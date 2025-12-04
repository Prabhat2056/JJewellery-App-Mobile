


//---------------------------------------------------------

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
  final QrDataModel qrData;

  const ExpectedAmount({
    super.key,
    required this.controller,
    required this.total,
    required this.qrData,
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

  void _onChanged(String value) {
   
    savedValue = value.trim();
    widget.qrData.expectedAmount = savedValue;

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
    widget.controller.text = savedValue;
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

  // Helper method to parse double safely
  double _safeParse(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  // In _isFieldRecalculated method, add more tolerant comparison:
bool _isFieldRecalculated(String originalValue, String newValue) {

  if (newValue.isEmpty || newValue == "0.000") return false;
  // Parse both to double for comparison
  double original = double.tryParse(originalValue) ?? 0.0;
  double updated = double.tryParse(newValue) ?? 0.0;
  
  // Consider it recalculated if new value exists and is different
  return updated > 0 && (updated - original).abs() > 0.001;
}





  // // Check if a field has been recalculated
  // bool _isFieldRecalculated(String originalValue, String newValue) {
  //   return newValue.isNotEmpty && 
  //          newValue != "0.000" && 
  //          newValue != "0.0" && 
  //          newValue != originalValue;
  // }

  @override
  Widget build(BuildContext context) {
    // Parse all values
    double jyala = _safeParse(widget.qrData.jyala);
    double newJyala = _safeParse(widget.qrData.newJyala);
    double jarti = _safeParse(widget.qrData.jarti);
    double rate = _safeParse(widget.qrData.rate);
   // double jartiAmount = _safeParse(widget.qrData.jartiAmount);
    //jartiAmount = double.parse(jartiAmount.toStringAsFixed(3)); // Round to 3 decimals
    print( "ExpectedAmount-jyala: $jyala, newJyala: $newJyala, jarti: $jarti, rate: $rate");
    double stone1Price = _safeParse(widget.qrData.stone1Price);
    double newStone1Price = _safeParse(widget.qrData.newStone1Price);
    double stone2Price = _safeParse(widget.qrData.stone2Price);
    double newStone2Price = _safeParse(widget.qrData.newStone2Price);
    double stone3Price = _safeParse(widget.qrData.stone3Price);
    double newStone3Price = _safeParse(widget.qrData.newStone3Price);

    // ✅ FIX: Calculate jartiAmount if field is empty
  double jartiAmount;
  if (widget.qrData.jartiAmount.isNotEmpty && 
      widget.qrData.jartiAmount != "0.000" &&
      widget.qrData.jartiAmount != "0.0") {
    // Use stored value
    jartiAmount = _safeParse(widget.qrData.jartiAmount);
  } else if (jarti > 0 && rate > 0) {
    // Calculate from jarti and rate
    jartiAmount = (jarti * rate) / 11.664;
  } else {
    jartiAmount = 0.0;
  }
  

      
   
    print("ExpectedAmount-jartiAmount: $jartiAmount (from field: ${widget.qrData.jartiAmount})");

      double newJartiAmount = _safeParse(widget.qrData.newJartiAmount);
  double newJarti = _safeParse(widget.qrData.newJarti);
  
  // ✅ FIX: Also calculate what newJartiAmount should be if not set
  double calculatedNewJartiAmount;
  if (newJartiAmount > 0) {
    // Use newJartiAmount if it exists
    calculatedNewJartiAmount = newJartiAmount;
  } else if (newJarti > 0 && rate > 0) {
    // Calculate from newJarti if available
    calculatedNewJartiAmount = ((newJarti * rate) / 11.664);
  } else {
    // Fall back to original jartiAmount
    calculatedNewJartiAmount = jartiAmount;
  }

   

     
    // Check which fields have been recalculated
    bool isJyalaRecalculated = _isFieldRecalculated(
      widget.qrData.jyala, 
      widget.qrData.newJyala
    );
    
  // bool showJarti = widget.qrData.newJartiAmount.isNotEmpty &&
  //                widget.qrData.newJartiAmount != "0.000";

     //✅ FIX: Check jartiAmount recalculation properly
  bool isJartiAmountRecalculated = _isFieldRecalculated(
    
    widget.qrData.jartiAmount,
    widget.qrData.newJartiAmount
  ) || (newJarti > 0 && newJarti != jarti); // Or if newJarti is different
    
    bool isJartiRecalculated = _isFieldRecalculated(
      widget.qrData.jarti, 
      widget.qrData.newJarti
    );

    bool isStone1PriceRecalculated = _isFieldRecalculated(
      stone1Price.toString(), // Convert to string for comparison
      newStone1Price.toString()
    );
    


    log("🟢 Field Recalculation Status:");
    log("🟢 Jyala: $isJyalaRecalculated (${widget.qrData.jyala} -> ${widget.qrData.newJyala})");
    log("🟢 Jarti Amount: $isJartiAmountRecalculated (${widget.qrData.jartiAmount} -> ${widget.qrData.newJartiAmount})");
    log("🟢 Jarti: $isJartiRecalculated (${widget.qrData.jarti} -> ${widget.qrData.newJarti})");
    
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
                  onChanged: _onChanged,
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
    "Expected Amount: Rs ${widget.qrData.expectedAmount}",
    style: const TextStyle(
      fontSize: 14,
      color: Colors.green,
      fontWeight: FontWeight.w600,
    ),
  ),
  const SizedBox(height: 8),
  
  // Always show discount
  Text(
    "Discount: Rs ${discount.toStringAsFixed(2)}",
    style: const TextStyle(
      fontSize: 14,
      color: Colors.green,
      fontWeight: FontWeight.w600,
    ),
  ),
  
  const SizedBox(height: 8),
  
  // JYALA SECTION - Only show if jyala was recalculated
  if (isJyalaRecalculated) ...[
    const Text(
      "--- Jyala Adjustment ---",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
    Text(
      "Original Jyala: Rs ${jyala.toStringAsFixed(2)}",
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
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 4),
  ],
  
  // JARTI AMOUNT SECTION - Only show if jarti amount was recalculated
  if (newJartiAmount > 0) ...[
    const Text(
      "--- Jarti Amount Adjustment ---",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
    Text(
      "Original Jarti Amount: Rs ${jartiAmount.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.green,
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      "Jarti Amount After Discount: Rs ${newJartiAmount.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 4),
  ],
  
  // JARTI GRAM SECTION - Only show if jarti gram was recalculated
  if (isJartiRecalculated) ...[
    const Text(
      "--- Jarti Gram Adjustment ---",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
    Text(
      "Original Jarti: ${jarti.toStringAsFixed(2)}g",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.green,
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      "Jarti After Discount: ${newJarti.toStringAsFixed(2)}g",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 4),
  ],
  
  // STONE PRICE SECTION
  if (isStone1PriceRecalculated) ...[
    const Text(
      "--- Stone1Price Adjustment ---",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
    Text(
      "Original Stone1Price: Rs ${stone1Price.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.green,
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      "Stone1Price After Discount: Rs ${newStone1Price.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 4),
  ],
  
  // Add similar sections for stone2 and stone3 if needed
  if (widget.qrData.newStone2Price.isNotEmpty && 
      widget.qrData.newStone2Price != "0.000" &&
      widget.qrData.newStone2Price != widget.qrData.stone2Price) ...[
    const Text(
      "--- Stone2Price Adjustment ---",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
    Text(
      "Original Stone2Price: Rs ${stone2Price.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.green,
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      "Stone2Price After Discount: Rs ${newStone2Price.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 4),
  ],
  
  if (widget.qrData.newStone3Price.isNotEmpty && 
      widget.qrData.newStone3Price != "0.000" &&
      widget.qrData.newStone3Price != widget.qrData.stone3Price) ...[
    const Text(
      "--- Stone3Price Adjustment ---",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
    Text(
      "Original Stone3Price: Rs ${stone3Price.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.green,
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      "Stone3Price After Discount: Rs ${newStone3Price.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 4),
  ],
  
  // Show message if no adjustments were made
  if (!isJyalaRecalculated && 
      !isJartiAmountRecalculated && 
      !isJartiRecalculated && 
      !isStone1PriceRecalculated &&
      discount > 0) ...[
    const SizedBox(height: 8),
    const Text(
      "⚠️ No component adjustments needed for this discount amount",
      style: TextStyle(
        fontSize: 12,
        color: Colors.orange,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
],
        ],
      ),
    );
  }
}