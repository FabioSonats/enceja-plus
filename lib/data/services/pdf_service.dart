import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_web_service.dart';

class PDFService {
  static const String _libraryPath = 'library';

  /// Lista todos os PDFs de uma matéria específica
  static Future<List<PDFFile>> getPDFsBySubject(String subject) async {
    final List<PDFFile> pdfs = [];

    try {
      // Para desenvolvimento, vamos simular os PDFs baseado na estrutura
      // Mapear nomes com acento para pastas sem acento
      final subjectFolderMap = {
        'matemática': 'matematica',
        'português': 'portugues',
        'história': 'historia',
        'ciências': 'ciencias',
        'geografia': 'geografia',
      };

      final folderName =
          subjectFolderMap[subject.toLowerCase()] ?? subject.toLowerCase();
      final subjectPath = '$_libraryPath/$folderName';
      print('Buscando PDFs em: $subjectPath');

      // Lista de PDFs conhecidos (em produção, isso viria de um scan real)
      final knownPDFs = {
        'matemática': [
          PDFFile(
            name: 'Matemática - Livro do Estudante',
            fileName: 'matematica-livro-estudante-ensino-fundamental.pdf',
            subject: 'Matemática',
            size: '2.5 MB',
            description: 'Livro completo de matemática para ensino fundamental',
            path:
                '$subjectPath/matematica-livro-estudante-ensino-fundamental.pdf',
          ),
        ],
        'português': [],
        'história': [],
        'ciências': [],
        'geografia': [],
      };

      final subjectKey = subject.toLowerCase();
      print('Chave da matéria: $subjectKey');
      final subjectPDFs = knownPDFs[subjectKey] ?? <PDFFile>[];
      print('PDFs encontrados para $subject: ${subjectPDFs.length}');
      pdfs.addAll(subjectPDFs.cast<PDFFile>());
    } catch (e) {
      print('Erro ao carregar PDFs: $e');
    }

    return pdfs;
  }

  /// Lista todos os PDFs de todas as matérias
  static Future<List<PDFFile>> getAllPDFs() async {
    final List<PDFFile> allPDFs = [];

    final subjects = [
      'matematica',
      'portugues',
      'historia',
      'ciencias',
      'geografia'
    ];

    for (final subject in subjects) {
      final pdfs = await getPDFsBySubject(subject);
      allPDFs.addAll(pdfs);
    }

    return allPDFs;
  }

  /// Copia um PDF do assets para o diretório de documentos
  static Future<String?> copyPDFToDocuments(String assetPath) async {
    try {
      print('Tentando carregar PDF: $assetPath');

      // Verificar se o arquivo existe
      final exists = await pdfExists(assetPath);
      if (!exists) {
        print('PDF não encontrado: $assetPath');
        return null;
      }

      final bytes = await rootBundle.load(assetPath);
      print('PDF carregado com sucesso, tamanho: ${bytes.lengthInBytes} bytes');

      // Verificar se está rodando no web
      if (kIsWeb) {
        print('Executando no web - usando download direto');
        return await _downloadPDFForWeb(bytes, assetPath);
      } else {
        print('Executando em dispositivo móvel - salvando em documentos');
        return await _savePDFToDevice(bytes, assetPath);
      }
    } catch (e) {
      print('Erro ao copiar PDF: $e');
      return null;
    }
  }

  /// Salva PDF em dispositivo móvel
  static Future<String?> _savePDFToDevice(
      ByteData bytes, String assetPath) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final fileName = assetPath.split('/').last;
      final file = File('${documentsDir.path}/$fileName');

      print('Salvando PDF em: ${file.path}');
      await file.writeAsBytes(bytes.buffer.asUint8List());

      print('PDF salvo com sucesso!');
      return file.path;
    } catch (e) {
      print('Erro ao salvar PDF no dispositivo: $e');
      return null;
    }
  }

  /// Download direto para web
  static Future<String?> _downloadPDFForWeb(
      ByteData bytes, String assetPath) async {
    final fileName = assetPath.split('/').last;
    return await PDFWebService.downloadPDF(bytes, fileName);
  }

  /// Abrir PDF em nova aba como fallback
  static Future<String?> _openPDFInNewTab(
      ByteData bytes, String assetPath) async {
    final fileName = assetPath.split('/').last;
    return await PDFWebService.openPDFInNewTab(bytes, fileName);
  }

  /// Verifica se um PDF existe
  static Future<bool> pdfExists(String assetPath) async {
    try {
      print('Verificando se PDF existe: $assetPath');
      await rootBundle.load(assetPath);
      print('PDF existe: $assetPath');
      return true;
    } catch (e) {
      print('PDF não existe: $assetPath - Erro: $e');
      return false;
    }
  }
}

/// Classe para representar um arquivo PDF
class PDFFile {
  final String name;
  final String fileName;
  final String subject;
  final String size;
  final String description;
  final String path;
  final bool isDownloaded;
  final DateTime? downloadedAt;

  const PDFFile({
    required this.name,
    required this.fileName,
    required this.subject,
    required this.size,
    required this.description,
    required this.path,
    this.isDownloaded = false,
    this.downloadedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fileName': fileName,
      'subject': subject,
      'size': size,
      'description': description,
      'path': path,
      'isDownloaded': isDownloaded,
      'downloadedAt': downloadedAt?.toIso8601String(),
    };
  }

  factory PDFFile.fromJson(Map<String, dynamic> json) {
    return PDFFile(
      name: json['name'],
      fileName: json['fileName'],
      subject: json['subject'],
      size: json['size'],
      description: json['description'],
      path: json['path'],
      isDownloaded: json['isDownloaded'] ?? false,
      downloadedAt: json['downloadedAt'] != null
          ? DateTime.parse(json['downloadedAt'])
          : null,
    );
  }
}
