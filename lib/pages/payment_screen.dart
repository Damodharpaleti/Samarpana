import 'package:flutter/material.dart';

import 'package:Samarpana/model/payment_method.dart';
import 'package:Samarpana/pages/base_page.dart';
import 'package:Samarpana/widgets/widget_payment_list_item.dart';

class PaymentScreen extends BasePage {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends BasePageState<PaymentScreen> {
  late PaymentList paymentList;

  @override
  Widget pageUI() {
    paymentList = new PaymentList(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 0,
          ),
          paymentList.paymentList.length > 0
              ? SizedBox(
                  height: 0,
                )
              : SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: 0,
          ),
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return PaymentListItem(
                  key: ValueKey(index),
                  payment: paymentList.paymentList.elementAt(index),
                );
              },
              separatorBuilder: (Context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: paymentList.paymentList.length),
          paymentList.cashlist.length > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 1,
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Divider(
            color: Colors.green,
          ),
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return CardPayment(
                  key: ValueKey(index),
                  payment: paymentList.paymentList.elementAt(index),
                );
              },
              separatorBuilder: (Context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: paymentList.paymentList.length),
          paymentList.cashlist.length > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Divider(
            color: Colors.green,
          ),
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return CreditCardPayment(
                  key: ValueKey(index),
                  payment: paymentList.paymentList.elementAt(index),
                );
              },
              separatorBuilder: (Context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: paymentList.paymentList.length),
          paymentList.cashlist.length > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Divider(
            color: Colors.green,
          ),
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return NetBanking(
                  key: ValueKey(index),
                  payment: paymentList.paymentList.elementAt(index),
                );
              },
              separatorBuilder: (Context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: paymentList.paymentList.length),
          paymentList.cashlist.length > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Divider(
            color: Colors.green,
          ),
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return Wallets(
                  key: ValueKey(index),
                  payment: paymentList.paymentList.elementAt(index),
                );
              },
              separatorBuilder: (Context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: paymentList.paymentList.length),
          paymentList.cashlist.length > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Divider(
            color: Colors.green,
          ),
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return CashonDelivery(
                  key: ValueKey(index),
                  payment: paymentList.cashlist.elementAt(index),
                );
              },
              separatorBuilder: (Context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemCount: paymentList.cashlist.length)
        ],
      ),
    );
  }
}
