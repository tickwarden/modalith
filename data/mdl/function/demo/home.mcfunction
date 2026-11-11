function mdl:api/begin
function mdl:api/title {text: {text: "MODALITH • Macro Laboratory", color: "aqua", bold: 1b}}
function mdl:api/body {text: {text: "No static dialog files. This screen was built at runtime: storage → SNBT → macro.", color: "gray"}, width: 310}
function mdl:api/view {callback: "mdl:demo/home", payload: {}}
function mdl:api/button {label: {text: "Dynamic catalog • 80 items"}, callback: "mdl:demo/catalog", payload: {}}
function mdl:api/button {label: {text: "Validated slider / wizard"}, callback: "mdl:demo/wizard", payload: {}}
function mdl:api/button {label: {text: "Confirmation flow"}, callback: "mdl:demo/confirm", payload: {}}
function mdl:api/button {label: {text: "All input controls"}, callback: "mdl:demo/inputs", payload: {}}
function mdl:api/button {label: {text: "Item + live server data"}, callback: "mdl:demo/live", payload: {}}
function mdl:api/button {label:{text:"Three fields • atomic form"},callback:"mdl:demo/packed",payload:{}}
function mdl:api/button {label:{text:"New in 1.1 • Features"},callback:"mdl:demo/features",payload:{}}
function mdl:api/button {label:{text:"New in 1.2 • Live progress"},callback:"mdl:demo/progress",payload:{}}
function mdl:api/button {label:{text:"New in 1.3 • Six extensions"},callback:"mdl:demo/extended",payload:{}}
function mdl:api/exit {label: {text: "Close"}, callback: "mdl:api/close", payload: {}}
function mdl:api/show
