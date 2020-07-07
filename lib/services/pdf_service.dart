import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class PDFService {
  Future<File> createFileOfPdfUrl(context, myUrl) async {
    // final record =
    //     "https://firebasestorage.googleapis.com/v0/b/math-app-521e1.appspot.com/o/contents%2Fexam%20papers%2FMathematics%20P1%20Nov%202018%20FINAL%20Memo%20Afr%20%26%20Eng..pdf?alt=media&token=bda4a483-e46d-44c4-98ee-fc674e746757";
    //print(record.url);
    final url = "$myUrl";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');

    await file.writeAsBytes(bytes);
    return file;
  }
}
