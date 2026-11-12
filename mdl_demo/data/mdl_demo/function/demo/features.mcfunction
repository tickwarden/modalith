function mdl:api/push
function mdl:api/begin
function mdl:api/title {text:{text:"Guards, templates and observers",color:"gold"}}
function mdl:api/body {text:{text:"Runtime templates, predicate guards, cooldowns, lifecycle hooks and metrics. The restricted button requires the mdl.demo.allowed tag.",color:"gray"},width:310}
function mdl:api/guarded_button {label:{text:"Predicate-protected action"},callback:[{type:"function",function:"mdl_demo:demo/guarded"}],payload:{},guard:"mdl_demo:demo_allowed"}
function mdl:api/button {label:{text:"View metrics"},callback:[{type:"function",function:"mdl_demo:demo/stats"}],payload:{}}
function mdl:api/button {label:{text:"Clone a runtime template"},callback:[{type:"function",function:"mdl_demo:demo/template"}],payload:{}}
function mdl:api/exit {label:{text:"Back"},callback:[{type:"function",function:"mdl:api/back"}],payload:{}}
function mdl:api/button {label:{text:"2.0 • Typed chains + native actions"},callback:[{type:"function",function:"mdl_demo:demo/actions"}],payload:{}}
function mdl:api/show
