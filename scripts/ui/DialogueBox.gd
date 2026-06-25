extends Control

@onready var speaker_label: Label = %SpeakerLabel
@onready var body_label: RichTextLabel = %BodyLabel

func show_line(speaker: String, body: String) -> void:
	speaker_label.text = speaker
	body_label.text = body
	show()
