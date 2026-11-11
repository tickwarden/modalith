function mdl:api/push
function mdl:api/begin
function mdl:api/title {text: {text: "Resolve server data before rendering"}}
execute store result storage mdl:demo live.health int 1 run data get entity @s Health
execute store result storage mdl:demo live.online int 1 run list
function mdl_demo:demo/live_body with storage mdl:demo live
function mdl:api/item {item: {id: "minecraft:diamond", count: 1}, text: {text: "Item body", color: "aqua"}}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/live_refresh"}], payload: {}}
function mdl:api/button {label: {text: "Refresh"}, callback:[{type:"function",function:"mdl:api/refresh"}], payload: {}}
function mdl:api/exit {label: {text: "Back"}, callback:[{type:"function",function:"mdl:api/back"}], payload: {}}
function mdl:api/show
