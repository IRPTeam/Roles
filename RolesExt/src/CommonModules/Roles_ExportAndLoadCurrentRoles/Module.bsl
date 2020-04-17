#Region Internal
Procedure UpdateRoleExt(Val Settings, CountRoles = 0, Log = "") Export
	LoadFromTemp = False;
	If Settings.Source = "SQL"
		Or Settings.Source = "File" Then
			
		Path = TempFilesDir() + "TR";
		
		DeleteFiles(Path);
		CreateDirectory(Path);
		LoadFromTemp = True;
		// unload to xml
		CommandToUploadExt = """" + BinDir() + "1cv8.exe"" designer " + "/N """ + Settings.Login + """" +
			" /P """ + Settings.Password + """" + " " + 
			?(Settings.Source = "SQL", "/s " + Settings.ServerName + "\" + Settings.BaseName, "/f " + Settings.Path) +
			" /DumpConfigToFiles " + Path + " /DumpResult " + Path + 
			"\Result.log /DisableStartupMessages /DisableStartupDialogs /Out " + Path + "\Event.log";
		RunApp(CommandToUploadExt, , True);
		
		TextReader = New TextReader();
		TextReader.Open(Path + "\Event.log", TextEncoding.UTF8);
		Log = TextReader.Read();
		TextReader.Close();

		TextReader = New TextReader();
		TextReader.Open(Path + "\Result.log", TextEncoding.UTF8);
		Status = TextReader.Read();
		TextReader.Close();

		If Not Status = "0" Then
			Log = Log + Chars.LF + "Status = " + Status;
			Return;
		EndIf;
		
		Settings.PathToXML = Path + "\";
		
	EndIf;
	
		
	Rights = FindFiles(Settings.PathToXML + "Roles", "*.xml", False);	
	LoadFromXMLFormat(Settings, Rights);
	
	CountRoles = Rights.Count();
	
	Rights = FindFiles(Settings.PathToXML + "Roles", "*.mdo", True);		
	LoadFromEDTFormat(Settings, Rights);
	
	CountRoles = CountRoles + Rights.Count();
	
	If LoadFromTemp Then	
		DeleteFiles(Path);
	EndIf;	
EndProcedure
#EndRegion

#Region Private
Procedure LoadFromEDTFormat(Settings, Val Rights)

	For Each Right In Rights Do
		TextReader = New TextReader();
		TextReader.Open(Right.FullName, TextEncoding.UTF8);
		Text = TextReader.Read();
		TextReader.Close();
		CurrentHash = Roles_ServiceServer.HashMD5(Text);
		
		RoleInfo = Roles_ServiceServer.DeserializeXMLUseXDTOFactory(Text);
		
		UUID = New UUID(RoleInfo.uuid);
		
		RightRef = Catalogs.Roles_AccessRoles.GetRef(UUID);
		If RightRef.Description = "" Then
			RightObject = Catalogs.Roles_AccessRoles.CreateItem();
			RightObject.SetNewObjectRef(RightRef);
		Else
			If RightRef.LastHashUpdate = CurrentHash Then
				Continue;
			EndIf;

			RightObject = RightRef.GetObject();
		EndIf;
		
		RightObject.LastHashUpdate = CurrentHash;
		RightObject.AdditionalProperties.Insert("Update");
		
		CurrentHash = Roles_ServiceServer.HashMD5(Roles_ServiceServer.SerializeXML(RightObject));
		
		RightObject.Rights.Clear();
		RightObject.LangInfo.Clear();
		RightObject.RestrictionByCondition.Clear();
		RightObject.Templates.Clear();
		
		RightObject.Description = RoleInfo.Name;
		RightObject.ConfigRoles = True;
		If Not RoleInfo.Properties().Get("Synonym") = Undefined Then	
			If TypeOf(RoleInfo.Synonym) = Type("XDTODataObject") Then
				Lang = RoleInfo.Synonym;
				NewLang = RightObject.LangInfo.Add();
				NewLang.LangCode = Lang.key;
				NewLang.LangDescription = Lang.value;
			Else
				For Each Lang In RoleInfo.Synonym Do
					NewLang = RightObject.LangInfo.Add();
					NewLang.LangCode = Lang.key;
					NewLang.LangDescription = Lang.value;
				EndDo;
			EndIf;
		EndIf;
		If Not RoleInfo.Properties().Get("Comment") = Undefined Then
			RightObject.Comment = RoleInfo.Comment;
		Else
			RightObject.Comment = "";
		EndIf;
		
		TextReader = New TextReader();
		TextReader.Open(Settings.PathToXML + "Roles\" + RightObject.Description + "\Rights.rights", TextEncoding.UTF8);
		Text = TextReader.Read();
		TextReader.Close();
		
		LoadRightsToDB(RightObject, Text);
		
		NewHash = Roles_ServiceServer.HashMD5(Roles_ServiceServer.SerializeXML(RightObject));
		
		If Not CurrentHash = NewHash Then
			RightObject.Write();
		EndIf;
	EndDo;
EndProcedure

Procedure LoadRightsToDB(RightObject, Text)

	
	Try
		RightInfo = Roles_ServiceServer.DeserializeXMLUseXDTOFactory(Text);
	Except
		// Try to make lower version
		VersionIndex = StrFind(Text, "version=" + Char(34), , StrFind(Text, "Rights"));
		VersioneEndIndex = StrFind(Text, Char(34), , VersionIndex + 9) + 1;
		Version = Mid(Text, VersionIndex, VersioneEndIndex - VersionIndex);
		Text = StrReplace(Text, Version, "version=""2.8""");	
		RightInfo = Roles_ServiceServer.DeserializeXMLUseXDTOFactory(Text);
	EndTry;

	
	RightObject.SetRightsForAttributesAndTabularSectionsByDefault = 
		RightInfo.setForAttributesByDefault;
	RightObject.SetRightsForNewNativeObjects = 
		RightInfo.setForNewObjects;
	RightObject.SubordinateObjectsHaveIndependentRights = 
		RightInfo.independentRightsOfChildObjects;
	
	For Each Object In RightInfo.object Do
		ObjectFullName = StrSplit(Object.Name, ".", False);
		ObjectType = Enums.Roles_MetadataTypes[ObjectFullName[0]];
		ObjectName = ObjectFullName[1];		
		For Each ObjectRight In Object.right Do
			NewObject = RightObject.Rights.Add();
			NewObject.ObjectName = ObjectName;
			NewObject.ObjectType = ObjectType;
			NewObject.ObjectPath = Object.Name;
			If ObjectFullName.Count() > 2 Then
				If Not ObjectFullName[2] = "Subsystem" Then
					NewObject.ObjectSubtype = Enums.Roles_MetadataSubtype[ObjectFullName[2]];
				EndIf;
			EndIf;
			If ObjectRight.name = "AllFunctionsMode" Then
				NewObject.RightName = Enums.Roles_Rights.TechnicalSpecialistMode;
			Else
				NewObject.RightName = Enums.Roles_Rights[ObjectRight.name];
			EndIf;
			
			NewObject.RowID = New UUID();
			NewObject.RightValue = ObjectRight.value;
			For Each RestrictionByCondition In ObjectRight.restrictionByCondition Do
				Condition = RightObject.RestrictionByCondition.Add();
				Condition.RowID = NewObject.RowID;
				Condition.Condition = RestrictionByCondition.condition;
			EndDo;
			
		EndDo;
	EndDo;
	For Each restrictionTemplate In RightInfo.restrictionTemplate Do
		Condition = RightObject.Templates.Add();
		Condition.Name = restrictionTemplate.Name;
		
		
		
		TemplateUUID = New UUID(Roles_ServiceServer.HashMD5(restrictionTemplate.condition));
		TemplateRef  = Catalogs.Roles_Templates.GetRef(TemplateUUID);
		
		If TemplateRef.Description = "" Then
			TemplateObject = Catalogs.Roles_Templates.CreateItem();
			TemplateObject.Description = restrictionTemplate.Name;
			TemplateObject.Template = restrictionTemplate.condition;
			TemplateObject.SetNewObjectRef(TemplateRef);
			
			If NOT Catalogs.Roles_Templates.FindByDescription(restrictionTemplate.Name).IsEmpty() Then
				TemplateObject.Description = TemplateObject.Description + "(" + RightObject.Description + ")";
			EndIf;
			
			TemplateObject.Write();
			TemplateRef = TemplateObject.Ref;
		EndIf;
		
		Condition.Template = TemplateRef;
	EndDo;
EndProcedure

Procedure LoadFromXMLFormat(Settings, Val Rights)

	For Each Right In Rights Do
		TextReader = New TextReader();
		TextReader.Open(Right.FullName, TextEncoding.UTF8);
		Text = TextReader.Read();
		TextReader.Close();
		
		CurrentHash = Roles_ServiceServer.HashMD5(Text);
		
		
		RoleInfo = Roles_ServiceServer.DeserializeXMLUseXDTOFactory(Text);
		
		UUID = New UUID(RoleInfo.Role.uuid);
		
		RightRef = Catalogs.Roles_AccessRoles.GetRef(UUID);
		If RightRef.Description = "" Then
			RightObject = Catalogs.Roles_AccessRoles.CreateItem();
			RightObject.SetNewObjectRef(RightRef);
		Else
			If RightRef.LastHashUpdate = CurrentHash Then
				Continue;
			EndIf;
			RightObject = RightRef.GetObject();
		EndIf;
		
		RightObject.LastHashUpdate = CurrentHash;
		
		RightObject.AdditionalProperties.Insert("Update");		
		RightObject.Rights.Clear();
		RightObject.LangInfo.Clear();
		RightObject.RestrictionByCondition.Clear();
		RightObject.Templates.Clear();
		
		RightObject.Description = RoleInfo.Role.Properties.Name;
		RightObject.ConfigRoles = True;
		
		If Not RoleInfo.Role.Properties.Synonym.Properties().Get("Item") = Undefined Then
			If TypeOf(RoleInfo.Role.Properties.Synonym.item) = Type("XDTODataObject") Then
				Lang = RoleInfo.Role.Properties.Synonym.item;
				NewLang = RightObject.LangInfo.Add();
				NewLang.LangCode = Lang.lang;
				NewLang.LangDescription = Lang.Content;
			Else
				For Each Lang In RoleInfo.Role.Properties.Synonym.item Do
					NewLang = RightObject.LangInfo.Add();
					NewLang.LangCode = Lang.lang;
					NewLang.LangDescription = Lang.Content;
				EndDo;
			EndIf;
		EndIf;
		If TypeOf(RoleInfo.Role.Properties.Comment) = Type("String") Then
			RightObject.Comment = RoleInfo.Role.Properties.Comment;
		Else
			RightObject.Comment = "";
		EndIf;
		
		TextReader = New TextReader();
		TextReader.Open(Settings.PathToXML + "Roles\" + RightObject.Description + "\Ext\Rights.xml", TextEncoding.UTF8);
		Text = TextReader.Read();
		TextReader.Close();
		
		LoadRightsToDB(RightObject, Text);
		RightObject.Write();
	EndDo;
EndProcedure
#EndRegion