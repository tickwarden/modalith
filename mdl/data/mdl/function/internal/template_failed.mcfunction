scoreboard players set #template_ok mdl.tmp 0
# Invalidate the draft owner so a partially rekeyed template cannot be shown.
data modify storage mdl:work owner set value -1
return 0
