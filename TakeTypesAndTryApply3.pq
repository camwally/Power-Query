let ChangeTypes = (tblGet as table, tblToAlter as table) =>

let    
    colNames = List.Intersect({Table.ColumnNames(tblGet),Table.ColumnNames(tblToAlter)})
    ,colTypes = List.Transform(colNames,each Type.TableColumn(Value.Type(tblGet),_))
    ,colNamesTypes = List.Zip({colNames,colTypes})
    ,Convert = Table.TransformColumnTypes(tblToAlter,colNamesTypes)
in
    Convert

in
    ChangeTypes
