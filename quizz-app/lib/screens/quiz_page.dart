import 'package:flutter/material.dart';

import '../models/category.dart';
import 'score_page.dart';

class QuizPage extends StatefulWidget {
  final Category category;

  const QuizPage({super.key, required this.category});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  int correctAnswers = 0;
  bool hasAnswered = false;
  bool? lastAnswerCorrect;

  void _handleAnswer(bool answer) {
    if (hasAnswered) return;

    final question = widget.category.questions[currentIndex];
    final isCorrect = question.answer == answer;

    setState(() {
      hasAnswered = true;
      lastAnswerCorrect = isCorrect;
      if (isCorrect) {
        correctAnswers++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      if (currentIndex == widget.category.questions.length - 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ScorePage(
              categoryName: widget.category.name,
              correct: correctAnswers,
              total: widget.category.questions.length,
            ),
          ),
        );
      } else {
        setState(() {
          currentIndex++;
          hasAnswered = false;
          lastAnswerCorrect = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.category.questions[currentIndex];
    final backgroundColor = lastAnswerCorrect == null
        ? Theme.of(context).scaffoldBackgroundColor
        : lastAnswerCorrect!
            ? Colors.green.shade50
            : Colors.red.shade50;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.category.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image,
                            size: 48,
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          widget.category.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Question ${currentIndex + 1} of ${widget.category.questions.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              flex: 2,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasAnswered && question.answer
                          ? Colors.green
                          : Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => _handleAnswer(true),
                    child: const Text(
                      'True',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasAnswered && !question.answer
                          ? Colors.green
                          : Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => _handleAnswer(false),
                    child: const Text(
                      'False',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
