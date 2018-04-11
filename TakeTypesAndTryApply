//You would normally do something like: Value.ReplaceType(#"Replaced Value", Value.Type(Source))
//But this tries each column out as columns may be missing. 

let ChangeTypes = (tblToAlter as table, tblGet as table) =>

let    
     smallschemaGet = Table.SelectColumns(Table.Schema(tblGet),{"Name","TypeName"})
    ,nameandtypeGet = Table.TransformColumns(smallschemaGet,{{"TypeName", each Expression.Evaluate(_,#shared), type type}})
    ,Convert = List.Accumulate(Table.ToRows(nameandtypeGet)
                              ,tblToAlter
                              ,(old, new) => try Table.TransformColumnTypes(old,new) otherwise old) 
in
    Convert

in ChangeTypes
