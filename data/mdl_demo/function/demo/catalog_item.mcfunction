$data modify storage mdl:demo items append value {label:{text:"Dynamic item #$(n)"},callback:[{type:"function",function:"mdl_demo:demo/selected"}],payload:{n:$(n)}}
