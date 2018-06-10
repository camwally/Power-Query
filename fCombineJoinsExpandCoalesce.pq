/* Similar to combine joins, but also: 
1) Preserves the order
2) Expands right hand side table
3) Right key is transferred to left key when left key is null, right key is then deleted */

(LeftTable as table  ,LeftKeys as list
,RightTable as table ,RightKeys as list
,ListOfJoins as list) =>

let
     Func = each Table.NestedJoin(LeftTable, LeftKeys, RightTable, RightKeys,"Right",_) 
    ,ListOfTables = List.Transform(ListOfJoins, Func)
    ,Combine = Table.Combine(ListOfTables)
    ,OldRightColNames = List.Buffer(Table.ColumnNames(RightTable))
    ,NewRightKeys = List.Buffer(List.Transform(RightKeys, each "Right." & _))
    ,NewRightColNames = List.ReplaceMatchingItems(OldRightColNames,List.Zip({RightKeys,NewRightKeys}))    
    //Below: Using Table.Buffer, so that order is preserved on expand
    ,ExpandRight = Table.ExpandTableColumn(Table.Buffer(Combine), "Right", OldRightColNames, NewRightColNames)   
    ,Coalesce = List.Accumulate(List.Zip({LeftKeys,NewRightKeys}),ExpandRight, (Table, Keys) =>
                Table.ReplaceValue(Table, null,each Record.Field(_,Keys{1}),Replacer.ReplaceValue,{Keys{0}}))
    ,RemoveRightKeys = Table.RemoveColumns(Coalesce,NewRightKeys)
    ,OriginalLeftKeyTypes = List.Transform(LeftKeys, each Type.TableColumn(Value.Type(LeftTable),_))
    ,ChangeTypes = Table.TransformColumnTypes(RemoveRightKeys,List.Zip({LeftKeys, OriginalLeftKeyTypes}))     
in
    ChangeTypes


