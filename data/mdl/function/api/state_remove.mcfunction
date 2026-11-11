$data modify storage mdl:state ctx set value {key:"$(key)"}
function mdl:internal/context
data modify storage mdl:state ctx.id set from storage mdl:ctx id
function mdl:internal/state_remove with storage mdl:state ctx
