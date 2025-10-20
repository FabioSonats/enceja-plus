import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/pdf_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.library_books,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Biblioteca Digital',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Acesse materiais de estudo por matéria',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Matérias
            const Text(
              'Matérias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildSubjectCard(
                  'Matemática',
                  '🧮',
                  AppTheme.primaryColor,
                  'PDFs de matemática',
                  () => _showSubjectFiles('Matemática'),
                ),
                _buildSubjectCard(
                  'Português',
                  '📚',
                  AppTheme.secondaryColor,
                  'PDFs de português',
                  () => _showSubjectFiles('Português'),
                ),
                _buildSubjectCard(
                  'História',
                  '🏛️',
                  AppTheme.accentColor,
                  'PDFs de história',
                  () => _showSubjectFiles('História'),
                ),
                _buildSubjectCard(
                  'Ciências',
                  '🔬',
                  AppTheme.infoColor,
                  'PDFs de ciências',
                  () => _showSubjectFiles('Ciências'),
                ),
                _buildSubjectCard(
                  'Geografia',
                  '🌍',
                  AppTheme.xpColor,
                  'PDFs de geografia',
                  () => _showSubjectFiles('Geografia'),
                ),
                _buildSubjectCard(
                  'Todos os PDFs',
                  '📖',
                  AppTheme.levelColor,
                  'Ver todos os materiais',
                  () => _showAllFiles(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    String title,
    String icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubjectFiles(String subject) async {
    final pdfs = await PDFService.getPDFsBySubject(subject);

    if (pdfs.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('PDFs de $subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.folder_open,
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Pasta: assets/library/${subject.toLowerCase()}/',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Adicione seus PDFs nesta pasta para vê-los aqui.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('PDFs de $subject'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pdfs.length,
              itemBuilder: (context, index) {
                final pdf = pdfs[index];
                return _buildPDFCard(pdf);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPDFCard(PDFFile pdf) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(
          Icons.picture_as_pdf,
          color: Colors.red,
          size: 32,
        ),
        title: Text(
          pdf.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLight,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pdf.description,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.storage,
                  size: 12,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  pdf.size,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadPDF(pdf),
              tooltip: 'Baixar PDF',
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () => _openPDF(pdf),
              tooltip: 'Abrir PDF',
            ),
          ],
        ),
      ),
    );
  }

  void _downloadPDF(PDFFile pdf) async {
    try {
      // Mostrar loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Baixando ${pdf.name}...'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );

      // Verificar se o PDF existe
      final exists = await PDFService.pdfExists(pdf.path);
      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF não encontrado: ${pdf.path}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      // Copiar PDF para documentos
      final downloadedPath = await PDFService.copyPDFToDocuments(pdf.path);

      if (downloadedPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${pdf.name} baixado com sucesso!\nSalvo em: $downloadedPath'),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        throw Exception('Falha ao baixar o PDF');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao baixar PDF: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _openPDF(PDFFile pdf) async {
    try {
      // Em produção, isso abriria o PDF em um visualizador
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Abrindo ${pdf.name}...'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );

      // Simular abertura
      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pdf.name} aberto com sucesso!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir PDF: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _showAllFiles() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Todos os PDFs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.library_books,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Estrutura de pastas:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'assets/library/matematica/\nassets/library/portugues/\nassets/library/historia/\nassets/library/ciencias/\nassets/library/geografia/',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
