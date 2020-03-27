
&AtClient
Procedure ConvertToQuery(Command)
	TemplateStructure = New Structure;
	For Each Tmp In Templates Do
		TemplateRows = StrSplit(Tmp.Code, Chars.LF, False);
		TemplateRows = DeleteCommentAndEmptyRow(TemplateRows);
		
		TemplateStructure.Insert(Tmp.Name,  New Structure("Code, Params", StrConcat(TemplateRows, Chars.LF), New Array));
	EndDo;
	RLSParamStructure = ParamsStructureInTemplates(RLS, TemplateStructure);
	
	FillTemplateWithParams(RLSParamStructure);
	
	AdditionalParamsStructure = AdditionalParamsStructure(RLSParamStructure);
	
	FillAdditionalParam(AdditionalParamsStructure);
	
	DebugTree.GetItems().Clear();
	
	CalculateResultQuery(RLSParamStructure, AdditionalParamsStructure);
	
EndProcedure

&AtServer
Procedure CalculateResultQuery(RLSParamStructure, AdditionalParamsStructure)
	DebugsTree = FormAttributeToValue("DebugTree");
	For Each Tmp In RLSParamStructure Do
		
		NewRow = DebugsTree.Rows.Add();
		NewRow.Condition = Tmp.Key;
		NewRow.Result = True;
		FullCode = StrReplace(Tmp.Value.Code, "&", "AdditionalParamsStructure.");
		Result = True;	
		Rows = StrSplit(FullCode, "#", False);
		Skip = False;
		Query = StrConcat(Rows, Chars.LF);
		For Index = 0 To Rows.Count() - 1 Do
			Row = Rows[Index];
			Row = TrimAll(Row);
			FirstTextLen = StrLen(StrSplit(Row, " " + Chars.LF, False)[0]);
			If StrStartsWith(Lower(Row), "if") Or StrStartsWith(Lower(Row), "если") Then
				
				
				
				Code = Right(Row, StrLen(Row) - FirstTextLen);
				Execute("Result = " + Code);
				
				
				NewRow = NewRow.Rows.Add();
				NewRow.Condition = "If";
				NewRow.ConditionText = Code;
				If Not NewRow.Parent.Result	Then
					Result = False;	
				EndIf;
				NewRow.Result = Result;

				
				
				Index = Index + 1;
				Row = Rows[Index];
				Row = TrimAll(Row);
				FirstTextLen = StrLen(StrSplit(Row, " " + Chars.LF, False)[0]);
				Code = Right(Row, StrLen(Row) - FirstTextLen);
				NewRow.Code = Code;						
		
			ElsIf StrStartsWith(Lower(Row), "elsif") Or StrStartsWith(Lower(Row), "иначеесли") Then
				
				Code = Right(Row, StrLen(Row) - FirstTextLen);
				NewRow = NewRow.Parent.Rows.Add();
				NewRow.Condition = "elsif";
				Execute("Result = " + Code);
				NewRow.ConditionText = Code;

				TmpIndex = NewRow.Parent.Rows.Count() - 1;
				isSet = False;
				While TmpIndex >= 0 Do
					If NewRow.Parent.Rows[TmpIndex].Condition = "endif" Then
						Break;
					Else
						If NewRow.Parent.Rows[TmpIndex].Result Then
							isSet = True;
							Break;
						EndIf;
					EndIf;
					TmpIndex = TmpIndex - 1;
				EndDo;
				If isSet Then
					NewRow.Result = False;
				Else
				    NewRow.Result = Result;
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
				
				isSet = False;
				While TmpIndex >= 0 Do
					If NewRow.Parent.Rows[TmpIndex].Condition = "endif" Then
						Break;
					Else
						If NewRow.Parent.Rows[TmpIndex].Result Then
							isSet = True;
							Break;
						EndIf;
					EndIf;
					TmpIndex = TmpIndex - 1;
				EndDo;
				If isSet Then
					NewRow.Result = False;
				Else
				    NewRow.Result = NewRow.Parent.Result;
				EndIf;
				
			ElsIf StrStartsWith(Lower(Row), "endif") Or StrStartsWith(Lower(Row), "конецесли") Then
						
				Code = Right(Row, StrLen(Row) - FirstTextLen);
				NewRow = NewRow.Parent.Rows.Add();
				NewRow.Condition = "endif";
				NewRow.Code = Code;
				NewRow.Result = NewRow.Parent.Result;
				NewRow =  NewRow.Parent;
			Else
				Continue;
			EndIf;
		EndDo;
		QueryRowsArray = New Array;
		DebugsTree.Rows[0].Status = True;
		CalculateQueryRows(DebugsTree.Rows[0].Rows, QueryRowsArray);
		Query = StrConcat(QueryRowsArray,"");
		Query = StrReplace(Query, "AdditionalParamsStructure.", "&")
	EndDo;
	
	ValueToFormAttribute(DebugsTree, "DebugTree");

EndProcedure

&AtServer
Procedure CalculateQueryRows(Rows, QueryRowsArray)
	For Each Row In Rows Do
		If Row.Result Then
			If ValueIsFilled(Row.Code) Then 
				QueryRowsArray.Add(Row.Code);
			EndIf;
			CalculateQueryRows(Row.Rows, QueryRowsArray)
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure FillAdditionalParam(AdditionalParamsStructure)
	For Each Param In AdditionalParamsStructure Do
		SessionParameter = Metadata.SessionParameters.Find(Param.Key);
		If SessionParameter = Undefined Then
			Constant = Metadata.Constants.Find(Param.Key);
			If Constant = Undefined Then
				// Raise Param.Key;
			Else
				AdditionalParamsStructure.Insert(Param.Key, Constants[Param.Key].Get());
			EndIf;
		Else
			AdditionalParamsStructure.Insert(Param.Key, SessionParameters[Param.Key]);
		EndIf;
		
	EndDo;
EndProcedure

Function AdditionalParamsStructure(RLSParamStructure)
	AdditionalParamList = New Structure;
	For Each Tmp In RLSParamStructure Do
		CodeRows = StrSplit(Tmp.Value.Code, " ,.()/" + Chars.LF, False);
		For Each Row In CodeRows Do
			If StrStartsWith(Row, "&") Then
				AdditionalParamList.Insert(StrReplace(Row,"&",""));
			EndIf;
		EndDo;
	EndDo;
	Return AdditionalParamList;
EndFunction
	
Procedure FillTemplateWithParams(RLSParamStructure)
	For Each Tmp In RLSParamStructure Do
		CurrentCode = Tmp.Value.Code;
		For Index = 0 To Tmp.Value.Params.Ubound() Do
			CurrentCode = StrReplace(CurrentCode, "#Параметр(" + (Index + 1) + ")" , String(Tmp.Value.Params[Index]));
			CurrentCode = StrReplace(CurrentCode, "#Parameter(" + (Index + 1) + ")", String(Tmp.Value.Params[Index]));
		EndDo;                            
		
		CurrentCode = StrReplace(CurrentCode, "#ИмяТекущегоПраваДоступа", Char(34) + CurrentAccessRightName + Char(34));
		CurrentCode = StrReplace(CurrentCode, "#CurrentAccessRightName", Char(34) + CurrentAccessRightName + Char(34));
		
		CurrentCode = StrReplace(CurrentCode, "#ИмяТекущейТаблицы", Char(34) + CurrentTableName + Char(34));
		CurrentCode = StrReplace(CurrentCode, "#CurrentTableName", Char(34) + CurrentTableName + Char(34));

		RLSParamStructure[Tmp.Key].Insert("Code", CurrentCode);
	EndDo;
EndProcedure

Function StrContains(String, Substring)
	Return StrFind(String, Substring) > 0;
EndFunction

Function СтрСодержит(String, Substring)
	Return StrFind(String, Substring) > 0;
EndFunction

Function ParamsStructureInTemplates(Val RLSString, Val TemplateStructure)
	
	For Each TemplateRow In TemplateStructure Do
		
		StartFunctionNumber = NumberCharFunctionStart(RLSString, TemplateRow);
		If Not StartFunctionNumber Then
			Continue;
		EndIf;
		
		FunctionString = FunctionString(RLSString, StartFunctionNumber);

		ParamsArray = New Array;
		RLSrows = StrSplit(FunctionString, Char(34), True);
		For Index = 0 To RLSrows.UBound() - 1 Do 
			Index = Index + 1;
			ParamsArray.Add(RLSrows[Index]);
		EndDo;
		TemplateStructure[TemplateRow.Key].Insert("Params", ParamsArray);

	EndDo;
	Return TemplateStructure;
EndFunction

Function FunctionString(Val RLSString, Val StartFunctionNumber)
	
	Var Finish, FunctionString, Start;
	
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
