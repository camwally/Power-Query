/*It's a bit like Table.Sort, but:
1) Sorts are stable
2) If you neglect to put a Order.Ascending or a Order.Descending then ordered by first occurrence */
    
(Table as table, List as list) =>
let
     fMakeEfficientList = (List as list) =>
     let 
         ColName = List.Transform(List, each _{0})
        ,Order = List.Transform(List, each _{1}?)
        ,TableForm = Table.FromColumns({ColName,Order},{"ColName","Order"})
        ,Comparer = (a as record, b as record) => Number.From(a[Order] is null or b[Order] is null) 
        ,PartionedTable = Table.Group(TableForm, {"Order"}, {{"NestedLists", each Table.ToRows(_), type list}},GroupKind.Local, Comparer)
        ,PartionedList = PartionedTable[NestedLists]
     in
         PartionedList

   ,fReorder = (Table as table, List as list) =>
    let
         ListItem = List.Buffer(List{0}) 
        ,ListItemColNames = List.Buffer(List.Zip(ListItem){0})
        ,GroupedTable = Table.Group(Table, ListItemColNames, {{"NestedTables", each Table.RemoveColumns(_,ListItemColNames), type table}})
        ,SortedTable = if ListItem{0}{1} = null then GroupedTable else Table.Sort(GroupedTable,ListItem)
        ,fRecursion = each if List.Count(List) > 1 then @fReorder(_, List.Skip(List)) else _
        ,RecurseOnNestedTables = Table.Buffer(Table.TransformColumns(SortedTable, {"NestedTables", fRecursion}))
        ,Expand = Table.ExpandTableColumn(RecurseOnNestedTables, "NestedTables", Table.ColumnNames(RecurseOnNestedTables[NestedTables]{0}))
    in
       Expand
    
   ,EfficientList = List.Buffer(fMakeEfficientList(List))
   ,ReorderRows = fReorder(Table,EfficientList)
   ,ReclaimColOrder = Table.ReorderColumns(ReorderRows,Table.ColumnNames(Table))
   ,ReclaimColTypes = Value.ReplaceType(ReclaimColOrder,Value.Type(Table))

in
    ReclaimColTypes
