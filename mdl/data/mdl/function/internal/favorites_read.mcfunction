data modify storage mdl:filter queue set value []
$execute if data storage mdl:db players.p$(id).favorites run data modify storage mdl:filter queue set from storage mdl:db players.p$(id).favorites
