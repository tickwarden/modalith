$data modify storage mdl:filter model set value {title:$(title),size:$(size),page:$(page),items:[]}
function mdl:internal/context
function mdl:internal/favorites_read with storage mdl:ctx
function mdl:internal/favorites_collect
data modify storage mdl:catalog model set from storage mdl:filter model
return run function mdl:internal/catalog
