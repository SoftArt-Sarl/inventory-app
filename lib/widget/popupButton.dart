import 'package:flutter/material.dart';

class PopupHelper {
  static OverlayEntry? overlayEntry;

  static void showPopup({
    required BuildContext context,
    required GlobalKey buttonKey,
    required double width,
    required Widget popupContent,
  }) {
    if (buttonKey.currentContext == null) return;

    final RenderBox renderBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => removePopup(context),
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            left: position.dx - width,
            top: (position.dy + size.height + 5 + 150 <= MediaQuery.of(context).size.height)
                ? position.dy + size.height + 5
                : position.dy - 150,
            child: Material(
              color: Colors.transparent,
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                color: Colors.white,
                elevation: 5,
                child: Container(
                  width: width,
                  padding: const EdgeInsets.all(5),
                  child: popupContent, // Le contenu du popup
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  static void removePopup(BuildContext context) {
    overlayEntry?.remove();
  }
}