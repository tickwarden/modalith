$data modify storage mdl:work dialog.body append value {type:"minecraft:plain_message",contents:$(text),width:$(width)}
execute if data storage mdl:work theme.body run data modify storage mdl:work dialog.body[-1].contents merge from storage mdl:work theme.body
