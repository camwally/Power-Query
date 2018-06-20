/*Add column of random numbers between 0 and 1:
  fAddRandomColumn(Source,"Random Numbers")*/
/*Add column of random percentages between 0% and 100%:
  fAddRandomColumn(Source,"Random Numbers", Percentage.Type)*/
/*Retrieve random item from list:
  fAddRandomColumn(Source,"RandItems", {each ListOfItems{Number.RoundDown(_*List.Count(ListOfItems))}, type text})*/

(Table as table, RandColName as text, optional TransformAndTypeCriteria as any) =>
let
    List = List.Buffer( 
            if not (TransformAndTypeCriteria is list) then {TransformAndTypeCriteria} else
            if List.Count(TransformAndTypeCriteria)<=2 then TransformAndTypeCriteria else
            error "Invalid Criteria (Too many items)" ) 
   ,Transform = if    List{0} is null
                   or List{0} is type then null else
                if List{0} is function then List{0} else
                error "Invalid Criteria (Tranform)" 
   ,ListLast = List.Last(List)
   ,Type = if    ListLast is null 
              or ListLast is function then type number else  
           if ListLast is type then ListLast else
           error "Invalid Criteria (Type)" 
   ,ListTable = Table.ToColumns(Table)
   ,ColNames = Table.ColumnNames(Table)
   ,NumRows = Table.RowCount(Table)
   ,ListRand = List.Random(NumRows)
   ,ListRandTrans = if Transform = null then ListRand else List.Transform(ListRand,Transform)
   ,ListRandTransType = Value.ReplaceType(ListRandTrans, type {Type})
   ,Together = Table.FromColumns(ListTable&{ListRandTransType},ColNames&{RandColName})    
in
    Together
