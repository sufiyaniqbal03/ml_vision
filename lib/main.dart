import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './Sensitive_contentDetector_func/Profanity_checkfunc.dart';
import './Sensitive_contentDetector_func/Nudity_imagecheck.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sensitive Content Detector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Call the function to detect nudity in the image
      final result = await detectNudityInImage(_image!);
      // Display feedback for whether or not nudity was detected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Nudity detected in image' : 'No nudity detected in image'),
          backgroundColor: result ? Colors.red : Colors.green,
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Enter your text:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _textEditingController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Type your text here...',
                border: OutlineInputBorder(),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                String input = _textEditingController.text.trim();
                bool hasProfanity = profanity_detector(input);
                if (hasProfanity) {
                  // display feedback for profanity found
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                      Text(' Profanity Found in Text'),
                      backgroundColor: Colors.red,

                    ),
                  );
                } else {
                  // display feedback for no profanity found
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                      Text('Profanity Not Found in Text'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Check for profanity'),
            ),

            const SizedBox(height: 20.0),
            Center(
              child: Column(
                children: <Widget>[
                  if (_image != null) ...[
                    Image.file(
                      _image!,
                      height: 150.0,
                      width: 150.0,
                    ),
                    const SizedBox(height: 10.0),
                  ],



                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take a photo'),
                                  onTap: () async{
                                    Navigator.pop(context);
                                    await  _pickImage (ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Choose from gallery'),
                                  onTap: () async {
                                    Navigator.pop(context);
                                   await _pickImage(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Choose an image'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
