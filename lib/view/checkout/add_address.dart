import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store/view_model/checkout_view_model.dart';

import 'package:store/widgets/custom_text.dart';
import 'package:store/widgets/custom_text_form_field.dart';

class AddAddress extends StatelessWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutViewModel>(
      init: CheckoutViewModel(),
      builder: (value) => Form(
        key: value.formState,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              // Wrap your Column with SingleChildScrollView
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CustomText(
                    text: 'Billing address is the same as delivery address',
                  ),
                  SizedBox(height: 40),
                  CustomTextFormField(
                    onSave: (valuee) {
                      value.street1 = valuee!;
                    },
                    validator: (valuee) {
                      if (valuee!.isEmpty) return "state1 empty";
                    },
                    text: 'Street 1',
                    hint: "hello",
                  ),
                  SizedBox(height: 40),
                  CustomTextFormField(
                    onSave: (valuee) {
                      value.street2 = valuee!;
                    },
                    text: 'Street 2',
                    hint: "hello2",
                  ),
                  SizedBox(height: 40),
                  CustomTextFormField(
                    onSave: (valuee) {
                      value.city = valuee!;
                    },
                    text: 'City',
                    hint: "Casablanca",
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: Get.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: CustomTextFormField(
                              onSave: (valuee) {
                                value.state = valuee!;
                              },
                              text: 'State',
                              hint: "Casablanca",
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: CustomTextFormField(
                              onSave: (valuee) {
                                value.country = valuee!;
                              },
                              text: 'Country',
                              hint: "Morocco",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
