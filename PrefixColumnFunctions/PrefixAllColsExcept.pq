(Table as table, Prefix as text, optional IgnoreCols as any) =>   
let
    listIgnoreCols = if IgnoreCols is list then IgnoreCols else
                     if IgnoreCols is text then {IgnoreCols} else
                     if IgnoreCols is null then {} else
                     error "Invalid IgnoreCols Argument"
   ,ColNamesToChange = List.RemoveItems(Table.ColumnNames(Table), listIgnoreCols)
   ,ListOfLists = List.Transform(ColNamesToChange, each {_,Prefix&_})
   ,RenameCols = Table.RenameColumns(Table,ListOfLists)
in
    RenameCols
