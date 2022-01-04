import 'package:flutter/material.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:provider/provider.dart';
import 'package:second_shopp/model/data/transaction.dart';
import 'package:second_shopp/model/data/transaction_dao.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyItem extends StatefulWidget {
  BuyItem({Key? key}) : super(key: key);

  @override
  State<BuyItem> createState() => _BuyItemState();
}

class _BuyItemState extends State<BuyItem> {
  String? title = 'Product Title';
  String? pcategory = "category";
  String? description = "description";
  int? price = 200;

  String sellerName = 'seller name';
  String phoneNumber = "9806977742";
  late Map transactionData = {};

  @override
  Widget build(BuildContext context) {
    String sellerNumber = '+977$phoneNumber';

    final transactionDao = Provider.of<Transaction_Dao>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          // onTap: press,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          // color: Colors.blueGrey,
                          decoration: BoxDecoration(
                            // image: DecorationImage(image: NetworkImage("")),
                            color: Colors.orange.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                        // child: Container(
                        //   color: Colors.indigoAccent,
                        // ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            RowData(
                              title: "Title ",
                              name: "$title",
                              icon: Icons.favorite_border_outlined,
                            ),
                            RowData(title: "Price ", name: "Rs $price"),
                            RowData(
                                title: "Category ", name: pcategory.toString()),
                            RowData(
                                title: "Description ",
                                name: description.toString()),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.orange.shade400,
                                    backgroundImage: const NetworkImage(
                                        "https://firebasestorage.googleapis.com/v0/b/secondshopp-f510b.appspot.com/o/DefaultPictures%2Fuser.png?alt=media&token=0a4f1565-673e-4953-b087-3b6ed584afb6")),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$sellerName",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      'Contact: $phoneNumber',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                Spacer(),
                                MaterialButton(
                                  padding: const EdgeInsets.all(12),
                                  color: Colors.orange.shade200,
                                  // shape: Border.all(color: Colors.orange.shade900),
                                  shape: const RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  onPressed: () {
                                    openwhatsapp(sellerNumber);
                                  },
                                  child: const Text(
                                    "Message",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
              // SizedBox(
              //   height: 100,
              //   child: Container(
              //     color: Colors.orange,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      elevation: 8,
                      padding: const EdgeInsets.all(12),
                      color: Colors.orange.shade300,
                      onPressed: () {},
                      child: const Text(
                        "Add To Watch List",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    MaterialButton(
                      elevation: 8,
                      padding: const EdgeInsets.all(12),
                      color: Colors.orange.shade300,
                      onPressed: () async {
                        await _sendToKhalti(transactionDao);
                        // _storeTransactionDetails(transactionDao);
                      },
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendToKhalti(transactionDao) {
    double amount = double.parse(price.toString()) * 100;

    FlutterKhalti _flutterkhalti = FlutterKhalti.configure(
        publicKey: "test_public_key_ce7622a43dce4ce895e43d7a9db28111",
        urlSchemeIOS: "khaltiPayFlutterExampleSchema");

    KhaltiProduct product = KhaltiProduct(
      id: "test",
      amount: amount,
      name: "description",
    );

    _flutterkhalti.startPayment(
        product: product,
        onSuccess: (Data) {
          print("success $Data");
          transactionData = {
            'amount': (Data['amount'] / 100),
            'mobile': Data['mobile'],
            'product_identity': Data['product_identity'],
            'product_name': Data['product_name'],
            'token': Data['token'],
          };
          print('Data added to transactionData : $transactionData');
          _storeTransactionDetails(transactionDao);
        },
        onFaliure: (error) {
          print("failure msg on payment: $error");
        });
  }

  Future<void> _storeTransactionDetails(Transaction_Dao transaction_dao) async {
    print('storeTransaction details function running');
    late final transaction_data = Transaction_Data(
      amount: transactionData['amount'],
      mobile: transactionData['mobile'],
      product_ID: transactionData['product_identity'],
      product_name: transactionData['product_name'],
      token: transactionData['token'],
    );
    print("$transaction_data data send to transaction data");
    transaction_dao.saveTransactionData(transaction_data);
  }

  openwhatsapp(sellerPhoneNum) async {
    var whatsapp = sellerPhoneNum.toString();
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios =
        "https://wa.me/$whatsapp?text=${Uri.parse("I am interested in $title")}";

    // android , web
    if (await canLaunch(whatsappURl_android)) {
      await launch(whatsappURl_android);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Second Shop uses WhatsApp for messaging'),
              content: Text('Download WhatsApp to use messanging feature.'),
              actions: [
                FlatButton(
                  // FlatButton widget is used to make a text to work like a button
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  }, // function used to perform after pressing the button
                  child: Text('CANCEL'),
                ),
                TextButton(
                  // textColor: Colors.black,
                  onPressed: () {
                    // StoreRedirect.redirect(androidAppId: 'com.whatsapp');
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text('Second Shop uses WhatsApp for messaging'),
                            content: Text(
                                'Download WhatsApp to use messanging feature.'),
                            actions: [
                              FlatButton(
                                // FlatButton widget is used to make a text to work like a button
                                textColor: Colors.black,
                                onPressed: () {
                                  Navigator.pop(context);
                                }, // function used to perform after pressing the button
                                child: Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () {
                                  StoreRedirect.redirect(
                                      androidAppId: 'com.whatsapp');
                                  Navigator.pop(context);
                                },
                                child: Text('DOWNLOAD'),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          );
                        });
                  },
                  child: Text('DOWNLOAD'),
                ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            );
          });
    }
  }
}

class RowData extends StatelessWidget {
  String title;
  String name;
  IconData? icon;
  RowData({Key? key, required this.title, required this.name, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title: ",
          style: TextStyle(fontSize: 20),
        ),
        Expanded(
            child: Text(
          "$name",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        )),
        Icon(
          icon,
          size: 40,
        )
      ],
    );
  }
}