import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CrosswordWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(String) onAnswer;
  final Function() onComplete;

  const CrosswordWidget({
    super.key,
    required this.data,
    required this.onAnswer,
    required this.onComplete,
  });

  @override
  State<CrosswordWidget> createState() => _CrosswordWidgetState();
}

class _CrosswordWidgetState extends State<CrosswordWidget> {
  List<List<String>> _grid = [];
  List<CrosswordClue> _clues = [];
  Map<String, String> _answers = {};
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeCrossword();
  }

  void _initializeCrossword() {
    // Criar grid 6x6 para as palavras cruzadas
    _grid = List.generate(6, (i) => List.generate(6, (j) => ''));

    // Definir as palavras e suas posições
    final words = [
      {'word': 'NUMERO', 'row': 0, 'col': 0, 'direction': 'horizontal'},
      {'word': 'SOMA', 'row': 1, 'col': 0, 'direction': 'vertical'},
      {'word': 'TOTAL', 'row': 2, 'col': 1, 'direction': 'horizontal'},
    ];

    // Colocar as palavras no grid
    for (final wordData in words) {
      final word = wordData['word'] as String;
      final row = wordData['row'] as int;
      final col = wordData['col'] as int;
      final direction = wordData['direction'] as String;

      for (int i = 0; i < word.length; i++) {
        if (direction == 'horizontal') {
          _grid[row][col + i] = word[i];
        } else {
          _grid[row + i][col] = word[i];
        }
      }
    }

    // Criar as pistas
    _clues = [
      CrosswordClue(
        number: 1,
        clue: 'Símbolo usado para contar (6 letras)',
        answer: 'NUMERO',
        direction: 'horizontal',
        row: 0,
        col: 0,
      ),
      CrosswordClue(
        number: 2,
        clue: 'Operação de adicionar (4 letras)',
        answer: 'SOMA',
        direction: 'vertical',
        row: 1,
        col: 0,
      ),
      CrosswordClue(
        number: 3,
        clue: 'Resultado de uma operação (5 letras)',
        answer: 'TOTAL',
        direction: 'horizontal',
        row: 2,
        col: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Título
          Text(
            'Palavras Cruzadas Matemáticas',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Grid do crucigrama
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: _buildCrosswordGrid(),
          ),

          const SizedBox(height: 20),

          // Pistas
          Text(
            'Pistas:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 12),

          // Lista de pistas
          _buildCluesList(),

          const SizedBox(height: 20),

          // Botões
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _resetCrossword,
                icon: const Icon(Icons.refresh),
                label: const Text('Reiniciar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _checkAnswers,
                icon: const Icon(Icons.check),
                label: const Text('Verificar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCrosswordGrid() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: _grid.asMap().entries.map((rowEntry) {
          final rowIndex = rowEntry.key;
          final row = rowEntry.value;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.asMap().entries.map((cellEntry) {
              final colIndex = cellEntry.key;
              final cell = cellEntry.value;

              return Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: cell.isEmpty
                      ? Colors.grey.withOpacity(0.3)
                      : AppTheme.primaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: cell.isEmpty
                      ? null
                      : Text(
                          cell,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCluesList() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _clues.length,
        itemBuilder: (context, index) {
          final clue = _clues[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  '${clue.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                clue.clue,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${clue.direction == 'horizontal' ? 'Horizontal' : 'Vertical'} - ${clue.answer.length} letras',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textLight.withOpacity(0.7),
                ),
              ),
              trailing: Icon(
                clue.direction == 'horizontal'
                    ? Icons.arrow_forward
                    : Icons.arrow_downward,
                color: AppTheme.primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }

  void _resetCrossword() {
    setState(() {
      _answers.clear();
      _isCompleted = false;
    });
  }

  void _checkAnswers() {
    // Verificar se todas as palavras estão corretas
    bool allCorrect = true;

    for (final clue in _clues) {
      if (_answers[clue.answer] != clue.answer) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      widget.onAnswer('Parabéns! Todas as palavras estão corretas!');
      widget.onComplete();
    } else {
      widget.onAnswer('Algumas palavras estão incorretas. Tente novamente!');
    }
  }
}

class CrosswordClue {
  final int number;
  final String clue;
  final String answer;
  final String direction;
  final int row;
  final int col;

  CrosswordClue({
    required this.number,
    required this.clue,
    required this.answer,
    required this.direction,
    required this.row,
    required this.col,
  });
}
