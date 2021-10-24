import 'dart:async';
import 'dart:io';

import 'package:astrologyapp/ChatUtils/fullphoto.dart';
import 'package:astrologyapp/ChatUtils/loading.dart';
import 'package:astrologyapp/ChatUtils/pdfViewer.dart';
import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/actions/actions.dart';
import 'package:astrologyapp/actions/dialog.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:astrologyapp/phoneAuthUtils/getphone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class Chat extends StatelessWidget {
  String peerId;
  String name;
  String image;
  Chat(
      {Key? key, required this.image, required this.peerId, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(
        image: image,
        peerId: peerId,
        name: name,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  String name;
  String image;

  ChatScreen(
      {Key? key, required this.peerId, required this.image, required this.name})
      : super(key: key);

  @override
  State createState() => ChatScreenState(
        peerId: peerId,
      );
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({
    Key? key,
    required this.peerId,
  });

  String peerId;
  String? id;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";
  SharedPreferences? prefs;
  bool isUserAstrologer = false;
  File? imageFile;
  File? fileUpload;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  String amountSelected = "";
  List<String> amountList = [
    "100₹",
    "200₹",
    "300₹",
    "400₹",
    "500₹",
    "600₹",
    "700₹",
    "800₹",
    "900₹",
    "1000₹"
  ];

  User? user;
  int selectedIndex = 0;
  Razorpay? _razorpay;
  List<Astrologer>? astrologersList;
  bool? isOnline;
  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void checkForUserAstrologer() {
    astrologersList = Provider.of<List<Astrologer>>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    for (var i = 0; i < astrologersList!.length; i++) {
      if (astrologersList![i].id == user!.uid) {
        isUserAstrologer = true;
      }
    }
    setState(() {});
  }

  void getData() async {
    var isMatched = false;
    List<Astrologer>? astrologersList2 =
        Provider.of<List<Astrologer>>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    for (var i = 0; i < astrologersList!.length; i++) {
      if (astrologersList2[i].id == peerId) {
        isMatched = true;
      }
    }
    if (isMatched == true) {
      QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection("Astrologer")
          .where("id", isEqualTo: peerId)
          .get();
      isOnline = result.docs[0]['isOnline'];
      print("isOnlien : : $isOnline");
    } else {
      QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection("users")
          .where("id", isEqualTo: peerId)
          .get();
      isOnline = result.docs[0]['isOnline'];
      print("isOnlien : : $isOnline");
    }
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    focusNode.addListener(onFocusChange);
    checkForUserAstrologer();
    getData();
    listScrollController.addListener(_scrollListener);
    readLocal();
    initializeRazorPay();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    print("object");
    prefs = await SharedPreferences.getInstance();
    id = prefs?.getString('id') ?? '';
    print("peerId => $peerId");
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile(false);
      }
    }
  }

  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result != null) {
      fileUpload = File(result.files.single.path!);
      if (fileUpload != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile(true);
      }
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile(bool isFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask =
        isFile ? reference.putFile(fileUpload!) : reference.putFile(imageFile!);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        isFile ? onSendMessage(imageUrl, 5) : onSendMessage(imageUrl, 1);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker, 5 = file
    if (content.trim() != '') {
      textEditingController.clear();
      prefs = await SharedPreferences.getInstance();
      id = prefs?.getString('id') ?? '';
      // var dateTime = DateTime.now().millisecondsSinceEpoch.toString();
      var dateTime = Timestamp.now().toDate().toString();
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(dateTime);
      FirebaseFirestore.instance.collection('messages').doc(groupChatId).set({
        'idFrom': id,
        'nameFrom': user!.displayName,
        'imageFrom': user!.photoURL,
        'idTo': peerId,
        'nameTo': widget.name,
        'imageTo': widget.image,
      });
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': dateTime,
            'content': content,
            'type': type,
            'lockMessage': type == 3 ? true : false,
            'amount': type == 3 ? amountSelected : 0,
            'isPaymentDone': false,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      var datea = DateTime.parse(document.get('timestamp'));
      var date = DateFormat('dd/MM').add_jm().format(datea);

      if (document.get('idFrom') == id) {
        // Right (my message)
        return Row(
          children: <Widget>[
            document.get('type') == 0
                // Text
                ? InkWell(
                    onLongPress: () {
                      _showDialog(
                          "Are you sure you want to delete this message?",
                          document.get('timestamp'));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(
                            document.get('content'),
                            style: TextStyle(color: primaryColor),
                          ),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          width: 200.0,
                          decoration: BoxDecoration(
                              color: greyColor2,
                              borderRadius: BorderRadius.circular(8.0)),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 0.0 : 0.0,
                              right: 10.0),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 15.0, bottom: 10),
                          child: Text(
                            date.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  )
                : document.get('type') == 1
                    // Image
                    ? InkWell(
                        onLongPress: () {
                          _showDialog(
                              "Are you sure you want to delete this Image?",
                              document.get('timestamp'));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: OutlinedButton(
                                child: Material(
                                  child: Image.network(
                                    document.get("content"),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: greyColor2,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                            value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null &&
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return Material(
                                        child: Image.asset(
                                          'assets/noimage.png',
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      );
                                    },
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullPhoto(
                                        url: document.get('content'),
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(0))),
                              ),
                              margin: EdgeInsets.only(
                                  bottom: isLastMessageRight(index) ? 0.0 : 0.0,
                                  right: 10.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0, bottom: 10.0, top: 2.0),
                              child: Text(
                                date.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      )
                    :
                    // File
                    document.get('type') == 5
                        ? InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewerPage(
                                            url: document.get('content'),
                                          )));
                            },
                            onLongPress: () {
                              _showDialog(
                                  "Are you sure you want to delete this File?",
                                  document.get('timestamp'));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  margin: EdgeInsets.only(right: 10.0),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PdfViewerPage(
                                                    url:
                                                        document.get('content'),
                                                  )));
                                    },
                                    label: Text('See File'),
                                    icon: Icon(
                                      Icons.file_present_outlined,
                                      size: 15,
                                    ),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      primary: Colors.white,
                                      backgroundColor: Colors.grey[600],
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, bottom: 10.0, top: 2.0),
                                  child: Text(
                                    date.toString(),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          )
                        // Sticker
                        : document.get('type') == 3
                            ? InkWell(
                                onLongPress: () {
                                  _showDialog(
                                      "Are you sure you want to delete this Sticker?",
                                      document.get('timestamp'));
                                },
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document.get('content'),
                                        style: TextStyle(color: primaryColor),
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child:
                                              Icon(Icons.lock_outline_rounded)),
                                    ],
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  margin: EdgeInsets.only(
                                      bottom: isLastMessageRight(index)
                                          ? 20.0
                                          : 10.0,
                                      right: 10.0),
                                ),
                              )
                            : InkWell(
                                onLongPress: () {
                                  _showDialog(
                                      "Are you sure you want to delete this GIF?",
                                      document.get('timestamp'));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        'assets/images/${document.get('content')}.gif',
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.cover,
                                      ),
                                      margin: EdgeInsets.only(right: 10.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15.0, bottom: 10.0, top: 2.0),
                                      child: Text(
                                        date.toString(),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                          child: widget.image == "no_image"
                              ? Image.asset('assets/images/bro.jpg',
                                  fit: BoxFit.fitWidth)
                              : Image.network(
                                  widget.image,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                        value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null &&
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, object, stackTrace) {
                                    return Icon(
                                      Icons.account_circle,
                                      size: 35,
                                      color: greyColor,
                                    );
                                  },
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover,
                                ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        )
                      : Container(width: 35.0),
                  document.get('type') == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                document.get('content'),
                                style: TextStyle(color: Colors.white),
                              ),
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              width: 200.0,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8.0)),
                              margin: EdgeInsets.only(left: 10.0),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 2.0),
                              child: Text(
                                date.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      : document.get('type') == 1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: TextButton(
                                    child: Material(
                                      child: Image.network(
                                        document.get('content'),
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: greyColor2,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                            width: 200.0,
                                            height: 200.0,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: primaryColor,
                                                value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null &&
                                                        loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, object, stackTrace) =>
                                                Material(
                                          child: Image.asset(
                                            'assets/noimage.pngs',
                                            width: 200.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullPhoto(
                                                  url: document
                                                      .get('content'))));
                                    },
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(EdgeInsets.all(0))),
                                  ),
                                  margin: EdgeInsets.only(left: 10.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 2.0),
                                  child: Text(
                                    date.toString(),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          : document.get('type') == 5
                              ? InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PdfViewerPage(
                                                  url: document.get('content'),
                                                )));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            15.0, 10.0, 15.0, 10.0),
                                        width: 200.0,
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        margin: EdgeInsets.only(left: 10.0),
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PdfViewerPage(
                                                          url: document
                                                              .get('content'),
                                                        )));
                                          },
                                          label: Text('See File'),
                                          icon: Icon(
                                            Icons.file_present_outlined,
                                            size: 15,
                                          ),
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            primary: Colors.white,
                                            backgroundColor:
                                                Colors.blueGrey[700],
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 2.0),
                                        child: Text(
                                          date.toString(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : document.get('type') == 3 &&
                                      document.get('lockMessage') == true &&
                                      document.get('isPaymentDone') == false
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Column(
                                            children: [
                                              Text(
                                                "You can not see this message, For unlock this message pay ${document.get('amount')}!",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              unlockMessageButton(
                                                  amountToPay:
                                                      document.get('amount'),
                                                  email: user!.email,
                                                  astrologerName: widget.name,
                                                  name: user!.displayName,
                                                  phoneNumber:
                                                      user!.phoneNumber,
                                                  descreption: "Descreption"),
                                            ],
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              15.0, 10.0, 15.0, 10.0),
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          margin: EdgeInsets.only(left: 10.0),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 2.0),
                                          child: Text(
                                            date.toString(),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            'assets/images/${document.get('content')}.gif',
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                                          margin: EdgeInsets.only(right: 10.0),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 2.0),
                                          child: Text(
                                            date.toString(),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                ],
              ),

              // Time
              // isLastMessageLeft(index)
              //     ? Container(
              //         child: Text(
              //           DateFormat('dd MMM kk:mm').format(
              //               DateTime.fromMillisecondsSinceEpoch(
              //                   int.parse(document.get('timestamp')))),
              //           style: TextStyle(
              //               color: greyColor,
              //               fontSize: 12.0,
              //               fontStyle: FontStyle.italic),
              //         ),
              //         margin:
              //             EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
              //       )
              //     : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  _showDialog(String content, String timeStamp) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(content: Text(content), actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No")),
            MaterialButton(
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('messages')
                      .doc(groupChatId)
                      .collection(groupChatId)
                      .doc(timeStamp)
                      .delete()
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text("Yes")),
          ]);
        });
  }

  unlockMessageButton(
      {var amountToPay,
      var name,
      var descreption,
      var email,
      var phoneNumber,
      var astrologerName}) {
    return TextButton.icon(
      onPressed: () {
        String amount = amountToPay.toString().replaceAll("₹", "");
        callPaymentMethod(
          amountToPay: int.parse(amount),
          name: name,
          description:
              'Payment made from User ( $name ) to Astrologer  ( $astrologerName ) )',
          email: email,
        );
      },
      label: Text('Unlock Message'),
      icon: Icon(
        Icons.lock_open_outlined,
        size: 15,
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        primary: Colors.white,
        backgroundColor: Colors.blueGrey[700],
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  void callPaymentMethod({
    required int amountToPay,
    required String name,
    required String description,
    required String email,
  }) async {
    Future.delayed(Duration(seconds: 3)).then((value) => {
          launchRazorPay(
            amountToPay,
            name,
            description,
            email,
          )
        });
  }

  void launchRazorPay(
    int amount,
    String name,
    String description,
    String email,
  ) {
    amount = amount * 100;

    var options = {
      'key': rzp_key,
      'amount': "$amount",
      'name': name,
      'description': description,
      'prefill': {'email': email}
    };

    try {
      Razorpay().open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          isOnline == true
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Online",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w500),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Offline",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                )
        ],
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Sticker
                isShowSticker ? buildSticker() : Container(),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildSticker() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi1', 2),
                  child: Image.asset(
                    'assets/images/mimi1.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi2', 2),
                  child: Image.asset(
                    'assets/images/mimi2.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi3', 2),
                  child: Image.asset(
                    'assets/images/mimi3.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi4', 2),
                  child: Image.asset(
                    'assets/images/mimi4.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi5', 2),
                  child: Image.asset(
                    'assets/images/mimi5.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi6', 2),
                  child: Image.asset(
                    'assets/images/mimi6.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi7', 2),
                  child: Image.asset(
                    'assets/images/mimi7.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi8', 2),
                  child: Image.asset(
                    'assets/images/mimi8.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi9', 2),
                  child: Image.asset(
                    'assets/images/mimi9.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
            color: Colors.white),
        padding: EdgeInsets.all(5.0),
        height: 180.0,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.file_upload_outlined),
                onPressed: getFile,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          isUserAstrologer
              ? Material(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.lock_outline_rounded),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: Text("Select Amount"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          onSendMessage(
                                              textEditingController.text, 3);
                                        },
                                        child: Text("Ok")),
                                    TextButton(
                                        onPressed: () {
                                          amountSelected = "";
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"))
                                  ],
                                  content: Container(
                                    height:
                                        300.0, // Change as per your requirement
                                    width:
                                        300.0, // Change as per your requirement
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: amountList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          trailing: selectedIndex == index
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                )
                                              : Container(
                                                  width: 1,
                                                  height: 1,
                                                ),
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              amountSelected =
                                                  amountList[index];
                                            });
                                          },
                                          title: Text(amountList[index]),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              });
                            });
                      },
                      color: primaryColor,
                    ),
                  ),
                  color: Colors.white,
                )
              : Container(),
          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    //check for paymentId
    if (response.paymentId != null) {
      print("PaymentId");
      // await getPaymentInfo('${response.paymentId}');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    ShowAction.showDetails(
        "Payment failed",
        "Error occurred during the payment.Please try again",
        context,
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("OK")));
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage.addAll(snapshot.data!.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data?.docs[index]),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
    );
  }
}
