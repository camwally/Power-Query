let
    ListOfTables = {Table1, Table2, Table3}
    ,ConcatLists = (func as function) => List.Accumulate(ListOfTables,{},(old, new) => old & func(new))
    ,TableNames = ConcatLists(Table.ColumnNames)
    ,TableData = ConcatLists(Table.ToColumns)
    ,Final = Table.FromColumns(TableData, TableNames)
in
    Final
