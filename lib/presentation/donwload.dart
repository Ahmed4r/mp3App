import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appColors.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends StatefulWidget {
  static const String routeName = 'download';

  const DownloadScreen({super.key});

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    _listFiles(); // Load files on initialization
  }

  Future<void> _listFiles() async {
    try {
      Directory downloadsDirectory;

      if (Platform.isAndroid) {
        // Get the download folder for Android
        downloadsDirectory = Directory('/storage/emulated/0/Download/QuranMp3');
        print(downloadsDirectory);
      } else if (Platform.isIOS) {
        // Get the documents folder for iOS
        downloadsDirectory = await getApplicationDocumentsDirectory();
        downloadsDirectory = Directory('${downloadsDirectory.path}/QuranMp3');
      } else {
        return;
      }

      // Check if the directory exists; if not, create it
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(
            recursive: true); // Creates the directory
        print("QuranMp3 directory created.");
      }

      // List files if the directory exists
      List<FileSystemEntity> fileList = downloadsDirectory.listSync();
      setState(() {
        files = fileList; // Update the UI with the list of files
      });
    } catch (e) {
      print("Error fetching files: $e");
    }
  }

  Future<void> _openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type == ResultType.done) {
      print('File opened successfully: ${result.message}');
    } else {
      print('Error opening file: ${result.message}');
    }
  }

  Future<void> _deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        _listFiles(); // Refresh the file list after deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File deleted successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error deleting file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting file: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Appcolors.primaryColor,
        title: Text(
          "Downloaded Files",
          style: TextStyle(color: Colors.white, fontFamily: 'Satoshi'),
        ),
      ),
      body: files.isNotEmpty
          ? ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                FileSystemEntity file = files[index];
                String filePath = file.path;
                String fileName = filePath.split('/').last;

                return ListTile(
                  title: Text(
                    fileName,
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Satoshi'),
                  ),
                  // subtitle: Text(
                  //   filePath,
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        onPressed: () {
                          if (fileName.endsWith('.mp3')) {
                            _openFile(filePath); // Open MP3 file
                          } else {
                            print('This is not an MP3 file');
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30.sp,
                        ),
                        onPressed: () {
                          _deleteFile(filePath); // Delete the file
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "No Downloads",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontFamily: 'Satoshi'),
              ),
            ),
    );
  }
}
