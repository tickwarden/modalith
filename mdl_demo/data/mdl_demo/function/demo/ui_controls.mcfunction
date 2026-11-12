function mdl:api/begin
function mdl:api/title {text:{text:"2.2 • UI controls",color:"aqua"}}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/ui_controls"}],payload:{}}
function mdl:api/body {text:{text:"This placeholder is removed."},width:300}
function mdl:api/body_clear
function mdl:api/body {text:{text:"Body rebuilt after clear. Three columns; client actions keep this dialog open. Routed callbacks still consume their session."},width:310}
function mdl:api/columns {columns:3}
function mdl:api/after_action {value:"none"}
function mdl:action/copy_to_clipboard {label:{text:"Placeholder"},value:"Modalith 2.2"}
function mdl:api/button_label {label:{text:"Copy project name",color:"gold"}}
function mdl:api/button_tooltip {text:{text:"Copies text; does not invoke a privileged server callback.",color:"gray"}}
function mdl:api/button_width {width:190}
function mdl:api/button {label:{text:"Refresh"},callback:[{type:"refresh"}],payload:{}}
function mdl:api/button_tooltip {text:{text:"Rebuilds this screen with fresh route tickets."}}
function mdl:api/button {label:{text:"Home"},callback:[{type:"function",function:"mdl_demo:demo/home"}],payload:{}}
function mdl:api/exit {label:{text:"Close"},callback:[{type:"close"}],payload:{}}
function mdl:api/show
