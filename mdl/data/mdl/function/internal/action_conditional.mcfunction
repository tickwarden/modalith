data modify storage mdl:conditional args set from storage mdl:dispatch stack[-1].current
data modify storage mdl:conditional args.payload set from storage mdl:action payload
return run function mdl:api/action_conditional with storage mdl:conditional args
