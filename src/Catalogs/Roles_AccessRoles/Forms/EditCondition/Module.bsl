&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Path = Parameters.Path;
	
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
	
	ParamStr = QueryResult.Select();
	
	While ParamStr.Next() Do
		NewParam = DCSTemplate.Parameters.Add();
		NewParam.Name = ParamStr.Description;
		NewParam.ValueType = ParamStr.ValueTypeData.Get();
		NewParam.ValueListAllowed = ParamStr.isList;
		NewParam.Value = ?(ParamStr.isList, ParamStr.ValuesListData.Get(), ParamStr.ValuesData.Get());
		NewParam.Use = DataCompositionParameterUse.Always;
	EndDo;
	
	DataSet = DCSTemplate.DataSets[0];
	DataSet.Query = (
	"SELECT *
	|FROM
	|    " + Path + " AS DataSet"
	);
	
	Address = PutToTempStorage(DCSTemplate, UUID);
	SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));
	
	If Parameters.FilterData = "" Then
		SettingsComposer.LoadSettings(DCSTemplate.DefaultSettings);
	Else
		SettingsComposer.LoadSettings(Roles_ServiceServer.DeserializeXML(Parameters.FilterData));
	EndIf;
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
	

	Settings = SettingsComposer.Settings;
	DataCompositionSchema = GetFromTempStorage(Address);
	
	
	
	Composer = New DataCompositionTemplateComposer();
	Template = Composer.Execute(DataCompositionSchema, Settings, , ,
		Type("DataCompositionValueCollectionTemplateGenerator"));

	If Not DataCompositionSchema.Parameters.Count() = Template.ParameterValues.Count() Then
		Items.DecorationErrorSetParams.Visible = True;
		Raise Items.DecorationErrorSetParams.Title;
	Else
		Items.DecorationErrorSetParams.Visible = True;
	EndIf;
		
	QuerySchema = New QuerySchema;
	QuerySchema.SetQueryText(Template.DataSets.DataSet.Query);
	QuerySchema.QueryBatch[0].Operators[0].Filter.Add(Template.DataSets.DataSet.Filter);
	
	
	FilterArray = New Array;
	FilterArray.Add("WHERE");
	For Each Filter In QuerySchema.QueryBatch[0].Operators[0].Filter Do
		FilterArray.Add(String(Filter));
	EndDo;
	
	FilterPrepare = StrConcat(FilterArray, Chars.LF);
	FilterPrepare = StrReplace(FilterPrepare, "DataSet.", "");
	FilterPrepare = StrReplace(FilterPrepare, "&", "&Role_");
	
	
	Result = New Structure();
	Result.Insert("Settings", Settings);
	Result.Insert("Filter", FilterPrepare);
	Result.Insert("SettingsXML", Roles_ServiceServer.SerializeXML(Settings));
	Result.Insert("Query", Template.DataSets.DataSet.Query);
	Return Result;
EndFunction

&AtClient
Procedure SettingsFilterDrag(Item, DragParameters, StandardProcessing, Row, Field)
	StandardProcessing = False;
	For Each SelectedField In DragParameters.Value Do
		AddNewFilterRow(SelectedField);
	EndDo;
EndProcedure

&AtClient
Procedure AddNewFilterRow(Val SelectedField)
		
	NewRow = SettingsComposer.Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
	NewRow.Use = True;    
	NewRow.LeftValue = SelectedField.Field;
	NewRow.RightValue = New DataCompositionField("");

EndProcedure


&AtClient
Procedure SettingsComposerSettingsFilterFilterAvailableFieldsSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	AddNewFilterRow(SettingsComposer.Settings.Filter.FilterAvailableFields.GetObjectByID(SelectedRow));
EndProcedure


&AtClient
Procedure RunReport(Command)
	RunReportAtServer();
EndProcedure

&AtServer
Procedure RunReportAtServer()
	
	Settings = SettingsComposer.GetSettings();
	DataCompositionSchema = GetFromTempStorage(Address);
	Composer = New DataCompositionTemplateComposer();
	Template = Composer.Execute(DataCompositionSchema, Settings);
	TabDoc.Clear();
	DataCompositionProcessor = New DataCompositionProcessor;
	DataCompositionProcessor.Initialize(Template);
	
	OutputProcessor = New DataCompositionResultSpreadsheetDocumentOutputProcessor;
	OutputProcessor.УстановитьДокумент(TabDoc);
	OutputProcessor.Вывести(DataCompositionProcessor);
	
EndProcedure



