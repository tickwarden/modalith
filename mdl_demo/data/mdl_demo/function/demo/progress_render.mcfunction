# Pure renderer: no history push and no business side effects.
function mdl:api/begin
function mdl:api/title {text:{text:"Live progress • auto-refresh",color:"aqua",bold:true}}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/progress_render"}],payload:{}}
function mdl:api/body {text:{text:"This is a text-component bar, not a native widget. Refreshes once per second without extending the original session TTL."},width:310}
execute store result score @s mdl.demo run time query gametime
scoreboard players set #demo_period mdl.tmp 200
scoreboard players operation @s mdl.demo %= #demo_period mdl.tmp
data modify storage mdl:demo progress set value {label:{text:"World clock cycle",color:"white"},max:200}
execute store result storage mdl:demo progress.value int 1 run scoreboard players get @s mdl.demo
function mdl:api/progress_style {segments:24,width:310,filled:{text:"|",color:"aqua"},empty:{text:"|",color:"dark_gray"}}
function mdl:api/progress with storage mdl:demo progress
function mdl:api/auto_refresh {ticks:20}
function mdl:api/button {label:{text:"Freeze this screen"},callback:[{type:"function",function:"mdl_demo:demo/progress_freeze"}],payload:{}}
function mdl:api/exit {label:{text:"Back"},callback:[{type:"function",function:"mdl:api/back"}],payload:{}}
function mdl:api/show
