function mdl:api/state_set {key:"demo",value:{visited:1b,message:"Saved per player, outside event scratch."}}
function mdl:api/state_get {key:"demo"}
tellraw @s [{text:"[Modalith] Your state: ",color:"aqua"},{nbt:"result",storage:"mdl:state"}]
function mdl:demo/extended_render
