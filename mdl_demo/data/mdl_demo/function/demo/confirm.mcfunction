function mdl:api/push
function mdl:api/begin
function mdl:api/title {text: {text: "Server-side confirmation", color: "yellow"}}
function mdl:api/body {text: {text: "This demo only sends a message. Recheck permission and balance inside item or economy callbacks."}, width: 310}
function mdl:api/button {label: {text: "Confirm"}, callback:[{type:"function",function:"mdl_demo:demo/confirmed"}], payload: {}}
function mdl:api/button {label: {text: "Cancel"}, callback:[{type:"function",function:"mdl:api/back"}], payload: {}}
function mdl:api/confirmation
function mdl:api/show
