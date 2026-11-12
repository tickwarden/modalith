function mdl:api/begin
function mdl:api/title {text:{text:"2.1 • Six runtime features",color:"aqua"}}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/runtime"}],payload:{}}
function mdl:api/body {text:{text:"Delays run once per player. Filters match exact tags. Disabled tickets are rejected server-side."},width:310}
function mdl:api/button {label:{text:"Delay a sound • 20 ticks"},callback:[{type:"delay",ticks:20,callback:[{type:"run_command",cmd:"playsound minecraft:entity.experience_orb.pickup player @s ~ ~ ~ 0.5 1"}]}],payload:{}}
function mdl:api/button {label:{text:"Cancel pending delay"},callback:[{type:"function",function:"mdl:api/action_delay_cancel"},{type:"refresh"}],payload:{}}
function mdl:api/button {label:{text:"Conditional action"},callback:[{type:"conditional",predicate:"mdl_demo:demo_allowed",yes:[{type:"run_command",cmd:"say Predicate allowed"}],no:[{type:"refresh"}]}],payload:{}}
function mdl:api/button {label:{text:"Stop on expected failure"},callback:[{type:"function",function:"mdl_demo:demo/failure",stop_on_failure:1b},{type:"run_command",cmd:"say This must not execute"}],payload:{}}
function mdl:api/button {label:{text:"Disabled server action"},callback:[{type:"run_command",cmd:"say This disabled route must not execute"}],payload:{}}
function mdl:api/button_enabled {enabled:0b}
function mdl:api/button {label:{text:"Filter rare items"},callback:[{type:"function",function:"mdl_demo:demo/filter"}],payload:{}}
function mdl:api/button {label:{text:"Save favorite and view"},callback:[{type:"function",function:"mdl:api/favorite_set",payload:{key:"demo_rare",item:{label:{text:"Favorite rare item"},callback:[{type:"close"}],payload:{},tags:["rare"]}}},{type:"function",function:"mdl:api/catalog_favorites",payload:{title:{text:"Your favorites"},size:8,page:0}}],payload:{}}
function mdl:api/button {label:{text:"Home"},callback:[{type:"function",function:"mdl_demo:demo/home"}],payload:{}}
function mdl:api/exit {label:{text:"Close"},callback:[{type:"close"}],payload:{}}
function mdl:api/show
