import 'package:flutter/material.dart';
import 'package:gharsewa/owner/views/property_screen/components/property_images.dart';
import 'package:gharsewa/owner/views/widgets/text_style.dart';
import 'package:gharsewa/user/views/common_widgets/custom_textfield.dart';
import 'package:gharsewa/constant/colors.dart';
import 'package:gharsewa/constant/const.dart';
import 'package:velocity_x/velocity_x.dart';

class AddProperty extends StatefulWidget {
  const AddProperty({super.key});

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  //text controller
  var pNameController = TextEditingController();
  var pDescController = TextEditingController();
  var pPriceController = TextEditingController();
  var pRoomController = TextEditingController();

  String? propertyType, propertyFor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 244, 243),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: boldText(text: "Add Property", color: Colors.white, size: 16.0),
        actions: [
          TextButton(
            onPressed: () async {},
            child: boldText(text: "Save", size: 16.0, color: Colors.white),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              customTextField(
                title: "Property Name",
                hint: "Room for student",
                isPass: false,
                controller: pNameController,
              ),
              10.heightBox,
              customTextField(
                title: "Property Description",
                hint: "Room for student",
                isPass: false,
                controller: pDescController,
              ),
              10.heightBox,
              customTextField(
                title: "Price Per Month",
                hint: "3000",
                isPass: false,
                controller: pPriceController,
                keyboardType: TextInputType.number,
              ),
              10.heightBox,
              "Property Type"
                  .text
                  .color(Colors.blue)
                  .fontFamily("sans_semibold")
                  .size(16)
                  .make(),
              DropdownButtonFormField<String>(
                iconEnabledColor: Colors.blue,
                value: propertyType,
                validator: (value) {
                  if (value.isEmptyOrNull) {
                    return emptyFieldErrMessage;
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    errorStyle: TextStyle(color: Colors.blue)),
                hint: normalText(text: "Room", color: fontGrey),
                isExpanded: true,
                items: propertiesType
                    .map((propertytype) => DropdownMenuItem<String>(
                          value: propertytype,
                          child: Text(propertytype),
                        ))
                    .toList(),
                onChanged: (value) {
                  propertyType = value;
                },
              )
                  .box
                  .roundedSM
                  .padding(const EdgeInsets.symmetric(horizontal: 4))
                  .color(textfieldGrey)
                  .make(),
              15.heightBox,
              customTextField(
                title: "Number of Rooms",
                hint: "2",
                isPass: false,
                controller: pRoomController,
                keyboardType: TextInputType.number,
              ),
              10.heightBox,
              "Property For"
                  .text
                  .color(Colors.blue)
                  .fontFamily("sans_semibold")
                  .size(16)
                  .make(),
              DropdownButtonFormField<String>(
                iconEnabledColor: Colors.blue,
                value: propertyFor,
                validator: (value) {
                  if (value.isEmptyOrNull) {
                    return emptyFieldErrMessage;
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    errorStyle: TextStyle(color: Colors.blue)),
                hint: normalText(text: "Student", color: fontGrey),
                isExpanded: true,
                items: propertiesFor
                    .map((propertyfor) => DropdownMenuItem<String>(
                          value: propertyfor,
                          child: Text(propertyfor),
                        ))
                    .toList(),
                onChanged: (value) {
                  propertyFor = value;
                },
              )
                  .box
                  .roundedSM
                  .padding(const EdgeInsets.symmetric(horizontal: 4))
                  .color(textfieldGrey)
                  .make(),
              15.heightBox,
              const Divider(),
              boldText(
                text: "Choose Property Images:",
                color: const Color.fromRGBO(73, 73, 73, 1),
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  3,
                  (index) => propertyImages(label: "+").onTap(() {}),
                ),
              ),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
