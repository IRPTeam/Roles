Procedure UpdateRoleExt(Settings) Export
	If NOT ValueIsFilled(Settings.PathToXML) Then
		Path = TempFilesDir() + "TemplateRoles";
		DeleteFiles(Path);
		
		// unload to xml
		CommandToUploadExt = """" + BinDir() + "1cv8.exe"" designer " + "/N """ + Settings.Login + """" +
		" /P """ + Settings.Password + """" + " " + 
		?(Settings.SQL, "/s " + Settings.Server + "\" + Settings.BaseName, "/f " + Path) +
		" /DumpConfigToFiles " + Path + " -Right /DumpResult " + Path + 
		"\Event.log /DisableStartupMessages /DisableStartupDialogs";
		RunApp(CommandToUploadExt, , True);
		
		Settings.PathToXML = Path + "\";
		
	EndIf;
	
	If Not StrEndsWith(Settings.PathToXML, "\") Then
		Settings.PathToXML = Settings.PathToXML + "\";
	EndIf;
	
	Rights = FindFiles(Settings.PathToXML + "Roles", "*.xml", False);
	
	LoadFromXMLFormat(Settings, Rights);
	
	Rights = FindFiles(Settings.PathToXML + "Roles", "*.mdo", True);
		
	LoadFromEDTFormat(Settings, Rights);		
EndProcedure

Procedure LoadFromEDTFormat(Settings, Val Rights)

	For Each Right In Rights Do
		TextReader = New TextReader();
		TextReader.Open(Right.FullName, TextEncoding.UTF8);
		Text = TextReader.Read();
		TextReader.Close();
		
		RoleInfo = Roles_ServiceServer.DeserializeXMLUseXDTOFactory(Text);
		
		UUID = New UUID(RoleInfo.uuid);
		
		RightRef = Catalogs.Roles_AccessRoles.GetRef(UUID);
		If RightRef.Description = "" Then
			RightObject = Catalogs.Roles_AccessRoles.CreateItem();
			RightObject.SetNewObjectRef(RightRef);
		Else
			RightObject = RightRef.GetObject();
		EndIf;
		
		RightObject.Rights.Clear();
		RightObject.LangInfo.Clear();
		RightObject.RestrictionByCondition.Clear();
		RightObject.Templates.Clear();
		
		RightObject.Description = RoleInfo.Name;
		RightObject.ConfigRoles = True;
		
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
	EndDo;
EndProcedure

Procedure LoadRightsToDB(RightObject, Text)

	RightInfo = Roles_ServiceServer.DeserializeXMLUseXDTOFactory(Text);
	
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
	RightObject.Write();
EndProcedure

Procedure LoadFromXMLFormat(Settings, Val Rights)

	For Each Right In Rights Do
		TextReader = New TextReader();
		TextReader.Open(Right.FullName, TextEncoding.UTF8);
		Text = TextReader.Read();
		TextReader.Close();
		
		RoleInfo = Roles_ServiceServer.DeserializeXMLUseXDTOFactory(Text);
		
		UUID = New UUID(RoleInfo.Role.uuid);
		
		RightRef = Catalogs.Roles_AccessRoles.GetRef(UUID);
		If RightRef.Description = "" Then
			RightObject = Catalogs.Roles_AccessRoles.CreateItem();
			RightObject.SetNewObjectRef(RightRef);
		Else
			RightObject = RightRef.GetObject();
		EndIf;
		
		RightObject.Rights.Clear();
		RightObject.LangInfo.Clear();
		RightObject.RestrictionByCondition.Clear();
		RightObject.Templates.Clear();
		
		RightObject.Description = RoleInfo.Role.Properties.Name;
		RightObject.ConfigRoles = True;
		
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
	EndDo;
EndProcedure

