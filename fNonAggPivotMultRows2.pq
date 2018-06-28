(Source as table
,PivotCol as text
,ValueCol as text)=> 
let
    Source = Table.Buffer(Source) //As source table is referenced 3 times
   ,GroupClustIndex = Table.Group(Source
                                 ,List.RemoveItems(Table.ColumnNames(Source),{ValueCol})
                                 ,{"ColOfTables"
                                  ,each Table.AddIndexColumn(_,"idx")})
   ,CombineTables = Table.Combine(GroupClustIndex[ColOfTables]) 
   ,Pivot = Table.Pivot(CombineTables, List.Distinct(Table.Column(Source,PivotCol)), PivotCol, ValueCol)
   ,RemoveIndex = Table.RemoveColumns(Pivot,{"idx"})
in
    RemoveIndex
