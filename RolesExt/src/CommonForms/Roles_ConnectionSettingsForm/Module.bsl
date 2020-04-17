#Region FormEventHandlers

&AtClient
Procedure OnOpen(Cancel)
	AutoFillSettings();
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	If ValueIsFilled(ThisObject.PathToXML)
	And Not StrEndsWith(ThisObject.PathToXML, "\") Then
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
	DirectoryChooseDialog = New FileDialog(FileDialogMode.ChooseDirectory);
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
Procedure LoadRolesFromCurrentConfigEnd(Result)
	
	Roles_ExportAndLoadCurrentRoles.UpdateRoleExt(Result, CountRoles, Log);

EndProcedure

&AtClient
Procedure PathToXMLStartChoiceEnd(SelectedFiles, AdditionalParameters) Export
	
	DirectoryChooseDialog = AdditionalParameters.DirectoryChooseDialog;
	
	
	If (SelectedFiles <> Undefined) Then
		ThisObject.PathToXML = DirectoryChooseDialog.Directory;
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









