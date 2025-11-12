import 'package:flutter/material.dart';
import 'package:jjewellery/presentation/widgets/Global/single_dot_formatter.dart';

Widget rowWithTextField(
    {TextEditingController? controller,
    Function(String)? onChanged,
    String? title,
    String? unit,
    required double width,
    bool isUnitLeading = true,
    required bool isNumberField,
    Function(String?)? validator,
    Color titleColor = Colors.black,
    bool isEnabled = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null)
          SizedBox(
            width: (width / 0.18) > 410 ? width * 0.58 : width,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        if (title != null) const SizedBox(width: 5),
        if (title != null)
          Text(
            ":",
            style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
          ),
        if (unit == null || isUnitLeading == false)
          const SizedBox(
            width: 24,
          ),
        if (title != null) const SizedBox(width: 5),
        if (isUnitLeading && unit != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              unit,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child: TextFormField(
            enabled: isEnabled,
            inputFormatters: isNumberField
                ? [
                    SingleDotFormatter(),
                  ]
                : [],
            controller: controller,
            validator: (value) => validator!(value),
            keyboardType:
                isNumberField ? TextInputType.number : TextInputType.text,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        if (isUnitLeading || unit == null)
          const SizedBox(
            width: 18,
          ),
        if (!isUnitLeading && unit != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              unit,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    ),
  );
}

Widget rowWithTwoTextField({
  required TextEditingController controller1,
  required TextEditingController controller2,
  required Function(String) onChanged1,
  required Function(String) onChanged2,
  required String title,
  required String unit1,
  required String unit2,
  required double width,
  required bool isUnitLeading,
  bool isJartiField = false,
  TextEditingController? jartiLalController,
  Function(String)? jartiLalOnChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title Section
        if (title.isNotEmpty)
          SizedBox(
            width: (width / (6 * 0.18)) > 410 ? width * 0.098 : width * 0.18,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        if (title.isNotEmpty) const SizedBox(width: 5), // Space after title
        if (title.isNotEmpty)
          const Text(
            ":",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        if (title.isNotEmpty) const SizedBox(width: 5), // Space after colon

        // Unit1 and First TextField
        Expanded(
          child: Row(
            children: [
              if (unit1.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    unit1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Expanded(
                child: TextField(
                  inputFormatters: [
                    SingleDotFormatter(),
                  ],
                  controller: controller1,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged1,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 8.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),

              // Spacer and Equals Sign
              isJartiField
                  ? const SizedBox(width: 2)
                  : const SizedBox(width: 8),
            ],
          ),
        ),
        Text(
          "=",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        !isUnitLeading && !isJartiField
            ? const SizedBox(width: 16)
            : const SizedBox.shrink(), // Space between fields
        isJartiField ? const SizedBox(width: 2) : const SizedBox.shrink(),
        Expanded(
          child: Row(
            children: [
              if (unit2.isNotEmpty && isUnitLeading)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    unit2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller2,
                  inputFormatters: [
                    SingleDotFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: onChanged2,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 8.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              if (unit2.isNotEmpty && !isUnitLeading)
                Padding(
                  padding: EdgeInsets.only(left: isJartiField ? 2 : 8.0),
                  child: Text(
                    unit2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        isJartiField
            ? Expanded(
                child: Row(
                  children: [
                    const SizedBox(width: 2),
                    Text(
                      "=",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: TextField(
                        inputFormatters: [
                          SingleDotFormatter(),
                        ],
                        controller: jartiLalController,
                        keyboardType: TextInputType.number,
                        onChanged: jartiLalOnChanged,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "l",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        if (isUnitLeading) const SizedBox(width: 18),
      ],
    ),
  );
}

Widget buildDetailRow(
    {required String label, required String value, required double textSize}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      children: [
        SizedBox(
          child: Text(
            label,
            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          ": $value",
          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400),
        ),
      ],
    ),
  );
}
