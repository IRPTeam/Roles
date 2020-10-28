
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	BD = Roles_GenerateExtension.UpdateRoleExt(True);
	
	BeginGetFileFromServer(BD, "" + Format(CurrentDate(), "DF=dd-MM-yyyy-HH-mm-ss;") + ".cfe");
EndProcedure
