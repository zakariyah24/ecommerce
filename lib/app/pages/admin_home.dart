import 'package:ecommerce/app/pages/admin_add_product.dart';
import 'package:ecommerce/app/providers.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/project_list_tile.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home"),
        actions: [
          IconButton(
              onPressed: () => ref.read(firebaseAuthProvider).signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: ref.read(databaseProvider)!.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data != null) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("No Products yet..."),
                    Lottie.asset("assets/anim/5081-empty-box.json",
                        width: 200, repeat: false),
                  ],
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.5),
                    child: ProductListTile(
                      product: product,
                      onDelete: () async {
                        openErrorSnackBar(
                            context,
                            "Deleting item...",
                            const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ));
                        await ref
                            .read(databaseProvider)!
                            .deleteProduct(product.id!);
                      },
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminAddProductPage())),
      ),
    );
  }
}
