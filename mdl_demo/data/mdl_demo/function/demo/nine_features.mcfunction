function mdl:api/begin
function mdl:api/title {text:{text:"2.5 - Nine UI features",color:"aqua"}}
function mdl:api/view {callback:[{type:"function",function:"mdl_demo:demo/nine_features"}],payload:{}}
function mdl:api/escape {enabled:1}
function mdl:api/pause {enabled:0}
function mdl:api/body_width {width:300}
function mdl:api/body_default {text:{text:"Placeholder"}}
function mdl:api/body_set {index:0,text:{text:"Three widgets, three settings and three draft tools.",color:"gray"},width:300}
function mdl:api/body_default {text:{text:"Temporary body entry"}}
function mdl:api/body_remove {index:1}
function mdl:api/widget/callout {title:{text:"Preview only",bold:1b},description:{text:"These widgets are read-only vanilla text compositions."},level:"info",width:300}
function mdl:api/widget/comparison {title:{text:"Equipment",bold:1b},left:{text:"Current",color:"gray"},right:{text:"Candidate",color:"green"},rows:[{label:{text:"Defense"},left:{text:"8"},right:{text:"12"}},{label:{text:"Speed"},left:{text:"Normal"},right:{text:"Fast"}}],width:300}
function mdl:api/widget/timeline {title:{text:"Quest timeline",bold:1b},events:[{time:{text:"Day 1",color:"gold"},title:{text:"Arrival"},description:{text:"Reached the village."}},{time:{text:"Day 2",color:"gold"},title:{text:"Discovery"},description:{text:"Found the old library."}}],width:300}
function mdl:api/button {label:{text:"Rebuild example"},callback:[{type:"refresh"}],payload:{}}
function mdl:api/button {label:{text:"Home"},callback:[{type:"function",function:"mdl_demo:demo/home"}],payload:{}}
function mdl:api/exit {label:{text:"Close"},callback:[{type:"close"}],payload:{}}
execute store result score #demo_valid mdl.demo run function mdl:api/validate
execute unless score #demo_valid mdl.demo matches 1 run return 0
function mdl:api/show
