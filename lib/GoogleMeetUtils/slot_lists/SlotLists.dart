import 'package:astrologyapp/actions/actions.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:flutter/material.dart';

class SlotLists extends StatefulWidget {
  final List<String> slotList;

  SlotLists({
    Key? key,
    required this.slotList,
  }) : super(key: key);

  @override
  _SlotListsState createState() => _SlotListsState();
}

class _SlotListsState extends State<SlotLists> {
  int? _slotSelected;
  bool isItemSelected = false;
  String _itemSelected = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.slotList.isEmpty
        ? Expanded(
            child: Container(
            child: Center(child: Text("No slots...")),
          ))
        : Expanded(
            child: Scaffold(
            bottomSheet: buildPaymentButton(),
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          children: widget.slotList.map((f) {
                            return GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                margin: EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                  color: _slotSelected ==
                                          widget.slotList.indexOf(f)
                                      ? Colors.blue
                                      : Colors.white,
                                  border: Border.all(
                                      color: Colors.black54, width: 1.3),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          32) //                 <--- border radius here
                                      ),
                                ),
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    color: _slotSelected ==
                                            widget.slotList.indexOf(f)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              onTap: () {
                                isItemSelected = true;
                                _slotSelected = widget.slotList.indexOf(f);
                                _itemSelected = f;
                                setState(() {});
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
  }

  //payment button
  Widget buildPaymentButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: sixtyDp, vertical: twentyDp),
      child: MaterialButton(
        onPressed: () {
          _itemSelected.isEmpty
              ? ShowAction().showToast(pleaseSelectSlot, Colors.red)
              : "";
        },
        child: Text(
          proceedToPay,
        ),
        textColor: Colors.white,
        color: Color(0xFF4736B5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(thirtyDp)),
      ),
    );
  }

//proceed to payment

}