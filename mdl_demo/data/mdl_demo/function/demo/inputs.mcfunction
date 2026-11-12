function mdl:api/push
function mdl:api/begin
function mdl:api/title {text: {text: "All four input controls"}}
function mdl:api/body {text: {text: "Text is a UI-only demo. This library does not claim arbitrary non-OP text capture in vanilla. The selected option uses the numeric channel."}, width: 310}
function mdl:api/input {input: {type: "minecraft:text", key: "note", label: "Text (visual demo)", max_length: 120, multiline: {max_lines: 3}, width: 280}}
function mdl:api/input {input: {type: "minecraft:boolean", key: "toggle", label: "Visual toggle", initial: 1b}}
function mdl:api/input {input: {type: "minecraft:number_range", key: "preview", label: "Visual range", start: 0, end: 100, step: 5, initial: 50}}
function mdl:api/input {input: {type: "minecraft:single_option", key: "value", label: "Option to submit", options: [{id: "0", display: "Warrior", initial: 1b}, {id: "1", display: "Mage"}, {id: "2", display: "Explorer"}]}}
function mdl:api/form_digit {label: {text: "Submit option"}, callback:[{type:"function",function:"mdl_demo:demo/choice"}], payload: {}, min: 0, max: 2}
function mdl:api/exit {label: {text: "Back"}, callback:[{type:"function",function:"mdl:api/back"}], payload: {}}
function mdl:api/show
