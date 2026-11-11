$data modify storage mdl:demo items append value {label:{text:"Dynamic item #$(n)"},callback:"mdl:demo/selected",payload:{n:$(n)}}
