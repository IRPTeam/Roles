Function RL(LangCode = Undefined) Export
	If LangCode = Undefined Then
		LangCode = ServiceSystemServer.GetSessionParameter("InterfaceLocalizationCode");
	EndIf;
	Return Roles_LocalizationReuse.Strings(LangCode);
EndFunction
