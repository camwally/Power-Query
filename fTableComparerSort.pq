//https://www.dingbatdata.com/2018/06/07/multilevel-sorting-comparers/
//https://www.dingbatdata.com/2018/05/31/documentationsortcomparer/
//Works like a Table.Sort, but also allows sorting using a comparer at the column level. 
//One use of this is for culture sensitive sorting. 

(Table as table
,comparisonCriteria as any 
,optional defaultcomparisonCriteria as any) =>
let
    fMakeSureIsList = each if _ is list then _ else {_}

   ,Default =
    let
        List = fMakeSureIsList(defaultcomparisonCriteria)
       ,Sort = if List{0} is number then List{0} else 
               if (List{0} is null or List{0} is function) then Order.Ascending 
               else error "invalid defaultcomparisonCriteria"     
       ,Comparer = if List{0} is function then List{0} else 
                   if List{1}? is function then List{1} else 
                   if List{1}? is null then Value.Compare else 
                   error "invalid defaultcomparisonCriteria"
       ,Record = [Sort = Sort, Comparer = Comparer]
    in
        Record

   ,compCritListRecords = 
    let
        FirstCheck = if Value.Type(comparisonCriteria{0}?) = type text 
                     and Value.Type(comparisonCriteria{1}?) = type number 
                     then {comparisonCriteria} else comparisonCriteria 
       ,List =  fMakeSureIsList(FirstCheck)
       ,ListList = List.Transform(List, fMakeSureIsList)
       ,fSort = (Order) => if Order = Order.Ascending then 1 else 
                           if Order = Order.Descending then -1 else 
                           error "Order must be Order.Ascending or Order.Descending"
       ,ListRec =  List.Transform(ListList
                  ,each let ColNam = _{0} as text
                           ,Order = _{1}? as nullable number
                           ,Comp = _{2}? as nullable function
                         in [ColNam = ColNam
                            ,Order = fSort(if Order = null then Default[Sort] else Order)
                            ,Comp = if Comp = null then Default[Comparer] else Comp ]) 
    in
        List.Buffer(ListRec as list)
    
    ,fComparer = (x as record, y as record) =>
     let 
         fFullCompare = (x,y, compCrit) => 
         let 
            cC = compCrit{0}
           ,comparison = cC[Comp](Record.Field(x,cC[ColNam]),Record.Field(y,cC[ColNam]))
           ,comparisonAllCols = if comparison = 0 and List.Count(compCrit)>1 then 
                                @fFullCompare(x,y,List.Skip(compCrit)) else 
                                comparison *cC[Order]
         in
            comparisonAllCols
        ,CompareRec = fFullCompare(x,y,compCritListRecords)
     in
         CompareRec

    ,Execute = Table.Sort(Table, fComparer)        
in
     Execute
