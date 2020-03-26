
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DisplayFilter();
EndProcedure

&AtServer
Procedure DisplayFilter()
	Items.ValueList.Visible = Object.isList;
	Items.ValueData.Visible = Not Object.isList;
EndProcedure

&AtClient
Procedure isListOnChange(Item)
	DisplayFilter();
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	If Not CurrentObject.isList Then
		ValueData = CurrentObject.ValuesData.Get();
	Else
		ValueList = CurrentObject.ValuesData.Get();
	EndIf;
	ValueType = CurrentObject.ValueTypeData.Get();
EndProcedure


&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.ValuesData 		= New ValueStorage(ValueData);
	CurrentObject.ValueTypeData 	= New ValueStorage(ValueType);
EndProcedure


&AtClient
Procedure ValueTypeOnChange(Item)
	
	
	
	Items.ValueData.TypeRestriction = New TypeDescription(ValueType);
	ValueList.ValueType = New TypeDescription(ValueType);
EndProcedure


&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	Try
		Str = New Structure(Object.Description);
	Except
		Cancel = True;
	EndTry;
EndProcedure

