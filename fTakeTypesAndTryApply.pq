//Ascribes types from one table and applies it to columns with the same name on another table

(tblToAlter as table, tblGet as table) =>
let
    typetblGet = Value.Type(tblGet)
   ,NameCols = List.Intersect({Table.ColumnNames(tblGet) 
                              ,Table.ColumnNames(tblToAlter)})
   ,NameFuncTypes = List.Transform(NameCols, (x) => { x
                                                     ,each {_}{0}
                                                     ,Type.TableColumn(typetblGet, x) })
   ,Transform = Table.TransformColumns(tblToAlter, NameFuncTypes)
in
    Transform
