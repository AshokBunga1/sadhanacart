import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';


class ElectronicsPage extends StatefulWidget {
  @override
  _ElectronicsPageState createState() =>
      _ElectronicsPageState();
}

class _ElectronicsPageState
    extends State<ElectronicsPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _brand = '';
  String _model = '';
  String _category = '';
  String _specifications = '';
  String _warranty = '';
  final ImagePicker _picker = ImagePicker();
  User? _user;
  bool _isVisible = false;
  List<Map<String, dynamic>> _variations = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;

    // Trigger fade-in after a delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  void _addVariation() {
    setState(() {
      _variations.add({
        'color': '',
        'price': 0.0,
        'stock': 0,
        'images': [],
        'videos': [],
      });
    });
  }

  Future<void> _pickImages(int index) async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _variations[index]['images']
            .addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> _pickVideos(int index) async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _variations[index]['videos'].add(File(pickedFile.path));
      });
    }
  }

  Future<void> _uploadMedia() async {
    for (int i = 0; i < _variations.length; i++) {
      // Upload images
      List<String> imageUrls = [];
      for (var file in _variations[i]['images']) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref =
        FirebaseStorage.instance.ref().child('electronics/images/$fileName');
        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
      _variations[i]['images'] = imageUrls;

      // Upload videos
      List<String> videoUrls = [];
      for (var file in _variations[i]['videos']) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref =
        FirebaseStorage.instance.ref().child('electronics/videos/$fileName');
        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        videoUrls.add(url);
      }
      _variations[i]['videos'] = videoUrls;
    }
  }

  Future<void> _uploadItem() async {
    if (_formKey.currentState!.validate() && _variations.isNotEmpty) {
      _formKey.currentState!.save();

      try {
        // Ensure the user is logged in
        if (_user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No seller is logged in!')),
          );
          return;
        }

        // Upload media
        await _uploadMedia();

        // Save item under the logged-in seller's collection
        await FirebaseFirestore.instance
            .collection('seller')
            .doc(_user!.uid)
            .collection('Electronics')
            .add({
          'name': _name,
          'brand': _brand,
          'model': _model,
          'category': _category,
          'specifications': _specifications,
          'warranty': _warranty,
          'variations': _variations,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item uploaded successfully!')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _variations.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload item: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and upload media.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Electronics Item'),
        backgroundColor: Colors.blueAccent,
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
                  decoration: InputDecoration(labelText: 'Brand'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the brand' : null,
                  onSaved: (value) => _brand = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Model'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the model' : null,
                  onSaved: (value) => _model = value!,
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
                  decoration: InputDecoration(labelText: 'Specifications',alignLabelWithHint: true),
                  maxLines: 5,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter specifications' : null,
                  onSaved: (value) => _specifications = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Warranty'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the warranty' : null,
                  onSaved: (value) => _warranty = value!,
                ),
                SizedBox(height: 16),
                Text('Variations (Color, Price, Stock)'),
                SizedBox(height: 5),
                ..._variations.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> variation = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Color'),
                        onChanged: (value) =>
                        _variations[index]['color'] = value,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                        _variations[index]['price'] =
                            double.tryParse(value) ?? 0.0,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                        _variations[index]['stock'] =
                            int.tryParse(value) ?? 0,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => _pickImages(index),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0x3ffffcb24),
                                  foregroundColor: Colors.black),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/image.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Pick images for ${variation['color']}'),
                                ],
                              )),
                          SizedBox(width: 15),
                          SizedBox(height: 10),
                          // Display the selected images for this color
                          _variations[index]['images'].isNotEmpty
                              ? Wrap(
                            spacing: 8.0,
                            children: _variations[index]['images']
                                .map<Widget>((file) => Image.file(file,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover))
                                .toList(),
                          )
                              : Container(),
                          SizedBox(height: 10),
                          // Display the selected videos for this color
                          _variations[index]['videos'].isNotEmpty
                              ? Wrap(
                            spacing: 8.0,
                            children: _variations[index]['videos']
                                .map<Widget>((file) {
                              return GestureDetector(
                                onTap: () {
                                  // You can add logic to play video here or navigate to a new screen to play the video
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VideoPlayerScreen(
                                              videoFile: file),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.play_arrow,
                                      size: 50, color: Colors.white),
                                ),
                              );
                            }).toList(),
                          )
                              : Container(),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _pickVideos(index),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  0x3ffffcb24,
                                ),
                                foregroundColor: Colors.black),
                            /*style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12)),*/
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/upload.png',
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 8),
                                Text('Pick videos for ${variation['color']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: _addVariation,
                  child: Text('Add Variation'),
                ),
                SizedBox(height: 20),
                // AnimatedOpacity(
                //   duration: Duration(milliseconds: 600),
                //   opacity: _isVisible ? 1.0 : 0.0,
                //   child: ElevatedButton(
                //     onPressed: _uploadItem,
                //     child: Text('Upload Item'),
                //   ),
                // ),
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

//VideoPlayerScreen to play the selected video
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