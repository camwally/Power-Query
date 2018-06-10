//Ascribes types from one table and applies it to columns with the same name on another table

(tblToAlter as table, tblGet as table) =>
let
    tblGet = Table.Buffer(tblGet)
   ,NameColsFrom = Table.ColumnNames(tblGet) 
   ,NameColsTo = Table.ColumnNames(tblToAlter)
   ,NameCols = List.Intersect({NameColsFrom, NameColsTo})
   ,NameFuncTypes = List.Transform(NameCols, (x) => { x
                                                     ,each {_}{0}
                                                     ,Type.ListItem(Value.Type(Table.Column(tblGet, x))) })
   ,Transform = Table.TransformColumns(tblToAlter, NameFuncTypes)
in
    Transform
