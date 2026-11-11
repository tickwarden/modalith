function mdl:internal/context
function mdl_demo:demo/save_toggle with storage mdl:ctx
function mdl:api/begin
function mdl:api/title {text: {text: "Wizard saved", color: "green"}}
function mdl:api/body {text: {text: "Both steps were saved in player-specific storage. /data get storage mdl:db players"}, width: 300}
function mdl:api/exit {label: {text: "Home"}, callback:[{type:"function",function:"mdl_demo:demo/home"}], payload: {}}
function mdl:api/show
