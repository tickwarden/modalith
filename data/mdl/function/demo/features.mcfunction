function mdl:api/push
function mdl:api/begin
function mdl:api/title {text:{text:"Modalith 1.1 • Five new features",color:"gold"}}
function mdl:api/body {text:{text:"Runtime templates, predicate guards, cooldowns, lifecycle hooks and metrics. The restricted button requires the mdl.demo.allowed tag.",color:"gray"},width:310}
function mdl:api/guarded_button {label:{text:"Predicate-protected action"},callback:"mdl:demo/guarded",payload:{},guard:"mdl:demo_allowed"}
function mdl:api/button {label:{text:"View metrics"},callback:"mdl:demo/stats",payload:{}}
function mdl:api/button {label:{text:"Clone a runtime template"},callback:"mdl:demo/template",payload:{}}
function mdl:api/exit {label:{text:"Back"},callback:"mdl:api/back",payload:{}}
function mdl:api/show
