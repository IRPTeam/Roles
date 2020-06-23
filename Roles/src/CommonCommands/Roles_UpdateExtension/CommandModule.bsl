#Region EventHandlers

&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Roles_GenerateExtension.UpdateRoleExt();
EndProcedure

#EndRegion
