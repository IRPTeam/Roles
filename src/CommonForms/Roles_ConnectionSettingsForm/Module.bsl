
&AtClient
Procedure OK(Command)
	CheckFilling();
	Settings = New Structure;
	Settings.Insert("Source",  	ThisObject.Source);
	Settings.Insert("Path", 	ThisObject.Path);
	Settings.Insert("BaseName", ThisObject.BaseName);
	Settings.Insert("Login", 	ThisObject.Login);
	Settings.Insert("Password", ThisObject.Password);
	Settings.Insert("ServerName", 	ThisObject.ServerName);
	Settings.Insert("PathToXML",ThisObject.PathToXML);
	Close(Settings);
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
Procedure OnOpen(Cancel)
	SourceOnChange();
EndProcedure

&AtClient
Procedure PathToXMLStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	DirectoryChooseDialog = New FileDialog(FileDialogMode.ChooseDirectory);
	DirectoryChooseDialog.Directory = ThisObject.PathToXML;
	If DirectoryChooseDialog.Choose() Then
		ThisObject.PathToXML = DirectoryChooseDialog.Directory;
	EndIf;	
EndProcedure

&AtClient
Procedure PathStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	DirectoryChooseDialog = New FileDialog(FileDialogMode.ChooseDirectory);
	DirectoryChooseDialog.Directory = ThisObject.Path;
	If DirectoryChooseDialog.Choose() Then
		ThisObject.Path = DirectoryChooseDialog.Directory;
	EndIf;	
EndProcedure

&AtClient
Procedure LoginStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	UserList = UserList();
	ChooseFromListNotify = New NotifyDescription("LoginStartChoiceEnd", ThisObject);
	ShowChooseFromList(ChooseFromListNotify, UserList);
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

&AtClient
Procedure FillByCurrentDatabase(Command)
	ConnectionString = InfoBaseConnectionString();	
    If Find(Upper(ConnectionString), "FILE=") = 1 Then
    	ConnectionString = StrReplace(ConnectionString, "File=", "");
		ConnectionString = StrReplace(ConnectionString, ";", "");
		ThisObject.Path = ConnectionString;
	ElsIf Find(Upper(ConnectionString), "SQL=") = 1 Then
		ConnectionString = StrReplace(ConnectionString, "Srvr=""", "");
		ConnectionString = StrReplace(ConnectionString, """;Ref=""", "|");
		ConnectionString = StrReplace(ConnectionString, ";", "");
		ConnectionStringArray = StrSplit(ConnectionString, "|");
		ThisObject.ServerName = ConnectionStringArray[0];
		ThisObject.BaseName = ConnectionStringArray[1];
	EndIf;
	ThisObject.Login = UserName();
EndProcedure

&AtClient
Procedure PathOnChange(Item)
	CheckFilling();
EndProcedure

&AtClient
Procedure PathToXMLOnChange(Item)
	CheckFilling();
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


