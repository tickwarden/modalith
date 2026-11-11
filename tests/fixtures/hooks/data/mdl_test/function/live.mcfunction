function mdl:api/begin
function mdl:api/title {text:{text:"Live test renderer"}}
function mdl:api/view {callback:"mdl_test:live",payload:{}}
function mdl:api/progress {label:{text:"Test progress"},value:42,max:100}
function mdl:api/auto_refresh {ticks:10}
function mdl:api/exit {label:{text:"Close"},callback:"mdl:api/close",payload:{}}
function mdl:api/button {label:{text:"Close"},callback:"mdl:api/close",payload:{}}
function mdl:api/show
