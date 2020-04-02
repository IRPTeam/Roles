
&AtClient
Procedure RightsObjectTypeOnChange(Item)
	CurrentRow = Items.Rights.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CurrentRow.ObjectName = "";
	CurrentRow.ObjectPath = "";
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
	CurrentRow.ObjectPath = Roles_Settings.MetaName(CurrentRow.ObjectType) + "." + CurrentRow.ObjectName;
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
	MatrixUpdated = False;
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
	RolesEdit.GetItems().Clear();
	UpdateRightsList(NOT MatrixUpdated);
EndProcedure

#Region RightsList
&AtServer
Procedure UpdateRightsList(OnlyReport)
	RoleTree = FormAttributeToValue("RolesEdit");
	
	ObjectData = New Structure;
	ObjectData.Insert("RightTable", Object.Rights.Unload());
	ObjectData.Insert("RestrictionByCondition", Object.RestrictionByCondition.Unload());
	ObjectData.Insert("SetRightsForNewNativeObjects", Object.SetRightsForNewNativeObjects);
	ObjectData.Insert("SetRightsForAttributesAndTabularSectionsByDefault", Object.SetRightsForAttributesAndTabularSectionsByDefault);
	ObjectData.Insert("SubordinateObjectsHaveIndependentRights", Object.SubordinateObjectsHaveIndependentRights);
	
	ObjectData.RightTable.Columns.Add("Ref");
	ObjectData.RightTable.FillValues(Object.Ref, "Ref");
	
	ObjectData.RestrictionByCondition.Columns.Add("Ref");
	ObjectData.RestrictionByCondition.FillValues(Object.Ref, "Ref");
	
	TabDocMartix = Roles_RoleMatrix.GenerateRoleMatrix(RoleTree, ObjectData, OnlyReport, NOT ShowAllObjects);
	ValueToFormAttribute(RoleTree, "RolesEdit");
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

#Region Service

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
	If Object.Ref.IsEmpty() Then
		Object.SetRightsForAttributesAndTabularSectionsByDefault = True;
	EndIf;

	UpdateRightsList(True);

EndProcedure


&AtClient
Procedure SearchTextOnChange(Item)
	If ValueIsFilled(SearchText) Then
		Items.RolesEdit.Representation = TableRepresentation.List;
	Else
		Items.RolesEdit.Representation = TableRepresentation.Tree;
	EndIf;
EndProcedure

&AtClient
Procedure RolesEditSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentRow = Items.RolesEdit.CurrentData;
	SetFlags(CurrentRow, Field);
	SetAddRestrictionEnabled (CurrentRow, Field.Name);
EndProcedure

&AtClient
Procedure SetFlags(CurrentRow,  Field, Value = Undefined, OnlyNextLvl = False)
		
	If NOT Value = Undefined Then
		CurrentRow[Field.Name] = Value;
	ElsIf CurrentRow[Field.Name] Then
		CurrentRow[Field.Name] = 0;
	Else
		CurrentRow[Field.Name] = ?(Object.SetRightsForNewNativeObjects, 2, 1);
	EndIf;
	CurrentRow.Edited = True;
	SetEditedInfo(CurrentRow);
	
	ParentRow = CurrentRow.GetParent();
	
	If CurrentRow.ObjectName = "" 
	  OR (Not CurrentRow.ObjectSubtype.isEmpty() AND 
	  		Not ParentRow.ObjectSubtype = CurrentRow.ObjectSubtype AND
			Not OnlyNextLvl) Then
		For Each RowChild In CurrentRow.GetItems() Do
			SetFlags(RowChild,  Field, CurrentRow[Field.Name], True);
		EndDo;
		Return;
	EndIf;
	
	Filter = New Structure();
	Filter.Insert("RightName", PredefinedValue("Enum.Roles_Rights." + Field.Name));
	Filter.Insert("ObjectPath", CurrentRow.ObjectPath);
	Row = Object.Rights.FindRows(Filter);
	
	If Row.Count() Then
		If CurrentRow[Field.Name] = 0 Then
			Row[0].Disable = True;
		Else
			Row[0].RightValue = ?(CurrentRow[Field.Name] = 1, True, False);
			Row[0].Disable = False;
		EndIf;
	Else
		PathArray = StrSplit(CurrentRow.ObjectPath, ".", False);
		NewRow = Object.Rights.Add();
		NewRow.ObjectType = PredefinedValue("Enum.Roles_MetadataTypes." + PathArray[0]);
		NewRow.ObjectName = PathArray[1];
		NewRow.RightName  = PredefinedValue("Enum.Roles_Rights." + Field.Name);
		NewRow.ObjectPath = CurrentRow.ObjectPath;
		NewRow.ObjectSubtype = CurrentRow.ObjectSubtype;
		NewRow.RightValue = ?(CurrentRow[Field.Name] = 1, True, False);
			
		RLSData = Field.Name = "Read"
			OR Field.Name = "Insert"
			OR Field.Name = "Update"
			OR Field.Name = "Delete";
		If RLSData Then
			If CurrentRow["RLS" + Field.Name + "ID"] = "" Then
				NewRow.RowID = New UUID;
				CurrentRow["RLS" + Field.Name + "ID"] = NewRow.RowID;
			Else
				NewRow.RowID = CurrentRow["RLS" + Field.Name + "ID"];
			EndIf;	
		EndIf;
		
	EndIf;
	
	If CurrentRow.ObjectType = PredefinedValue("Enum.Roles_MetadataTypes.Subsystem") Then
		For Each Row In CurrentRow.GetItems() Do
			SetFlags(Row,  Field, CurrentRow[Field.Name])
		EndDo;
	ElsIf ParentRow.ObjectSubtype = CurrentRow.ObjectSubtype And Not OnlyNextLvl Then
		SetNewStatus = New Map;
		For Each ChRow In ParentRow.GetItems() Do
			SetNewStatus.Insert(ChRow[Field.Name], ChRow[Field.Name]);
		EndDo;
		If SetNewStatus.Count() = 1 Then
			ParentRow[Field.Name] = SetNewStatus.Get(ChRow[Field.Name]);
		Else
			ParentRow[Field.Name] = 3;
		EndIf;
	EndIf;
	
EndProcedure

&AtClient
Procedure RestrictionByConditionConditionOpening(Item, StandardProcessing)
	StandardProcessing = False;
	Filter = New Structure("Text, ObjectPath, RightName, RLSList");
	Filter.Text = Item.Parent.CurrentData.Condition;
	Filter.ObjectPath = Items.RolesEdit.CurrentData.ObjectPath;
	Filter.RightName = Items.RolesEdit.CurrentItem.Name;
	RLSList = New Array;
	For Each RLSRow In Object.Templates Do
		RLSList.Add(RLSRow.Template);
	EndDo;
	Filter.RLSList = RLSList;
	
	Notify = New NotifyDescription("RestrictionByConditionConditionOpeningEnd", ThisForm, New Structure("Item", Item));
	
	OpenForm("CommonForm.Roles_ConvertTemplateToQuery", Filter, ThisObject,,,, Notify, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure RestrictionByConditionConditionOpeningEnd(Text, AdditionalParameters) Export
	
	Item = AdditionalParameters.Item;
	If NOT Text = Undefined Then
		Item.Parent.CurrentData.Condition = Text;
	EndIf;

EndProcedure


&AtClient
Procedure SetEditedInfo(Row)
	Parent = Row.GetParent();
	If Parent = Undefined Then
		Return;
	EndIf;
	If Parent.Edited Then
		Return;
	EndIf;
	Parent.Edited = True;
	SetEditedInfo(Parent);
EndProcedure

&AtClient
Procedure RolesEditOnActivateCell(Item)
	SetAddRestrictionEnabled(Item.CurrentData, Item.CurrentItem.Name);
EndProcedure

&AtClient
Procedure SetAddRestrictionEnabled (CurrentData, ColumnName)

	isRLSData = ColumnName = "Read"
		OR ColumnName = "Insert"
		OR ColumnName = "Update"
		OR ColumnName = "Delete";
	
	If NOT isRLSData Or CurrentData.ObjectName = "" Then
		RLSRowID = "";
		Items.RestrictionByConditionMatrixAddRestriction.Enabled = False;
		Return;
	EndIf;
	Items.RestrictionByConditionMatrixAddRestriction.Enabled = 
					NOT CurrentData[ColumnName] = 0;
	RLSRowID = CurrentData["RLS" + ColumnName + "ID"];
	
	If RLSRowID = "" Then
		RLSRowID = New UUID;
		CurrentData["RLS" + ColumnName + "ID"] = RLSRowID;
	EndIf;
	
EndProcedure

&AtClient
Procedure TabDocMartixDetailProcessing(Item, Details, StandardProcessing, AdditionalParameters)
	StandardProcessing = False;
EndProcedure


&AtClient
Procedure GroupMainPagesOnCurrentPageChange(Item, CurrentPage)
	If CurrentPage = Items.GroupRoleMatrix 
		AND NOT MatrixUpdated Then
		
		RolesEdit.GetItems().Clear();
		UpdateRightsList(False);
		MatrixUpdated = True;
	EndIf;
EndProcedure

&AtClient
Procedure AddRestriction(Command)
	If NOT ValueIsFilled(RLSRowID) Then
		Return;
	EndIf;
	NewRow = Object.RestrictionByCondition.Add();
	NewRow.RowID = RLSRowID;
EndProcedure


&AtClient
Procedure RestrictionByConditionMatrixFilterDataStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	Notify = New NotifyDescription("OnFinishEditFilter", ThisObject);
	OpeningParameters = New Structure();
	OpeningParameters.Insert("Path", Items.RolesEdit.CurrentData.ObjectPath);
	OpeningParameters.Insert("FilterData", Items.RestrictionByConditionMatrix.CurrentData.SerializedData);
	
	OpenForm("Catalog.Roles_AccessRoles.Form.EditCondition", OpeningParameters, ThisObject, , , , Notify);
EndProcedure



&AtClient
Procedure OnFinishEditFilter(Result, AddInfo = Undefined) Export
	If TypeOf(Result) = Type("Structure") Then
		CurrentData = Items.RestrictionByConditionMatrix.CurrentData;
		CurrentData.FilterData = Result.Settings.Filter;
		CurrentData.Condition = Result.Filter;
		
		CurrentData.Modified = Not CurrentData.SerializedData = Result.SettingsXML;
		CurrentData.SerializedData = Result.SettingsXML;
	EndIf;
EndProcedure


&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	ModifiedRows = Object.RestrictionByCondition.FindRows(New Structure("Modified", True));
	For Each Row In ModifiedRows Do
		CurrentObject.RestrictionByCondition[Row.SourceLineNumber - 1].FilterDataStorage = 
										New ValueStorage(Row.SerializedData, New Deflation(9));
	EndDo;
EndProcedure


&AtServer
Procedure OnReadAtServer(CurrentObject)
	For Each Row In CurrentObject.RestrictionByCondition Do
		FormRow = Object.RestrictionByCondition.FindRows(
						New Structure("SourceLineNumber", Row.LineNumber))[0];
		FormRow.SerializedData = Row.FilterDataStorage.Get();
		If Not FormRow.SerializedData = "" Then
			FormRow.FilterData = Roles_ServiceServer.DeserializeXML(FormRow.SerializedData).Filter;
		EndIf;
	EndDo;
EndProcedure

