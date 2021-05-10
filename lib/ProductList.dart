import 'package:flutter/material.dart';
import 'package:e_commerce/DisplayCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animations/loading_animations.dart';

// ignore: must_be_immutable
class ProductList extends StatefulWidget {
  String screenName;

  ProductList({this.screenName});

  _ProductListState createState() => _ProductListState(screenName);
}

class _ProductListState extends State<ProductList> {
  String productId;
  String productName;
  String offeredBy ;
  double offer ;
  double oldPrice ;
  int price ;
  int rating ;
  String screenName;
  var currentTime;
  String imageUrl = '';
  List<String> reviews;
  final _firestore = FirebaseFirestore.instance;

  _ProductListState(this.screenName);

  bool isLoading=true;

  var productList;

  // ignore: must_call_super
   void initState() {
    isLoading=true;

    Future.delayed(Duration( seconds: 2),(){
      setState(() {
        isLoading=false;
      });
    });

    setState(() {
    productList=  StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('productDetails').orderBy('Time',descending: true).snapshots(),
        builder: (context, snapshot) {
          List<DisplayCard> displayCards=[];
          if (snapshot.hasData) {
            final displayData = snapshot.data.docs;
            for (var eachProduct in displayData) {
              productId = eachProduct.id;
              productName = eachProduct.get('Name');
              offeredBy = eachProduct.get('OfferedBy');
              price = eachProduct.get('Price');
              offer = eachProduct.get('Offer');
              oldPrice = eachProduct.get('OldPrice');
              imageUrl = eachProduct.get('imageUrls')[0];
              final displayCardWidget = DisplayCard(
                productId: productId,
                productName: productName,
                offeredBy: offeredBy,
                price: price,
                offer: offer,
                oldPrice: oldPrice,
                imageUrl: imageUrl,
              );
              displayCards.add(displayCardWidget);
            }
          }
          return Column(
            children: displayCards,
          );
        }
    );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              screenName,
              style: TextStyle(color: Colors.white),
            )),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: isLoading? Center(
              child: LoadingBouncingGrid.circle(
                size: 70,
                backgroundColor: Color(0xfffca9e4),
                borderSize: 10,
              ),
            ): ListView(
              shrinkWrap: true,
              children: [
                  productList??Text('Loading')
              ],
            )
        )
    );
  }
}
