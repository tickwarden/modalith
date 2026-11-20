function mdl:api/begin
function mdl:api/title {text:{text:"2.3 • Composite widgets",color:"aqua"}}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/widgets"}],payload:{}}
function mdl:api/widget/stat_card {title:{text:"Balance",color:"gold"},value:{text:"125 coins",bold:1b},description:{text:"Read-only example; no economy is modified.",color:"gray"},width:300}
function mdl:api/widget/key_value {title:{text:"Player statistics",bold:1b},rows:[{label:{text:"Health"},value:{text:"20 / 20",color:"green"}},{label:{text:"Level"},value:{text:"12",color:"aqua"}}],width:300}
function mdl:api/widget/checklist {title:{text:"Quest objectives",bold:1b},items:[{label:{text:"Find the village"},status:"done"},{label:{text:"Speak to the librarian"},status:"pending"},{label:{text:"Optional timed objective"},status:"failed"}],width:300}
function mdl:api/widget/step_indicator {title:{text:"Checkout",bold:1b},steps:[{label:{text:"Cart"}},{label:{text:"Payment"}},{label:{text:"Receipt"}}],current:2,width:300}
function mdl:api/body {text:{text:"These are composed text bodies, not new native widgets or interactive inputs.",color:"gray"},width:300}
function mdl:api/button {label:{text:"Rebuild example"},callback:[{type:"refresh"}],payload:{}}
function mdl:api/button {label:{text:"Home"},callback:[{type:"function",function:"mdl_demo:demo/home"}],payload:{}}
function mdl:api/exit {label:{text:"Close"},callback:[{type:"close"}],payload:{}}
function mdl:api/show
