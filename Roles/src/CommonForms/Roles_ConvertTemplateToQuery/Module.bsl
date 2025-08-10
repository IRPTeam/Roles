#Region FormEventHandlers
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CurrentAccessRightName = Parameters.RightName;
	CurrentTableName = Parameters.ObjectPath;
	RLS =  Parameters.Text;
		
	Query = New Query;
	Query.Text = 
		"SELECT
		|	Roles_Templates.Description AS Name,
		|	Roles_Templates.Template AS Code
		|FROM
		|	Catalog.Roles_Templates AS Roles_Templates
		|WHERE
		|	NOT Roles_Templates.DeletionMark
		|	AND Roles_Templates.Ref IN(&RLSList)";
	Query.SetParameter("RLSList", Parameters.RLSList);
	QueryResult = Query.Execute().Unload();
	Templates.Load(QueryResult);
	

	If Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.Russian Then
		// BSLLS:IfElseIfEndsWithElse-off
		If CurrentAccessRightName = "Read" Then
			CurrentAccessRightName = "Чтение";
		ElsIf CurrentAccessRightName = "Insert" Then
			CurrentAccessRightName = "Добавление";
		ElsIf CurrentAccessRightName = "Update" Then
			CurrentAccessRightName = "Изменение";
		ElsIf CurrentAccessRightName = "Delete" Then
			CurrentAccessRightName = "Удаление";
		EndIf;
		// BSLLS:IfElseIfEndsWithElse-on
		
		CurrentTableName = Metadata.FindByFullName(CurrentTableName).FullName();
		
	EndIf;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	For Each Row In Templates Do
		If StrFind(Row.Name, "(") Then
			Row.NamedParams = FunctionString(Row.Name, StrFind(Row.Name, "("));
		EndIf;
		Row.Name = StrSplit(Row.Name, " (")[0];
	EndDo;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure ConvertToQuery(Command)
	TemplateStructure = New Structure;
	For Each Tmp In Templates Do
		TemplateRows = StrSplit(Tmp.Code, Chars.LF, False);
		TemplateRows = DeleteCommentAndEmptyRow(TemplateRows);
		
		TempStr = New Structure;
		TempStr.Insert("Code", StrConcat(TemplateRows, Chars.LF));
		TempStr.Insert("Params", New Array);
		TempStr.Insert("FunctionString", "");
		TempStr.Insert("NamedParams", StrSplit(Tmp.NamedParams, ", ", False));
		TemplateStructure.Insert(Tmp.Name, TempStr);
	EndDo;
	RLSParamStructure = ParamsStructureInTemplates(RLS, TemplateStructure);
	
	FillTemplateWithParams(RLSParamStructure);
	
	FillSessionParametersTable(RLSParamStructure);
	
	DebugTree.GetItems().Clear();
	
	CalculateResultQuery(RLSParamStructure);
	
EndProcedure

&AtClient
Procedure ConvertToBSLCode(Command)
	ConvertToBSLCodeAtServer();	
EndProcedure

&AtClient
Procedure ConvertToInternalBSLCode(Command)
	ConvertToInternalBSLCodeAtServer();
EndProcedure

&AtClient
Procedure RunBSLCode(Command)
	RunBSLCodeAtServer();
EndProcedure

&AtClient
Procedure QueryWizard(Command)
	QueryWizard = New QueryWizard;
	If Not IsBlankString(QueryText) Then
		QueryWizard.Text = QueryText;
	EndIf;
	QueryWizard.Show(New NotifyDescription("AfterQueryChange", ThisObject));
EndProcedure

&AtClient
Procedure RunReport(Command)
	RunReportAtServer();
EndProcedure

#EndRegion

#Region Private

#Region CalculateQuery

&AtServer
Procedure CalculateResultQuery(RLSParamStructure)
	
	DebugsTree = FormAttributeToValue("DebugTree");
	TotalRLSCode = RLS;
	For Each Tmp In RLSParamStructure Do
		TotalRLSCode = StrReplace(TotalRLSCode, Tmp.Value.FunctionString, Tmp.Value.Code);
	EndDo;
	
	NewRow = DebugsTree.Rows.Add();
	NewRow.Condition = "RLS";
	NewRow.Status = True;
	NewRow.Result = True;
	
	RLSTemplateView = TotalRLSCode;
	
	FullCode = StrReplace(TotalRLSCode, "&", "AdditionalParamsStructure.");
	Rows = StrSplit(FullCode, "#", False);
	QueryText = StrConcat(Rows, Chars.LF);
		
	CalculateTreeRow(NewRow, Rows);

	QueryRowsArray = New Array;
	DebugsTree.Rows[0].Status = True;
	CalculateQueryRows(DebugsTree.Rows[0].Rows, QueryRowsArray);
	QueryText = StrConcat(QueryRowsArray, "");
	QueryText = StrReplace(QueryText, "AdditionalParamsStructure.", "&");
	
	ValueToFormAttribute(DebugsTree, "DebugTree");
EndProcedure

&AtServer
Procedure CalculateTreeRow(NewRow, Rows) 
	Query = New Query;
	For Each Param In SessionParametersTable Do
		Query.SetParameter(Param.Name, Param.Value);
	EndDo;	
	
	For Index = 0 To Rows.Count() - 1 Do
		Row = TrimAll(Rows[Index]);
		FirstTextLen = StrLen(StrSplit(Row, " " + Chars.LF, False)[0]);
		If StrStartsWith(Lower(Row), "if") Or StrStartsWith(Lower(Row), "если") Then
			NewRow = NewRow.Rows.Add();
			Code = Right(Row, StrLen(Row) - FirstTextLen);
			Result = CalculateResult(Code, Query);

			If TypeOf(Result) = Type("Array") Then
				NewRow.Error = StrConcat(Result, Chars.LF);
				Result = False;
				Roles_CommonFunctionsClientServer.ShowUsersMessage(NewRow.Error);
			EndIf;
		
			// @skip-warning
			NewRow.Result = Result;
			NewRow.Condition = "If";
			NewRow.ConditionText = Code;
			If Not NewRow.Parent.Status Then
				Result = False;
			EndIf;
			// @skip-warning
			NewRow.Status = Result;
			Index = Index + 1;
			Row = TrimAll(Rows[Index]);
			FirstTextLen = StrLen(StrSplit(Row, " " + Chars.LF, False)[0]);
			Code = Right(Row, StrLen(Row) - FirstTextLen);
			NewRow.Code = Code;

		ElsIf StrStartsWith(Lower(Row), "elseif") Or StrStartsWith(Lower(Row), "иначеесли") Then

			Code = Right(Row, StrLen(Row) - FirstTextLen);
			NewRow = NewRow.Parent.Rows.Add();
			NewRow.Condition = "elsif";
			Result = CalculateResult(Code, Query);
			If TypeOf(Result) = Type("Array") Then
				NewRow.Error = StrConcat(Result, Chars.LF);
				Result = False;
				Roles_CommonFunctionsClientServer.ShowUsersMessage(NewRow.Error);
			EndIf;
			// @skip-warning
			NewRow.Result = Result;
			NewRow.ConditionText = Code;

			TmpIndex = NewRow.Parent.Rows.Count() - 1;
			If isFirstStatusTrue(TmpIndex, NewRow) Then
				NewRow.Status = False;
			Else
			// @skip-warning
				NewRow.Status = Result;
			EndIf;
			Index = Index + 1;
			Row = Rows[Index];
			Row = TrimAll(Row);
			FirstTextLen = StrLen(StrSplit(Row, " " + Chars.LF, False)[0]);
			Code = Right(Row, StrLen(Row) - FirstTextLen);
			NewRow.Code = Code;

		ElsIf StrStartsWith(Lower(Row), "else") Or StrStartsWith(Lower(Row), "иначе") Then
			Code = Right(Row, StrLen(Row) - FirstTextLen);
			NewRow = NewRow.Parent.Rows.Add();

			NewRow.Condition = "else";
			NewRow.Code = Code;

			TmpIndex = NewRow.Parent.Rows.Count() - 1;

			If isFirstStatusTrue(TmpIndex, NewRow) Then
				NewRow.Status = False;
			Else
				NewRow.Status = NewRow.Parent.Status;
			EndIf;
			NewRow.Result = NewRow.Status;
		ElsIf StrStartsWith(Lower(Row), "endif") Or StrStartsWith(Lower(Row), "конецесли") Then

			Code = Right(Row, StrLen(Row) - FirstTextLen);
			NewRow = NewRow.Parent.Rows.Add();
			NewRow.Condition = "endif";
			NewRow.Code = Code;
			NewRow.Status = NewRow.Parent.Status;
			NewRow.Result = NewRow.Status;
			NewRow =  NewRow.Parent;
		Else
			Return;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function isFirstStatusTrue(TmpIndex, NewRow)
	isSet = False;
	While TmpIndex >= 0 Do
		If NewRow.Parent.Rows[TmpIndex].Condition = "endif" Then
			Break;
		Else
			If NewRow.Parent.Rows[TmpIndex].Status Then
				isSet = True;
				Break;
			EndIf;
		EndIf;
		TmpIndex = TmpIndex - 1;
	EndDo;
	Return isSet;
EndFunction

&AtServer
Function CalculateResult(Val Code, Query) Export
	Result = Undefined;
	ErrorList = New Array;
	Try
		SetSafeMode(True);
		Execute("Result = " + Code);
		SetSafeMode(False);
		Return Result;
	Except
		ErrorList.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
	EndTry;
	
	// try to create query
	Code = StrReplace(Code, "AdditionalParamsStructure.", "&");
	Query.Text = 
	"SELECT TOP 1
	|	CASE
	|		WHEN (" + Code + ")
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS Result";
		
	Try
		Return Query.Execute().Unload()[0].Result;
	Except
		ErrorList.Add(DetailErrorDescription(ErrorInfo()));
	EndTry;
	
	Return ErrorList;
EndFunction

&AtServer
Procedure CalculateQueryRows(Rows, QueryRowsArray)
	For Each Row In Rows Do
		If Row.Status Then
			If ValueIsFilled(Row.Code) Then 
				QueryRowsArray.Add(Row.Code);
			EndIf;
			CalculateQueryRows(Row.Rows, QueryRowsArray);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure FillAdditionalParam(AdditionalParamsStructure)
	For Each Param In AdditionalParamsStructure Do
		SessionParameter = Metadata.SessionParameters.Find(Param.Key);
		If SessionParameter = Undefined Then
			Constant = Metadata.Constants.Find(Param.Key);
			If Not Constant = Undefined Then
				AdditionalParamsStructure.Insert(Param.Key, Constants[Param.Key].Get());
			EndIf;
		Else
			AdditionalParamsStructure.Insert(Param.Key, SessionParameters[Param.Key]);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function AdditionalParamsStructure(RLSParamStructure)
	AdditionalParamList = New Structure;
	For Each Tmp In RLSParamStructure Do
		CodeRows = StrSplit(Tmp.Value.Code, " ,.()/" + Chars.LF, False);
		For Each Row In CodeRows Do
			If StrStartsWith(Row, "&") Then
				AdditionalParamList.Insert(StrReplace(Row, "&", ""));
			EndIf;
		EndDo;
	EndDo;
	
	CodeRows = StrSplit(RLS, " ,.()/" + Chars.LF, False);
	For Each Row In CodeRows Do
		If StrStartsWith(Row, "&") Then
			AdditionalParamList.Insert(StrReplace(Row, "&", ""));
		EndIf;
	EndDo;
	
	Return AdditionalParamList;
EndFunction

&AtClient	
Procedure FillTemplateWithParams(RLSParamStructure)
	For Each Tmp In RLSParamStructure Do
		CurrentCode = Tmp.Value.Code;
		For Index = 0 To Tmp.Value.Params.Ubound() Do
			CurrentCode = StrReplace(CurrentCode, "#Параметр(" + (Index + 1) + ")" , String(Tmp.Value.Params[Index]));
			CurrentCode = StrReplace(CurrentCode, "#Parameter(" + (Index + 1) + ")", String(Tmp.Value.Params[Index]));
			
			CurrentCode = StrReplace(CurrentCode, "#Поле"  + (Index + 1), String(Tmp.Value.Params[Index]));
			CurrentCode = StrReplace(CurrentCode, "#Field" + (Index + 1), String(Tmp.Value.Params[Index]));

		EndDo;                          
		
		For Each NamedParam In Tmp.Value.NamedParams Do
			CurrentCode = StrReplace(CurrentCode, Char(34) + "#" + NamedParam.Key + Char(34), Char(34) + NamedParam.Value + Char(34));
			CurrentCode = StrReplace(CurrentCode, "#" + NamedParam.Key, NamedParam.Value);
		EndDo;
		
		CurrentCode = StrReplace(CurrentCode, "#ИмяТекущегоПраваДоступа", Char(34) + CurrentAccessRightName + Char(34));
		CurrentCode = StrReplace(CurrentCode, "#CurrentAccessRightName", Char(34) + CurrentAccessRightName + Char(34));
		
		CurrentCode = StrReplace(CurrentCode, "#ИмяТекущейТаблицы", Char(34) + CurrentTableName + Char(34));
		CurrentCode = StrReplace(CurrentCode, "#CurrentTableName", Char(34) + CurrentTableName + Char(34));
		
		CurrentCode = StrReplace(CurrentCode, "#ТекущаяТаблица", CurrentTableName);
		CurrentCode = StrReplace(CurrentCode, "#CurrentTable", CurrentTableName);
		
		RLSParamStructure[Tmp.Key].Insert("Code", CurrentCode);
	EndDo;
EndProcedure

&AtClient
Function ParamsStructureInTemplates(Val RLSString, Val TemplateStructure)
	FilteredStructure = New Structure;
	For Each TemplateRow In TemplateStructure Do
		
		StartFunctionNumber = NumberCharFunctionStart(RLSString, TemplateRow);
		If Not StartFunctionNumber Then
			Continue;
		EndIf;
		
		
		FunctionString = FunctionString(RLSString, StartFunctionNumber);

		
		ParamsArray = New Array;
		RLSrows = StrSplit(FunctionString, Char(34), True);
		NamedParamsStructure = New Structure;
		For Index = 0 To RLSrows.UBound() - 1 Do 
			Index = Index + 1;
			ParamsArray.Add(RLSrows[Index]);
			
			If Index - 1 <=  TemplateRow.Value.NamedParams.UBound() Then
				NamedParamsStructure.Insert(TemplateRow.Value.NamedParams[Index - 1], RLSrows[Index]);
			EndIf;
			
		EndDo;
		
		FilteredStructure.Insert(TemplateRow.Key, New Structure);		
		FilteredStructure[TemplateRow.Key].Insert("Code", TemplateRow.Value.Code);
		FilteredStructure[TemplateRow.Key].Insert("Params", ParamsArray);
		FilteredStructure[TemplateRow.Key].Insert("NamedParams", NamedParamsStructure);
		FunctionString = Mid(RLSString, StartFunctionNumber, StrFind(RLSString, ")" , , 
								StrLen(FunctionString) + StartFunctionNumber) - StartFunctionNumber + 1);
		
		FilteredStructure[TemplateRow.Key].Insert("FunctionString", FunctionString);
	EndDo;
	Return FilteredStructure;
EndFunction

&AtClient
Function FunctionString(Val RLSString, Val StartFunctionNumber)
	
	Start = StrFind(RLSString, "(", , StartFunctionNumber) + 1;
	Finish = StrFind(RLSString, ")", , StartFunctionNumber);
	FunctionString = Mid(RLSString, Start, Finish - Start);
	NubersToFind = 0;
	While NOT StrOccurrenceCount(FunctionString, "(") =
						StrOccurrenceCount(FunctionString, ")") Do
		NubersToFind = NubersToFind + 1;
		Start = StrFind(RLSString, "(", , StartFunctionNumber) + 1;
		Finish = StrFind(RLSString, ")", , StartFunctionNumber, NubersToFind);
		FunctionString = Mid(RLSString, Start, Finish - Start);
	EndDo;
	Return FunctionString;

EndFunction

&AtClient
Function NumberCharFunctionStart(Val RLSString, Val TemplateRow)
	
	StartFunctionNumber = StrFind(RLSString, "#" + TemplateRow.Key + "(");
	If StartFunctionNumber Then
		Return StartFunctionNumber;
	EndIf;
	
	StartFunctionNumber = StrFind(RLSString, "#" + TemplateRow.Key + " ");
	If StartFunctionNumber Then
		Return StartFunctionNumber;
	EndIf;
	
	StartFunctionNumber = StrFind(RLSString, "#" + TemplateRow.Key + Chars.LF);
	If StartFunctionNumber Then
		Return StartFunctionNumber;
	EndIf;
	Return 0;
EndFunction

&AtClient
Function DeleteCommentAndEmptyRow(Rows)
	NewRows = New Array;
	For Each Row In Rows Do
		Row = TrimAll(Row);
		If StrStartsWith(Row, "/") Or Row = "" Then
			Continue;
		EndIf;
		
		FindComment = StrFind(Row, "//");
		If FindComment Then
			Row = Left(Row, FindComment - 1);
		EndIf;
		NewRows.Add(Row);
	EndDo;
	Return NewRows;
EndFunction

&AtServer
Function PrepareQueryText(Val Text)
	Text = StrReplace(Text, Char(34), Char(34) + Char(34));
	Text = StrReplace(Text, Chars.LF, Chars.LF + "|");
	Return Text;
EndFunction

#EndRegion

#Region SpecialFunctionForRLS

&AtServer
Function StrContains(String, Substring) Export
	Return StrFind(String, Substring) > 0;
EndFunction

&AtServer
Function СтрСодержит(String, Substring) Export
	Return StrFind(String, Substring) > 0;
EndFunction
#EndRegion

#Region ConvertToExternalBSLCode

&AtServer
Procedure ConvertToBSLCodeAtServer()
	FunctionMap = New Map;
	ArrayBSLCode = New Array;
	ArrayBSLCode.Add("&AtServer");
	ArrayBSLCode.Add("Procedure TestBSL()");
	ArrayBSLCode.Add("ArrayText = New Array;");
	
	ArrayBSLCode.Add("Query = New Query;
	|	
	|	AdditionalParamsStructure = New Structure;
	|	For Each Param In Metadata.SessionParameters Do
	|		Query.SetParameter(Param.Name, SessionParameters[Param.Name]);
	|		AdditionalParamsStructure.Insert(Param.Name, SessionParameters[Param.Name]);
	|	EndDo;");	
	
	Query = New Query;

	AdditionalParamsStructure = New Structure;
	For Each Param In SessionParametersTable Do
		Query.SetParameter(Param.Name, Param.Value);
		AdditionalParamsStructure.Insert(Param.Name, Param.Value);
	EndDo;
	
	ConvertToBSLCodeRecursion(DebugTree.GetItems(), ArrayBSLCode, FunctionMap, AdditionalParamsStructure, Query);
	ArrayBSLCode.Add("EndProcedure");
	
	For Each Func In FunctionMap Do
		ArrayBSLCode.Add(StrConcat(Func.Value, Chars.LF));
	EndDo;
	
	ArrayBSLCode.Add("
		|Function StrContains(String, Substring) Export
		|	Return StrFind(String, Substring) > 0;
		|EndFunction
		|Function СтрСодержит(String, Substring) Export
		|	Return StrFind(String, Substring) > 0;
		|EndFunction");

	
	BSLCode = StrConcat(ArrayBSLCode, Chars.LF);
EndProcedure

&AtServer
Procedure ConvertToBSLCodeRecursion(Rows, Array, FunctionMap, AdditionalParamsStructure, Query)
	For Each Row In Rows Do

		If IsBlankString(Row.ConditionText) Then
			If Row.Condition = "endif" Then
				Row.Condition = Row.Condition + ";";
			EndIf;
			Array.Add(Row.Condition);
		Else
			CodeTypeOrData = CodeTypeOrData(Row.ConditionText, AdditionalParamsStructure, Query);
			
			If TypeOf(CodeTypeOrData) = Type("Boolean") Then
				Array.Add(Row.Condition + " " + Row.ConditionText + " Then");
			Else
				Array.Add(Row.Condition + " " + "QueryFunction" + Format(FunctionMap.Count()) + "(Query) Then");
				
				TmpArray = New Array;
				TmpArray.Add("Function " + "QueryFunction" + Format(FunctionMap.Count()) + "(Query)");
				TmpArray.Add("Query.Text = """ + CodeTypeOrData + """;");
				TmpArray.Add("Return Query.Execute().Unload()[0].Result;");
				TmpArray.Add("EndFunction");
				FunctionMap.Insert("QueryFunction" + Format(FunctionMap.Count()), TmpArray);
			EndIf;
		EndIf;
		
		Text = PrepareQueryText(Row.Code);
		Array.Add("ArrayText.Add(""" + Text + """);");
		
		ConvertToBSLCodeRecursion(Row.GetItems(), Array, FunctionMap, AdditionalParamsStructure, Query);
	EndDo;
EndProcedure

#EndRegion

#Region ConvertToInternalBSLCode

&AtServer
Procedure ConvertToInternalBSLCodeAtServer()
	ArrayBSLCode = New Array;
	ArrayBSLCode.Add("ArrayText = New Array;");
	
	ArrayBSLCode.Add("Query = New Query;
	|	
	|	AdditionalParamsStructure = New Structure;
	|For Each Param In SessionParametersTable Do
	|	Query.SetParameter(Param.Name, Param.Value);
	|	AdditionalParamsStructure.Insert(Param.Name, Param.Value);
	|EndDo;");	
	
	Query = New Query;

	AdditionalParamsStructure = New Structure;
	For Each Param In SessionParametersTable Do
		Query.SetParameter(Param.Name, Param.Value);
		AdditionalParamsStructure.Insert(Param.Name, Param.Value);
	EndDo;
	
	ConvertToInternalBSLCodeRecursion(DebugTree.GetItems()[0].GetItems(), ArrayBSLCode,  AdditionalParamsStructure, Query);
	
	BSLCode = StrConcat(ArrayBSLCode, Chars.LF);
EndProcedure

&AtServer
Procedure ConvertToInternalBSLCodeRecursion(Rows, Array,  AdditionalParamsStructure, Query)
	For Each Row In Rows Do

		If IsBlankString(Row.ConditionText) Then
			If Row.Condition = "endif" Then
				Row.Condition = Row.Condition + ";";
			EndIf;
			Array.Add(Row.Condition);
		Else
			CodeTypeOrData = CodeTypeOrData(Row.ConditionText, AdditionalParamsStructure, Query);
			
			If TypeOf(CodeTypeOrData) = Type("Boolean") Then
				Array.Add(Row.Condition + " " + Row.ConditionText + " Then");
			Else
				Array.Add("Query.Text = """ + CodeTypeOrData + """;");
				Array.Add(Row.Condition + " Query.Execute().Unload()[0].Result Then");
			EndIf;
		EndIf;
		
		Text = PrepareQueryText(Row.Code);
		Array.Add("ArrayText.Add(""" + Text + """);");
		
		ConvertToInternalBSLCodeRecursion(Row.GetItems(), Array, AdditionalParamsStructure, Query);
	EndDo;
EndProcedure

#EndRegion

&AtServer
Function CodeTypeOrData(Val Code, AdditionalParamsStructure, Query)
	//@skip-warning
	Result = Undefined;
	ErrorList = New Array;
	Try
		Execute("Result = " + Code);
		Return False;
	Except
		ErrorList.Add(DetailErrorDescription(ErrorInfo()));
	EndTry;
	
	// try to create query
	Code = StrReplace(Code, "AdditionalParamsStructure.", "&");
	Query.Text = 
	"SELECT TOP 1
	|	CASE
	|		WHEN (" + Code + ")
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS Result";
		
	Try
		Query.Execute();
		Text = Query.Text;
		Text = PrepareQueryText(Text);

		Return Text;
	Except
		ErrorList.Add(DetailErrorDescription(ErrorInfo()));
	EndTry;

	For Each Row In ErrorList Do
		Roles_CommonFunctionsClientServer.ShowUsersMessage(Row);
	EndDo;
	
	Return ErrorList;
EndFunction

&AtServer
Procedure RunBSLCodeAtServer()
	ArrayText = New Array;
	Execute(BSLCode);
	BSLResult = StrConcat(ArrayText, Chars.LF);
EndProcedure

&AtServer
Procedure RunReportAtServer()
	DCSTemplate = GetCommonTemplate("Roles_DCS");
	
	For Each ParamStr In SessionParametersTable Do
		NewParam = DCSTemplate.Parameters.Add();
		NewParam.Name = ParamStr.Name;
		NewParam.Value = ParamStr.Value;
		NewParam.Use = DataCompositionParameterUse.Always;
	EndDo;
	
	QueryText = StrReplace(QueryText, FindStringIntoQuery, ReplaceStringWith);
	
	DataSet = DCSTemplate.DataSets[0];
	DataSet.Query = (QueryText);

	
	Address = PutToTempStorage(DCSTemplate, UUID);
	SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));
	
	SettingsComposer.LoadSettings(DCSTemplate.DefaultSettings);
	SettingsComposer.Settings.Selection.Items.Clear();
	For Each Field In SettingsComposer.Settings.Selection.SelectionAvailableFields.Items Do
		If Field.Folder Then
			Continue;
		EndIf;
		Selection = SettingsComposer.Settings.Selection.Items.Add(Type("DataCompositionSelectedField"));
		Selection.Use = True;
		Selection.Field = Field.Field; 
	EndDo;
	
	
	
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

&AtClient
Procedure AfterQueryChange(Text, AddInfo) Export
    If Not IsBlankString(QueryText) Then
        QueryText = Text;
    EndIf;
EndProcedure

&AtClient
Procedure FillSessionParametersTable(Val RLSParamStructure)
	If Not UseSessionParametersFromTable Or 
			UseSessionParametersFromTable And Not SessionParametersTable.Count() Then
		AdditionalParamsStructure = AdditionalParamsStructure(RLSParamStructure);
		FillAdditionalParam(AdditionalParamsStructure);
		
		SessionParametersTable.Clear();		
		For Each Param In AdditionalParamsStructure Do
			NewSP = SessionParametersTable.Add();
			NewSP.Name = Param.Key;
			NewSP.Value = Param.Value;
		EndDo;	
	Else
		AdditionalParamsStructure = New Structure;
		For Each Param In SessionParametersTable Do
			AdditionalParamsStructure.Insert(Param.Name, Param.Value);
		EndDo; 
	EndIf;
EndProcedure
#EndRegion




