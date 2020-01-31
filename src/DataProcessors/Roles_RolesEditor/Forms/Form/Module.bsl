
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillRoles();
EndProcedure

&AtClient
Procedure RolesSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
EndProcedure

&AtServer
Procedure FillRoles()
	ThisObject.Roles.GetItems().Clear();
	ArrayOfRoles = GetArrayOfRoles();
	For Each Role In ArrayOfRoles Do
		NewRow = ThisObject.Roles.GetItems().Add();
		NewRow.Synonym = Role.Synonym;
		NewRow.Name = Role.Name;
	EndDo;
EndProcedure

&AtServerNoContext
Function GetRoleInfo()
	RoleInfo = New Structure();
	RoleInfo.Insert("Synonym", "");
	RoleInfo.Insert("Name", "");
	Return RoleInfo;
EndFunction

&AtServerNoContext
Function GetArrayOfRoles()
	ArrayOfRoles = New Array();
	For Each Role In Metadata.Roles Do
		RoleInfo = GetRoleInfo();
		RoleInfo.Synonym = Role.Synonym;
		RoleInfo.Name = Role.FullName();
		ArrayOfRoles.Add(RoleInfo);
	EndDo;
	Return ArrayOfRoles;
EndFunction

&AtServerNoContext
Function GetPossibleAccessRightFor_Catalog()
	ArrayOfAccessRight = New Array();
	ArrayOfAccessRight.Add("Insert");
	ArrayOfAccessRight.Add("Read");
	ArrayOfAccessRight.Add("Update");
	ArrayOfAccessRight.Add("Delete");
	Return ArrayOfAccessRight;
EndFunction

&AtServerNoContext
Function GetAccessRightsFor_Catalog(RoleInfo)
	RoleMetadataObject = Metadata.FindByFullName(RoleInfo.Name);
	For Each MetadataItem In Metadata.Catalogs Do
		For Each AccessRight In GetPossibleAccessRightFor_Catalog() Do
			IsAccess = AccessRight(AccessRight, MetadataItem, RoleMetadataObject);
		EndDo;
	EndDo;
EndFunction

&AtClient
Procedure TestRoleEditor(Command)
	OpenForm("DataProcessor.Roles_RolesEditor.Form.EditRole", ,ThisObject, ThisObject.UUID);
EndProcedure

#Region Extention
&AtClient
Procedure UpdateExtention(Command)
	UpdateRoleExt();
EndProcedure

&AtServer
Procedure UpdateRoleExt()
	
	
	
	
	Path = TempFilesDir() + "TemplateDB";
	DeleteFiles(Path);
	
	Obj = FormAttributeToValue("Object");
	TemplateDB = Obj.GetTemplate("TemplateDB").OpenStreamForRead();
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
	ExtentionServer.InstallExtention("AccessRoles", BD, True);
//	DeleteFiles(Path);
	
EndProcedure

Procedure UpdateRoleExt_CreateRolesXML(Path);

	Query = New Query;
	Query.Text =
		"SELECT DISTINCT
		|	""AccRoles_"" + Roles_AccessRoles.Description AS RoleName,
		|	Roles_AccessRoles.Ref
		|FROM
		|	Catalog.Roles_AccessRoles AS Roles_AccessRoles";
	
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
	Return DeserializeXMLUseXDTOFactory(Text);
EndFunction

Function UpdateRoleExt_CreateRolesXML_RoleData(RightTemplate, Role)
	
	RightTemplate.object.Clear();
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Roles_AccessRolesRights.ObjectType + ""."" + Roles_AccessRolesRights.ObjectName AS ObjectName,
		|	Roles_AccessRolesRestrictionByCondition.Fields,
		|	ISNULL(Roles_AccessRolesRestrictionByCondition.Condition, """") AS Condition,
		|	Roles_AccessRolesRights.RightName AS RightName,
		|	Roles_AccessRolesRights.RightValue AS RightValue
		|FROM
		|	Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|		LEFT JOIN Catalog.Roles_AccessRoles.RestrictionByCondition AS Roles_AccessRolesRestrictionByCondition
		|		ON Roles_AccessRolesRestrictionByCondition.Ref = Roles_AccessRolesRights.Ref
		|		AND Roles_AccessRolesRestrictionByCondition.RowID = Roles_AccessRolesRights.RowID
		|TOTALS
		|	MAX(RightValue) AS RightValue
		|BY
		|	ObjectName,
		|	RightName";
	
	QueryResult = Query.Execute();
	
	SelectionObjectName = QueryResult.Select(QueryResultIteration.ByGroups);
	
	
	
	While SelectionObjectName.Next() Do
		ObjectList = XDTOFactory.Create(RightTemplate.object.OwningProperty.Type);
		ObjectList.Name = SelectionObjectName.ObjectName;
		
		SelectionRightName = SelectionObjectName.Select(QueryResultIteration.ByGroups);
		
		

		While SelectionRightName.Next() Do
			RightList = XDTOFactory.Create(ObjectList.right.OwningProperty.Type);
			RightList.Name = SelectionRightName.RightName;
			RightList.Value = SelectionRightName.RightValue;
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
	
	Return SerializeXMLUseXDTOFactory(RightTemplate);
	
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

Procedure UpdateRoleExt_ConfigurationXML(SourcePath)
	
	Query = New Query;
	Query.Text =
		"SELECT DISTINCT
		|	Roles_AccessRolesRights.ObjectType,
		|	Roles_AccessRolesRights.ObjectName
		|FROM
		|	Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|
		|UNION ALL
		|
		|SELECT
		|	""Role"",
		|	""AccRoles_"" + Roles_AccessRoles.Description
		|FROM
		|	Catalog.Roles_AccessRoles AS Roles_AccessRoles";
	
	QueryResult = Query.Execute().Unload();
	
	ReadXML = New XMLReader;
	ReadXML.OpenFile(SourcePath + "Configuration.xml");
	DOMBuilder = New DOMBuilder;
	DOMDocument = DOMBuilder.Read(ReadXML);
	ReadXML.Close();
		
	ItemsDOM = DOMDocument.GetElementByTagName("ChildObjects");
	For Each Item In QueryResult Do
		NewNode = DOMDocument.CreateElement(Item.ObjectType);
		NewNode.TextContent = Item.ObjectName;
		ItemsDOM[0].AppendChild(NewNode);
	EndDo;
	
	WriteXML = New XMLWriter;
	WriteXML.OpenFile(SourcePath + "Configuration.xml");
	SaveDOM = New DOMWriter;
	SaveDOM.Write(DOMDocument, WriteXML);
	WriteXML.Close();
	
	XMLSettings = New Structure;
	XMLSettings.Insert("version", DOMDocument.FirstChild.Attributes.GetNamedItem("version").Value);
	XMLSettings.Insert("Template", DataProcessors.Roles_RolesEditor.GetTemplate("TemplateMetaDataObject").GetText());
	XMLSettings.Insert("SourcePath", SourcePath);
	
	
	For Each Item In QueryResult Do
		If NOT Item.ObjectType = "Role" OR NOT Item.ObjectType = "Configuration" Then
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
		
	ObjectNode = DOMDocument.CreateElement(Item.ObjectType);
	AttributeUUID = DOMDocument.CreateAttribute("uuid");
	AttributeUUID.Value = String(New UUID());
	ObjectNode.Attributes.SetNamedItem(AttributeUUID);
		
	InternalInfo = DOMDocument.CreateElement("InternalInfo");
	
	For Each Row In Roles_Settings.MetaDataObject()[Item.ObjectType] Do
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

Function DeserializeXMLUseXDTOFactory(Value)
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = XDTOFactory.ReadXML(Reader);
	Reader.Close();
	Return Result;
EndFunction

Function SerializeXMLUseXDTOFactory(Value)
	Writer = New XMLWriter();
	Writer.SetString();
	XDTOFactory.WriteXML(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

#EndRegion

