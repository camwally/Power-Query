(table as table
,ColName as any // Can be as list of column names or a single column name 
,optional ColNameDate as nullable text
,optional ColNameTime as nullable text
,optional Delimiter   as nullable text) as table=> 
let
     ColNameDateD = if ColNameDate is null then "Date" else ColNameDate // Default values can be changed to fit  
    ,ColNameTimeD = if ColNameTime is null then "Time" else ColNameTime // your own language or table naming standards
    ,DelimiterD   = if Delimiter   is null then "."    else Delimiter   // (only applicable when ColName is list)
    ,ColNameIsText = if ColName is text then true else
                     if ColName is list then false else
                     error "ColName needs to be a text value or a list of text values" 
    ,fnSplitColumn = (State as table, CurrentColName as text) as table=>
    let
        CurrentColNamesNew = if ColNameIsText then                               {ColNameDateD
                                                                                 ,ColNameTimeD}   
                                              else {CurrentColName & DelimiterD & ColNameDateD  
                                                   ,CurrentColName & DelimiterD & ColNameTimeD}                                                 
       ,SplitColumn =  Table.SplitColumn(State, CurrentColName, each {_,_}, CurrentColNamesNew)
       ,ColumnTransType = {{DateTime.Date, type nullable date}
                          ,{DateTime.Time, type nullable time}} 
       ,TransformColumns = Table.TransformColumns(SplitColumn,List.Zip({CurrentColNamesNew}&List.Zip(ColumnTransType)))
    in
        TransformColumns
in
     List.Accumulate(
           if ColNameIsText then {ColName} 
                            else  ColName 
          ,table
          ,fnSplitColumn)

