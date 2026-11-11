$data modify storage mdl:state ctx set value {key:"$(key)"}
data modify storage mdl:state result set value {}
data modify storage mdl:state found set value 0b
function mdl:internal/context
data modify storage mdl:state ctx.id set from storage mdl:ctx id
return run function mdl:internal/state_get with storage mdl:state ctx
