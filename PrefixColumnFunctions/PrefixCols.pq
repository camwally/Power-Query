(Table as table, Prefix as text, Cols as list) =>   
let
    ListOfLists = List.Transform(Cols, each {_,Prefix&_})
   ,RenameCols = Table.RenameColumns(Table,ListOfLists)
in
    RenameCols
