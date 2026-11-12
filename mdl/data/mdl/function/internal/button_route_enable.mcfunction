$data modify storage mdl:work routes[{action_index:$(index)}].enabled set value $(enabled)
$execute if data storage mdl:work form{action_index:$(index)} run data modify storage mdl:work form.enabled set value $(enabled)
return 1
