function mdl:api/begin
function mdl:api/title {text: {text: "MODALITH 2.0 • Macro Laboratory", color: "aqua", bold: 1b}}
function mdl:api/body {text: {text: "No static dialog files. This screen was built at runtime: storage → SNBT → macro.", color: "gray"}, width: 310}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/home"}], payload: {}}
function mdl:api/button {label: {text: "Dynamic catalog • 80 items"}, callback:[{type:"function",function:"mdl_demo:demo/catalog"}], payload: {}}
function mdl:api/button {label: {text: "Validated slider / wizard"}, callback:[{type:"function",function:"mdl_demo:demo/wizard"}], payload: {}}
function mdl:api/button {label: {text: "Confirmation flow"}, callback:[{type:"function",function:"mdl_demo:demo/confirm"}], payload: {}}
function mdl:api/button {label: {text: "All input controls"}, callback:[{type:"function",function:"mdl_demo:demo/inputs"}], payload: {}}
function mdl:api/button {label: {text: "Item + live server data"}, callback:[{type:"function",function:"mdl_demo:demo/live"}], payload: {}}
function mdl:api/button {label:{text:"Three fields • atomic form"},callback:[{type:"function",function:"mdl_demo:demo/packed"}],payload:{}}
function mdl:api/button {label:{text:"New in 1.1 • Features"},callback:[{type:"function",function:"mdl_demo:demo/features"}],payload:{}}
function mdl:api/button {label:{text:"New in 1.2 • Live progress"},callback:[{type:"function",function:"mdl_demo:demo/progress"}],payload:{}}
function mdl:api/button {label:{text:"New in 1.3 • Six extensions"},callback:[{type:"function",function:"mdl_demo:demo/extended"}],payload:{}}
function mdl:api/button {label:{text:"2.0 • Typed actions + hooks",color:"aqua"},callback:[{type:"function",function:"mdl_demo:demo/actions"}],payload:{}}
function mdl:api/button {label:{text:"2.1 • Six runtime features",color:"gold"},callback:[{type:"function",function:"mdl_demo:demo/runtime"}],payload:{}}
function mdl:api/exit {label: {text: "Close"}, callback:[{type:"close"}], payload: {}}
function mdl:api/show
