// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionfocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionfocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro.'),
                content: Text('Ocorreu um erro ao tentar salvar o produto.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('ok'),
                  ),
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de produto'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: (_formData['title'] ?? '') as String,
                        decoration: InputDecoration(labelText: 'Nome'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        onSaved: (title) => _formData['title'] = title ?? '',
                        validator: (_title) {
                          final title = _title ?? '';

                          if (title.trim().isEmpty) {
                            return 'Nome é obrigatório.';
                          }

                          if (title.trim().length < 3) {
                            return 'Nome precisa conter no mínimo 3 letras.';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price']?.toString(),
                        decoration: InputDecoration(labelText: 'Preço'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocus,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionfocus);
                        },
                        onSaved: (price) =>
                            _formData['price'] = double.parse(price ?? '0'),
                        validator: (_price) {
                          final priceString = _price ?? '-1';
                          final price = double.tryParse(priceString) ?? -1;
                          if (price <= 0) {
                            return 'Informe um preço válido!';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description']?.toString(),
                        decoration: InputDecoration(labelText: 'Descriçao'),
                        focusNode: _descriptionfocus,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_imageUrlFocus);
                        },
                        onSaved: (description) =>
                            _formData['description'] = description ?? '',
                        validator: (_description) {
                          final description = _description ?? '';

                          if (description.trim().isEmpty) {
                            return 'Descricao é obrigatória.';
                          }

                          if (description.trim().length < 10) {
                            return 'Precisa conter no mínimo 10 letras.';
                          }

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'URL da Imagem'),
                              focusNode: _imageUrlFocus,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) => _submitForm(),
                              onSaved: (imageUrl) =>
                                  _formData['imageUrl'] = imageUrl ?? '',
                              validator: (_imageUrl) {
                                final imageUrl = _imageUrl ?? '';
                                if (!isValidImageUrl(imageUrl)) {
                                  return 'Informe uma Url válida!';
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(
                              top: 10,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueGrey, width: 1)),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? Text('Informe a URL')
                                : Image.network(
                                    _imageUrlController.text,
                                    width: 100,
                                    height: 100,
                                  ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
