import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PDFService {
  static const String _libraryPath = 'assets/library';

  /// Lista todos os PDFs de uma matéria específica
  static Future<List<PDFFile>> getPDFsBySubject(String subject) async {
    final List<PDFFile> pdfs = [];

    try {
      // Para desenvolvimento, vamos simular os PDFs baseado na estrutura
      final subjectPath = '$_libraryPath/${subject.toLowerCase()}';

      // Lista de PDFs conhecidos (em produção, isso viria de um scan real)
      final knownPDFs = {
        'matematica': [
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
        'portugues': [],
        'historia': [],
        'ciencias': [],
        'geografia': [],
      };

      final subjectPDFs = knownPDFs[subject.toLowerCase()] ?? <PDFFile>[];
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
      final bytes = await rootBundle.load(assetPath);
      final documentsDir = await getApplicationDocumentsDirectory();
      final fileName = assetPath.split('/').last;
      final file = File('${documentsDir.path}/$fileName');

      await file.writeAsBytes(bytes.buffer.asUint8List());
      return file.path;
    } catch (e) {
      print('Erro ao copiar PDF: $e');
      return null;
    }
  }

  /// Verifica se um PDF existe
  static Future<bool> pdfExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
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
