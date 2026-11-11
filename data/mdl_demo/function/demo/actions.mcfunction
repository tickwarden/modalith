function mdl:api/begin
function mdl:api/title {text:{text:"2.0 • Actions",color:"aqua"}}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/actions"}],payload:{}}
function mdl:api/body {text:{text:"Client buttons keep vanilla permissions. Server chains use validated tickets."},width:300}
function mdl:action/open_url {label:{text:"Documentation"},url:"https://github.com/tickwarden/modalith"}
function mdl:action/suggest_command {label:{text:"Suggest /help"},command:"/help"}
function mdl:action/copy_to_clipboard {label:{text:"Copy project name"},value:"Modalith"}
function mdl:action/show_dialog {label:{text:"Inline notice"},dialog:{type:"minecraft:notice",title:{text:"Native nested dialog"},action:{label:{text:"OK"}}}}
function mdl:api/action/run_command {label:{text:"Client /help"},cmd:"/help"}
function mdl:api/button {label:{text:"Two ordered server actions"},callback:[{type:"run_command",cmd:"say Modalith typed chain accepted"},{type:"function",function:"mdl_demo:demo/actions"}],payload:{}}
function mdl:api/exit {label:{text:"Home"},callback:[{type:"function",function:"mdl_demo:demo/home"}],payload:{}}
function mdl:api/show
