
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

#Region RightsList
&AtServer
Procedure UpdateRightsList()
	RoleTree = FormAttributeToValue("RolesEdit");
	RoleTree.Rows.Clear();
	
	For Each Meta In Enums.Roles_MetadataTypes Do
		
		If Meta = Enums.Roles_MetadataTypes.IntegrationService // wait 8.3.17
			OR Meta = Enums.Roles_MetadataTypes.Role Then 
			Continue;
		EndIf;
		
		MetaRow = RoleTree.Rows.Add();
		MetaRow.ObjectType = Meta;
		MetaRow.ObjectFullName = Meta;

		MetaRow.Picture = PictureLib["Roles_" + Roles_GenerateExtension.MetaName(Meta)];
		
		If Meta = Enums.Roles_MetadataTypes.Configuration Then
			MetaRow.ObjectFullName = Metadata.Name;
			Continue;
		EndIf;
		EmptyData = True;
		For Each MetaItem In Metadata[Roles_Settings.MetaDataObjectNames().Get(Meta)] Do
			EmptyData = False;
			MetaItemRow = MetaRow.Rows.Add();
			MetaItemRow.ObjectType = Meta;
			MetaItemRow.ObjectName = MetaItem.Name;
			MetaItemRow.ObjectFullName = String(MetaItem);
			MetaItemRow.Picture = PictureLib["Roles_" + Roles_GenerateExtension.MetaName(Meta)];
			If Roles_Settings.hasAttributes(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "Attributes");
			EndIf;
			If Roles_Settings.hasDimensions(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "Dimensions");
			EndIf;
			If Roles_Settings.hasResources(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "Resources");
			EndIf;
			If Roles_Settings.hasStandardAttributes(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "StandardAttributes");
			EndIf;
			If Roles_Settings.hasCommands(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "Commands");
			EndIf;			
			If Roles_Settings.hasRecalculations(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "Recalculations");
			EndIf;
			If Roles_Settings.hasAccountingFlags(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "AccountingFlags");
			EndIf;
			If Roles_Settings.hasExtDimensionAccountingFlags(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "ExtDimensionAccountingFlags");
			EndIf;
			If Roles_Settings.hasAddressingAttributes(Meta) Then
				AddChild(Meta, MetaItem, MetaItemRow, "AddressingAttributes");
			EndIf;
			If Roles_Settings.hasTabularSections(Meta) Then
				AddChildTab(Meta, MetaItem, MetaItemRow, "TabularSections");
			EndIf;
			If Roles_Settings.hasStandardTabularSections(Meta) Then
				AddChildStandardTab(Meta, MetaItem, MetaItemRow, "StandardTabularSections");
			EndIf;
			
		EndDo;
		If EmptyData Then
			RoleTree.Rows.Delete(MetaRow);
		EndIf;
		
	EndDo;
	ValueToFormAttribute(RoleTree, "RolesEdit");
EndProcedure

&AtServer
Procedure AddChild(Meta, MetaItem, MetaItemRow, DataType)

	
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	ObjectSubtype = Enums.Roles_MetadataSubtype[Left(DataType, StrLen(DataType) - 1)];
	
	AddChildRows = MetaItemRow.Rows.Add();
	For Each AddChild In MetaItem[DataType] Do
		AddChildRow = AddChildRows.Rows.Add();
		//AddChildRow.ObjectType = Meta;
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.Picture = PictureLib["Roles_" + DataType];
		If DataType = "StandardAttributes" Then		
			AddChildRow.ObjectFullName = AddChild.Name;
		Else	
			AddChildRow.ObjectFullName = String(AddChild);
		EndIf;		
		AddChildRow.ObjectSubtype = ObjectSubtype;
	EndDo;
	If DataType = "StandardAttributes" Then
		AddChildRows.ObjectFullName = "StandardAttribute";
	Else
		NamePart = StrSplit(AddChild.FullName(), ".");
		AddChildRows.ObjectFullName = NamePart[2];
	EndIf;
	AddChildRows.ObjectSubtype = ObjectSubtype;
	AddChildRows.ObjectName = DataType;
	AddChildRows.Picture = PictureLib["Roles_" + DataType];
EndProcedure

&AtServer
Procedure AddChildTab(Meta, MetaItem, MetaItemRow, DataType)
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	
	AddChildRows = MetaItemRow.Rows.Add();
	ObjectSubtype = Enums.Roles_MetadataSubtype[Left(DataType, StrLen(DataType) - 1)];
	For Each AddChild In MetaItem[DataType] Do
		AddChildRow = AddChildRows.Rows.Add();
		//AddChildRow.ObjectType = Meta;
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.ObjectFullName = String(AddChild);	
		AddChildRow.Picture = PictureLib["Roles_" + DataType];
		AddChildRow.ObjectSubtype = ObjectSubtype;
		For Each AddChildAttribute In AddChild.Attributes Do
			AddChildNewRow = AddChildRow.Rows.Add();
			//AddChildNewRow.ObjectType = Meta;
			AddChildNewRow.ObjectName = AddChildAttribute.Name;
			AddChildNewRow.ObjectFullName = String(AddChildAttribute);
			AddChildNewRow.Picture = PictureLib["Roles_Attributes"];
			AddChildNewRow.ObjectSubtype = ObjectSubtype;
		EndDo;
		
	EndDo;
	NamePart = StrSplit(AddChild.FullName(), ".");
	AddChildRows.ObjectFullName = NamePart[2];
	AddChildRows.Picture = PictureLib["Roles_" + DataType];
	AddChildRows.ObjectName = DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
EndProcedure

&AtServer
Procedure AddChildStandardTab(Meta, MetaItem, MetaItemRow, DataType)
	AddChildRows = MetaItemRow.Rows.Add();
	AddChildRows.ObjectFullName = "StandardTabularSection";
	ObjectSubtype = Enums.Roles_MetadataSubtype[Left(DataType, StrLen(DataType) - 1)];

	For Each AddChild In MetaItem[DataType] Do
		AddChildRow = AddChildRows.Rows.Add();
		//AddChildRow.ObjectType = Meta;
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.ObjectFullName = AddChild.Name;
		AddChildRow.Picture = PictureLib["Roles_" + DataType];
		AddChildRow.ObjectSubtype = ObjectSubtype;
		For Each AddChildAttribute In AddChild.StandardAttributes Do
			AddChildNewRow = AddChildRow.Rows.Add();
			//AddChildNewRow.ObjectType = Meta;
			AddChildNewRow.ObjectName = AddChildAttribute.Name;
			AddChildNewRow.ObjectFullName = String(AddChildAttribute);	
			AddChildNewRow.Picture = PictureLib["Roles_StandardAttributes"];
			AddChildNewRow.ObjectSubtype = ObjectSubtype;
		EndDo;	
	EndDo;
	AddChildRows.Picture = PictureLib["Roles_" + DataType];
	AddChildRows.ObjectName = DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
EndProcedure

&AtClient
Procedure RolesEditBeforeAddRow(Item, Cancel, Clone, Parent, Folder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure RolesEditBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

#EndRegion

&AtClient
Procedure ChangeRole(Item)
	FlagOnChange(Item);
EndProcedure

#Region Service

#Region FlagStatus
&AtClient
Procedure FlagOnChange(Item)
    RowID = Items.RolesEdit.CurrentRow;
    If RowID <> Undefined Then
        ItemRow = RolesEdit.FindByID(RowID);
        If ItemRow[Item.Name] = 2 Then
            ItemRow[Item.Name] = 0;
        EndIf;
        SetFlag(ItemRow, Item, ArrayForViewEdit());
        Parent = ItemRow.GetParent();
        While Parent <> Undefined Do
            Parent[Item.Name] = ?(isAllSet(ItemRow, Item),
                ItemRow[Item.Name], 2);
            ItemRow = Parent;
            Parent = ItemRow.GetParent();
        EndDo;
    EndIf;
EndProcedure

&AtClient
Procedure SetFlag(ItemRow, Item, ArrayForViewEdit)
    Childs = ItemRow.GetItems();
	For Each ThisItem In Childs Do
		If Skip(ArrayForViewEdit, Item, ThisItem) Then
			Continue;
		EndIf;
        ThisItem[Item.Name] = ItemRow[Item.Name];
        SetFlag(ThisItem, Item, ArrayForViewEdit);
    EndDo;
EndProcedure

&AtClient
Function Skip(Val ArrayForViewEdit, Val Item, Val ThisItem)
	
	If NOT ThisItem.ObjectSubtype.isEmpty() Then
		If Item.Name = "View" Then
			If ThisItem.ObjectSubtype = PredefinedValue("Enum.Roles_MetadataSubtype.Command")
				OR NOT ArrayForViewEdit.Find(ThisItem.ObjectSubtype) = Undefined Then
				Return False;
			Else
				Return True;
			EndIf;
		ElsIf (Item.Name = "Read" OR Item.Name = "Update")
			AND ThisItem.ObjectSubtype = PredefinedValue("Enum.Roles_MetadataSubtype.Recalculation") Then
			Return False;
		ElsIf Item.Name = "Edit" 
			AND NOT ArrayForViewEdit.Find(ThisItem.ObjectSubtype) = Undefined Then
			Return False;
		Else	
			Return True;
		EndIf;
		
	EndIf;
	Return False;
EndFunction

&AtClient
Function isAllSet(ItemRow, Item)
    UpChilds = ItemRow.GetParent().GetItems();
    For Each thisItem In UpChilds Do
        If NOT thisItem[Item.Name] = ItemRow[Item.Name] Then
            Return False;
        EndIf;
    EndDo;
    Return True;
КонецФункции   
#EndRegion

&AtServer
Procedure SetOnChangeAction()
	
	ArrayChildItems = New Array;
	ArrayChildItems.Add(Items.RolesEditGroupAdmin.ChildItems);
	ArrayChildItems.Add(Items.RolesEditGroupBasic.ChildItems);
	ArrayChildItems.Add(Items.RolesEditGroupDocument.ChildItems);
	ArrayChildItems.Add(Items.RolesEditGroupHistory.ChildItems);
	ArrayChildItems.Add(Items.RolesEditGroupInteractive.ChildItems);
	ArrayChildItems.Add(Items.RolesEditGroupPredefined.ChildItems);
	ArrayChildItems.Add(Items.RolesEditGroupRLS.ChildItems);
	ArrayChildItems.Add(Items.RolesEditGroupSessionParameters.ChildItems);
	ArrayChildItems.Add(Items.RolesEditGroupTask.ChildItems);
	For Each ChildItem In ArrayChildItems Do
		For Each Item In ChildItem Do
			Item.SetAction("OnChange", "ChangeRole"); 
		EndDo;
	EndDo;
	
EndProcedure
#EndRegion

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetOnChangeAction();
EndProcedure

&AtServer
Function ArrayForViewEdit()
	ArrayForViewEdit = New Array;
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.Attribute);
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.TabularSection);
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.StandardAttribute);
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.Dimension);
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.Resource);
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.AccountingFlag);
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.ExtDimensionAccountingFlag);
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.AddressingAttribute);
	ArrayForViewEdit.Add(Enums.Roles_MetadataSubtype.StandardTabularSection);
	Return ArrayForViewEdit;
EndFunction