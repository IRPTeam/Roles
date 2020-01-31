

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	RolesSet = Roles_Settings.RolesSet();
	
	For Each Set In RolesSet Do
		Items.RightsObjectType.ChoiceList.Add(Set.Key);
	EndDo;
	
EndProcedure

&AtClient
Procedure RightsObjectTypeOnChange(Item)
	CurrentRow = Items.Rights.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CurrentRow.ObjectName = "";
EndProcedure

&AtClient
Procedure RightsObjectNameStartChoice(Item, ChoiceData, StandardProcessing)
	
	CurrentRow = Items.Rights.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	UpdateObjectNameChoiceList(CurrentRow);
EndProcedure


&AtClient
Procedure UpdateObjectNameChoiceList(Val CurrentRow)
	Items.RightsObjectName.ChoiceList.Clear();
	
	If ValueIsFilled(CurrentRow.ObjectType) Then
		For Each Row In Roles_Settings.MetadataInfo()[CurrentRow.ObjectType] Do
			Items.RightsObjectName.ChoiceList.Add(Row.Value, Row.Presentation);
		EndDo;
	Else
		For Each Data In Roles_Settings.MetadataInfo() Do
			For Each Row In Data.Value Do
				Items.RightsObjectName.ChoiceList.Add(Data.Key + "." + Row.Value, Row.Presentation + " [" + Data.Key + "]");
			EndDo;
		EndDo;
	EndIf;
EndProcedure


&AtClient
Procedure RightsObjectNameOnChange(Item)
	CurrentRow = Items.Rights.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	Data = StrSplit(CurrentRow.ObjectName, ".", False);
	If Data.Count() > 1 Then
		CurrentRow.ObjectType = Data[0];
		UpdateObjectNameChoiceList(CurrentRow);
		CurrentRow.ObjectName = Data[1];
	EndIf;
EndProcedure

&AtClient
Procedure RightsRightNameStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentRow = Items.Rights.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	UpdateRightChoiceList(CurrentRow);
EndProcedure

&AtClient
Procedure UpdateRightChoiceList(Val CurrentRow)
	Items.RightsRightName.ChoiceList.LoadValues(Roles_Settings.RolesSet()[CurrentRow.ObjectType]);
EndProcedure

&AtClient
Procedure RightsBeforeDeleteRow(Item, Cancel)
	CurrentRow = Item.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	RowsToDelete = Object.RestrictionByCondition.FindRows(New Structure("RowID", CurrentRow.RowID));
	For Each RowToDelete In RowsToDelete Do
		Object.RestrictionByCondition.Delete(RowToDelete);
	EndDo;
EndProcedure

&AtClient
Procedure RightsOnChange(Item)
	CurrentRow = Item.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	If NOT ValueIsFilled(CurrentRow.RowID) Then
		CurrentRow.RowID = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure RestrictionByConditionOnChange(Item)
	CurrentRightRow = Items.Rights.CurrentData;
	If CurrentRightRow = Undefined Then
		Return;
	EndIf;
	
	CurrentRow = Item.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentRow.RowID = CurrentRightRow.RowID;
EndProcedure










