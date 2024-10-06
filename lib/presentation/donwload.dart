import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends StatefulWidget {
  static const String routeName = 'download';

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  Future<void> _listFiles() async {
    try {
      Directory? downloadsDirectory;

      if (Platform.isAndroid) {
        downloadsDirectory = Directory(
            "/storage/emulated/0/Download/storage/emulated/0/Download/");
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      if (downloadsDirectory != null && downloadsDirectory.existsSync()) {
        List<FileSystemEntity> fileList = downloadsDirectory.listSync();
        setState(() {
          files = fileList;
        });
      } else {
        print("Downloads directory does not exist.");
      }
    } catch (e) {
      print("Error fetching files: $e");
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Opens the specified file using the default associated app.
  ///
  /// For example, if the file is an MP3, it will open in the default music player.
  /// If the file is an image, it will open in the default image viewer.
  ///
/******  65479768-9dc7-4052-ae77-5d3af3589d79  *******/ Future<void> _openFile(
      String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type == ResultType.done) {
      print('File opened successfully: ${result.message}');
    } else {
      print('Error opening file: ${result.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloaded Files"),
      ),
      body: files.isNotEmpty
          ? ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                FileSystemEntity file = files[index];
                String filePath = file.path;
                String fileName = filePath.split('/').last;

                return ListTile(
                  title: Text(fileName),
                  subtitle: Text(filePath),
                  trailing: Icon(Icons.play_circle_filled),
                  onTap: () {
                    if (fileName.endsWith('.mp3')) {
                      _openFile(filePath); // Open MP3 file
                    } else {
                      print('This is not an MP3 file');
                    }
                  },
                );
              },
            )
          : Center(child: Text("No files found")),
    );
  }
}
