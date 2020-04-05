Function MetaNameByRef(RefData) Export
	RefNameType = RefData.Metadata().Name;
	ValueIndex = Enums[RefNameType].IndexOf(RefData);
	Return Metadata.Enums[RefNameType].EnumValues[ValueIndex].Name;
EndFunction

Function GetRefForAllLang(Name, XMLTypeRef = Undefined) Export
	If Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.English Then
		Return Enums.Roles_MetadataTypes[Name];
	Else
		If XMLTypeRef = Undefined Then
			Return Undefined;
		Else
			XMLParts = StrSplit(XMLTypeRef, "<.:", False);
			TypeName = XMLParts[XMLParts.UBound() - 1 - 1];
			TypeName = Left(TypeName, StrLen(TypeName) - 3);
			Return Enums.Roles_MetadataTypes[TypeName];
		EndIf;		
	EndIf;
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

Function MatrixTemplates() Export
	Return GetCommonTemplate("Roles_MatrixTemplate");
EndFunction

Function RoleTree() Export
	Return Roles_ServiceServer.DeserializeXML(GetCommonTemplate("Roles_RoleTree").GetText());
EndFunction

Function isMetadataExist(MetaName) Export
	ReturnValue = True;
	FoundedMetadata = Metadata.FindByFullName(MetaName);
	If FoundedMetadata = Undefined Then
		ReturnValue = False;
	EndIf;
	Return ReturnValue;
EndFunction

Function RightPictureByRef(RefData) Export
	If ValueIsFilled(RefData) Then
		Name = MetaNameByRef(RefData);
		Return New ValueStorage(PictureLib["Roles_right_" + Name].GetBinaryData());
	Else
		Return New ValueStorage(New Picture);
	EndIf;
		                       
EndFunction

Function TypeObjectPictureByRef(RefData) Export
	If ValueIsFilled(RefData) Then
		Name = MetaNameByRef(RefData);
		
		PictureList = Roles_SettingsReUse.PictureList();
		If PictureList.Property("Roles_" + Name) Then
			Return New ValueStorage(PictureList["Roles_" + Name].GetBinaryData());
		Else
			Return New ValueStorage(PictureList["Roles_" + Name + "s"].GetBinaryData());
		EndIf;
	Else
		Return New ValueStorage(New Picture);
	EndIf;
EndFunction

Function ObjectPathSubtype(Path, Type) Export
	If Not ValueIsFilled(Type) Then
		Return Path;
	EndIf;
	PartPath = StrSplit(Path, ".", False);
	If Type = Enums.Roles_MetadataSubtype.StandardTabularSection
		OR Type = Enums.Roles_MetadataSubtype.TabularSection Then
		Return PartPath[PartPath.UBound() - 1 - 1] + "." + PartPath[PartPath.UBound()];
	Else
		Return PartPath[PartPath.UBound()];
	EndIf;
EndFunction

