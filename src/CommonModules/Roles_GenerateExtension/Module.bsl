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
	
	RightTemplate.object.Clear();
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Roles_AccessRolesRights.ObjectType AS ObjectType,
		|	Roles_AccessRolesRights.ObjectName AS ObjectName,
		|	Roles_AccessRolesRestrictionByCondition.Fields AS Fields,
		|	ISNULL(Roles_AccessRolesRestrictionByCondition.Condition, """") AS Condition,
		|	Roles_AccessRolesRights.RightName AS RightName
		|FROM
		|	Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|		LEFT JOIN Catalog.Roles_AccessRoles.RestrictionByCondition AS Roles_AccessRolesRestrictionByCondition
		|		ON (Roles_AccessRolesRestrictionByCondition.Ref = Roles_AccessRolesRights.Ref)
		|		AND (Roles_AccessRolesRestrictionByCondition.RowID = Roles_AccessRolesRights.RowID)
		|TOTALS
		|BY
		|	ObjectType,
		|	ObjectName,
		|	RightName";
	
	QueryResult = Query.Execute();
	
	SelectionObjectType = QueryResult.Select(QueryResultIteration.ByGroups);
	
	While SelectionObjectType.Next() Do
		
		SelectionObjectName = SelectionObjectType.Select(QueryResultIteration.ByGroups);
		
		MetaName = Roles_Settings.MetaName(SelectionObjectType.ObjectType);
		While SelectionObjectName.Next() Do
			ObjectList = XDTOFactory.Create(RightTemplate.object.OwningProperty.Type);
			ObjectList.Name = MetaName + "." + SelectionObjectName.ObjectName;
			
			SelectionRightName = SelectionObjectName.Select(QueryResultIteration.ByGroups);
			
			
	
			While SelectionRightName.Next() Do
				RightList = XDTOFactory.Create(ObjectList.right.OwningProperty.Type);
				RightList.Name = Roles_Settings.MetaName(SelectionRightName.RightName);
				RightList.Value = True;
				SelectionDetailRecords = SelectionRightName.Select();
		
				While SelectionDetailRecords.Next() Do
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
		|	Roles_AccessRolesRights.ObjectType,
		|	Roles_AccessRolesRights.ObjectName
		|FROM
		|	Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|WHERE
		|	NOT Roles_AccessRolesRights.Ref.ConfigRoles
		|	AND
		|	NOT Roles_AccessRolesRights.Ref.DeletionMark
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(Enum.Roles_MetadataTypes.Role),
		|	""AccRoles_"" + Roles_AccessRoles.Description
		|FROM
		|	Catalog.Roles_AccessRoles AS Roles_AccessRoles
		|WHERE
		|	NOT Roles_AccessRoles.DeletionMark
		|	AND
		|	NOT Roles_AccessRoles.ConfigRoles";
	
	QueryResult = Query.Execute().Unload();
	
	ReadXML = New XMLReader;
	ReadXML.OpenFile(SourcePath + "Configuration.xml");
	DOMBuilder = New DOMBuilder;
	DOMDocument = DOMBuilder.Read(ReadXML);
	ReadXML.Close();
		
	ItemsDOM = DOMDocument.GetElementByTagName("ChildObjects");
	For Each Item In QueryResult Do
		NewNode = DOMDocument.CreateElement(Roles_Settings.MetaName(Item.ObjectType));
		NewNode.TextContent = Item.ObjectName;
		ItemsDOM[0].AppendChild(NewNode);
	EndDo;
	

	Language = DOMDocument.GetElementByTagName("Language");
	Language[0].TextContent = Metadata.DefaultLanguage.Name;
	
	WriteXML = New XMLWriter;
	WriteXML.OpenFile(SourcePath + "Configuration.xml");
	SaveDOM = New DOMWriter;
	SaveDOM.Write(DOMDocument, WriteXML);
	WriteXML.Close();
	
	UpdateRoleExt_ConfigurationXML_UpdateLang(SourcePath);
	
	XMLSettings = New Structure;
	XMLSettings.Insert("version", DOMDocument.FirstChild.Attributes.GetNamedItem("version").Value);
	XMLSettings.Insert("Template", GetCommonTemplate("Roles_TemplateMetadataObject").GetText());
	XMLSettings.Insert("SourcePath", SourcePath);
	
	
	For Each Item In QueryResult Do
		If NOT Item.ObjectType = Enums.Roles_MetadataTypes.Role 
			OR NOT Item.ObjectType = Enums.Roles_MetadataTypes.Configuration Then
			UpdateRoleExt_ConfigurationXML_AttachMetadata(XMLSettings, Item);
		EndIf;
	EndDo;
EndProcedure

Procedure UpdateRoleExt_ConfigurationXML_AttachMetadata(XMLSettings, Item)
	ReadXML = New XMLReader;
	ReadXML.SetString(XMLSettings.Template);
	DOMBuilder = New DOMBuilder;
	DOMDocument = DOMBuilder.Read(ReadXML);
	ReadXML.Close();
		
	DOMDocument.FirstChild.Attributes.GetNamedItem("version").Value	= XMLSettings.version;
		
	ObjectNode = DOMDocument.CreateElement(Roles_Settings.MetaName(Item.ObjectType));
	AttributeUUID = DOMDocument.CreateAttribute("uuid");
	AttributeUUID.Value = String(New UUID());
	ObjectNode.Attributes.SetNamedItem(AttributeUUID);
		
	InternalInfo = DOMDocument.CreateElement("InternalInfo");
	
	For Each Row In Roles_Settings.MetaDataObject()[Roles_Settings.MetaName(Item.ObjectType)] Do
		GeneratedType = DOMDocument.CreateElement("http://v8.1c.ru/8.3/xcf/readable", "GeneratedType");
		
		AttributeName = DOMDocument.CreateAttribute("name");
		AttributeName.Value = Row.Key + "." + Item.ObjectName;
		GeneratedType.Attributes.SetNamedItem(AttributeName);
	
		AttributeCategory = DOMDocument.CreateAttribute("category");
		AttributeCategory.Value = Row.Value;
		GeneratedType.Attributes.SetNamedItem(AttributeCategory);
		
		TypeId = DOMDocument.CreateElement("http://v8.1c.ru/8.3/xcf/readable", "TypeId");
		TypeId.TextContent = String(New UUID());
		ValueId = DOMDocument.CreateElement("http://v8.1c.ru/8.3/xcf/readable", "ValueId");
		ValueId.TextContent = String(New UUID());
		
		GeneratedType.AppendChild(TypeId);
		GeneratedType.AppendChild(ValueId);
		
		InternalInfo.AppendChild(GeneratedType);
	EndDo;
	
	Properties = DOMDocument.CreateElement("Properties");
	Name = DOMDocument.CreateElement("Name");
	Name.TextContent = Item.ObjectName;
	
	Comment = DOMDocument.CreateElement("Comment");
	
	ObjectBelonging = DOMDocument.CreateElement("ObjectBelonging");
	ObjectBelonging.TextContent = "Adopted";
	
	Properties.AppendChild(Name);
	Properties.AppendChild(Comment);
	Properties.AppendChild(ObjectBelonging);
			
	ObjectNode.AppendChild(InternalInfo);	
	ObjectNode.AppendChild(Properties);
	
	ChildObjects = DOMDocument.CreateElement("ChildObjects");
	ObjectNode.AppendChild(ChildObjects);
	DOMDocument.FirstChild.AppendChild(ObjectNode);	
	
	CreateDirectory(XMLSettings.SourcePath + Roles_Settings.MetaDataObjectNames()[Item.ObjectType]);
	
	WriteXML = New XMLWriter;
	WriteXML.OpenFile(XMLSettings.SourcePath + Roles_Settings.MetaDataObjectNames()[Item.ObjectType] + "\" + Item.ObjectName + ".xml");
	SaveDOM = New DOMWriter;
	SaveDOM.Write(DOMDocument, WriteXML);
	WriteXML.Close();
		
EndProcedure

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
