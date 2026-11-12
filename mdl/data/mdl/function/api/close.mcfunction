# Idempotent: emit on_close only for an active library session.
dialog clear @s
execute unless entity @s[tag=mdl.active] run return run function mdl:internal/invalidate
function mdl:internal/invalidate
function mdl:internal/lifecycle
data modify storage mdl:event type set value "close"
function #mdl:on_close
