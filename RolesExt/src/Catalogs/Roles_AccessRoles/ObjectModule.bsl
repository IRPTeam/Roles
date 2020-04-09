#Region Private
Procedure OnCopy(CopiedObject)
	For Each Row In Rights Do
		NewID = New UUID;
		FindRestrictions = RestrictionByCondition.FindRows(New Structure("RowID", Row.RowID));
		For Each Restriction In FindRestrictions Do
			Restriction.RowID = NewID;
		EndDo;
		Row.RowID = NewID;
		ConfigRoles = False;
	EndDo;
EndProcedure

Procedure BeforeWrite(Cancel)
	If ConfigRoles And Not AdditionalProperties.Property("Update") Then
		Cancel = True;
	EndIf;
EndProcedure
#EndRegion