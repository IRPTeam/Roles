Function MetaNameByRef(RefData) Export
	RefNameType = RefData.Metadata().Name;
	ValueIndex = Enums[RefNameType].IndexOf(RefData);
	Return Metadata.Enums[RefNameType].EnumValues[ValueIndex].Name;
EndFunction

Function PictureList() Export
	
	PictureLibData = New Structure;
	For Each Pic In Metadata.CommonPictures Do
		If NOT StrStartsWith(Pic.Name, "Roles_") Then
			Continue;
		EndIf;
		PictureLibData.Insert(Pic.Name, PictureLib[Pic.Name]);
	EndDo;	
	Return PictureLibData;

EndFunction

Function MetaRolesName() Export
	
	RolesData = New Structure;
	For Each Roles In Enums.Roles_Rights Do
		RolesData.Insert(Roles_Settings.MetaName(Roles), 2);
	EndDo;	
	Return RolesData;

EndFunction

Function ArrayForViewEdit() Export
	ArrayForViewEdit = New Array;
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.Attribute"));
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.TabularSection"));
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.StandardAttribute"));
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.Dimension"));
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.Resource"));
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.AccountingFlag"));
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.ExtDimensionAccountingFlag"));
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.AddressingAttribute"));
	ArrayForViewEdit.Add(PredefinedValue("Enum.Roles_MetadataSubtype.StandardTabularSection"));
	Return ArrayForViewEdit;
EndFunction

Function Skip(ObjectType, ObjectSubtype, RoleName) Export
	ArrayForViewEdit = Roles_SettingsReUse.ArrayForViewEdit();
	If NOT ObjectSubtype.isEmpty() Then
		If RoleName = "View" Then
			If ObjectSubtype = Enums.Roles_MetadataSubtype.Command
				OR NOT ArrayForViewEdit.Find(ObjectSubtype) = Undefined Then
				Return False;
			Else
				Return True;
			EndIf;
		ElsIf (RoleName = "Read" OR RoleName = "Update")
			AND ObjectSubtype = Enums.Roles_MetadataSubtype.Recalculation Then
			Return False;
		ElsIf RoleName = "Edit" 
			AND NOT ArrayForViewEdit.Find(ObjectSubtype) = Undefined Then
			Return False;
		Else	
			Return True;
		EndIf;
	Else
		If RoleName = "Edit" Then 
			If ObjectType = Enums.Roles_MetadataTypes.DataProcessor
				OR ObjectType = Enums.Roles_MetadataTypes.Report
				OR ObjectType = Enums.Roles_MetadataTypes.DocumentJournal Then
				Return True;
			Else 
				Return False;
			EndIf;
		Else	
			Return False;
		EndIf;
	EndIf;
	Return False;
EndFunction
