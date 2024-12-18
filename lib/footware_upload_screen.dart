import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

class FootwearPage extends StatefulWidget {
  @override
  _FootwearPageState createState() =>
      _FootwearPageState();
}

class _FootwearPageState extends State<FootwearPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _brandName = '';
  String _footwearType = '';
  String _description = '';
  String _gender = 'Men';
  List<Map<String, dynamic>> _colors = [];
  final ImagePicker _picker = ImagePicker();

  User? _user;
  bool _isVisible = false;

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

  void _addColor() {
    setState(() {
      _colors.add({
        'color': '',
        'price': 0.0,
        'sizes': [],
        'images': [],
        'videos': [],
      });
    });
  }

  void _addSize(int colorIndex) {
    setState(() {
      _colors[colorIndex]['sizes'].add({'size': '', 'quantity': 0});
    });
  }

  Future<void> _pickImages(int colorIndex) async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _colors[colorIndex]['images'].addAll(
          pickedFiles.map((file) => File(file.path)),
        );
      });
    }
  }

  Future<void> _pickVideos(int colorIndex) async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _colors[colorIndex]['videos'].add(File(pickedFile.path));
      });
    }
  }

  Future<void> _uploadMedia() async {
    for (int i = 0; i < _colors.length; i++) {
      // Upload images for this color
      List<String> imageUrls = [];
      for (var file in _colors[i]['images']) {
        String fileName = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        Reference ref =
        FirebaseStorage.instance.ref().child('footwear/images/$fileName');
        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
      _colors[i]['images'] = imageUrls;

      // Upload videos for this color
      List<String> videoUrls = [];
      for (var file in _colors[i]['videos']) {
        String fileName = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        Reference ref =
        FirebaseStorage.instance.ref().child('footwear/videos/$fileName');
        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        videoUrls.add(url);
      }
      _colors[i]['videos'] = videoUrls;
    }
  }

  Future<void> _uploadItem() async {
    if (_formKey.currentState!.validate() && _colors.isNotEmpty) {
      _formKey.currentState!.save();

      try {
        if (_user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No seller is logged in!')),
          );
          return;
        }

        await _uploadMedia();

        await FirebaseFirestore.instance
            .collection('seller')
            .doc(_user!.uid)
            .collection('Footwear')
            .add({
          'name': _name,
          'type': _footwearType,
          'brandName': _brandName,
          'description': _description,
          'colors': _colors,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Footwear uploaded successfully!')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _colors.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload footwear: $e')),
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
        title: Text(
          'Upload Footwear',
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
                  decoration: InputDecoration(labelText: 'Footwear Name'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the footwear name' : null,
                  onSaved: (value) => _name = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Footwear Type'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the footwear type' : null,
                  onSaved: (value) => _footwearType = value!,
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
                  decoration: InputDecoration(
                      labelText: 'Description', alignLabelWithHint: true),
                  maxLines: 5,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter the description' : null,
                  onSaved: (value) => _description = value!,
                ),
                SizedBox(height: 16),
                Text('Select Gender'),
                SizedBox(height: 10,),
                DropdownButtonFormField<String>(
                  padding: EdgeInsets.all(10),
                  value: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                  items: ['Men', 'Women', 'Unisex']
                      .map((gender) =>
                      DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                  validator: (value) =>
                  value == null ? 'Please select a gender' : null,
                ),
                SizedBox(height: 16),
                Text('Colors and Prices'),
                SizedBox(height: 5),
                ..._colors
                    .asMap()
                    .entries
                    .map((entry) {
                  int colorIndex = entry.key;
                  Map<String, dynamic> color = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Color'),
                        onChanged: (value) =>
                        _colors[colorIndex]['color'] = value,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                        _colors[colorIndex]['price'] =
                            double.tryParse(value) ?? 0.0,
                      ),
                      SizedBox(height: 10),
                      Text('Sizes and Quantities'),
                      SizedBox(height: 5),
                      ...color['sizes']
                          .asMap()
                          .entries
                          .map((sizeEntry) {
                        int sizeIndex = sizeEntry.key;
                        Map<String, dynamic> size = sizeEntry.value;

                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Size'),
                                    onChanged: (value) =>
                                    _colors[colorIndex]
                                    ['sizes'][sizeIndex]['size'] = value,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration:
                                    InputDecoration(labelText: 'Quantity'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) =>
                                    _colors[colorIndex]
                                    ['sizes'][sizeIndex]['quantity'] =
                                        int.tryParse(value) ?? 0,
                                  ),
                                  SizedBox(height: 10)
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () => _addSize(colorIndex),
                        child: Text('Add Size'),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _pickImages(colorIndex),
                            child: Text('Pick Images'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _pickVideos(colorIndex),
                            child: Text('Pick Videos'),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: _addColor,
                  child: Text('Add Color'),
                ),
                SizedBox(height: 20),
                // AnimatedOpacity(
                //   duration: Duration(milliseconds: 600),
                //   opacity: _isVisible ? 1.0 : 0.0,
                //   curve: Curves.easeInOut,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.green,
                //       minimumSize: Size(double.infinity, 50),
                //     ),
                //     onPressed: _uploadItem,
                //     child: Text(
                //       'Upload Footwear',
                //       style: TextStyle(fontSize: 20),
                //     ),
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