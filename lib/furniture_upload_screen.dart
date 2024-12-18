import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

class FurniturePage extends StatefulWidget {
  @override
  _FurniturePageState createState() => _FurniturePageState();
}

class _FurniturePageState extends State<FurniturePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _shopName = '';
  String _brandName = '';
  String _category = '';
  String _material = '';
  String _description = '';
  String _dimensions = '';
  String _weight = '';
  bool _requiresAssembly = false;
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  User? _user;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;

    // Trigger fade-in animation
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    for (var file in _images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('furniture/images/$fileName');
      await ref.putFile(file);
      String url = await ref.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls;
  }

  Future<void> _uploadItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (_user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No seller is logged in!')),
          );
          return;
        }

        // Upload images
        List<String> imageUrls = await _uploadImages();

        // Save item details to Firestore
        await FirebaseFirestore.instance
            .collection('seller')
            .doc(_user!.uid)
            .collection('Furniture')
            .add({
          'name': _name,
          'category': _category,
          'shopName': _shopName,
          'brandName': _brandName,
          'material': _material,
          'dimensions': _dimensions,
          'weight': _weight,
          'requiresAssembly': _requiresAssembly,
          'description': _description,
          'images': imageUrls,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Furniture item uploaded successfully!')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _images.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload item: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload images.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Furniture Item',
        ),
        backgroundColor: Color(0x3ff4a89f7),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Item Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the item name' : null,
                  onSaved: (value) => _name = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the category' : null,
                  onSaved: (value) => _category = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Shop Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the shop name' : null,
                  onSaved: (value) => _shopName = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Brand Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the brand name' : null,
                  onSaved: (value) => _brandName = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Material'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the material' : null,
                  onSaved: (value) => _material = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Dimensions'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the dimensions' : null,
                  onSaved: (value) => _dimensions = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Weight'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the weight' : null,
                  onSaved: (value) => _weight = value!,
                ),
                // SizedBox(height: 10),
                // CheckboxListTile(
                //   title: Text('Requires Assembly'),
                //   value: _requiresAssembly,
                //   onChanged: (value) {
                //     setState(() {
                //       _requiresAssembly = value!;
                //     });
                //   },
                // ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the description' : null,
                  onSaved: (value) => _description = value!,
                ),
                SizedBox(height: 16),
                Text('Images'),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: Text('Pick Images'),
                ),
                _images.isNotEmpty
                    ? Wrap(
                        spacing: 8.0,
                        children: _images
                            .map((file) => Image.file(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ))
                            .toList(),
                      )
                    : Container(),
                SizedBox(height: 20),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 600),
                  opacity: _isVisible ? 1.0 : 0.0,
                  curve: Curves.easeInOut,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0x3ff08cb0b),
                      minimumSize: Size(600, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _uploadItem,
                    child: Text(
                      'Upload Item',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// VideoPlayerScreen to play the selected video
class VideoPlayerScreen extends StatelessWidget {
  final File videoFile;

  VideoPlayerScreen({required this.videoFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play Video')),
      body: Center(
        child: videoFile.existsSync()
            ? VideoPlayerWidget(videoFile: videoFile)
            : Text('Video file not found!'),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  VideoPlayerWidget({required this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
