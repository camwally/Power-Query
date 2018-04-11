//Another way of doing TakeTypesAndTryApply

let ChangeTypes = (tblToAlter as table, tblGet as table) =>

let    
     colnamesAlter = List.Buffer(Table.ColumnNames(tblToAlter)) 
    ,smallschemaGet = Table.SelectColumns(Table.Schema(tblGet),{"Name","TypeName"})
    ,nameandtypeGet = Table.TransformColumns(smallschemaGet,{{"TypeName", each Expression.Evaluate(_,#shared), type type}})
    ,#"Filtered Rows" = Table.SelectRows(nameandtypeGet, each List.Contains(colnamesAlter,_[Name]))
    ,Convert = Table.TransformColumnTypes(tblToAlter,Table.ToRows(#"Filtered Rows"))
in
    Convert

in ChangeTypes
