data modify storage mdl:favorites result set value {}
data modify storage mdl:favorites found set value 0b
$execute unless data storage mdl:db players.p$(id).favorites[{key:"$(key)"}] run return 0
$data modify storage mdl:favorites result set from storage mdl:db players.p$(id).favorites[{key:"$(key)"}].item
data modify storage mdl:favorites found set value 1b
return 1
