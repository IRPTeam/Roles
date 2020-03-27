
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	OpenForm("CommonForm.Roles_ConnectionSettingsForm", 
		, , , , , New NotifyDescription("LoadRolesFromCurrentConfigEnd", ThisObject));
EndProcedure

&AtClient
Procedure LoadRolesFromCurrentConfigEnd(Result, AddInfo) Export
	
	If Result = Undefined Then
		Return;
	EndIf;
	
	Roles_ExportAndLoadCurrentRoles.UpdateRoleExt(Result);

EndProcedure