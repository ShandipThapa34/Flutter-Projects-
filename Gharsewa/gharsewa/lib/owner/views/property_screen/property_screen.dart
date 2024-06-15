import 'package:flutter/material.dart';
import 'package:gharsewa/owner/views/property_screen/add_property_screen.dart';
import 'package:gharsewa/owner/views/property_screen/property_details.dart';
import 'package:gharsewa/owner/views/widgets/appbar_widget.dart';
import 'package:gharsewa/owner/views/widgets/text_style.dart';
import 'package:velocity_x/velocity_x.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({super.key});

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  var popupMenuTitles = ["Edit", "Delete"];
  var popupMenuIcons = [Icons.edit, Icons.delete];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProperty(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget("Property"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: List.generate(
              3,
              (index) => Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PropertyDetails(),
                      ),
                    );
                  },
                  leading: Image.asset("assets/images/room4.jpg",
                      width: 100, height: 100, fit: BoxFit.contain),
                  title: boldText(
                      text: "single Room for Student",
                      color: const Color.fromRGBO(73, 73, 73, 1)),
                  subtitle: Row(
                    children: [
                      normalText(text: "Rs. 3000/month", color: Colors.red),
                      10.widthBox,
                    ],
                  ),
                  trailing: VxPopupMenu(
                    menuBuilder: () => Column(
                      children: List.generate(
                        popupMenuTitles.length,
                        (i) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                popupMenuIcons[i],
                                color: const Color.fromRGBO(73, 73, 73, 1),
                              ),
                              5.widthBox,
                              normalText(
                                text: popupMenuTitles[i],
                                color: const Color.fromRGBO(73, 73, 73, 1),
                              )
                            ],
                          ).onTap(
                            () async {
                              switch (i) {
                                case 0:
                                  break;
                                case 1:
                                  VxToast.show(context, msg: "Product removed");

                                  break;
                              }
                            },
                          ),
                        ),
                      ),
                    ).box.white.width(200).rounded.make(),
                    clickType: VxClickType.singleClick,
                    child: const Icon(Icons.more_vert_rounded),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
