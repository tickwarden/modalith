execute if data storage mdl:filter options{query:""} run return run data modify storage mdl:filter model.items append from storage mdl:filter queue[0]
$execute if data storage mdl:filter item{tags:["$(query)"]} run data modify storage mdl:filter model.items append from storage mdl:filter queue[0]
