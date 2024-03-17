import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/providers/modelsProvider.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:chat_gpt/widgets/textWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ModelDropDownWidget extends StatefulWidget {
  const ModelDropDownWidget({super.key});

  @override
  State<ModelDropDownWidget> createState() => _ModelDropDownWidgetState();
}

class _ModelDropDownWidgetState extends State<ModelDropDownWidget> {
  String currentModel = "gpt-3.5-turbo-0301";

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.currentModel;
    return
    //  (currentModel.isEmpty)?const SpinKitThreeBounce(
    //         color: Colors.white,
    //         size: 15,
    //       ):
          FutureBuilder(
      future: modelsProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState.name == "waiting") {
          return const FittedBox(
            child:  SpinKitThreeBounce(
              color: Colors.white,
              size: 15,
            ),
          );
        } else if (snapshot.hasError) {
          return TextWidget(label: snapshot.error.toString());
        } else
          if ((snapshot.data == null || snapshot.data!.isEmpty)) {
            return const SizedBox.shrink();
          } else {
            return FittedBox(
                  child: DropdownButton(
                    dropdownColor: scafoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                        snapshot.data!.length,
                        (index) => DropdownMenuItem(
                            value: snapshot.data![index].id,
                            child: TextWidget(
                              label: snapshot.data![index].id,
                              fontSize: 15,
                            ))),
                    value: modelsProvider.currentModel,
                    onChanged: (val) {
                      setState(() {
                        currentModel = val.toString();
                      });
                      modelsProvider.setCurrentModel(val.toString());
                    },
                  ),
                );
          }
      },
    );
  }
}

/***/
