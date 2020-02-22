Function GenerateRoleMatrix(RoleTree, ObjectData, OnlyReport) Export
	
	RightsMap = CurrentRights(ObjectData);
	PictureLibData = Roles_SettingsReUse.PictureList();
	
	ParamStructure = New Structure;
	ParamStructure.Insert("PictureLibData", PictureLibData);
	ParamStructure.Insert("RightsMap", RightsMap);
	ParamStructure.Insert("ObjectData", ObjectData);
	
	
	For Each Meta In Enums.Roles_MetadataTypes Do
		
		If Meta = Enums.Roles_MetadataTypes.IntegrationService // wait 8.3.17
			OR Meta = Enums.Roles_MetadataTypes.Role Then 
			Continue;
		EndIf;
		
		MetaRow = RoleTree.Rows.Add();
		MetaRow.ObjectType = Meta;
		MetaRow.ObjectFullName = Meta;
		MetaRow.ObjectPath = Roles_Settings.MetaName(Meta);
		Picture = PictureLibData["Roles_" + Roles_Settings.MetaName(Meta)];
		MetaRow.Picture = Picture;
		
		SetCurrentRights(MetaRow, ParamStructure);
		EmptyData = True;		
		If Meta = Enums.Roles_MetadataTypes.Configuration Then
			MetaRow.ObjectFullName = Metadata.Name;
			Continue;
		EndIf;
		
		ParamStructure.Insert("Meta", Meta);
			
		For Each MetaItem In Metadata[Roles_Settings.MetaDataObjectNames().Get(Meta)] Do
			If NOT isNative(MetaItem) Then
				Continue;
			EndIf;

			EmptyData = False;
			MetaItemRow = MetaRow.Rows.Add();
			MetaItemRow.ObjectType = Meta;
			MetaItemRow.ObjectName = MetaItem.Name;
			MetaItemRow.ObjectFullName = MetaItem.Name;
			MetaItemRow.Picture = Picture;
			MetaItemRow.ObjectPath = MetaRow.ObjectPath + "." + MetaItemRow.ObjectFullName;
			
			ParamStructure.Insert("MetaItem", MetaItem);
			ParamStructure.Insert("MetaItemRow", MetaItemRow);

			
			SetCurrentRights(MetaItemRow, ParamStructure);			
						
			If Roles_Settings.hasAttributes(Meta) Then
				ParamStructure.Insert("DataType", "Attributes");
				AddChild(ParamStructure);
			EndIf;
			If Roles_Settings.hasDimensions(Meta) Then
				ParamStructure.Insert("DataType", "Dimensions");
				AddChild(ParamStructure);
			EndIf;
			If Roles_Settings.hasResources(Meta) Then
				ParamStructure.Insert("DataType", "Resources");
				AddChild(ParamStructure);
			EndIf;
			If Roles_Settings.hasStandardAttributes(Meta) Then
				ParamStructure.Insert("DataType", "StandardAttributes");
				AddChild(ParamStructure);
			EndIf;
			If Roles_Settings.hasCommands(Meta) Then
				ParamStructure.Insert("DataType", "Commands");
				AddChild(ParamStructure);
			EndIf;			
			If Roles_Settings.hasRecalculations(Meta) Then
				ParamStructure.Insert("DataType", "Recalculations");
				AddChild(ParamStructure);
			EndIf;
			If Roles_Settings.hasAccountingFlags(Meta) Then
				ParamStructure.Insert("DataType", "AccountingFlags");
				AddChild(ParamStructure);
			EndIf;
			If Roles_Settings.hasExtDimensionAccountingFlags(Meta) Then
				ParamStructure.Insert("DataType", "ExtDimensionAccountingFlags");
				AddChild(ParamStructure);
			EndIf;
			If Roles_Settings.hasAddressingAttributes(Meta) Then
				ParamStructure.Insert("DataType", "AddressingAttributes");
				AddChild(ParamStructure);
			EndIf;
			If Roles_Settings.hasTabularSections(Meta) Then
				ParamStructure.Insert("DataType", "TabularSections");
				AddChildTab(ParamStructure);
			EndIf;
			If Roles_Settings.hasStandardTabularSections(Meta) Then
				ParamStructure.Insert("DataType", "StandardTabularSections");
				AddChildStandardTab(ParamStructure);
			EndIf;
			If Roles_Settings.isSubsystem(Meta) Then
				ParamStructure.Insert("DataType", "Subsystems");
				AddChildSubsystem(ParamStructure);
			EndIf;
			If Roles_Settings.hasOperations(Meta) Then
				ParamStructure.Insert("DataType", "Operations");
				AddChildOperations(ParamStructure);
			EndIf;
			If Roles_Settings.hasURLTemplates(Meta) Then
				ParamStructure.Insert("DataType", "URLTemplates");
				AddChildURLTemplates(ParamStructure);
			EndIf;
		EndDo;
		If EmptyData Then
			RoleTree.Rows.Delete(MetaRow);
		EndIf;
	EndDo;
	
	RoleTree.Rows.Sort("ObjectPath", True);
	
	TabDoc = New SpreadsheetDocument;
	TabDoc.ShowRowGroupLevel(1);
	TabDocTemplate = Catalogs.Roles_AccessRoles.GetTemplate("MatrixTemplate");
	Area = TabDocTemplate.GetArea("Head");
	TabDoc.Put(Area);
	TabRow = TabDocTemplate.GetArea("Row"); 
	FillTabDoc(TabDoc, RoleTree, TabRow);
	TabDoc.ShowHeaders = True;
	Area = TabDocTemplate.GetArea("Footer");
	TabDoc.Put(Area);

	ReplaceTextInTabDoc(TabDoc, 1, "✔", New Color(0, 255, 0));
	ReplaceTextInTabDoc(TabDoc, 2, "❌", New Color(255, 0, 0));
	If OnlyReport Then
		RoleTree.Rows.Clear();
	EndIf;
	Return TabDoc;
EndFunction


Procedure ReplaceTextInTabDoc(TabDoc, Find, Replace, Color)
	Var AreaToReplace;
	AreaToReplace = TabDoc.FindText(Find, , , , True);
	While NOT AreaToReplace = Undefined Do
		AreaToReplace.Text = Replace;
		AreaToReplace.BackColor = Color;
		AreaToReplace = TabDoc.FindText(Find, , , , True);
	EndDo;
EndProcedure


Procedure FillTabDoc(TabDoc, RoleTree, TabRow)
	For Each Row In RoleTree.Rows Do
		TabRow.Parameters.Fill(Row);
		TabRow.Area(1, 2).Picture = Row.Picture;
		TabRow.Area(1, 2).Indent = Row.Level();
 		TabDoc.Put(TabRow, , , False);
		
		TabDoc.StartRowGroup(, False);
		FillTabDoc(TabDoc, Row, TabRow);
		TabDoc.EndRowGroup();
	EndDo;
	
EndProcedure

Procedure AddChildOperations(Val StrData)
	If NOT StrData.MetaItem[StrData.DataType].Count() Then
		Return;
	EndIf;
	
	ObjectSubtype = Enums.Roles_MetadataSubtype[
			Left(StrData.DataType, StrLen(StrData.DataType) - 1)];
	Picture = StrData.PictureLibData["Roles_" + ObjectSubtype];
	For Each AddChild In StrData.MetaItem[StrData.DataType] Do
		
		If NOT isNative(AddChild) Then
			Continue;
		EndIf;
		
		AddChildRow = StrData.MetaItemRow.Rows.Add();
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.ObjectFullName = AddChild.Name;	
		AddChildRow.Picture = Picture;
		AddChildRow.ObjectSubtype = ObjectSubtype;
				
		AddChildRow.ObjectPath = StrData.MetaItemRow.ObjectPath + ".Operation." + AddChildRow.ObjectName;
		SetCurrentRights(AddChildRow, StrData);
	EndDo;
EndProcedure

Procedure AddChildURLTemplates(Val StrData)
	If NOT StrData.MetaItem[StrData.DataType].Count() Then
		Return;
	EndIf;
	
	AddChildRows = StrData.MetaItemRow.Rows.Add();
	ObjectSubtype = Enums.Roles_MetadataSubtype[Left(StrData.DataType, StrLen(StrData.DataType) - 1)];
	PictureMethod = StrData.PictureLibData["Roles_Method"];
	AddChildRows.ObjectPath = StrData.MetaItemRow.ObjectPath + "." + ObjectSubtype;
	For Each AddChild In StrData.MetaItem[StrData.DataType] Do
		
		If NOT isNative(AddChild) Then
			Continue;
		EndIf;
		
		If AddChildRows.ObjectFullName = "" Then
			NamePart = StrSplit(AddChild.FullName(), ".");
			AddChildRows.ObjectFullName = NamePart[3];
		EndIf;
		For Each AddChildAttribute In AddChild.Methods Do
			If NOT isNative(AddChildAttribute) Then
				Continue;
			EndIf;
			
			AddChildNewRow = AddChildRows.Rows.Add();
			AddChildNewRow.ObjectName = AddChildAttribute.Name;
			AddChildNewRow.ObjectFullName = AddChildAttribute.Name;
			AddChildNewRow.Picture = PictureMethod;
			AddChildNewRow.ObjectSubtype = Enums.Roles_MetadataSubtype.Method;
			
			// read data from object
			
			AddChildNewRow.ObjectPath = AddChildRows.ObjectPath + "." + AddChild.Name + ".Method." + 
							AddChildNewRow.ObjectName;
			SetCurrentRights(AddChildNewRow, StrData);

		EndDo;
		
	EndDo;
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + ObjectSubtype];
	AddChildRows.ObjectName = StrData.DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
EndProcedure

Procedure AddChildSubsystem(Val StrData)

	
	If NOT StrData.MetaItem[StrData.DataType].Count() Then
		Return;
	EndIf;
	ObjectSubtypeName = Left(StrData.DataType, StrLen(StrData.DataType) - 1);
	Picture = StrData.PictureLibData["Roles_Subsystem"];
	For Each AddChild In StrData.MetaItem[StrData.DataType] Do
		
		If NOT isNative(AddChild) Then
			Continue;
		EndIf;
		
		AddChildRow = StrData.MetaItemRow.Rows.Add();		
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.Picture = Picture;
		AddChildRow.ObjectFullName = AddChild.Name;
		AddChildRow.ObjectType = StrData.Meta;		
		// read data from object
		If StrData.MetaItemRow.ObjectPath = "" Then
			AddChildRow.ObjectPath = ObjectSubtypeName + "." + AddChildRow.ObjectName;
		Else
			AddChildRow.ObjectPath = StrData.MetaItemRow.ObjectPath + "." + 
					ObjectSubtypeName + "." + AddChildRow.ObjectName;
		EndIf;
		SetCurrentRights(AddChildRow, StrData);
		
		StrData.MetaItem = AddChild;
		AddChildSubsystem(StrData);
	EndDo;
EndProcedure

Procedure AddChild(Val StrData)

	
	If NOT StrData.MetaItem[StrData.DataType].Count() Then
		Return;
	EndIf;
	ObjectSubtypeName = Left(StrData.DataType, StrLen(StrData.DataType) - 1);
	ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectSubtypeName];
	
	AddChildRows = StrData.MetaItemRow.Rows.Add();
	AddChildRows.ObjectPath = StrData.MetaItemRow.ObjectPath + "." + ObjectSubtypeName;
	Picture = StrData.PictureLibData["Roles_" + StrData.DataType];
	For Each AddChild In StrData.MetaItem[StrData.DataType] Do
		
		If NOT StrData.DataType = "StandardAttributes" 
			AND NOT isNative(AddChild) Then
			Continue;
		EndIf;
		
		AddChildRow = AddChildRows.Rows.Add();
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.Picture = Picture;
		AddChildRow.ObjectFullName = AddChild.Name;
		If StrData.DataType = "StandardAttributes" Then		
			If AddChildRows.ObjectFullName = "" Then
				AddChildRows.ObjectFullName = "StandardAttribute";
			EndIf;
		Else	
			If AddChildRows.ObjectFullName = "" Then
				NamePart = StrSplit(AddChild.FullName(), ".");
				AddChildRows.ObjectFullName = NamePart[2];
			EndIf;
		EndIf;		
		
		AddChildRow.ObjectSubtype = ObjectSubtype;
		
		// read data from object
		
		AddChildRow.ObjectPath = AddChildRows.ObjectPath + "." + AddChildRow.ObjectName;
		SetCurrentRights(AddChildRow, StrData);
	EndDo;
	AddChildRows.ObjectSubtype = ObjectSubtype;
	AddChildRows.ObjectName = StrData.DataType;
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + StrData.DataType];
EndProcedure

Procedure AddChildTab(Val StrData)
	If NOT StrData.MetaItem[StrData.DataType].Count() Then
		Return;
	EndIf;
	
	AddChildRows = StrData.MetaItemRow.Rows.Add();
	ObjectSubtypeName = Left(StrData.DataType, StrLen(StrData.DataType) - 1);
	ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectSubtypeName];
	Picture = StrData.PictureLibData["Roles_" + StrData.DataType];
	PictureAttributes = StrData.PictureLibData["Roles_Attributes"];
	AddChildRows.ObjectPath = StrData.MetaItemRow.ObjectPath + "." + ObjectSubtypeName;
	For Each AddChild In StrData.MetaItem[StrData.DataType] Do
		
		If NOT isNative(AddChild) Then
			Continue;
		EndIf;
		
		AddChildRow = AddChildRows.Rows.Add();
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.ObjectFullName = AddChild.Name;	
		AddChildRow.Picture = Picture;
		AddChildRow.ObjectSubtype = ObjectSubtype;
		
		If AddChildRows.ObjectFullName = "" Then
			NamePart = StrSplit(AddChild.FullName(), ".");
			AddChildRows.ObjectFullName = NamePart[2];
		EndIf;
		
		AddChildRow.ObjectPath = AddChildRows.ObjectPath + "." + AddChildRow.ObjectName;
		SetCurrentRights(AddChildRow, StrData);
		
		For Each AddChildAttribute In AddChild.Attributes Do
			If NOT isNative(AddChildAttribute) Then
				Continue;
			EndIf;
			
			AddChildNewRow = AddChildRow.Rows.Add();
			AddChildNewRow.ObjectName = AddChildAttribute.Name;
			AddChildNewRow.ObjectFullName = AddChildAttribute.Name;
			AddChildNewRow.Picture = PictureAttributes;
			AddChildNewRow.ObjectSubtype = ObjectSubtype;
			
			// read data from object
			
			AddChildNewRow.ObjectPath = AddChildRow.ObjectPath + ".Attribute." + 
							AddChildNewRow.ObjectName;
			SetCurrentRights(AddChildNewRow, StrData);

		EndDo;
	EndDo;
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + StrData.DataType];
	AddChildRows.ObjectName = StrData.DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
EndProcedure

Procedure AddChildStandardTab(Val StrData)
	AddChildRows = StrData.MetaItemRow.Rows.Add();
	AddChildRows.ObjectFullName = "StandardTabularSection";
	ObjectSubtypeName = Left(StrData.DataType, StrLen(StrData.DataType) - 1);
	ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectSubtypeName];
	AddChildRows.ObjectPath = StrData.MetaItemRow.ObjectPath + "." + ObjectSubtype;
	For Each AddChild In StrData.MetaItem[StrData.DataType] Do
		AddChildRow = AddChildRows.Rows.Add();
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.ObjectFullName = AddChild.Name;
		AddChildRow.Picture = StrData.PictureLibData["Roles_" + StrData.DataType];
		AddChildRow.ObjectSubtype = ObjectSubtype;
		
		AddChildRow.ObjectPath = AddChildRows.ObjectPath + "." + AddChildRow.ObjectName;
		SetCurrentRights(AddChildRow, StrData);
		
		For Each AddChildAttribute In AddChild.StandardAttributes Do
			AddChildNewRow = AddChildRow.Rows.Add();
			AddChildNewRow.ObjectName = AddChildAttribute.Name;
			AddChildNewRow.ObjectFullName = AddChildAttribute.Name;	
			AddChildNewRow.Picture = StrData.PictureLibData["Roles_StandardAttributes"];
			AddChildNewRow.ObjectSubtype = ObjectSubtype;
			
			// read data from object
			
			AddChildNewRow.ObjectPath = AddChildRow.ObjectPath + ".Attribute." + 
							AddChildNewRow.ObjectName;
			SetCurrentRights(AddChildNewRow, StrData);

		EndDo;	
	EndDo;
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + StrData.DataType];
	AddChildRows.ObjectName = StrData.DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
EndProcedure

Function CurrentRights(DataTables)
	RightMap = New Map;
	
	TempVT = DataTables.RightTable.Copy();
	TempVT.GroupBy("ObjectPath");
	For Each RowVT In TempVT Do
		RightsStructure = New Structure;
		FindRows = DataTables.RightTable.FindRows(New Structure("ObjectPath, Disable", RowVT.ObjectPath, False));
		For Each Row In FindRows Do			
			RightValue = New Structure;
			RightValue.Insert("Value", Row.RightValue);
			RightValue.Insert("RowID", Row.RowID);
			RightValue.Insert("RLSisEmpty", DataTables.RestrictionByCondition.FindRows(New Structure("RowID", Row.RowID)).Count());
			RightsStructure.Insert(Roles_Settings.MetaName(Row.RightName), RightValue);
		EndDo;
		RightMap.Insert(RowVT.ObjectPath, RightsStructure);
	EndDo;
	Return RightMap;
EndFunction

Procedure SetCurrentRights(Row, StrData)
	
	RightData = StrData.RightsMap.Get(Row.ObjectPath);
	If RightData = Undefined Then
		Return;
	EndIf;
	
	For Each Data In RightData Do
		Row[Data.Key] = ?(Data.Value.Value, 1, 2);
	EndDo;

	If RightData.Property("Insert") Then
		Row.RLSInsertID = RightData.Insert.RowID;
		Row.RLSInsertIsEmpty = RightData.Insert.RLSisEmpty;
	EndIf;
	If RightData.Property("Read") Then
		Row.RLSReadID = RightData.Read.RowID;
		Row.RLSReadIsEmpty = RightData.Insert.RLSisEmpty;
	EndIf;
	If RightData.Property("Delete") Then
		Row.RLSDeleteID = RightData.Delete.RowID;
		Row.RLSDeleteIsEmpty = RightData.Insert.RLSisEmpty;
	EndIf;
	If RightData.Property("Update") Then
		Row.RLSUpdateID = RightData.Update.RowID;
		Row.RLSUpdateIsEmpty = RightData.Insert.RLSisEmpty;
	EndIf;

	Row.Edited = True;
	SetEditedInfo(Row);
EndProcedure

Procedure SetEditedInfo(Row)
	If Row.Parent = Undefined Then
		Return;
	EndIf;
	If Row.Parent.Edited Then
		Return;
	EndIf;
	Row.Parent.Edited = True;
	SetEditedInfo(Row.Parent);
EndProcedure


#Region Service
Function isNative(TestObject)
	
	Return TestObject.ObjectBelonging = Metadata.ObjectBelonging;

EndFunction


#EndRegion