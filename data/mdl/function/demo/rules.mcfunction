function mdl:api/push
function mdl:api/begin
function mdl:api/title {text:{text:"Validated numeric input"}}
function mdl:api/body {text:{text:"Only 2, 4 and 8 pass. Other submissions preserve the current session and emit a validation rejection."},width:310}
function mdl:api/input {input:{type:"minecraft:number_range",key:"value",label:"Choose",start:0,end:9,step:1,initial:2}}
function mdl:api/form_digit {label:{text:"Validate"},callback:"mdl:demo/confirmed",payload:{},min:0,max:9}
function mdl:api/form_rules {step:2,offset:0,allowed:[{value:2},{value:4},{value:8}]}
function mdl:api/exit {label:{text:"Back"},callback:"mdl:api/back",payload:{}}
function mdl:api/show
