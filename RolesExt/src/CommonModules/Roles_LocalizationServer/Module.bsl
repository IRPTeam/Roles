Function Strings(LangCode = "en") Export
	StringsStructure = Roles_Localization.Strings(LangCode);
	If LangCode <> "en" Then
		LocalisationStrings_df = Roles_Localization.Strings("en");
		For Each StringsStructureItem In StringsStructure Do
			If Not ValueIsFilled(StringsStructureItem.Value) Then
				StringsStructure[StringsStructureItem.Key] = LocalisationStrings_df[StringsStructureItem.Key];
			EndIf;
		EndDo; 
	EndIf;
	Return StringsStructure;
EndFunction

Function GetLocalizationCode(AddInfo = Undefined) Export
	Return CurrentLocaleCode();
EndFunction