import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medx/config/colors.dart';
import 'package:medx/models/product_model.dart';
import 'package:medx/providers/review_cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:medx/screens/home/single_product.dart';

class Count extends StatefulWidget {
  String productName;
  String productImage;
  String productId;
  int productPrice;
  var productUnit;

  Count({
    this.productName,
    this.productUnit,
    this.productId,
    this.productImage,
    this.productPrice,
  });
  @override
  _CountState createState() => _CountState();
}

class _CountState extends State<Count> {
  int count = 1;
  bool isTrue = false;

  getAddAndQuantity() {
    FirebaseFirestore.instance
        .collection("ReviewCart")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("YourReviewCart")
        .doc(widget.productId)
        .get()
        .then(
          (value) => {
            if (this.mounted)
              {
                if (value.exists)
                  {
                    setState(() {
                      count = value.get("cartQuantity");
                      isTrue = value.get("isAdd");
                    })
                  }
              }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    getAddAndQuantity();

    ReviewCartProvider reviewCartProvider = Provider.of(context);
    return Container(
      height: 25,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: isTrue == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (count == 1) {
                      setState(() {
                        isTrue = false;
                      });
                      reviewCartProvider.reviewCartDataDelete(widget.productId);
                    } else if (count > 1) {
                      setState(() {
                        count--;
                      });
                      reviewCartProvider.updateReviewCartData(
                        cartId: widget.productId,
                        cartImage: widget.productImage,
                        cartName: widget.productName,
                        cartPrice: widget.productPrice,
                        cartQuantity: count,
                        cartUnit: selected_units==null?'50 mg':selected_units,
                      );
                    }
                  },
                  child: Icon(
                    Icons.remove,
                    size: 15,
                    color: primaryColor,
                  ),
                ),
                Text(
                  "$count",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      count++;
                    });
                    reviewCartProvider.updateReviewCartData(
                      cartId: widget.productId,
                      cartImage: widget.productImage,
                      cartName: widget.productName,
                      cartPrice: widget.productPrice,
                      cartQuantity: count,
                      cartUnit:selected_units==null?'50 mg':selected_units,
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 15,
                    color: primaryColor,
                  ),
                ),
              ],
            )
          : Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isTrue = true;
                  });
                  reviewCartProvider.addReviewCartData(
                    cartId: widget.productId,
                    cartImage: widget.productImage,
                    cartName: widget.productName,
                    cartPrice: widget.productPrice,
                    cartQuantity: count,
                    cartUnit: selected_units==null?'50 mg':selected_units,
                  );
                },
                child: Text(
                  "ADD",
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),
    );
  }
}
