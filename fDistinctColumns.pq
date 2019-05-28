(Table as table, optional MaxLength as number)=>
let
    TableType = Value.Type(Table)
   ,ColNames = Table.ColumnNames(Table)
   ,ListOfCols = List.Transform(Table.ToColumns(Table), List.Distinct)
   ,Meta = List.Transform(List.Zip({ListOfCols,ColNames}), each _{0} meta [ColName = _{1}])
   ,SelectList =  List.Buffer(if MaxLength = null then Meta else List.Select(Meta, each List.Count(_)<=MaxLength))
   ,NewColNames = List.Transform(SelectList, each Value.Metadata(_)[ColName])
   ,NewTable = Table.FromColumns(SelectList,NewColNames)
in
    NewTable
