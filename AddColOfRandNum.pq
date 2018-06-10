//Adds a column of random numbers
(Table as table, RandColName as text) =>
let
    ListTable = Table.ToColumns(Table)
   ,ColNames = Table.ColumnNames(Table)
   ,NumRows = Table.RowCount(Table)
   ,RandList = Value.ReplaceType(List.Random(NumRows),type {number})
   ,Together = Table.FromColumns(ListTable&{RandList},ColNames&{RandColName})    
in
    Together
