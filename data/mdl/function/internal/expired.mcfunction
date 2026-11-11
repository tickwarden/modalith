scoreboard players add @s mdl.expire 1
scoreboard players add #expired mdl.stat 1
function mdl:internal/lifecycle
data modify storage mdl:event type set value "timeout"
function #mdl:on_timeout
function mdl:api/close
