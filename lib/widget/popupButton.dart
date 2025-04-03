import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupHelper {
  static OverlayEntry? overlayEntry;

  static void showPopup({
    required BuildContext context,
    required double width,
    required Widget popupContent,
    required GlobalKey buttonKey,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Mode Mobile : Affichage en backdrop modal
      Get.bottomSheet(Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: SingleChildScrollView(

              child: Padding(
                padding: const EdgeInsets.all(10),
                child: popupContent,
              ),
            ),
          ),isScrollControlled: true);
    } else {
      // Mode Desktop : Affichage en overlay draggable
      final double screenHeight = MediaQuery.of(context).size.height;
      overlayEntry = OverlayEntry(
        builder: (context) => DraggablePopup(
          initialOffset: Offset(
            (screenWidth - width) / 2,
            (screenHeight - 150) / 2,
          ),
          width: width,
          popupContent: popupContent,
        ),
      );

      Overlay.of(context).insert(overlayEntry!);
    }
  }

  static void removePopup(BuildContext context) {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}

class DraggablePopup extends StatefulWidget {
  final Offset initialOffset;
  final double width;
  final Widget popupContent;

  const DraggablePopup({
    Key? key,
    required this.initialOffset,
    required this.width,
    required this.popupContent,
  }) : super(key: key);

  @override
  _DraggablePopupState createState() => _DraggablePopupState();
}

class _DraggablePopupState extends State<DraggablePopup> {
  late Offset offset;

  @override
  void initState() {
    super.initState();
    offset = widget.initialOffset;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => PopupHelper.removePopup(context),
            behavior: HitTestBehavior.translucent,
          ),
        ),
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                offset += details.delta;
              });
            },
            child: Material(
              color: Colors.transparent,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                color: Colors.grey[200],
                elevation: 5,
                child: Container(
                  width: widget.width,
                  padding: const EdgeInsets.all(10),
                  child: widget.popupContent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
