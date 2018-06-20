/*Add column of random numbers between 0 and 1:
  fAddRandomColumn(Source,"Random Number",0,1)*/
/*Add column of random percentages between 0% and 100%:
  fAddRandomColumn(Source,"Random Percentage",0,1,Percentage.Type)*/
/*Retrieve random item from list:
  fAddRandomColumn(Source,"Random Item",0,List.Count(ListOfItems),{each ListOfItems{Number.RoundDown(_)}, type text})
  (ListOfItems would need to be buffered into memory for it to run quickly, e.g. ListOfItems = List.Buffer(SomeList))*/

(Table as table, RandColName as text, Min as number, Max as number, optional TransformAndTypeCriteria as any) =>
let
    List = List.Buffer( 
            if not (TransformAndTypeCriteria is list) then {TransformAndTypeCriteria} else
            if List.Count(TransformAndTypeCriteria)<=2 then TransformAndTypeCriteria else
            error "Invalid Criteria (Too many items)" ) 
   ,TransformFunc = if    List{0} is null
                       or List{0} is type then null else
                    if List{0} is function then List{0} else
                    error "Invalid Criteria (Tranform)" 
   ,ListLast = List.Last(List)
   ,Type = if    ListLast is null 
              or ListLast is function then type number else  
           if ListLast is type then ListLast else
           error "Invalid Criteria (Type)" 
   ,FirstName = Table.ColumnNames(Table){0}
   ,AddColumn = Table.AddColumn(Table
                               ,RandColName
                               ,each Number.RandomBetween(if Record.Field(_,FirstName)=null then Min else Min,Max)
                               ,Type)
   ,Transform = if TransformFunc = null then AddColumn else
                Table.TransformColumns(AddColumn,{RandColName, TransformFunc})
in
    Transform
