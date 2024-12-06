import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

class UploadClothingItemsScreen extends StatefulWidget {
  @override
  _UploadClothingItemsScreenState createState() =>
      _UploadClothingItemsScreenState();
}

class _UploadClothingItemsScreenState extends State<UploadClothingItemsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _shopName = '';
  String _brandName = '';
  String _category = '';
  String _description = '';
  List<Map<String, dynamic>> _colors = [];
  final ImagePicker _picker = ImagePicker();

  User? _user;
  bool _isVisible = false;


  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser; // Get the current user

    // Trigger fade-in after a delay
    Future.delayed(Duration(milliseconds: 500),(){
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
        'images': [], // List to hold images specific to this color
        'videos': [], // List to hold videos specific to this color
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
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref =
            FirebaseStorage.instance.ref().child('items/images/$fileName');
        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
      _colors[i]['images'] = imageUrls;

      // Upload videos for this color
      List<String> videoUrls = [];
      for (var file in _colors[i]['videos']) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref =
            FirebaseStorage.instance.ref().child('items/videos/$fileName');
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
        // Ensure the user is logged in
        if (_user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No seller is logged in!')),
          );
          return;
        }

        // Upload media (both images and videos) for each color
        await _uploadMedia();

        // Save item under the logged-in seller's collection
        await FirebaseFirestore.instance
            .collection('seller')
            .doc(_user!.uid) // Using the seller's UID as document ID
            .collection(
                'Clothings') // Creating a 'Clothings' subcollection for the seller
            .add({
          'name': _name,
          'category': _category,
          'shop Name': _shopName,
          'Brand Name': _brandName,
          'description': _description,
          'colors': _colors,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item uploaded successfully!')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _colors.clear();
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
      appBar: AppBar(title: Text('Upload Item',style: TextStyle(color: Colors.white),),backgroundColor: Color(0x3ff4a89f7),),
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
                      value!.isEmpty ? 'Please enter the Shop Name' : null,
                  onSaved: (value) => _shopName = value!,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Brand Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the Brand Name' : null,
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
                Text('Colors and Prices'),
                SizedBox(height: 5),
                ..._colors.asMap().entries.map((entry) {
                  int colorIndex = entry.key;
                  Map<String, dynamic> color = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Color',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _colors.removeAt(colorIndex);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete_sweep,
                                        color: Colors.redAccent,
                                      ))),
                              onChanged: (value) =>
                                  _colors[colorIndex]['color'] = value,
                            ),
                          ),
                          /*IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _colors.removeAt(colorIndex);
                              });
                            },
                          ),*/
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _colors[colorIndex]['price'] =
                            double.tryParse(value) ?? 0.0,
                      ),
                      SizedBox(height: 5),
                      Text('Sizes and Quantities'),
                      SizedBox(height: 5),
                      ...color['sizes'].asMap().entries.map((sizeEntry) {
                        int sizeIndex = sizeEntry.key;
                        Map<String, dynamic> size = sizeEntry.value;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'Size'),
                                    onChanged: (value) => _colors[colorIndex]
                                        ['sizes'][sizeIndex]['size'] = value,
                                  ),
                                  SizedBox(height: 7),
                                  // Vertical spacing within the column
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            // Horizontal spacing between the two Expanded widgets
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'Quantity'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) => _colors[colorIndex]
                                            ['sizes'][sizeIndex]['quantity'] =
                                        int.tryParse(value) ?? 0,
                                  ),
                                  SizedBox(height: 5),
                                  // Vertical spacing within the column (optional)
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _addSize(colorIndex),
                            child: Text('Add Size'),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 16),

                      /*IconButton(onPressed: (){}, icon: Icon(Icons.upload_rounded)),
                      ElevatedButton(
                        onPressed: () => _pickImages(colorIndex),
                        child: Text('Pick Images for ${color['color']}'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImages(colorIndex),
                        icon: Icon(Icons.file_upload),
                        // The icon you want to display
                        label: Text('Pick Images for ${color['color']}'),
                        // The label text
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12), // Adjust padding
                        ),
                      ),*/
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => _pickImages(colorIndex),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0x3ffffcb24),
                                  foregroundColor: Colors.black),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/image.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Pick images for ${color['color']}'),
                                ],
                              )),
                          SizedBox(width: 15),
                          SizedBox(height: 10),
                          // Display the selected images for this color
                          _colors[colorIndex]['images'].isNotEmpty
                              ? Wrap(
                                  spacing: 8.0,
                                  children: _colors[colorIndex]['images']
                                      .map<Widget>((file) => Image.file(file,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover))
                                      .toList(),
                                )
                              : Container(),
                          SizedBox(height: 10),
                          // Display the selected videos for this color
                          _colors[colorIndex]['videos'].isNotEmpty
                              ? Wrap(
                                  spacing: 8.0,
                                  children: _colors[colorIndex]['videos']
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
                            onPressed: () => _pickVideos(colorIndex),
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
                                  'assets/upload.png',
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(height: 8),
                                Text('Pick videos for ${color['color']}'),
                              ],
                            ),
                          ),
                        ],
                      ),

                      /*ElevatedButton.icon(
                        onPressed: () => _pickVideos(colorIndex),
                        icon: Icon(Icons.video_camera_back),
                        label: Text('Pick videos for ${color['color']}'),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12)),
                      ),
                      ElevatedButton(
                        onPressed: () => _pickVideos(colorIndex),
                        child: Text('Pick Videos for ${color['color']}'),
                      ),*/

                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: _addColor,
                  child: Text('Add Color'),
                ),
                SizedBox(height: 20),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 600),
                  opacity: _isVisible? 1.0 : 0.0,
                  curve: Curves.easeInOut,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0x3ff08cb0b),
                        minimumSize: Size(600, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: _uploadItem,
                    child: Text('Upload Item',style: TextStyle(fontSize: 16),),
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
