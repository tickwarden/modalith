data modify storage mdl:widget result.extra append value {text:"\n",extra:[]}
data modify storage mdl:widget result.extra[-1].extra append from storage mdl:widget marker
$data modify storage mdl:widget result.extra[-1].extra append value $(label)
