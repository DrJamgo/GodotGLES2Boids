extends HBoxContainer

func _on_ButtonBoidsSettings_toggled(button_pressed):
    $Sliders.visible = button_pressed
