#Region Internal
Function GenerateRoleMatrix(RoleTree, ObjectData, OnlyReport, OnlyFilled = True) Export
	
	RightsMap = CurrentRights(ObjectData);
	PictureLibData = Roles_SettingsReUse.PictureList();
	
	ParamStructure = New Structure;
	ParamStructure.Insert("PictureLibData", PictureLibData);
	ParamStructure.Insert("RightsMap", RightsMap);
	ParamStructure.Insert("ObjectData", ObjectData);
	ParamStructure.Insert("OnlyFilled", OnlyFilled);
	ParamStructure.Insert("OnlyReport", OnlyReport);
	For Each Meta In Enums.Roles_MetadataTypes Do
		SkipMeta =  Meta = Enums.Roles_MetadataTypes.IntegrationService // wait 8.3.17
			OR Meta = Enums.Roles_MetadataTypes.Role
			OR Meta = Enums.Roles_MetadataTypes.Enum
			OR Meta = Enums.Roles_MetadataTypes.Language;
		If SkipMeta Then 
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
			MetaRow.ObjectPath = MetaRow.ObjectPath + "." + Metadata.Name;
			SetCurrentRights(MetaRow, ParamStructure);
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
		Else
			CulculateTopLvlStatus(MetaRow);
		EndIf;
		
		
	EndDo;
	
	RoleTree.Rows.Sort("ObjectPath", True);
	
	TabDoc = New SpreadsheetDocument;
	TabDoc.ShowRowGroupLevel(1);
	HeadTemplate = Roles_ServiceServer.HeadTemplate();
	For Each Roles_Right In Metadata.Enums.Roles_Rights.EnumValues Do
		HeadTemplate.Parameters[Roles_Right.Name] = Enums.Roles_Rights[Roles_Right.Name];
	EndDo;
	TabDoc.Put(HeadTemplate); 
	FillTabDoc(TabDoc, RoleTree, ParamStructure);
	TabDoc.ShowHeaders = True;
	TabDoc.Put(Roles_ServiceServer.FooterTemplate()); 

	ReplaceTextInTabDoc(TabDoc, 1, "✔", New Color(0, 255, 0));
	ReplaceTextInTabDoc(TabDoc, 2, "❌", New Color(255, 0, 0));
	ReplaceTextInTabDoc(TabDoc, 3, "✔", New Color(255, 255, 0));
	
	ReplaceTextInTabDoc(TabDoc, 11, "✅", New Color(0, 255, 0));
	ReplaceTextInTabDoc(TabDoc, 22, "❎", New Color(255, 0, 0));
	ReplaceTextInTabDoc(TabDoc, 33, "✅", New Color(255, 255, 0));

	If OnlyReport Then
		RoleTree.Rows.Clear();
	EndIf;
	TabDoc.FixedLeft = 2;
	TabDoc.FixedTop = 1;
	Return TabDoc;
EndFunction
#EndRegion

#Region Private
Procedure CulculateTopLvlStatus(Val MetaRow)
	
	Var Right, SetFalse, SetTrue;
	
	For Each Right In Metadata.Enums.Roles_Rights.EnumValues Do
		If Not MetaRow.Rows.Total(Right.Name) Then
			Continue;
		EndIf;
		
		SetTrue = MetaRow.Rows.FindRows(New Structure(Right.Name, 1)).Count();
		SetFalse = MetaRow.Rows.FindRows(New Structure(Right.Name, 2)).Count();
		
		If SetTrue = MetaRow.Rows.Count() Then
			MetaRow[Right.Name] = 1;
		ElsIf SetFalse = MetaRow.Rows.Count() Then
			MetaRow[Right.Name] = 2;
		Else	
			MetaRow[Right.Name] = 3;
		EndIf;
		
	EndDo;

EndProcedure

Procedure addSubtypeRow(Val MetaItem, Val MetaItemRow, Val ParamStructure)
	
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
		AddChildURLTemplates(MetaItem, MetaItemRow, "URLTemplates", ParamStructure);
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
		AreaToReplace = TabDoc.FindText(Find, AreaToReplace, , , True);
	EndDo;
EndProcedure

Procedure FillTabDoc(TabDoc, RoleTree, ParamStructure)
	For Each Row In RoleTree.Rows Do			
		TabRow = Roles_ServiceServer.RowTemplate();
			
		TabRow.Parameters.Fill(Row);
		TabRow.Area(1, 2).Picture = Row.Picture;
		TabRow.Area(1, 2).Indent = Row.Level();
		
		If Not ParamStructure.RightsMap.Get(Row.ObjectPath) = Undefined Then
			For Each Right In ParamStructure.RightsMap.Get(Row.ObjectPath) Do
				If Right.Value.Count() > 1 Then
					TabRow.Parameters[Right.Key] = "" + TabRow.Parameters[Right.Key] + TabRow.Parameters[Right.Key];
				EndIf; 
			EndDo;
		EndIf;
		
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
			
			FillTabDocRLS(ParamStructure, TabDoc, "Insert", Row.RLSInsertID, Row.RLSInsertFilled, Row);
			FillTabDocRLS(ParamStructure, TabDoc, "Read", 	Row.RLSReadID, 	Row.RLSReadFilled, Row);
			FillTabDocRLS(ParamStructure, TabDoc, "Delete", Row.RLSDeleteID, Row.RLSDeleteFilled, Row);
			FillTabDocRLS(ParamStructure, TabDoc, "Update", Row.RLSUpdateID, Row.RLSUpdateFilled, Row);

			TabDoc.EndRowGroup();
		
		EndIf;		
		FillTabDoc(TabDoc, Row, ParamStructure);
		TabDoc.EndRowGroup();
	EndDo;
	
EndProcedure

Procedure FillTabDocRLS(Val ParamStructure, TabDoc, Name, RowIDList, RLSFilled, Row)
	If Not RLSFilled = 0 Then
		RowIDArray = StrSplit(RowIDList, ";", False);
		For Each RowID In RowIDArray Do
			For Each RLSRow In ParamStructure.ObjectData.RestrictionByCondition.FindRows(New Structure("RowID", RowID)) Do				
				TabRowRLS = Roles_ServiceServer.RLSTemplate();
				TabRowRLS.Area(1, 2).Picture = PictureLib.Roles_rls_blank;
				TabRowRLS.Area(1, 2).Indent = 3;
				TabRowRLS.Parameters.RLSName = Name + Chars.LF + RLSRow.Ref;
				If RLSFilled = -1 Then
					TabRowRLS.Area(1, 2).Font = New Font(, , , , , True);
				EndIf;
				TabRowRLS.Parameters.Fields = RLSRow.Fields;
				TabRowRLS.Parameters.Condition = RLSRow.Condition;
				TabRowRLS.Parameters.ObjectPath = Row.ObjectPath;
				TabDoc.Put(TabRowRLS, , , False);
			EndDo;
		EndDo;
	EndIf;

EndProcedure

#Region AddChilds

Procedure AddChildOperations(MetaItem, MetaItemRow, DataType, Val StrData)
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	
	ObjectSubtype = Enums.Roles_MetadataSubtype[
			Left(DataType, StrLen(DataType) - 1)];
	Picture = StrData.PictureLibData["Roles_" + Roles_SettingsReUse.MetaNameByRef(ObjectSubtype)];
	
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
		
		If NOT AddChildRow.Edited AND StrData.OnlyFilled Then
			MetaItemRow.Rows.Delete(AddChildRow);								
		EndIf;
	EndDo;
EndProcedure

Procedure AddChildURLTemplates(MetaItem, MetaItemRow, DataType, Val StrData)
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	
	AddChildRows = MetaItemRow.Rows.Add();
	ObjectSubtype = Enums.Roles_MetadataSubtype[Left(DataType, StrLen(DataType) - 1)];
	PictureMethod = StrData.PictureLibData.Roles_Method;
	AddChildRows.ObjectPath = MetaItemRow.ObjectPath + "." + Roles_SettingsReUse.MetaNameByRef(ObjectSubtype);
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
			
			If NOT AddChildNewRow.Edited AND StrData.OnlyFilled Then
				AddChildRows.Rows.Delete(AddChildNewRow);								
			EndIf;

		EndDo;
		
	EndDo;
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + Roles_Settings.MetaName(ObjectSubtype)];
	AddChildRows.ObjectName = DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
	
	If NOT AddChildRows.Edited AND StrData.OnlyFilled Then
		MetaItemRow.Rows.Delete(AddChildRows);								
	EndIf;

EndProcedure

Procedure AddChildSubsystem(MetaItem, MetaItemRow, DataType, Val StrData)

	
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	ObjectSubtypeName = Left(DataType, StrLen(DataType) - 1);
	Picture = StrData.PictureLibData.Roles_Subsystem;
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
		
		If NOT AddChildRow.Edited AND StrData.OnlyFilled Then
			MetaItemRow.Rows.Delete(AddChildRow);								
		EndIf;
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
		If NOT DataType = "StandardAttributes" Then
			AddChildRow.ObjectPath = AddChildRows.ObjectPath + "." + AddChildRow.ObjectName;
		Else
			AddChildRow.ObjectPath = AddChildRows.ObjectPath + "." + Roles_SettingsReUse.TranslationList(AddChildRow.ObjectName);
		EndIf;
		SetCurrentRights(AddChildRow, StrData);
		
		If ObjectSubtype = Enums.Roles_MetadataSubtype.Table
			OR ObjectSubtype = Enums.Roles_MetadataSubtype.Cube
			OR ObjectSubtype = Enums.Roles_MetadataSubtype.DimensionTable Then
			AddChildRow.ObjectType = ObjectSubtype;
			addSubtypeRow(AddChild, AddChildRow, StrData);
		EndIf;
		If NOT AddChildRow.Edited AND StrData.OnlyFilled Then
			AddChildRows.Rows.Delete(AddChildRow);								
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
	
	If NOT AddChildRows.Edited AND StrData.OnlyFilled Then
		MetaItemRow.Rows.Delete(AddChildRows);
	Else
		CulculateTopLvlStatus(AddChildRows);
	EndIf;

	
EndProcedure

Procedure AddChildTab(MetaItem, MetaItemRow, DataType, Val StrData)
	If NOT MetaItem[DataType].Count() Then
		Return;
	EndIf;
	
	AddChildRows = MetaItemRow.Rows.Add();
	ObjectSubtypeName = Left(DataType, StrLen(DataType) - 1);
	ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectSubtypeName];
	Picture = StrData.PictureLibData["Roles_" + DataType];
	PictureAttributes = StrData.PictureLibData.Roles_Attributes;
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
			AddChildNewRow.ObjectSubtype = Enums.Roles_MetadataSubtype.Attribute;
			
			// read data from object
			
			AddChildNewRow.ObjectPath = AddChildRow.ObjectPath + ".Attribute." + 
							AddChildNewRow.ObjectName;
			If Not AddChildNewRow.Edited AND StrData.OnlyFilled Then
				AddChildRow.Rows.Delete(AddChildNewRow);								
			EndIf;
		EndDo;
		If Not AddChildRow.Edited AND StrData.OnlyFilled Then
			AddChildRows.Rows.Delete(AddChildRow);								
		EndIf;
	EndDo;
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + DataType];
	AddChildRows.ObjectName = DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
	
	If Not AddChildRows.Edited AND StrData.OnlyFilled Then
		MetaItemRow.Rows.Delete(AddChildRows);
	Else
		CulculateTopLvlStatus(AddChildRows);
	EndIf;
EndProcedure

Procedure AddChildStandardTab(MetaItem, MetaItemRow, DataType, Val StrData)
	AddChildRows = MetaItemRow.Rows.Add();
	AddChildRows.ObjectFullName = "StandardTabularSection";
	ObjectSubtypeName = Left(DataType, StrLen(DataType) - 1);
	ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectSubtypeName];
	AddChildRows.ObjectPath = MetaItemRow.ObjectPath + "." + Roles_SettingsReUse.MetaNameByRef(ObjectSubtype);
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
			AddChildNewRow.Picture = StrData.PictureLibData.Roles_StandardAttributes;
			AddChildNewRow.ObjectSubtype = Enums.Roles_MetadataSubtype.Attribute;
			
			// read data from object
			
			AddChildNewRow.ObjectPath = AddChildRow.ObjectPath + ".Attribute." + 
							Roles_SettingsReUse.TranslationList(AddChildNewRow.ObjectName);
			If Not AddChildNewRow.Edited AND StrData.OnlyFilled Then
				AddChildRow.Rows.Delete(AddChildNewRow);								
			EndIf;
		EndDo;
		If Not AddChildRow.Edited AND StrData.OnlyFilled Then
			AddChildRows.Rows.Delete(AddChildRow);								
		EndIf;
	EndDo;
	AddChildRows.Picture = StrData.PictureLibData["Roles_" + DataType];
	AddChildRows.ObjectName = DataType;
	AddChildRows.ObjectSubtype = ObjectSubtype;
	If Not AddChildRows.Edited AND StrData.OnlyFilled Then
		MetaItemRow.Rows.Delete(AddChildRows);		
	Else
		CulculateTopLvlStatus(AddChildRows);
	EndIf;
EndProcedure

#EndRegion

Function CurrentRights(DataTables)
	RightMap = New Map;
	
	TempVT = DataTables.RightTable.Copy();
	TempVT.Indexes.Add();
	TempVT.GroupBy("ObjectPath");
	For Each RowVT In TempVT Do
		
		FindRows = DataTables.RightTable.FindRows(New Structure("ObjectPath, Disable", RowVT.ObjectPath, False));
		RightsStructure = New Structure;
		For Each Row In FindRows Do	
			CurrentRightStructure = Undefined;
			If Not RightsStructure.Property(Roles_Settings.MetaName(Row.RightName), CurrentRightStructure) Then
				RightsStructure.Insert(Roles_Settings.MetaName(Row.RightName), New Array);			
			EndIf;
			
			RightValue = New Structure;
			RightValue.Insert("Value", Row.RightValue);
			RightValue.Insert("RowID", Row.RowID);
			
			RLSFilter = New Structure("Ref, RowID", Row.Ref, Row.RowID);
			RLSFilled = DataTables.RestrictionByCondition.FindRows(RLSFilter).Count();
			
			RightValue.Insert("RLSFilled", RLSFilled);
			
			
			RightsStructure[Roles_Settings.MetaName(Row.RightName)].Add(RightValue);

		EndDo;
		
		RightMap.Insert(RowVT.ObjectPath, RightsStructure);
	EndDo;
	Return RightMap;
EndFunction

Procedure SetCurrentRights(Row, StrData)
	
	RightDataArray = StrData.RightsMap.Get(Row.ObjectPath);
	If RightDataArray = Undefined Then
		Return;
	EndIf;
	For Each RightData In RightDataArray Do
		For Each Data In RightData.Value Do
			isRLS = RightData.Key = "Read" 	 Or RightData.Key = "Insert" 
				 Or RightData.Key = "Delete" Or RightData.Key = "Update";
			If isRLS Then
				FillRLSData(Row, Data,  RightData.Key);
			EndIf;
			
			If Row[RightData.Key] = 1 Then
				Continue;
			EndIf;
			Row[RightData.Key] = ?(Data.Value, 1, 2);

		EndDo;
	

	EndDo;
		
	Row.Edited = True;
	SetEditedInfo(Row);
EndProcedure


Procedure FillRLSData(Row, RightData, Name)
	
	FirstStep = IsBlankString(Row["RLS" + Name + "ID"]);
	Row["RLS" + Name + "ID"] = RightData.RowID + ";" + Row["RLS" + Name + "ID"];
	
	If Row["RLS" + Name + "Filled"] = -1 Then
		Return;
	EndIf;
	// 0 - have no RLS
	// 1 - All RLS is active
	// -1 - some role give full access to object
	If Not RightData.RLSFilled Then
		Row["RLS" + Name + "Filled"] = -1;
	ElsIf RightData.RLSFilled Then
		Row["RLS" + Name + "Filled"] = 1;
	EndIf;	
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
	
	Return TestObject.ConfigurationExtension() = Undefined;

EndFunction
#EndRegion

#EndRegion