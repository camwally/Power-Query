(LeftTable as table,  LeftKey as list
,RightTable as table, RightKey as list
,ListOfJoins as list) =>
let
     Func = each Table.NestedJoin(LeftTable, LeftKey, RightTable, RightKey,"Right",_) 
    ,ListOfTables = List.Transform(ListOfJoins, Func)
    ,Combine = Table.Combine(ListOfTables)
in
    Combine
