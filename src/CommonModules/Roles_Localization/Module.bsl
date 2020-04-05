Function Strings(CodeLanguage) Export
	
	Strings = New Structure();
	
	#Region Warnings
	Strings.Insert("a1", NStr("en = 'Configuration doesn't have support profiles.'", CodeLanguage));
	#EndRegion
	
	Return Strings;
EndFunction
