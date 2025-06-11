import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '/models/product_model.dart';
import '/providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  final Product? initialProduct;

  const AddProductScreen({super.key, this.initialProduct});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _selectedImage;
  String? _selectedCategory;

  final List<String> _categories = ['Women', 'Men', 'Kids', 'Trending'];

  @override
  void initState() {
    super.initState();
    if (widget.initialProduct != null) {
      _titleController.text = widget.initialProduct!.title;
      _descriptionController.text = widget.initialProduct!.description;
      _priceController.text = widget.initialProduct!.price.toString();
      _selectedCategory = widget.initialProduct!.category;
      // Note: In a real app, you'd need to handle network images differently
      _selectedImage = File(widget.initialProduct!.imageUrl);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      final product = Product(
        id: widget.initialProduct?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        category: _selectedCategory!,
        imageUrl: _selectedImage!.path,
        rating: widget.initialProduct?.rating ?? 0.0,
      );

      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      if (widget.initialProduct == null) {
        productProvider.addProduct(product);
      } else {
        productProvider.updateProduct(product);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.initialProduct == null
              ? 'Product added successfully!'
              : 'Product updated successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop(true); // Return true to indicate success
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please select an image'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    );
    final fieldStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialProduct == null ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _submitForm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              Text('Product Image', style: headlineStyle),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage == null
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Add Product Image', style: TextStyle(color: Colors.grey)),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              TextFormField(
                controller: _titleController,
                style: fieldStyle,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                style: fieldStyle,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                style: fieldStyle,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: 'Rs. ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((category) =>
                    DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (value) =>
                value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Product', style: TextStyle(fontSize: 18)),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}