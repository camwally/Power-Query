(Table as table, GroupOnCols as list) => 
let
    Group = Table.Group(Table, GroupOnCols, {"ColumnOfTables",each Table.AddIndexColumn(_, "ClustIndex", 0, 1)})
   ,Combine = Table.Combine(Group[ColumnOfTables])
in
    Combine
