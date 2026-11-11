function mdl:api/push
function mdl:api/begin
function mdl:api/title {text:{text:"Atomic three-field form",color:"aqua"}}
function mdl:api/input {input:{type:"minecraft:number_range",key:"power",label:"Power",start:0,end:9,step:1,initial:5}}
function mdl:api/input {input:{type:"minecraft:boolean",key:"enabled",label:"Enabled",on_true:"1",on_false:"0",initial:1b}}
function mdl:api/input {input:{type:"minecraft:single_option",key:"mode",label:"Mode",options:[{id:"0",display:"Normal",initial:1b},{id:"1",display:"Expert"},{id:"2",display:"Experimental"}]}}
function mdl:api/form_code {label:{text:"Submit three fields atomically"},callback:[{type:"function",function:"mdl_demo:demo/packed_done"}],payload:{},min:0,max:999,digits:3,pattern:"$(power)$(enabled)$(mode)"}
function mdl:api/exit {label:{text:"Back"},callback:[{type:"function",function:"mdl:api/back"}],payload:{}}
function mdl:api/show
