let Func = (Lists as list,TypeToUse as number) =>

let
     TypesOfEachList = Table.Schema(Table.FromColumns(Lists))[TypeName] 
    ,Type = List.Transform(TypesOfEachList, each Expression.Evaluate(_,#shared)){TypeToUse}
    ,tabAppended = Table.FromValue(List.Combine(Lists)) //Combine together and convert to table
    ,listAppend = Table.TransformColumnTypes(tabAppended,{"Value",Type})[Value] //Change table type and convert back to list
in
    listAppend

in

Func

/*To Do: Allow TypeToUse to be type as well, also smarten it up a bit as well, 
maybe use First Function before Table.FromColumns as lists may be quite long */
