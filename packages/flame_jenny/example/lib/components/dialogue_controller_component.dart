import 'dart:async';
import 'package:flame/components.dart' hide Timer;
import 'package:jenny/jenny.dart';
import 'package:jenny_example/components/dialogue_box.dart';

class DialogueControllerComponent extends Component
    with DialogueView, HasGameReference {
  Completer<void> _forwardCompleter = Completer();
  Completer<int> _choiceCompleter = Completer<int>();
  Completer<void> _closeCompleter = Completer();
  late final DialogueBoxComponent _dialogueBoxComponent =
      DialogueBoxComponent();

  @override
  Future<void> onNodeStart(Node node) async {
    _closeCompleter = Completer();
    _addDialogueBox();
  }

  void _addDialogueBox() {
    game.camera.viewport.add(_dialogueBoxComponent);
  }

  @override
  Future<void> onNodeFinish(Node node) async {
    _dialogueBoxComponent.showCloseButton(_onClose);
    return await _closeCompleter.future;
  }

  void _onClose() {
    if (!_closeCompleter.isCompleted) {
      _closeCompleter.complete();
    }
    List<DialogueBoxComponent> list =
        game.camera.viewport.children.query<DialogueBoxComponent>();
    if (list.isNotEmpty) {
      game.camera.viewport.removeAll(list);
    }
  }

  Future<void> _advance() async {
    return _forwardCompleter.future;
  }

  @override
  FutureOr<bool> onLineStart(DialogueLine line) async {
    _forwardCompleter = Completer();
    _changeTextAndShowNextButton(line);
    await _advance();
    return super.onLineStart(line);
  }

  void _changeTextAndShowNextButton(DialogueLine line) {
    String characterName = line.character?.name ?? '';
    String dialogueLineText = '$characterName: ${line.text}';
    _dialogueBoxComponent.changeText(dialogueLineText, _goNextLine);
  }

  void _goNextLine() {
    if (!_forwardCompleter.isCompleted) {
      _forwardCompleter.complete();
    }
  }

  @override
  FutureOr<int?> onChoiceStart(DialogueChoice choice) async {
    _forwardCompleter = Completer();
    _choiceCompleter = Completer<int>();
    _dialogueBoxComponent.showOptions(
      onChoice: _onChoice,
      option1: choice.options[0],
      option2: choice.options[1],
    );
    await _advance();
    return _choiceCompleter.future;
  }

  void _onChoice(int optionNum) {
    if (!_forwardCompleter.isCompleted) {
      _forwardCompleter.complete();
    }
    if (!_choiceCompleter.isCompleted) {
      _choiceCompleter.complete(optionNum);
    }
  }
}
