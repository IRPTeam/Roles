Function Strings(LangCode) Export
	Return Roles_LocalizationServer.Strings(LangCode);
EndFunction

Function UseMultiLanguage(MetadataFullName, AddInfo = Undefined) Export
	Return Roles_LocalizationServer.UseMultiLanguage(MetadataFullName, AddInfo);
EndFunction

Function GetLocalizationCode(AddInfo = Undefined) Export
	Return Roles_LocalizationServer.GetLocalizationCode(AddInfo);
EndFunction