
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
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
Procedure BeforeWrite(Cancel, WriteParameters)
	Try
		// @skip-warning
		Str = New Structure(Object.Description);
	Except
		Cancel = True;
	EndTry;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetValueType();
	SetBSLFunction();
EndProcedure

&AtClient
Procedure DescriptionOnChange(Item)
	SetBSLFunction();
EndProcedure
#EndRegion

#Region FormHeaderItemsEventHandlers
&AtClient
Procedure ValueTypeOnChange(Item)
	SetValueType();
EndProcedure

&AtClient
Procedure isListOnChange(Item)
	DisplayFilter();
EndProcedure

&AtClient
Procedure UseCodeOnChange(Item)
	DisplayFilter();
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure DisplayFilter()
	Items.GroupBSL.Visible = Object.UseCode;
	Items.GroupValue.Visible = Not Object.UseCode;	
	Items.ValueList.Visible = Object.isList;
	Items.ValueData.Visible = Not Object.isList;
EndProcedure



&AtClient
Procedure SetValueType()
	Items.ValueData.TypeRestriction = New TypeDescription(ValueType);
	ValueList.ValueType = New TypeDescription(ValueType);
EndProcedure

&AtClient
Procedure SetBSLFunction()
	Items.DecorationName.Title = "Function AccRoles_" + Object.Description + "(RequiredParameters)";
	Items.DecorationEnd.Title = "EndFunction";
EndProcedure

#EndRegion














