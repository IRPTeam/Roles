&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Path = Parameters.Path;
	
	DCSTemplate = GetCommonTemplate("Roles_DCS");
	
	Query = New Query;
	Query.Text = 
		"SELECT
		|	Roles_Parameters.Ref AS Ref,
		|	Roles_Parameters.Description AS Description,
		|	Roles_Parameters.ValuesData AS ValuesData,
		|	Roles_Parameters.isList AS isList,
		|	Roles_Parameters.ValuesListData AS ValuesListData,
		|	Roles_Parameters.ValueTypeData AS ValueTypeData
		|FROM
		|	Catalog.Roles_Parameters AS Roles_Parameters";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		NewParam = DCSTemplate.Parameters.Add();
		NewParam.Name = SelectionDetailRecords.Description;
		NewParam.ValueType = SelectionDetailRecords.ValueTypeData.Get();
	EndDo;
	
	



	
	DataSet = DCSTemplate.DataSets[0];
	DataSet.Query = (
	"SELECT *
	|FROM
	|    " + Path + " AS DataSet"
	);
	
	Address = PutToTempStorage(DCSTemplate, UUID);
	ThisObject.SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));
	
	//If Parameters.SavedSettings = Undefined Then
		ThisObject.SettingsComposer.LoadSettings(DCSTemplate.DefaultSettings);
	//Else
	//	ThisObject.SettingsComposer.LoadSettings(Parameters.SavedSettings);
	//EndIf;
	SettingsComposer.Settings.Selection.Items.Clear();
	For Each Field In SettingsComposer.Settings.Selection.SelectionAvailableFields.Items Do
		If Field.Folder Then
			Continue;
		EndIf;
		Selection = SettingsComposer.Settings.Selection.Items.Add(Type("DataCompositionSelectedField"));
		Selection.Use = True;
		Selection.Field = Field.Field; 
	EndDo;
	
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure Ok(Command)
	Close(PrepareResult());
EndProcedure

&AtServer
Function PrepareResult()
	Settings = ThisObject.SettingsComposer.GetSettings();
	DataCompositionSchema = GetFromTempStorage(Address);
	Composer = New DataCompositionTemplateComposer();
	Tempalte = Composer.Execute(DataCompositionSchema, Settings, , ,
		Type("DataCompositionValueCollectionTemplateGenerator"));

	//QuerySchema = New QuerySchema;
	//QuerySchema.SetQueryText(Tempalte.DataSets.DataSet.Query);
	//QuerySchema.QueryBatch[0].Operators[0].Filter.Add(Tempalte.DataSets.DataSet.Filter);
	//
	//For Each Filter In QuerySchema.QueryBatch[0].Operators[0].Filter Do
	//	Message(Filter);
	//EndDo;
	//
	
	
	Result = New Structure();
	Result.Insert("Settings", Settings);
	Result.Insert("Query", Tempalte.DataSets.DataSet.Query);
	Return Result;
EndFunction
