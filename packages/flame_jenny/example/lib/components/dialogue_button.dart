import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jenny_example/commons/commons.dart';

class DialogueButton extends SpriteButtonComponent {
  DialogueButton({
    required super.position,
    required String assetPath,
    required String text,
    required super.onPressed,
    super.anchor = Anchor.center,
  }) : super() {
    position = posit;
    _text = text;
    _assetPath = assetPath;
  }

  late String _text;
  late String _assetPath;

  @override
  Future<void> onLoad() async {
    button = await Sprite.load(_assetPath);
    ButtonText buttonText = ButtonText(text: _text);
    add(buttonText);
  }
}

class ButtonText extends TextComponent {
  ButtonText({
    required String text,
  }) : super(
          text: text,
          position: Vector2(48, 16),
          anchor: Anchor.center,
          size: Vector2(88, 28),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: fontSize,
              color: Colors.white70,
            ),
          ),
        );
}
