&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Path = Parameters.Path;
	
	DCSTemplate = GetCommonTemplate("Roles_DCS");
	DataSet = DCSTemplate.DataSets[0];
	DataSet.Query = (
	"SELECT *
	|FROM
	|    " + Path + " AS DataObj"
	);
	
	Address = PutToTempStorage(DCSTemplate, UUID);
	ThisObject.SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));
	
	//If Parameters.SavedSettings = Undefined Then
		ThisObject.SettingsComposer.LoadSettings(DCSTemplate.DefaultSettings);
	//Else
	//	ThisObject.SettingsComposer.LoadSettings(Parameters.SavedSettings);
	//EndIf;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure Ok(Command)
	PrepareResult();
EndProcedure

&AtServer
Function PrepareResult()
	Settings = ThisObject.SettingsComposer.GetSettings();
	DataCompositionSchema = GetFromTempStorage(Address);
	Composer = New DataCompositionTemplateComposer();
	Tempalte = Composer.Execute(DataCompositionSchema, Settings, , ,
	Type("DataCompositionValueCollectionTemplateGenerator"));
	
	Message(Roles_ServiceServer.SerializeXML(DataCompositionSchema));
	Message(Roles_ServiceServer.SerializeXML(Settings));
	Try
		Message(Tempalte.DataSets.DataSet.Query);
		Message(Tempalte.DataSets.DataSet.Filter);
	Except
	EndTry;

	Result = New Structure();
	Result.Insert("Settings", Settings);
	Return Result;
EndFunction
