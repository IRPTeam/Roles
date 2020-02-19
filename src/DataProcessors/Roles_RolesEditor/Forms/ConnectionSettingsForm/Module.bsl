
&AtClient
Procedure OK(Command)
	Settings = New Structure;
	Settings.Insert("SQL",  	SQL);
	Settings.Insert("Path", 	Path);
	Settings.Insert("BaseName", BaseName);
	Settings.Insert("Login", 	Login);
	Settings.Insert("Password", Password);
	Settings.Insert("Server", 	Server);
	Settings.Insert("PathToXML",PathToXML);
	Close(Settings);
EndProcedure

&AtClient
Procedure SQLOnChange()
	Items.GroupFile.Visible = NOT SQL;
	Items.GroupSQL.Visible = SQL;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SQLOnChange()
EndProcedure
