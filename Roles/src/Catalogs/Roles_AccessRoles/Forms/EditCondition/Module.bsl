#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Path = Parameters.Path;
	
	UpdateQuery();
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure SettingsFilterDrag(Item, DragParameters, StandardProcessing, Row, Field)
	If DragParameters.Value.Count() 
		And TypeOf(DragParameters.Value[0]) = Type("DataCompositionFilterAvailableField") Then
		StandardProcessing = False;
		For Each SelectedField In DragParameters.Value Do
			AddNewFilterRow(SelectedField, Row);
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure AddNewFilterRow(Val SelectedField, Row)
	Index = 0;
	GroupItem = Undefined;
	If Not Row = Undefined And Not IsBlankString(String(Row)) Then 
		RowData = SettingsComposer.Settings.Filter.GetObjectByID(Row);
		Index = SettingsComposer.Settings.Filter.Items.IndexOf(RowData);
		
		
		If TypeOf(RowData) = Type("DataCompositionFilterItemGroup") Then
			GroupItem = RowData;
		ElsIf Not RowData.Parent = Undefined And TypeOf(RowData.Parent) = Type("DataCompositionFilterItemGroup") Then
			GroupItem = RowData.Parent;
		Else
			GroupItem = Undefined;
		EndIf;
	EndIf;
	
	If GroupItem = Undefined Then
		NewRow = SettingsComposer.Settings.Filter.Items.Insert(Index + 1, Type("DataCompositionFilterItem"));
	Else
		NewRow = GroupItem.Items.Insert(Index + 1, Type("DataCompositionFilterItem"));
	EndIf;
	
	NewRow.Use = True;    
	NewRow.LeftValue = SelectedField.Field;
	NewRow.RightValue = New DataCompositionField("");
	If SettingsComposer.Settings.Filter.Items.Count() = 1 Then
		Items.SettingsFilter.Expand(Items.SettingsFilter.CurrentRow);
	EndIf;
EndProcedure

&AtClient
Procedure SettingsComposerSettingsFilterFilterAvailableFieldsSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	AddNewFilterRow(SettingsComposer.Settings.Filter.FilterAvailableFields.GetObjectByID(SelectedRow), Items.SettingsFilter.CurrentRow);
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure Ok(Command)
	Close(PrepareResult());
EndProcedure

&AtClient
Procedure RunReport(Command)
	RunReportAtServer();
EndProcedure

&AtClient
Procedure UpdateQueryData(Command)
	UpdateQueryDataAtServer();
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure UpdateQuery()
	
	DCSTemplate = GetCommonTemplate("Roles_DCS");

	UpdateParams(DCSTemplate);

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

&AtServer
Procedure UpdateParams(DCSTemplate)
	
	Query = New Query;
	Query.Text = 
	"SELECT
	|	Roles_Parameters.Ref AS Ref,
	|	Roles_Parameters.Description AS Description,
	|	Roles_Parameters.ValuesData AS ValuesData,
	|	Roles_Parameters.isList AS isList,
	|	Roles_Parameters.ValueTypeData AS ValueTypeData
	|FROM
	|	Catalog.Roles_Parameters AS Roles_Parameters
	|WHERE
	|	NOT Roles_Parameters.DeletionMark";
	
	QueryResult = Query.Execute();
	
	ParamStr = QueryResult.Select();
	DCSTemplate.Parameters.Clear();
	While ParamStr.Next() Do
		NewParam = DCSTemplate.Parameters.Add();
		NewParam.Name = ParamStr.Description;
		NewParam.ValueType = ParamStr.ValueTypeData.Get();
		NewParam.ValueListAllowed = ParamStr.isList;
		NewParam.Value = ParamStr.ValuesData.Get();
		NewParam.Use = DataCompositionParameterUse.Always;
	EndDo;

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
	FilterPrepare = StrReplace(FilterPrepare, "&", "&AccRoles_");
	
	
	Result = New Structure();
	Result.Insert("Settings", Settings);
	Result.Insert("Filter", FilterPrepare);
	Result.Insert("SettingsXML", Roles_ServiceServer.SerializeXML(Settings));
	Result.Insert("Query", Template.DataSets.DataSet.Query);
	Return Result;
EndFunction

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
	OutputProcessor.SetDocument(TabDoc);
	OutputProcessor.Output(DataCompositionProcessor);
	
EndProcedure

&AtServer
Procedure UpdateQueryDataAtServer()
	
	DCSTemplate = GetFromTempStorage(Address);
	UpdateParams(DCSTemplate);
	Address = PutToTempStorage(DCSTemplate, UUID);
	Settings = SettingsComposer.Settings;
	
	SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));
	SettingsComposer.LoadSettings(Settings);
	
EndProcedure

#EndRegion
