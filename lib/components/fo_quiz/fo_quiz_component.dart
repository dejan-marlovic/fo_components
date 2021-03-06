import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/fo_quiz_model.dart';
import 'fo_question_component.dart';

@Component(
    selector: 'fo-quiz',
    templateUrl: 'fo_quiz_component.html',
    styleUrls: ['fo_quiz_component.css'],
    directives: [FoQuestionComponent, NgFor],
    changeDetection: ChangeDetectionStrategy.OnPush)
class FoQuizComponent implements OnInit, OnDestroy {
  FoQuestionModel activeQuestion;

  final _doneController = StreamController<FoQuizDoneEvent>();

  @Input()
  FoQuizModel model;

  @Input()
  bool disabled = false;

  @Input()
  String buttonColor = '#666';

  @Output('done')
  Stream<FoQuizDoneEvent> get onDone => _doneController.stream;

  @override
  void ngOnDestroy() {
    _doneController.close();
  }

  @override
  void ngOnInit() {
    activeQuestion = model.questions.first;
  }

  void onQuestionDone(FoQuestionModel question) {
    final index = model.questions.indexOf(question);

    if (index == model.questions.length - 1) {
      _doneController
          .add(FoQuizDoneEvent(_calcScore(model), _calcMaxPoints(model)));
    } else {
      activeQuestion = model.questions[index + 1];
    }
  }

  int _calcMaxPoints(FoQuizModel quiz) {
    if (quiz == null) return 0;
    var maxPoints = 0;

    /// Add all options in multi-selects
    for (final question in quiz.questions.where((q) => q.multiSelect == true)) {
      for (final option in question.options) {
        if (option.score > 0) {
          maxPoints += option.score;
        }
        maxPoints += _calcMaxPoints(option.child);
      }
    }

    /// Add only highest score option in single-selects
    for (final question
        in quiz.questions.where((q) => q.multiSelect == false)) {
      final sortedOptions = List<FoOptionModel>.from(question.options)
        ..sort((o1, o2) => o2.score - o1.score);

      final highestScore = sortedOptions.first.score;
      if (highestScore > 0) {
        maxPoints += highestScore;
      }

      for (final option in question.options) {
        maxPoints += _calcMaxPoints(option.child);
      }
    }
    return maxPoints;
  }

  int _calcScore(FoQuizModel quiz) {
    if (quiz == null) return 0;
    var score = 0;
    for (final question in quiz.questions) {
      final selectedOptions =
          question.options.where((option) => option.selected);
      for (final option in selectedOptions) {
        score += option.score;
        score += _calcScore(option.child);
      }
    }
    return score;
  }
}

class FoQuizDoneEvent {
  final int score;

  final int maxPoints;
  FoQuizDoneEvent(this.score, this.maxPoints);
}
