import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt/widgets/dropDown.dart';

class Services{

  static Future<void> showModalSheet({required BuildContext context})async{
     await showModalBottomSheet(
                    backgroundColor: scafoldBackgroundColor,
                      context: context,
                      builder: (c) {
                        return const Padding(
                          padding:  EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: TextWidget(
                                label: "Chosen Model: ",
                                fontSize: 16,
                              )),
                              ModelDropDownWidget()
                            ],
                          ),
                        );
                      });
  }
}
