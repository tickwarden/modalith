data modify storage mdl:delay args set from storage mdl:dispatch stack[-1].current
data modify storage mdl:delay args.payload set from storage mdl:action payload
return run function mdl:api/action_delay with storage mdl:delay args
