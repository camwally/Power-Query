/*Ascribes table type of column based on first table in column as 
Table.TransformColumnTypes does not work with complex types. E.g.  type table[A=text, B=number]
Based on Marcel Beugals code at 
https://social.technet.microsoft.com/Forums/en-US/636e9b44-6820-4ff2-ab60-5dd6a5307bd2/type-conversion-mysteries
*/

(PreviousStep as table,ColName as text) =>
Table.TransformColumns(PreviousStep, {ColName, each {_}{0}, Value.Type(Table.Column(PreviousStep,ColName){0})})
