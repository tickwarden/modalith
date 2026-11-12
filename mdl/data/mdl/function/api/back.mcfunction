function mdl:internal/context
data remove storage mdl:nav target
function mdl:internal/pop with storage mdl:ctx
execute unless data storage mdl:nav target.callback run return run function mdl:api/close
function mdl:internal/callback with storage mdl:nav target
