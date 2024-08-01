import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../entities/transaction.dart';
import '../generated/l10n.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  File? _image;
  bool isInput = true;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final newTransaction = TransactionEntity(
        id: DateTime.now().toString(),
        title: titleController.text,
        description: descriptionController.text,
        imagePath: _image?.path,
        date: DateTime.now(),
        amount: double.parse(amountController.text),
        isInput: isInput,
      );
      Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).addTransaction)),
      body: Container(
        height: MediaQuery.of(context).size.height,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: S.of(context).title),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterATitle;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: S.of(context).description),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterADescription;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: S.of(context).amount),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterAnAmount;
                      }
                      if (double.tryParse(value) == null) {
                        return S.of(context).pleaseEnterAValidNumber;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _pickImage, child: Text(S.of(context).pickImage)),
                  if (_image != null) Image.file(_image!),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(S.of(context).input),
                          leading: Radio<bool>(
                            value: true,
                            groupValue: isInput,
                            onChanged: (bool? value) {
                              setState(() {
                                isInput = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(S.of(context).expense),
                          leading: Radio<bool>(
                            value: false,
                            groupValue: isInput,
                            onChanged: (bool? value) {
                              setState(() {
                                isInput = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: Text(S.of(context).addTransaction),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
