function mdl:api/begin
$function mdl:api/title {text:$(title)}
$function mdl:api/body {text:$(body),width:$(width)}
function mdl:api/button {label:{text:"Continue"},callback:[{type:"function",function:"mdl:api/notification_next"}],payload:{}}
function mdl:api/notice
data modify storage mdl:work notification set value 1b
function mdl:api/show
