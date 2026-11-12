data modify storage mdl:action invocation set from storage mdl:action action
data modify storage mdl:action invocation.payload set from storage mdl:action payload
return run function mdl:action/function with storage mdl:action invocation
