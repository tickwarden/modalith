$execute unless data storage mdl:db players.p$(id).state.$(key) run return 0
data modify storage mdl:state found set value 1b
$data modify storage mdl:state result set from storage mdl:db players.p$(id).state.$(key)
return 1
