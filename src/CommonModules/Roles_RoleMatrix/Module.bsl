Function GenerateRoleMatrix(RoleTree, ObjectData, OnlyReport, OnlyFilled = True) Export
	
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
		
		If OnlyFilled Then
			If NOT ObjectData.RightTable.FindRows(New Structure("ObjectType, Disable", Meta, False)).Count() Then
				Continue;
			EndIf;
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

			If OnlyFilled Then
				If NOT ObjectData.RightTable.FindRows(New Structure("ObjectName, Disable", MetaItem.Name, False)).Count() Then
					Continue;
				EndIf;
			EndIf;

			
			EmptyData = False;
			
			Meta = MetaRow.ObjectType;
			
			MetaItemRow = MetaRow.Rows.Add();
			MetaItemRow.ObjectType = Meta;
			MetaItemRow.ObjectName = MetaItem.Name;
			MetaItemRow.ObjectFullName = MetaItem.Name;
			MetaItemRow.Picture = MetaRow.Picture;
			MetaItemRow.ObjectPath = MetaRow.ObjectPath + "." + MetaItemRow.ObjectFullName;

			addSubtypeRow(MetaItem, MetaItemRow, ParamStructure);

		EndDo;
		If EmptyData Then
			RoleTree.Rows.Delete(MetaRow);
		EndIf;
	EndDo;
	
	RoleTree.Rows.Sort("ObjectPath", True);
	
	TabDoc = New SpreadsheetDocument;
	TabDoc.ShowRowGroupLevel(1);
	TabDoc.Put(Roles_ServiceServer.HeadTemplate()); 
	FillTabDoc(TabDoc, RoleTree, ParamStructure);
	TabDoc.ShowHeaders = True;
	TabDoc.Put(Roles_ServiceServer.FooterTemplate()); 

	ReplaceTextInTabDoc(TabDoc, 1, "✔", New Color(0, 255, 0));
	ReplaceTextInTabDoc(TabDoc, 2, "❌", New Color(255, 0, 0));
	If OnlyReport Then
		RoleTree.Rows.Clear();
	EndIf;
	Return TabDoc;
EndFunction

Procedure addSubtypeRow(Val MetaItem, Val MetaItemRow, Val ParamStructure, Val FirstLvl = True)
	
	
	//ParamStructure.Insert("MetaItem", MetaItem);
	//ParamStructure.Insert("MetaItemRow", MetaItemRow);
	
	Meta = MetaItemRow.ObjectType;
	
	SetCurrentRights(MetaItemRow, ParamStructure);			
	
	If Roles_Settings.hasAttributes(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Attributes", ParamStructure);
	EndIf;
	If Roles_Settings.hasDimensions(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Dimensions", ParamStructure);
	EndIf;
	If Roles_Settings.hasResources(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Resources", ParamStructure);
	EndIf;
	If Roles_Settings.hasStandardAttributes(Meta) Then
		AddChild(MetaItem, MetaItemRow, "StandardAttributes", ParamStructure);
	EndIf;
	If Roles_Settings.hasCommands(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Commands", ParamStructure);
	EndIf;			
	If Roles_Settings.hasRecalculations(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Recalculations", ParamStructure);
	EndIf;
	If Roles_Settings.hasAccountingFlags(Meta) Then
		AddChild(MetaItem, MetaItemRow, "AccountingFlags", ParamStructure);
	EndIf;
	If Roles_Settings.hasExtDimensionAccountingFlags(Meta) Then
		AddChild(MetaItem, MetaItemRow, "ExtDimensionAccountingFlags", ParamStructure);
	EndIf;
	If Roles_Settings.hasAddressingAttributes(Meta) Then
		AddChild(MetaItem, MetaItemRow, "AddressingAttributes", ParamStructure);
	EndIf;
	If Roles_Settings.hasTabularSections(Meta) Then
		AddChildTab(MetaItem, MetaItemRow, "TabularSections", ParamStructure);
	EndIf;
	If Roles_Settings.hasStandardTabularSections(Meta) Then
		AddChildStandardTab(MetaItem, MetaItemRow, "StandardTabularSections", ParamStructure);
	EndIf;
	If Roles_Settings.isSubsystem(Meta) Then
		AddChildSubsystem(MetaItem, MetaItemRow, "Subsystems", ParamStructure);
	EndIf;
	If Roles_Settings.hasOperations(Meta) Then
		AddChildOperations(MetaItem, MetaItemRow, "Operations", ParamStructure);
	EndIf;
	If Roles_Settings.hasURLTemplates(Meta) Then
		AddChildURLTemplates(MetaItem, MetaItemRow, "URLTemplates",ParamStructure);
	EndIf;
	If Roles_Settings.hasTables(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Tables", ParamStructure);
	EndIf;
	If Roles_Settings.hasCubes(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Cubes", ParamStructure);
	EndIf;
	If Roles_Settings.hasFields(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Fields", ParamStructure);
	EndIf;
	If Roles_Settings.hasFunctions(Meta) Then
		AddChild(MetaItem, MetaItemRow, "Functions", ParamStructure);
	EndIf;
	If Roles_Settings.hasDimensionTables(Meta) Then
		AddChild(MetaItem, MetaItemRow, "DimensionTables", ParamStructure);
	EndIf;
	

EndProcedure


Procedure ReplaceTextInTabDoc(TabDoc, Find, Replace, Color)
	Var AreaToReplace;
	AreaToReplace = TabDoc.FindText(Find, , , , True);
	While NOT AreaToReplace = Undefined Do
		AreaToReplace.Text = Replace;
		AreaToReplace.BackColor = Color;
		AreaToReplace = TabDoc.FindText(Find, , , , True);
	EndDo;
EndProcedure


Procedure FillTabDoc(TabDoc, RoleTree, ParamStructure)
	For Each Row In RoleTree.Rows Do
		
		TabRow = Roles_ServiceServer.RowTemplate();
			
		TabRow.Parameters.Fill(Row);
		TabRow.Area(1, 2).Picture = Row.Picture;
		TabRow.Area(1, 2).Indent = Row.Level();

		TabDoc.Put(TabRow, , , False);
		
		TabDoc.StartRowGroup(, False);
		RLSExist = Row.RLSInsertFilled OR Row.RLSReadFilled 
			OR Row.RLSDeleteFilled OR Row.RLSUpdateFilled;
		
		If RLSExist Then
			TabRowRLS = Roles_ServiceServer.RowTemplate();
			TabRowRLS.Area(1, 2).Picture = PictureLib.Roles_rls_blank;
			TabRowRLS.Area(1, 2).Indent = Row.Level() + 1;
			TabRowRLS.Parameters.ObjectFullName = "RLS";
			TabDoc.Put(TabRowRLS, , , False);
			TabDoc.StartRowGroup(, False);
			If Row.RLSInsertFilled Then
				TabRow.Area(1, 4).Comment.Text = ?(Row.RLSInsertFilled, "RLS", "");
				FillTabDocRLS(ParamStructure, TabDoc, "Insert", Row.RLSInsertID);
			EndIf;
			If Row.RLSReadFilled Then
				TabRow.Area(1, 3).Comment.Text = ?(Row.RLSReadFilled  , "RLS", "");
				FillTabDocRLS(ParamStructure, TabDoc, "Read", Row.RLSReadID);
			EndIf;
			If Row.RLSDeleteFilled Then
				TabRow.Area(1, 6).Comment.Text = ?(Row.RLSDeleteFilled, "RLS", "");
				FillTabDocRLS(ParamStructure, TabDoc, "Delete", Row.RLSDeleteID);
			EndIf;
			If Row.RLSUpdateFilled Then
				TabRow.Area(1, 5).Comment.Text = ?(Row.RLSUpdateFilled, "RLS", "");
				FillTabDocRLS(ParamStructure, TabDoc, "Update", Row.RLSUpdateID);
			EndIf;
			TabDoc.EndRowGroup();
		
		EndIf;		
		FillTabDoc(TabDoc, Row, ParamStructure);
		TabDoc.EndRowGroup();
	EndDo;
	
EndProcedure

Procedure FillTabDocRLS(Val ParamStructure, TabDoc, Name, RowID)
	For Each RLSRow In ParamStructure.ObjectData.RestrictionByCondition.FindRows(New Structure("RowID", RowID)) Do
		TabRowRLS = Roles_ServiceServer.RLSTemplate();
		TabRowRLS.Area(1, 2).Picture = PictureLib.Roles_rls_blank;
		TabRowRLS.Area(1, 2).Indent = 3;
		TabRowRLS.Parameters.RLSName = Name;
		TabRowRLS.Parameters.Fields = RLSRow.Fields;
		TabRowRLS.Parameters.Condition = RLSRow.Condition;
		TabDoc.Put(TabRowRLS, , , False);
	EndDo;

EndProcedure

#Region AddChilds

Procedure AddChildOperations(MetaItem, MetaItemRow, DataType, Val StrData)
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	
	ObjectSubtype = Enums.Roles_MetadataSubtype[
			Left(DataType, StrLen(DataType) - 1)];
	Picture = StrData.PictureLibData["Roles_" + ObjectSubtype];
	For Each AddChild In MetaItem[DataType] Do
		
		If NOT isNative(AddChild) Then
			Continue;
		EndIf;
		
		AddChildRow = MetaItemRow.Rows.Add();
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.ObjectFullName = AddChild.Name;	
		AddChildRow.Picture = Picture;
		AddChildRow.ObjectSubtype = ObjectSubtype;
				
		AddChildRow.ObjectPath = MetaItemRow.ObjectPath + ".Operation." + AddChildRow.ObjectName;
		SetCurrentRights(AddChildRow, StrData);
	EndDo;
EndProcedure

Procedure AddChildURLTemplates(MetaItem, MetaItemRow, DataType, Val StrData)
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	
	AddChildRows = MetaItemRow.Rows.Add();
	ObjectSubtype = Enums.Roles_MetadataSubtype[Left(DataType, StrLen(DataType) - 1)];
	PictureMethod = StrData.PictureLibData["Roles_Method"];
	AddChildRows.ObjectPath = MetaItemRow.ObjectPath + "." + ObjectSubtype;
	For Each AddChild In MetaItem[DataType] Do
		
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
	AddChildRows.ObjectName = DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
EndProcedure

Procedure AddChildSubsystem(MetaItem, MetaItemRow, DataType, Val StrData)

	
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	ObjectSubtypeName = Left(DataType, StrLen(DataType) - 1);
	Picture = StrData.PictureLibData["Roles_Subsystem"];
	For Each AddChild In MetaItem[DataType] Do
		
		If NOT isNative(AddChild) Then
			Continue;
		EndIf;
		
		AddChildRow = MetaItemRow.Rows.Add();		
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.Picture = Picture;
		AddChildRow.ObjectFullName = AddChild.Name;
		AddChildRow.ObjectType = StrData.Meta;		
		// read data from object
		If MetaItemRow.ObjectPath = "" Then
			AddChildRow.ObjectPath = ObjectSubtypeName + "." + AddChildRow.ObjectName;
		Else
			AddChildRow.ObjectPath = MetaItemRow.ObjectPath + "." + 
					ObjectSubtypeName + "." + AddChildRow.ObjectName;
		EndIf;
		SetCurrentRights(AddChildRow, StrData);
		
		MetaItem = AddChild;
		AddChildSubsystem(MetaItem, MetaItemRow, "Subsystems", StrData);
	EndDo;
EndProcedure

Procedure AddChild(MetaItem, MetaItemRow, DataType, Val StrData)

	
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	
	ObjectSubtypeName = Left(DataType, StrLen(DataType) - 1);
	ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectSubtypeName];
	
	AddChildRows = MetaItemRow.Rows.Add();
	AddChildRows.ObjectPath = MetaItemRow.ObjectPath + "." + ObjectSubtypeName;
	Picture = StrData.PictureLibData["Roles_" + DataType];
	For Each AddChild In MetaItem[DataType] Do
		
		If NOT DataType = "StandardAttributes" 
			AND NOT isNative(AddChild) Then
			Continue;
		EndIf;
		
		AddChildRow = AddChildRows.Rows.Add();
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.Picture = Picture;
		AddChildRow.ObjectFullName = AddChild.Name;
		AddChildRow.ObjectSubtype = ObjectSubtype;
		
		// read data from object
		
		AddChildRow.ObjectPath = AddChildRows.ObjectPath + "." + AddChildRow.ObjectName;
		SetCurrentRights(AddChildRow, StrData);
		
		If ObjectSubtype = Enums.Roles_MetadataSubtype.Table
			OR ObjectSubtype = Enums.Roles_MetadataSubtype.Cube
			OR ObjectSubtype = Enums.Roles_MetadataSubtype.DimensionTable Then
			AddChildRow.ObjectType = ObjectSubtype;
			addSubtypeRow(AddChild, AddChildRow, StrData, False);
		EndIf;
		
	EndDo;
	If DataType = "StandardAttributes" Then		
		If AddChildRows.ObjectFullName = "" Then
			AddChildRows.ObjectFullName = "StandardAttribute";
		EndIf;
	Else	
		If AddChildRows.ObjectFullName = "" Then
			NamePart = StrSplit(AddChild.FullName(), ".");
			AddChildRows.ObjectFullName = NamePart[NamePart.UBound() - 1];
		EndIf;
	EndIf;
	AddChildRows.ObjectSubtype = ObjectSubtype;
	AddChildRows.ObjectName = DataType;
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + DataType];
EndProcedure

Procedure AddChildTab(MetaItem, MetaItemRow, DataType, Val StrData)
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	
	AddChildRows = MetaItemRow.Rows.Add();
	ObjectSubtypeName = Left(DataType, StrLen(DataType) - 1);
	ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectSubtypeName];
	Picture = StrData.PictureLibData["Roles_" + DataType];
	PictureAttributes = StrData.PictureLibData["Roles_Attributes"];
	AddChildRows.ObjectPath = MetaItemRow.ObjectPath + "." + ObjectSubtypeName;
	For Each AddChild In MetaItem[DataType] Do
		
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
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + DataType];
	AddChildRows.ObjectName = DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
EndProcedure

Procedure AddChildStandardTab(MetaItem, MetaItemRow, DataType, Val StrData)
	AddChildRows = MetaItemRow.Rows.Add();
	AddChildRows.ObjectFullName = "StandardTabularSection";
	ObjectSubtypeName = Left(DataType, StrLen(DataType) - 1);
	ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectSubtypeName];
	AddChildRows.ObjectPath = MetaItemRow.ObjectPath + "." + ObjectSubtype;
	For Each AddChild In MetaItem[DataType] Do
		AddChildRow = AddChildRows.Rows.Add();
		AddChildRow.ObjectName = AddChild.Name;
		AddChildRow.ObjectFullName = AddChild.Name;
		AddChildRow.Picture = StrData.PictureLibData["Roles_" + DataType];
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
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + DataType];
	AddChildRows.ObjectName = DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
EndProcedure

#EndRegion

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
			RightValue.Insert("RLSFilled", DataTables.RestrictionByCondition.FindRows(New Structure("RowID", Row.RowID)).Count() > 0);
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
		Row.RLSInsertFilled = RightData.Insert.RLSFilled;
	EndIf;
	If RightData.Property("Read") Then
		Row.RLSReadID = RightData.Read.RowID;
		Row.RLSReadFilled = RightData.Read.RLSFilled;
	EndIf;
	If RightData.Property("Delete") Then
		Row.RLSDeleteID = RightData.Delete.RowID;
		Row.RLSDeleteFilled = RightData.Delete.RLSFilled;
	EndIf;
	If RightData.Property("Update") Then
		Row.RLSUpdateID = RightData.Update.RowID;
		Row.RLSUpdateFilled = RightData.Update.RLSFilled;
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