#Region FormEventHandlers

&AtClient
Procedure OnOpen(Cancel)
	AutoFillSettings();
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	If ValueIsFilled(ThisObject.PathToXML)
	And Not StrEndsWith(ThisObject.PathToXML, "\") And Not LoadFromClientPath Then
		ThisObject.PathToXML = ThisObject.PathToXML + "\";
	EndIf;
	If ValueIsFilled(ThisObject.Path) Then
		If Not StrEndsWith(ThisObject.Path, """") Then
			ThisObject.Path = ThisObject.Path + """";
		EndIf;
		If Not StrStartsWith(ThisObject.Path, """") Then
			ThisObject.Path = """" + ThisObject.Path;
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure LoadFromClientPathOnChange(Item)
	Items.DecorationClient.Visible = LoadFromClientPath;
	Items.DecorationServer.Visible = Not LoadFromClientPath;
EndProcedure

&AtClient
Procedure PathOnChange(Item)
	CheckFilling();
EndProcedure

&AtClient
Procedure PathToXMLOnChange(Item)
	CheckFilling();
EndProcedure

&AtClient
Procedure PathToXMLStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	If LoadFromClientPath Then
		DirectoryChooseDialog = New FileDialog(FileDialogMode.Open);
		DirectoryChooseDialog.Filter = "(*.zip)|*.zip";
	Else
		DirectoryChooseDialog = New FileDialog(FileDialogMode.ChooseDirectory);
	EndIf;	
	DirectoryChooseDialog.Directory = ThisObject.PathToXML;
	DirectoryChooseDialog.Show(New NotifyDescription("PathToXMLStartChoiceEnd", ThisObject, 
											New Structure("DirectoryChooseDialog", DirectoryChooseDialog)));
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure LoadRoles(Command)
	CheckFilling();
	Settings = New Structure;
	Settings.Insert("Source",  		ThisObject.Source);
	Settings.Insert("Path", 		ThisObject.Path);
	Settings.Insert("BaseName", 	ThisObject.BaseName);
	Settings.Insert("Login", 		ThisObject.Login);
	Settings.Insert("Password", 	ThisObject.Password);
	Settings.Insert("ServerName", 	ThisObject.ServerName);
	Settings.Insert("PathToXML",	ThisObject.PathToXML);
	LoadRolesFromCurrentConfigEnd(Settings);
EndProcedure

&AtClient
Procedure FillByCurrentDatabase(Command)
	AutoFillSettings();
EndProcedure


&AtClient
Procedure AutoFillSettings()
	Var ConnectionString;
	ConnectionString = InfoBaseConnectionString();	
	ThisObject.Path = NStr(ConnectionString, "File");
	ThisObject.ServerName = NStr(ConnectionString, "Srvr");
	ThisObject.BaseName = NStr(ConnectionString, "Ref");
	ThisObject.Login = UserName();
	If IsBlankString(ThisObject.Path) Then
		Source = "SQL";
	Else
		Source = "File";
	EndIf;
	SourceOnChange();
EndProcedure


&AtClient
Procedure SourceOnChange()
	Items.GroupXML.Visible = Source = "XML";
	Items.GroupDatabase.Visible = Source <> "XML";
	Items.FillFromCurrentDatabase.Visible = Source <> "XML";
	Items.GroupFile.Visible = Source = "File";
	Items.GroupSQL.Visible = Source = "SQL";
EndProcedure

&AtClient
Procedure PathStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	DirectoryChooseDialog = New FileDialog(FileDialogMode.ChooseDirectory);
	DirectoryChooseDialog.Directory = ThisObject.Path;
	DirectoryChooseDialog.Show(New NotifyDescription("PathStartChoiceEnd", ThisObject, 
									New Structure("DirectoryChooseDialog", DirectoryChooseDialog)));	
EndProcedure

&AtClient
Procedure LoginStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	UserList = UserList();
	ChooseFromListNotify = New NotifyDescription("LoginStartChoiceEnd", ThisObject);
	ShowChooseFromList(ChooseFromListNotify, UserList);
EndProcedure

#EndRegion

#Region Private


&AtClient
Procedure LoadRolesFromCurrentConfigEnd(Settings)
	
	If LoadFromClientPath Then

		EndCall = New NotifyDescription("AddFileEndCall", ThisObject, New Structure("Settings", Settings));
	    ProgressCall = New NotifyDescription("AddFileProgressCall", ThisObject);
	    BeforeStartCall = New NotifyDescription("AddFileBeforeStartCall", ThisObject);
	    BeginPutFileToServer(EndCall, ProgressCall, BeforeStartCall, , Settings.PathToXML, ThisObject.UUID);
	Else	
		Roles_ExportAndLoadCurrentRoles.UpdateRoleExt(Settings, CountRoles, CountFO, Log);
	EndIf;
EndProcedure

&AtClient
Procedure PathToXMLStartChoiceEnd(SelectedFiles, AdditionalParameters) Export
	If (SelectedFiles <> Undefined) Then
		ThisObject.PathToXML = SelectedFiles[0];
	EndIf;
EndProcedure


&AtClient
Procedure PathStartChoiceEnd(SelectedFiles, AdditionalParameters) Export
	
	DirectoryChooseDialog = AdditionalParameters.DirectoryChooseDialog;
	
	
	If (SelectedFiles <> Undefined) Then
		ThisObject.Path = DirectoryChooseDialog.Directory;
	EndIf;

EndProcedure


&AtClient
Procedure LoginStartChoiceEnd(ChoosenItem, AdditionalParameters) Export
	If ChoosenItem <> Undefined Then
		ThisObject.Login = ChoosenItem;
	EndIf;
EndProcedure

&AtServer
Function UserList()
	UsersArray = InfoBaseUsers.GetUsers();
	UserList = New ValueList();
	For Each UserItem In UsersArray Do 
		UserList.Add(UserItem.Name);
	EndDo;
	Return UserList;
EndFunction

#EndRegion

#Region FileTransfer

&AtClient
Procedure AddFileEndCall(FileDescription, AddInfo) Export
	If FileDescription = Undefined Then 
		Return;
	EndIf;
	#If NOT WebClient Then
	If FileDescription.PutFileCanceled Then 
		Return;
	EndIf;
	#EndIf
	SaveFilesAtServer(FileDescription.Address, AddInfo);
EndProcedure
	
&AtServer
Procedure SaveFilesAtServer(Address, AddInfo) 
	
	BD = GetFromTempStorage(Address);
	
	Path = TempFilesDir() + "RolesTmp\";
	DeleteFiles(Path);
	
	MemoryStream = New MemoryStream();
	
	DataWriter = New DataWriter(MemoryStream);
	DataWriter.Write(BD);
	DataWriter.Close();
	
	Zip = New ZipFileReader(MemoryStream);
	Zip.ExtractAll(Path);
	Zip.Close();
	MemoryStream.Close();
	AddInfo.Settings.PathToXML = Path;
	Roles_ExportAndLoadCurrentRoles.UpdateRoleExt(AddInfo.Settings, CountRoles, CountFO, Log);
EndProcedure

&AtClient
Procedure AddFileProgressCall(PuttingFile, PutProgress, CancelPut, AddInfo) Export
    Status(PuttingFile.Name, PutProgress, , PictureLib.MoveUp);
EndProcedure

&AtClient
Procedure AddFileBeforeStartCall(PuttingFile, CancelPut, AddInfo) Export
	Return;
EndProcedure

#EndRegion








