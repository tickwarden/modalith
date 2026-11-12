$data modify storage mdl:favorites args set value {key:"$(key)"}
function mdl:internal/context
data modify storage mdl:favorites args.id set from storage mdl:ctx id
return run function mdl:internal/favorite_get with storage mdl:favorites args
