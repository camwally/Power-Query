(table as table, columns as list) as table=> 
let
    fnSplitColumn = (table as table, text as text) as table=>
    let
        ColumnNames = {text&"_Date"
                      ,text&"_Time"} // Change this to fit your table naming standards
       ,SplitColumn =  Table.SplitColumn(table, text, each {_,_}, ColumnNames)
       ,ColumnTransType = {{DateTime.Date, type nullable date}
                          ,{DateTime.Time, type nullable time}} 
       ,TransformColumns = Table.TransformColumns(SplitColumn,List.Zip(ColumnNames&List.Zip(ColumnTransType)))
    in
        TransformColumns 
   ,IterateOverColumns = List.Accumulate(table,columns,fnSplitColumn)
in
    IterateOverColumns
