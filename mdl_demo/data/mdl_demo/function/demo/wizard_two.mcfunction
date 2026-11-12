function mdl:internal/context
function mdl_demo:demo/save_digit with storage mdl:ctx
function mdl:api/begin
function mdl:api/title {text: {text: "Wizard • step 2 / 2"}}
function mdl:api/input {input: {type: "minecraft:boolean", key: "value", label: "Enable", initial: 1b, on_true: "1", on_false: "0"}}
function mdl:api/form_digit {label: {text: "Save"}, callback:[{type:"function",function:"mdl_demo:demo/wizard_done"}], payload: {}, min: 0, max: 1}
function mdl:api/exit {label: {text: "Home"}, callback:[{type:"function",function:"mdl_demo:demo/home"}], payload: {}}
function mdl:api/show
