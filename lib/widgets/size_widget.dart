import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/model/product_size.dart';

class SizeWidget extends StatelessWidget {
  final SizeModel sizeModel;
  final ProductSizes productSizes;

  SizeWidget(this.sizeModel, this.productSizes);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      child: Container(
        width: 50.0,
        height: 50.0,
        child: Center(
          child: Text(
            sizeModel.text,
            style: TextStyle(
                color: sizeModel.isSelected ? Colors.white : Colors.black,
                fontSize: 14),
          ),
        ),
        decoration: BoxDecoration(
            color: sizeModel.isSelected ? Colors.black : Colors.transparent,
            border: Border.all(
                width: 1.0,
                color: sizeModel.isSelected ? Colors.black : Colors.grey),
          borderRadius: const BorderRadius.all(const Radius.circular(2.0))
        ),
      ),
    );
  }
}

class SizeModel {
  bool isSelected;
  final String text;

  SizeModel(this.isSelected, this.text);
}
