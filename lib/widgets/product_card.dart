import 'package:flutter/material.dart';
import '/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double widthFactor;
  final double leftPosition;
  final bool isWishlist;

  const ProductCard({
    super.key,
    required this.product,
    this.widthFactor = 2.25,
    this.leftPosition = 5,
    this.isWishlist = false,
  });

  @override
  Widget build(BuildContext context) {
    final double widthValue = MediaQuery.of(context).size.width / widthFactor;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product',
          arguments: product,
        );
      },
      child: Stack(
        children: [
          SizedBox(
            width: widthValue,
            height: 150,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              top: 60,
              left: leftPosition,
              child: Container(
                width: widthValue - 5 - leftPosition,
                height: 80,
                decoration: BoxDecoration(color: Colors.black.withAlpha(50)),
              )),
          Positioned(
            top: 65,
            left: leftPosition + 5,
            child: Container(
              width: widthValue - 15 - leftPosition,
              height: 70,
              decoration: const BoxDecoration(color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            'Ksh.${product.price}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    isWishlist
                        ? Expanded(
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
