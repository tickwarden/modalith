$data modify storage mdl:state ctx set value {key:"$(key)",value:$(value)}
function mdl:internal/context
data modify storage mdl:state ctx.id set from storage mdl:ctx id
function mdl:internal/state_set with storage mdl:state ctx
