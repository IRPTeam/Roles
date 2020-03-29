Procedure UpdateRoleExt() Export
	Path = TempFilesDir() + "TemplateDB";
	DeleteFiles(Path);
	
	TemplateDB = GetCommonTemplate("Roles_TemplateDB").OpenStreamForRead();
	Zip = New ZipFileReader(TemplateDB);
	Zip.ExtractAll(Path);
	Zip.Close();
	TemplateDB.Close();

	// unload to xml
	CommandToUploadExt = """" + BinDir() + "1cv8.exe"" designer /f " + Path + 
			" /DumpConfigToFiles " + Path + "\Ext -Extension AccessRoles /DumpResult " + Path + 
			"\Event.log /DisableStartupMessages /DisableStartupDialogs";
	RunApp(CommandToUploadExt, , True);
	DeleteFiles(Path + "\Ext\ConfigDumpInfo.xml");
	
	UpdateRoleExt_ConfigurationXML(Path + "\Ext\");
	
	UpdateRoleExt_CreateRolesXML(Path + "\Ext\Roles\");
	
	
	// load from xml to db
	CommandToUploadExt = """" + BinDir() + "1cv8.exe"" designer /f " + Path + 
			" /LoadConfigFromFiles " + Path + "\Ext -Extension AccessRoles /DumpResult " + Path + 
			"\Event.log /DisableStartupMessages /DisableStartupDialogs";
	RunApp(CommandToUploadExt, , True);
	
	// upload from db to cfe
	CommandToUploadExt = """" + BinDir() + "1cv8.exe"" designer /f " + Path + 
			" /DumpCfg " + Path + "\AccessRoles.cfe -Extension AccessRoles /DumpResult " + Path + 
			"\Event.log /DisableStartupMessages /DisableStartupDialogs";
	RunApp(CommandToUploadExt, , True);
	
	// load cfe to cuurent db
	BD = New BinaryData(Path + "\AccessRoles.cfe");
	InstallExtention("AccessRoles", BD, True);
//	DeleteFiles(Path);
	
EndProcedure

Procedure UpdateRoleExt_CreateRolesXML(Path)

	Query = New Query;
	Query.Text =
		"SELECT DISTINCT
		|	""AccRoles_"" + Roles_AccessRoles.Description AS RoleName,
		|	Roles_AccessRoles.Ref AS Ref
		|FROM
		|	Catalog.Roles_AccessRoles AS Roles_AccessRoles
		|WHERE
		|	NOT Roles_AccessRoles.ConfigRoles
		|	AND
		|	NOT Roles_AccessRoles.DeletionMark";
	
	RolesList = Query.Execute().Unload();
	RoleTemplate = UpdateRoleExt_CreateRolesXML_RolesTemplate(Path);
	RightTemplate = UpdateRoleExt_CreateRolesXML_ReadRole(Path);
	
	For Each Row In RolesList Do
		RoleData = RoleTemplate;
		RoleData = StrTemplate(RoleData, Row.Ref.UUID(), Row.RoleName);
		
		TextWriter = New TextWriter(Path + Row.RoleName + ".xml", TextEncoding.UTF8);
		TextWriter.Write(RoleData);
		TextWriter.Close();		
		
		RoleData = UpdateRoleExt_CreateRolesXML_RoleData(RightTemplate, Row.Ref);
		
		CreateDirectory(Path + Row.RoleName + "\Ext");
		TextWriter = New TextWriter(Path + Row.RoleName + "\Ext\Rights.xml", TextEncoding.UTF8);
		TextWriter.Write(RoleData);
		TextWriter.Close();	
		
	EndDo;
	
EndProcedure

Function UpdateRoleExt_CreateRolesXML_ReadRole(Path)
	TextReader = New TextReader();
	TextReader.Open(Path + "AccRoles_DefaultRole\Ext\Rights.xml", TextEncoding.UTF8);
	Text = TextReader.Read();
	TextReader.Close();
	Return Roles_ServiceServer.DeserializeXMLUseXDTOFactory(Text);
EndFunction

Function UpdateRoleExt_CreateRolesXML_RoleData(RightTemplate, Role)
	
	RightTemplate.Object.Clear();
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Roles_AccessRolesRights.ObjectType AS ObjectType,
		|	Roles_AccessRolesRights.ObjectName AS ObjectName,
		|	Roles_AccessRolesRestrictionByCondition.Fields AS Fields,
		|	Roles_AccessRolesRestrictionByCondition.Condition AS Condition,
		|	Roles_AccessRolesRights.RightName AS RightName,
		|	Roles_AccessRolesRights.RightValue AS RightValue,
		|	Roles_AccessRolesRights.ObjectPath AS ObjectPath,
		|	Roles_AccessRolesRights.Ref AS Ref
		|FROM
		|	Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|		LEFT JOIN Catalog.Roles_AccessRoles.RestrictionByCondition AS Roles_AccessRolesRestrictionByCondition
		|		ON (Roles_AccessRolesRestrictionByCondition.Ref = Roles_AccessRolesRights.Ref)
		|			AND (Roles_AccessRolesRestrictionByCondition.RowID = Roles_AccessRolesRights.RowID)
		|WHERE
		|	NOT Roles_AccessRolesRights.Disable
		|	AND Roles_AccessRolesRights.Ref = &Ref
		|TOTALS
		|	MAX(RightValue)
		|BY
		|	ObjectPath,
		|	RightName";
	Query.SetParameter("Ref", Role);
	QueryResult = Query.Execute();
	
	SelectionObjectType = QueryResult.Select(QueryResultIteration.ByGroups);
	While SelectionObjectType.Next() Do
		ObjectList = XDTOFactory.Create(RightTemplate.object.OwningProperty.Type);
		ObjectList.Name = SelectionObjectType.ObjectPath;
		SelectionRightName = SelectionObjectType.Select(QueryResultIteration.ByGroups);
		While SelectionRightName.Next() Do
			RightList = XDTOFactory.Create(ObjectList.right.OwningProperty.Type);
			RightList.Name = Roles_Settings.MetaName(SelectionRightName.RightName);
			RightList.Value = SelectionRightName.RightValue;
			SelectionDetailRecords = SelectionRightName.Select();
			
			While SelectionDetailRecords.Next() Do
				
				If SelectionDetailRecords.Condition = Null Then
					Continue;
				EndIf;
				
				RestrictionByCondition = XDTOFactory.Create(RightList.restrictionByCondition.OwningProperty.Type);	
				
				For Each FieldRow In StrSplit(SelectionDetailRecords.Fields, ",", False) Do
					RestrictionByCondition.field.Add(FieldRow);														
				EndDo;
				RestrictionByCondition.condition = SelectionDetailRecords.Condition;
				RightList.restrictionByCondition.Add(RestrictionByCondition);
			EndDo;
			ObjectList.right.Add(RightList);
		EndDo;
		
		RightTemplate.object.Add(ObjectList);
	EndDo;
	Return Roles_ServiceServer.SerializeXMLUseXDTOFactory(RightTemplate);
	
EndFunction


Function UpdateRoleExt_CreateRolesXML_RolesTemplate(Path)
	TextReader = New TextReader();
	TextReader.Open(Path + "AccRoles_DefaultRole.xml", TextEncoding.UTF8);
	Text = TextReader.Read();
	TextReader.Close();
	
	Text = StrReplace(Text, "8ce88d34-f28e-43b1-b58a-0cf0d67343db", "%1");
	Text = StrReplace(Text, "AccRoles_DefaultRole", "%2");
	Return Text;
EndFunction

Procedure UpdateRoleExt_ConfigurationXML_UpdateLang(Path)
	
	MainLang = Metadata.DefaultLanguage;
	
	ReadXML = New XMLReader;
	ReadXML.OpenFile(Path + "Languages\English.xml");
	DOMBuilder = New DOMBuilder;
	DOMDocument = DOMBuilder.Read(ReadXML);
	ReadXML.Close();
	 
	DeleteFiles(Path + "Languages\English.xml");
		
	DOMDocument.GetElementByTagName("Name")[0].TextContent = Metadata.DefaultLanguage.Name;
	DOMDocument.GetElementByTagName("LanguageCode")[0].TextContent = Metadata.DefaultLanguage.LanguageCode;
	
	ExtendedConfigurationObject = DOMDocument.GetElementByTagName("ExtendedConfigurationObject");
	
	If ExtendedConfigurationObject.Count() Then
		ExtendedConfigurationObject[0].ParentNode.RemoveChild(ExtendedConfigurationObject[0]);	
	EndIf;
	
	
	WriteXML = New XMLWriter;
	WriteXML.OpenFile(Path + "Languages\" + MainLang.Name + ".xml");
	SaveDOM = New DOMWriter;
	SaveDOM.Write(DOMDocument, WriteXML);
	WriteXML.Close();
		
EndProcedure

Procedure UpdateRoleExt_ConfigurationXML(SourcePath)
	
	Query = New Query;
	Query.Text =
		"SELECT DISTINCT
		|	Roles_AccessRolesRights.ObjectType AS ObjectType,
		|	Roles_AccessRolesRights.ObjectName AS ObjectName,
		|	""          "" AS AddInfo
		|FROM
		|	Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|WHERE
		|	NOT Roles_AccessRolesRights.Ref.ConfigRoles
		|	AND NOT Roles_AccessRolesRights.Ref.DeletionMark
		|	AND NOT Roles_AccessRolesRights.ObjectType = VALUE(Enum.Roles_MetadataTypes.Configuration)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(Enum.Roles_MetadataTypes.Role),
		|	""AccRoles_"" + Roles_AccessRoles.Description,
		|	""          ""
		|FROM
		|	Catalog.Roles_AccessRoles AS Roles_AccessRoles
		|WHERE
		|	NOT Roles_AccessRoles.DeletionMark
		|	AND NOT Roles_AccessRoles.ConfigRoles
		|
		|ORDER BY
		|	ObjectType,
		|	ObjectName
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	Roles_AccessRolesRights.ObjectPath AS ObjectPath,
		|	Roles_AccessRolesRights.ObjectType AS ObjectType,
		|	Roles_AccessRolesRights.ObjectName AS ObjectName,
		|	Roles_AccessRolesRights.ObjectSubtype AS ObjectSubtype
		|FROM
		|	Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|WHERE
		|	NOT Roles_AccessRolesRights.Disable
		|	AND NOT Roles_AccessRolesRights.Ref.DeletionMark
		|	AND NOT Roles_AccessRolesRights.ObjectSubtype = VALUE(Enum.Roles_MetadataSubtype.EmptyRef)
		|
		|ORDER BY
		|	ObjectPath,
		|	ObjectType,
		|	ObjectName,
		|	ObjectSubtype
		|AUTOORDER
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	""AccRoles_"" + Roles_Parameters.Description AS ObjectName,
		|	Roles_Parameters.ValueTypeData AS ValueTypeData
		|FROM
		|	Catalog.Roles_Parameters AS Roles_Parameters
		|WHERE
		|	NOT Roles_Parameters.Ref.DeletionMark
		|
		|ORDER BY
		|	ObjectName";
	
	QueryResult = Query.ExecuteBatch();
	MainMetadata = QueryResult[0].Unload();
	SubMetadata = QueryResult[1].Unload();
	SessionParam = QueryResult[2].Unload();
	SubMetadata.Indexes.Add("ObjectType");
	SubMetadata.Indexes.Add("ObjectName");
	
	
	ReadXML = New XMLReader;
	ReadXML.OpenFile(SourcePath + "Configuration.xml");
	DOMBuilder = New DOMBuilder;
	DOMDocument = DOMBuilder.Read(ReadXML);
	ReadXML.Close();
	
	ExtLanguage = DOMDocument.GetElementByTagName("Language").Item(0);
	ExtLanguage.ParentNode.RemoveChild(ExtLanguage);
	
    DOMDocument.GetElementByTagName("Version")[0].TextContent = String(CurrentDate());
	ItemsDOM = DOMDocument.GetElementByTagName("ChildObjects");
	
	
	
	For Each Item In SessionParam Do
		NewNode = DOMDocument.CreateElement("SessionParameter");
		NewNode.TextContent = Item.ObjectName;
		ItemsDOM[0].AppendChild(NewNode);
		For Each RowType In Item.ValueTypeData.Get().Types() Do
			
			TypeData = Metadata.FindByType(RowType);
			If TypeData = Undefined Then
				Continue;
			EndIf;
			NewType = MainMetadata.Add();
			ObjectName = StrSplit(TypeData.FullName(), ".", False);
			NewType.ObjectName = ObjectName[1];
			NewType.ObjectType = Enums.Roles_MetadataTypes[Roles_Settings.MetaName(ObjectName[0])];
		EndDo;
	EndDo;
	
	For Each Lang In Metadata.Languages Do
		NewType = MainMetadata.Add();
		ObjectName = StrSplit(Lang.FullName(), ".", False);
		NewType.ObjectName = ObjectName[1];
		NewType.ObjectType = Enums.Roles_MetadataTypes.Language;
		NewType.AddInfo = Lang.LanguageCode;
	EndDo;

	
	MainMetadata.GroupBy("ObjectName, ObjectType, AddInfo");
	
	For Each Item In MainMetadata Do
		NewNode = DOMDocument.CreateElement(Roles_Settings.MetaName(Item.ObjectType));
		NewNode.TextContent = Item.ObjectName;
		ItemsDOM[0].AppendChild(NewNode);
	EndDo;


	
	
	WriteXML = New XMLWriter;
	WriteXML.OpenFile(SourcePath + "Configuration.xml");
	SaveDOM = New DOMWriter;
	SaveDOM.Write(DOMDocument, WriteXML);
	WriteXML.Close();
	
	UpdateRoleExt_ConfigurationXML_UpdateLang(SourcePath);
	
	XMLSettings = New Structure;
	XMLSettings.Insert("version", DOMDocument.FirstChild.Attributes.GetNamedItem("version").Value);
	XMLSettings.Insert("Template", GetCommonTemplate("Roles_TemplateMetadataObject").GetText());
	XMLSettings.Insert("TemplateSP", GetCommonTemplate("Roles_TemplateMetadataObjectSP").GetText());
	XMLSettings.Insert("SourcePath", SourcePath);
	
	
	For Each Item In MainMetadata Do
		If NOT Item.ObjectType = Enums.Roles_MetadataTypes.Role  Then
			UpdateRoleExt_ConfigurationXML_AttachMetadata(XMLSettings, Item, SubMetadata);
		EndIf;
	EndDo;
	
	CreateDirectory(SourcePath + "SessionParameters");
	For Each SessionRow In SessionParam Do
		UpdateRoleExt_ConfigurationXML_AttachSessionParameters(XMLSettings, SessionRow);
	EndDo;
EndProcedure

Procedure UpdateRoleExt_ConfigurationXML_AttachSessionParameters(XMLSettings, Item)
	
	TextContent = Roles_ServiceServer.SerializeXML(Item.ValueTypeData.Get());
	
	TemplateSP = StrTemplate(XMLSettings.TemplateSP, String(New UUID), Item.ObjectName, TextContent, XMLSettings.version);
	
	ReadXML = New XMLReader;
	ReadXML.SetString(TemplateSP);
	DOMBuilder = New DOMBuilder;
	DOMDocument = DOMBuilder.Read(ReadXML);
	ReadXML.Close();

	TypeDescription = DOMDocument.GetElementByTagName("TypeDescription").Item(0);
	TypeDescription.UnsetNamespaceMapping("http://v8.1c.ru/8.1/data/core");
	
	For Each Child In TypeDescription.ChildNodes Do
		Child.UnsetNamespaceMapping("http://v8.1c.ru/8.1/data/enterprise/current-config");
		
		TextContent = StrSplit(Child.TextContent, ":", False);
		If TextContent.Count() > 1 And Not TextContent[0] = "xs" Then
			TextContent[0] = "cfg";
			Child.TextContent = StrConcat(TextContent, ":");
		EndIf;
		TypeDescription.ParentNode.AppendChild(Child);
	EndDo;
	TypeDescription.ParentNode.RemoveChild(TypeDescription);
		
	WriteXML = New XMLWriter;
	WriteXML.OpenFile(XMLSettings.SourcePath + "SessionParameters\" + Item.ObjectName + ".xml");
	SaveDOM = New DOMWriter;
	SaveDOM.Write(DOMDocument, WriteXML);
	WriteXML.Close();

		
EndProcedure

Procedure UpdateRoleExt_ConfigurationXML_AttachMetadata(XMLSettings, Item, SubMetadata)
	ReadXML = New XMLReader;
	ReadXML.SetString(XMLSettings.Template);
	DOMBuilder = New DOMBuilder;
	DOMDocument = DOMBuilder.Read(ReadXML);
	ReadXML.Close();
		
	DOMDocument.FirstChild.Attributes.GetNamedItem("version").Value	= XMLSettings.version;
		
	ObjectNode = DOMDocument.CreateElement(Roles_Settings.MetaName(Item.ObjectType));
	UpdateRoleExt_ConfigurationXML_AddUUID(DOMDocument, ObjectNode);

	If Not Roles_Settings.hasNoInternalInfo(Item.ObjectType)  Then	
		InternalInfo = DOMDocument.CreateElement("InternalInfo");
		
		If Item.ObjectType = Enums.Roles_MetadataTypes.ExchangePlan Then
			ThisNode = DOMDocument.CreateElement("http://v8.1c.ru/8.3/xcf/readable", "ThisNode");
			ThisNode.TextContent = String(New UUID);
			InternalInfo.AppendChild(ThisNode);
		EndIf;

		For Each Row In Roles_Settings.MetaDataObject()[Roles_Settings.MetaName(Item.ObjectType)] Do
			GeneratedType = UpdateRoleExt_ConfigurationXML_AddInternalInfo(DOMDocument, Row.Key + "." + Item.ObjectName, Row.Value);
			InternalInfo.AppendChild(GeneratedType);
		EndDo;
		
		ObjectNode.AppendChild(InternalInfo);	
	EndIf;
	
	Properties = UpdateRoleExt_ConfigurationXML_AddProperties(DOMDocument, Item.ObjectName);
	If Item.ObjectType = Enums.Roles_MetadataTypes.Language Then
		ThisNode = DOMDocument.CreateElement("LanguageCode");
		ThisNode.TextContent = Item.AddInfo;
		Properties.AppendChild(ThisNode);
	EndIf;

	ObjectNode.AppendChild(Properties);
	
	If Not Roles_Settings.hasNoChildObjects(Item.ObjectType)  Then		
		ChildObjects = DOMDocument.CreateElement("ChildObjects");		
		SubMetadataRows = SubMetadata.FindRows(New Structure("ObjectName, ObjectType", Item.ObjectName, Item.ObjectType));
		For Each Row In SubMetadataRows Do		
			If Roles_Settings.hasOnlyProperties(Row.ObjectSubtype) Then
				Path = StrSplit(Row.ObjectPath, ".", False);
				SubtypeTag = DOMDocument.CreateElement(Roles_Settings.MetaName(Row.ObjectSubtype));
				UpdateRoleExt_ConfigurationXML_AddUUID(DOMDocument, SubtypeTag);
				Properties = UpdateRoleExt_ConfigurationXML_AddProperties(DOMDocument, Path[3]);
				SubtypeTag.AppendChild(Properties);
				ChildObjects.AppendChild(SubtypeTag);
			EndIf;
		EndDo;
		ObjectNode.AppendChild(ChildObjects);
	EndIf;
	
	DOMDocument.FirstChild.AppendChild(ObjectNode);	
	
	CreateDirectory(XMLSettings.SourcePath + Roles_Settings.MetaDataObjectNames()[Item.ObjectType]);
	
	WriteXML = New XMLWriter;
	WriteXML.OpenFile(XMLSettings.SourcePath + Roles_Settings.MetaDataObjectNames()[Item.ObjectType] + "\" + Item.ObjectName + ".xml");
	SaveDOM = New DOMWriter;
	SaveDOM.Write(DOMDocument, WriteXML);
	WriteXML.Close();
		
EndProcedure

Procedure UpdateRoleExt_ConfigurationXML_AddUUID(Val DOMDocument, Val ObjectNode)

	AttributeUUID = DOMDocument.CreateAttribute("uuid");
	AttributeUUID.Value = String(New UUID());
	ObjectNode.Attributes.SetNamedItem(AttributeUUID);

EndProcedure

Function UpdateRoleExt_ConfigurationXML_AddInternalInfo(DOMDocument, Name, category)
	
	GeneratedType = DOMDocument.CreateElement("http://v8.1c.ru/8.3/xcf/readable", "GeneratedType");
	
	AttributeName = DOMDocument.CreateAttribute("name");
	AttributeName.Value = Name;
	GeneratedType.Attributes.SetNamedItem(AttributeName);
	
	AttributeCategory = DOMDocument.CreateAttribute("category");
	AttributeCategory.Value = category;
	GeneratedType.Attributes.SetNamedItem(AttributeCategory);
	
	TypeId = DOMDocument.CreateElement("http://v8.1c.ru/8.3/xcf/readable", "TypeId");
	TypeId.TextContent = String(New UUID());
	ValueId = DOMDocument.CreateElement("http://v8.1c.ru/8.3/xcf/readable", "ValueId");
	ValueId.TextContent = String(New UUID());
	
	GeneratedType.AppendChild(TypeId);
	GeneratedType.AppendChild(ValueId);
	Return GeneratedType;

EndFunction

Function UpdateRoleExt_ConfigurationXML_AddProperties(Val DOMDocument, Name)
	
	Properties = DOMDocument.CreateElement("Properties");
	NameTag = DOMDocument.CreateElement("Name");
	NameTag.TextContent = Name;
	
	Comment = DOMDocument.CreateElement("Comment");
	
	ObjectBelonging = DOMDocument.CreateElement("ObjectBelonging");
	ObjectBelonging.TextContent = "Adopted";
	
	Properties.AppendChild(NameTag);
	Properties.AppendChild(Comment);
	Properties.AppendChild(ObjectBelonging);
	Return Properties;

EndFunction

Procedure InstallExtention(Name, ExtensionData, OverWrite = True) Export
	If ExtensionData = Undefined Then
		Return;
	EndIf;
	
	ArrayExt = ConfigurationExtensions.Get(New Structure("Name", Name));
	If ArrayExt.Count() Then
		If Not OverWrite Then
			Return;
		EndIf;
		Ext = ArrayExt[0];
	Else
		Ext = ConfigurationExtensions.Create();
	EndIf;

	Ext.Active = True;
	Ext.SafeMode = False;
	Ext.Write(ExtensionData);
EndProcedure
