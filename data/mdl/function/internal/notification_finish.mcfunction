$data modify storage mdl:notification resume set from storage mdl:db players.p$(id).notify_return
$data modify storage mdl:db players.p$(id).notify_return set value {}
$data modify storage mdl:db players.p$(id).notify_open set value 0b
function mdl:api/close
execute if data storage mdl:notification resume.callback run function mdl:internal/callback with storage mdl:notification resume
