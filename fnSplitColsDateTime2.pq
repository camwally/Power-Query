(table as table
,ColName as any // Can be as list of column names or a single column name 
,optional ColNameDate as nullable text
,optional ColNameTime as nullable text) as table=> 
let
     ColNameDate = if ColNameDate is null then "Date" else ColNameDate // Change these default values to
    ,ColDateTime = if ColNameTime is null then "Time" else ColNameTime // fit your table naming standards
    ,ColNameIsList = if ColName is list then true else
                     if ColName is text then false else
                     error "ColName needs to be a text value or a list of text values"
   ,ColNames = if ColNameIsList then  ColName 
                                else {ColName} 
   ,fnSplitColumn = (State as table, CurrentColName as text) as table=>
    let
        CurrentColNamesNew = if ColNameIsList then {CurrentColName&"_"&ColNameDate
                                                   ,CurrentColName&"_"&ColNameTime}
                                              else {ColNameDate
                                                   ,ColNameTime}                                      
       ,SplitColumn =  Table.SplitColumn(State, CurrentColName, each {_,_}, CurrentColNamesNew)
       ,ColumnTransType = {{DateTime.Date, type nullable date}
                          ,{DateTime.Time, type nullable time}} 
       ,TransformColumns = Table.TransformColumns(SplitColumn,List.Zip(CurrentColNamesNew&List.Zip(ColumnTransType)))
    in
        TransformColumns 
   ,IterateOverColumns = List.Accumulate(table,ColNames,fnSplitColumn)
in
    IterateOverColumns
