
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
		OpenForm("CommonForm.ConnectionSettingsForm", 
		, , , , , New NotifyDescription("LoadRolesFromCurrentConfigEnd"));
EndProcedure

&AtClient
Procedure LoadRolesFromCurrentConfigEnd(Result, AddInfo) Export
	
	If Result = Undefined Then
		Return;
	EndIf;
	
	Roles_ExportAndLoadCurrentRoles.UpdateRoleExt(Result);

EndProcedure