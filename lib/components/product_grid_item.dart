// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          header: GridTileBar(
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.gabs,
          ),
          // ignore: sort_child_properties_last
          child: GestureDetector(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.fitWidth,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
            },
          ),
          footer: GridTileBar(
            title: Text(
              'R\$ ${product.price.toString()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.babs,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromARGB(34, 127, 127, 127),
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavorite(
                    auth.token ?? '',
                    auth.userId ?? '',
                  );
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                iconSize: 17,
                color: Color.fromARGB(184, 253, 76, 0),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              iconSize: 17,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product seccessfully added!'),
                    duration: Duration(milliseconds: 500),
                    action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
                cart.addItem(product);
              },
              color: Color.fromARGB(184, 253, 76, 0),
            ),
          ),
        ));
  }
}
