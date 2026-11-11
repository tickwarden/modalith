function mdl:api/push
function mdl:api/begin
function mdl:api/title {text: {text: "Selection validated by server", color: "green"}}
$function mdl:api/body {text:{text:"Selected item: $(n)"},width:300}
function mdl:api/button {label: {text: "Back to catalog"}, callback: "mdl:api/back", payload: {}}
function mdl:api/exit {label: {text: "Home"}, callback: "mdl:demo/home", payload: {}}
function mdl:api/show
