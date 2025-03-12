import 'package:flutter/material.dart';
import 'package:simple_grid/simple_grid.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int columnsMobile;
  final int columnsTablet;
  final int columnsDesktop;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.columnsMobile = 1, // Nombre de colonnes pour mobile (par défaut 1)
    this.columnsTablet = 2, // Nombre de colonnes pour tablette (par défaut 2)
    this.columnsDesktop = 4, // Nombre de colonnes pour desktop (par défaut 4)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpGrid(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(0),
      spacing: spacing,
      runSpacing: runSpacing,
      children: children
          .map(
            (child) => SpGridItem(
              xs: 12~/ columnsMobile, // Prend toute la largeur sur mobile
              sm: 12 ~/ columnsTablet,  // Divise la largeur par le nombre de colonnes sur tablette
              md: 12 ~/ columnsDesktop, // Divise la largeur par le nombre de colonnes sur desktop
              child: child,
            ),
          )
          .toList(),
    );
  }
}