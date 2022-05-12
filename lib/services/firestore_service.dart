import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product.dart';

class FirestoreService {
  FirestoreService({required this.uid});
  final String uid;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //add
  Future<void> addProduct(Product product) async {
    final docId = firestore.collection("products").doc().id;
    print(docId);
    // await firestore
    //     .collection("products")
    //     .add(product.toMap())
    //     .then((value) => print(value))
    //     .catchError((onError) => print("Error"));
    await firestore.collection("products").doc(docId).set(product.toMap(docId));
  }

  // display
  Stream<List<Product>> getProducts() {
    return firestore
        .collection("products")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final d = doc.data();
              return Product.fromMap(d);
            }).toList());
  }

  //delete
  Future<void> deleteProduct(String id) async {
    return await firestore.collection("products").doc(id).delete();
  }
}
