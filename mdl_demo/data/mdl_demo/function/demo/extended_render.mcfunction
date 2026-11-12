function mdl:api/begin
function mdl:api/theme_register {key:"ocean",theme:{title:{color:"aqua",bold:true},body:{color:"gray"},button:{color:"aqua"},button_width:170,body_width:310,columns:2}}
function mdl:api/theme_apply {key:"ocean"}
function mdl:api/translation_register {locale:"en_us",key:"extended_title",text:{text:"Modalith 1.3 • Runtime extensions"}}
function mdl:api/localized_title {key:"extended_title"}
function mdl:api/themed_body {text:{text:"Theme defaults, locale fallback, player UI state, FIFO notifications, numeric validation and stable rank sorting."}}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/extended_render"}],payload:{}}
function mdl:api/button {label:{text:"Save / read player state"},callback:[{type:"function",function:"mdl_demo:demo/state"}],payload:{}}
function mdl:api/button {label:{text:"Two queued notifications"},callback:[{type:"function",function:"mdl_demo:demo/notifications"}],payload:{}}
function mdl:api/button {label:{text:"Validated numeric form"},callback:[{type:"function",function:"mdl_demo:demo/rules"}],payload:{}}
function mdl:api/button {label:{text:"Sorted priority catalog"},callback:[{type:"function",function:"mdl_demo:demo/sorted"}],payload:{}}
function mdl:api/exit {label:{text:"Back"},callback:[{type:"function",function:"mdl:api/back"}],payload:{}}
function mdl:api/show
