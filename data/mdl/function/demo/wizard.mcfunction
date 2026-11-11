function mdl:api/push
function mdl:api/begin
function mdl:api/title {text: {text: "Wizard • step 1 / 2"}}
function mdl:api/body {text: {text: "Choose a digit. No OP required; the server validates the ticket, range and session."}, width: 300}
function mdl:api/input {input: {type: "minecraft:number_range", key: "value", label: "Power", start: 0, end: 9, step: 1, initial: 5, width: 250}}
function mdl:api/form_digit {label: {text: "Continue"}, callback: "mdl:demo/wizard_two", payload: {}, min: 0, max: 9}
function mdl:api/exit {label: {text: "Cancel"}, callback: "mdl:api/back", payload: {}}
function mdl:api/show
