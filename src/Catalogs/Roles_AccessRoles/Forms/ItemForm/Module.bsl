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
		For Each Row In Roles_Settings.MetadataInfo().Get(CurrentRow.ObjectType) Do
			Items.RightsObjectName.ChoiceList.Add(Row.Value);
		EndDo;
	EndIf;
EndProcedure


&AtServerNoContext
Function MetadataName(Val RefData)
	Return RefData.Metadata().Name;
EndFunction



&AtClient
Procedure RightsObjectNameOnChange(Item)
	CurrentRow = Items.Rights.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	Data = StrSplit(CurrentRow.ObjectName, ".", False);
	If Data.Count() > 1 Then
		CurrentRow.ObjectType = PredefinedValue("Enums.Roles_MetadataTypes." + Data[0]);
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
	Items.RightsRightName.ChoiceList.LoadValues(Roles_Settings.RolesSet().Get(CurrentRow.ObjectType));
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

&AtClient
Procedure UpdateRights(Command)
	UpdateRightsList();
EndProcedure


&AtServer
Procedure UpdateRightsList()
	RoleTree = FormAttributeToValue("RolesEdit");
	RoleTree.Rows.Clear();
	
	For Each Meta In Enums.Roles_MetadataTypes Do
		
		If Meta = Enums.Roles_MetadataTypes.Configuration 
			OR Meta = Enums.Roles_MetadataTypes.IntegrationService Then // wait 8.3.17
			Continue;
		EndIf;
		
		MetaRow = RoleTree.Rows.Add();
		MetaRow.ObjectFullName = Meta;
		EmptyData = True;
		For Each MetaItem In Metadata[Roles_Settings.MetaDataObjectNames().Get(Meta)] Do
			EmptyData = False;
			MetaItemRow = MetaRow.Rows.Add();
			MetaItemRow.ObjectType = Meta;
			MetaItemRow.ObjectName = MetaItem.Name;
			MetaItemRow.ObjectFullName = String(MetaItem);
			
			AddAttributes(Meta, MetaItem, MetaItemRow);
			AddCommands(Meta, MetaItem, MetaItemRow);
//			Try	
//				
//				ИмяПеречисления = Meta.Метаданные().Имя;
//				ИндексЗначенияПеречисления = Перечисления[ИмяПеречисления].Индекс(Meta);
//				ИмяЗначенияПеречисления = Метаданные.Перечисления[ИмяПеречисления].ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
//				Message("	Array.Add(Enums.Roles_MetadataTypes." + ИмяЗначенияПеречисления + ");");
//			Except
//				
//			EndTry;
		EndDo;
		If EmptyData Then
			RoleTree.Rows.Delete(MetaRow);
		EndIf;
		
	EndDo;
	ValueToFormAttribute(RoleTree, "RolesEdit");
EndProcedure

&AtServer
Procedure AddAttributes(Meta, MetaItem, MetaItemRow)
	
	If NOT Roles_Settings.hasAttributes(Meta) Then
		Return;
	EndIf;
	
	If NOT MetaItem.Attributes.Count() Then
		Return;
	EndIf;
	
	AddAttributesRow = MetaItemRow.Rows.Add();
	AddAttributesRow.ObjectFullName = "Attributes";
	For Each Attribute In MetaItem.Attributes Do
		AddAttributeRow = AddAttributesRow.Rows.Add();
		AddAttributeRow.ObjectType = Meta;
		AddAttributeRow.ObjectName = Attribute.Name;
		AddAttributeRow.ObjectFullName = String(Attribute);
	EndDo;
EndProcedure


&AtServer
Procedure AddCommands(Meta, MetaItem, MetaItemRow)
	
	If NOT Roles_Settings.hasCommands(Meta) Then
		Return;
	EndIf;
	
	If NOT MetaItem.Commands.Count() Then
		Return;
	EndIf;
	
	CommandsRow = MetaItemRow.Rows.Add();
	CommandsRow.ObjectFullName = "Commands";
	For Each Command In MetaItem.Commands Do
		CommandRow = CommandsRow.Rows.Add();
		CommandRow.ObjectType = Meta;
		CommandRow.ObjectName = Command.Name;
		CommandRow.ObjectFullName = String(Command);
	EndDo;
EndProcedure





