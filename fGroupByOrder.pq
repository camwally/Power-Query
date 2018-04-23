/*Orders table by grouping on a column(s). E.g. If 1 column, 
the order of the grouping will match that of List.Distinct of that column.
With List.Distinct, the list is read from top to bottom, each encounter with a 
unique value is kept but any subsequent duplicates are discarded. */ 

let func = (Source as table, GroupBy as list) =>
    let
        #"Grouped Rows" = Table.Group(Source, GroupBy, {{"Tables", each _, type table}})
        ,#"Removed Columns" = Table.RemoveColumns(#"Grouped Rows", GroupBy)
        ,#"Expanded Tables" = Table.ExpandTableColumn(#"Removed Columns", "Tables", Table.ColumnNames(Source)) 
        ,RevertTypes = Value.ReplaceType(#"Expanded Tables", Value.Type(Source))
    in
        RevertTypes
in
    func
