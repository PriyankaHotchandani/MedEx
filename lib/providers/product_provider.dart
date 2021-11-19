import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:med_x/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  ProductModel productModel;

  List<ProductModel> search = [];
  productModels(QueryDocumentSnapshot element) {
    productModel = ProductModel(
      productImage: element.get("productImage"),
      productName: element.get("productName"),
      productPrice: element.get("productPrice"),
      productId: element.get("productId"),
      productUnit: element.get("productUnit"),
    );
    search.add(productModel);
  }

  // herbal and ayurveda products
  List<ProductModel> herbalProductList = [];

  fetchHerbalProductData() async {
    List<ProductModel> newList = [];

    QuerySnapshot value =
        await FirebaseFirestore.instance.collection("HerbAyur").get();

    value.docs.forEach(
      (element) {
        productModels(element);

        newList.add(productModel);
      },
    );
    herbalProductList = newList;
    notifyListeners();
  }

  List<ProductModel> get getHerbalProductDataList {
    return herbalProductList;
  }

// covid essential products

  List<ProductModel> covidProductList = [];

  fetchCovidProductData() async {
    List<ProductModel> newList = [];

    QuerySnapshot value =
        await FirebaseFirestore.instance.collection("Covid").get();

    value.docs.forEach(
      (element) {
        productModels(element);
        newList.add(productModel);
      },
    );
    covidProductList = newList;
    notifyListeners();
  }

  List<ProductModel> get getCovidProductDataList {
    return covidProductList;
  }

// nutrition & fitness products

  List<ProductModel> nutritionProductList = [];

  fetchNutritionProductData() async {
    List<ProductModel> newList = [];

    QuerySnapshot value =
        await FirebaseFirestore.instance.collection("Nutrition").get();

    value.docs.forEach(
      (element) {
        productModels(element);
        newList.add(productModel);
      },
    );
    nutritionProductList = newList;
    notifyListeners();
  }

  List<ProductModel> get getNutritionProductDataList {
    return nutritionProductList;
  }

  /////////////////// Search Return ////////////
  List<ProductModel> get getAllProductSearch {
    return search;
  }
}
