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
