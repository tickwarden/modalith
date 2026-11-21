data modify storage mdl:ui number set from storage mdl:work dialog.columns
execute store result score #validate_columns mdl.tmp run function mdl:internal/ui/integer {min:1,max:8}
