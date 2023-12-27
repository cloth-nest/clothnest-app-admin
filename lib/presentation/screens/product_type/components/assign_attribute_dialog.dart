import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/attribute.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/bloc/assign_attributes_bloc.dart';

class AssignAttributeDialog extends StatefulWidget {
  const AssignAttributeDialog({
    super.key,
  });

  @override
  State<AssignAttributeDialog> createState() => _AssignAttributeDialogState();
}

class _AssignAttributeDialogState extends State<AssignAttributeDialog> {
  bool isActive = false;
  AssignAttributesBloc get _bloc =>
      BlocProvider.of<AssignAttributesBloc>(context);

  List<Attribute> attributes = [];
  List<Attribute> selectedAttributes = [];
  @override
  void initState() {
    super.initState();
    _bloc.add(AssignAttributeInit());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<AssignAttributesBloc, AssignAttributesState>(
      listener: (context, state) {
        if (state is AssignAttributesInitial) {
          attributes = state.attributes;
        }
      },
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        clipBehavior: Clip.hardEdge,
        title: Container(
          width: 400,
          padding: const EdgeInsets.only(
            bottom: 10,
            top: 10,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height * .5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Assign Attribute', style: AppStyles.medium),
                  const SizedBox(height: 20),
                  BlocBuilder<AssignAttributesBloc, AssignAttributesState>(
                      builder: (context, state) {
                    if (state is AssignAttributesLoading) {
                      return LoadingScreen().showLoadingWidget();
                    } else if (state is AssignAttributesInitial) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: attributes[index].selected,
                                    onChanged: (value) {
                                      if (value == true) {
                                        selectedAttributes
                                            .add(attributes[index]);
                                      } else {
                                        selectedAttributes.removeAt(index);
                                      }

                                      setState(() {
                                        isActive =
                                            selectedAttributes.isNotEmpty;
                                        attributes[index] = attributes[index]
                                            .copyWith(selected: value);
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    attributes[index].name,
                                    style: AppStyles.medium,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: attributes.length,
                        ),
                      );
                    }
                    return LoadingScreen().showLoadingWidget();
                  }),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildButton(
                          title: 'Back',
                          callback: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.white,
                          borderColor: AppColors.box.withOpacity(0.5),
                          textColor: AppColors.black,
                        ),
                        const SizedBox(width: 10),
                        _buildButton(
                          title: 'Assign and save',
                          callback: () {
                            if (isActive) {
                              Navigator.of(context).pop(selectedAttributes);
                            }
                          },
                          color: isActive
                              ? Colors.black
                              : AppColors.textGray999.withOpacity(0.3),
                          textColor: isActive ? Colors.white : Colors.black,
                          width: 200,
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

  Widget comboBox(
      List<dynamic> source, Function(dynamic)? callback, dynamic value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.gray,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          isExpanded: true,
          value: value,
          style: AppStyles.medium,
          dropdownColor: Colors.white,
          items: source
              .map(
                (e) => DropdownMenuItem<dynamic>(
                  value: e,
                  child: Text(
                    '${e.name}',
                    style: AppStyles.medium,
                  ),
                ),
              )
              .toList(),
          onChanged: callback,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required VoidCallback callback,
    required Color color,
    Color? borderColor,
    required Color textColor,
    double? width = 100,
  }) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null
              ? Border.all(
                  width: 1,
                  color: borderColor,
                )
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.semibold.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
