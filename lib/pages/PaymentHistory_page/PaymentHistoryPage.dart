import 'package:astrologyapp/model/PaymentHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentHistoryPage extends StatefulWidget {
  static String? useremail;

  static const String routeName = '/paymentHitoryPage';
  const PaymentHistoryPage({Key? key}) : super(key: key);

  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment History',
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: PaymentHistory.readPayments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 8.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var noteInfo = snapshot.data!.docs[index].data();
                // String docID = snapshot.data!.docs[index].id;
                String paymentId = noteInfo['paymentId'];
                String description = noteInfo['description'];
                double amount = noteInfo['amount'];
                String paidTo = noteInfo['paidTo'];
                String from = noteInfo['from'];
                String date = noteInfo['paymentDateTime'];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ExpansionTile(
                        iconColor: Colors.blue.shade900,
                        collapsedIconColor: Colors.blue.shade900,
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Payment ID - ' + paymentId,
                                  // maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                          child: Text(
                            'Tap to check more information',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description - ' + description,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Amount - ' +
                                        amount.toString() +
                                        ' \u{20B9}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Paid to - ' + paidTo,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('From - ' + from,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Payment ID - ' + paymentId,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Payment DateTime - ' + date,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                      // ListTile(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(8.0),
                      //   ),
                      //   onTap: () {
                      //     // Navigator.of(context).push(MaterialPageRoute(
                      //     //     builder: (context) => PaymentHistoryPage()));
                      //   },

                      //   subtitle: Text(
                      //     'Tap for details',
                      //     maxLines: 1,
                      //     style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                      ),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue.shade900,
              ),
            ),
          );
        },
      ),
    );
  }
}
