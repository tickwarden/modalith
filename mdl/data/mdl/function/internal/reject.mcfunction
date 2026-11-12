scoreboard players add @s mdl.reject 1
scoreboard players add #rejected mdl.stat 1
function mdl:internal/lifecycle
data modify storage mdl:event type set value "reject"
data modify storage mdl:event reason set from storage mdl:reject reason
function #mdl:on_reject
# Restore the committed screen without extending TTL or issuing a new ticket.
function mdl:internal/context
function mdl:internal/resume with storage mdl:ctx
function mdl:internal/rearm
