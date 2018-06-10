//https://www.dingbatdata.com/non-aggregate-pivot-with-multiple-rows-in-powerquery/

(Source as table
,ColToPivot as text
,ColForValues as text)=> 

let
    PivotColNames = List.Buffer(List.Distinct(Table.Column(Source,ColToPivot))) 
   ,#"Pivoted Column" = Table.Pivot(Source, PivotColNames, ColToPivot, ColForValues, each _)

   ,TableFromRecordOfLists = (rec as record, fieldnames as list) =>
    let
        PartialRecord = Record.SelectFields(rec,fieldnames)
       ,RecordToList = Record.ToList(PartialRecord)
       ,Table = Table.FromColumns(RecordToList,fieldnames)
    in
        Table

   ,#"Added Custom" = Table.AddColumn(#"Pivoted Column", "Values", each TableFromRecordOfLists(_,PivotColNames))
   ,#"Removed Other Columns" = Table.RemoveColumns(#"Added Custom",PivotColNames)
   ,#"Expanded Values" = Table.ExpandTableColumn(#"Removed Other Columns", "Values", PivotColNames)
in
    #"Expanded Values"


