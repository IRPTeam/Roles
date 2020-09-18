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
	
	FindConfigRole = Rights.FindRows(New Structure("ObjectType", Enums.Roles_MetadataTypes.Configuration));
	For Each Row In FindConfigRole Do
		Rights.Delete(Row);
	EndDo;
EndProcedure

Procedure BeforeWrite(Cancel)
	If ConfigRoles And Not AdditionalProperties.Property("Update") Then
		Cancel = True;
	EndIf;
	
	If Not SetSeparateRightToStandardAttributes And Not ConfigRoles Then
		
		FindRowsWithStandardAttribures = Rights.FindRows(New Structure("ObjectSubtype", Enums.Roles_MetadataSubtype.StandardAttribute));
		For Each Row In FindRowsWithStandardAttribures Do
			Rights.Delete(Row);		
		EndDo;
		
		FindFirstLvlType = Rights.FindRows(New Structure("ObjectSubtype, RightName", Enums.Roles_MetadataSubtype.EmptyRef(), Enums.Roles_Rights.View));
		FillStandardAttributes(FindFirstLvlType);
				
		FindFirstLvlType = Rights.FindRows(New Structure("ObjectSubtype, RightName", Enums.Roles_MetadataSubtype.EmptyRef(), Enums.Roles_Rights.Edit));
		FillStandardAttributes(FindFirstLvlType);
	EndIf;
EndProcedure

Procedure FillStandardAttributes(Val FindFirstLvlType)	
	For Each Row In FindFirstLvlType Do
		If Roles_Settings.hasStandardAttributes(Row.ObjectType) Then
			For Each StAttribute In Metadata.FindByFullName(Row.ObjectPath).StandardAttributes Do
				NewRow = Rights.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.ObjectSubtype = Enums.Roles_MetadataSubtype.StandardAttribute;
				NewRow.ObjectPath = NewRow.ObjectPath + ".StandardAttribute." + Roles_SettingsReUse.TranslationList(StAttribute.Name)
			EndDo;
		EndIf;		
	EndDo;
EndProcedure

#EndRegion