import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final List<dynamic> questions;

  QuizPage({required this.questions}); // Accept the questions data

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int selectedOption = -1;
  bool isAnswered = false;
  int score = 0;

  void nextQuestion() {
    if (selectedOption == -1) return; // Do nothing if no option is selected

    setState(() {
      if (selectedOption == widget.questions[currentQuestionIndex]['correctIndex']) {
        score++; // Increment score if the correct option is selected
      }

      selectedOption = -1;
      isAnswered = false;
      currentQuestionIndex++;
    });
  }

  void finishQuiz() {
    if (selectedOption == -1) return; // Do nothing if no option is selected

    if (selectedOption == widget.questions[currentQuestionIndex]['correctIndex']) {
      score++; // Increment score for the last question if correct
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultPage(score: score, total: widget.questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestionIndex >= widget.questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Complete'),
        ),
        body: Center(
          child: Text('You have completed the quiz!'),
        ),
      );
    }

    var currentQuestion = widget.questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Quiz',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView( // Added to allow scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(
                  currentQuestion['question'],
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 24),
            Column(
              children: List.generate(currentQuestion['answers'].length, (index) {
                bool isCorrect = index == currentQuestion['correctIndex'];
                return GestureDetector(
                  onTap: () {
                    if (!isAnswered) {
                      setState(() {
                        selectedOption = index;
                        isAnswered = true;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isAnswered
                            ? (index == selectedOption
                                ? (isCorrect
                                    ? Colors.green
                                    : Colors.red) // Color for wrong answer
                                : (isCorrect
                                    ? Colors.green
                                    : Colors.grey))
                            : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(currentQuestion['answers'][index]),
                      trailing: isAnswered
                          ? (index == selectedOption
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isCorrect)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red, // Circle color
                                          shape: BoxShape.circle,
                                        ),
                                        // Circle size
                                        child: Icon(
                                          Icons.close, // 'X' icon
                                          color: Colors.white,
                                          size: 20, // Size of the 'X' icon
                                        ),
                                      ),
                                    if (isCorrect)
                                      Icon(Icons.check_circle, color: Colors.green),
                                  ],
                                )
                              : isCorrect
                                  ? Icon(Icons.check_circle, color: Colors.green)
                                  : null)
                          : null,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 60, // Increased height of the button
              child: ElevatedButton(
                onPressed: selectedOption != -1
                    ? (currentQuestionIndex < widget.questions.length - 1
                        ? nextQuestion
                        : finishQuiz)
                    : null, // Disable button if no option is selected
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentQuestionIndex < widget.questions.length - 1
                      ? 'Next'
                      : 'Finish',
                  style: TextStyle(fontSize: 18, color: Colors.white), // White text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class QuizResultPage extends StatelessWidget {
  final int score;
  final int total;

  QuizResultPage({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black, // Match the color with quiz design
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Score',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$score / $total',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    Text(
                      score >= total * 0.7 ? 'Great Job!' : 'Keep Trying!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: score >= total * 0.7 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to home
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close Quiz',
                    style: TextStyle(fontSize: 18, color: Colors.white), // White text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
