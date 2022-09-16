extends HBoxContainer

signal value_chaned(value)

var target_object : Object = null
var target_field : String

func _ready():
    if target_object:
        var init_value = target_object.get(target_field)
        $Caption.text = target_field
        $HSlider.value = init_value
        $Value.text = str(init_value)

func _on_HSlider_value_changed(value):
    $Value.text = str(value)
    target_object.set(target_field, value)
    emit_signal("value_chaned", value)
    
