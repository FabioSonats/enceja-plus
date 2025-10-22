import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class PDFWebService {
  /// Download direto para web
  static Future<String?> downloadPDF(ByteData bytes, String fileName) async {
    if (!kIsWeb) {
      return null; // Não funciona em mobile
    }
    
    try {
      print('Iniciando download real para web...');
      print('Preparando download: $fileName');

      // Converter ByteData para Uint8List
      final uint8List = bytes.buffer.asUint8List();

      // Criar blob com o PDF
      final blob = html.Blob([uint8List], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Criar elemento de download
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

      // Adicionar ao DOM e clicar
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();

      // Limpar URL após download
      html.Url.revokeObjectUrl(url);

      print('Download iniciado para web: $fileName');
      return 'Download iniciado: $fileName';
    } catch (e) {
      print('Erro ao fazer download para web: $e');
      // Fallback: abrir PDF em nova aba
      return await openPDFInNewTab(bytes, fileName);
    }
  }

  /// Abrir PDF em nova aba como fallback
  static Future<String?> openPDFInNewTab(ByteData bytes, String fileName) async {
    if (!kIsWeb) {
      return null; // Não funciona em mobile
    }
    
    try {
      print('Abrindo PDF em nova aba...');

      final uint8List = bytes.buffer.asUint8List();

      // Criar blob URL
      final blob = html.Blob([uint8List], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Abrir em nova aba
      html.window.open(url, '_blank');

      print('PDF aberto em nova aba: $fileName');
      return 'PDF aberto em nova aba: $fileName';
    } catch (e) {
      print('Erro ao abrir PDF em nova aba: $e');
      return null;
    }
  }
}
