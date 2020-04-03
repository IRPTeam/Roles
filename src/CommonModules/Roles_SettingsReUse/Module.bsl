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