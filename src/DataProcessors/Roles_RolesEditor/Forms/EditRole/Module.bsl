

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	NewRow = ThisObject.Objects.Add();
	NewRow.FullName = Metadata.Catalogs.ItemKeys.FullName();
	ArrayOfMetadataNames = New Array();
	For Each Row In ThisObject.Objects Do
		ArrayOfMetadataNames.Add(Row.FullName);
	EndDo;
	FillRoleTree(ArrayOfMetadataNames, ThisObject.RoleTree);
EndProcedure

&AtServer
Procedure FillRoleTree(ArrayOfMetadataNames, Tree)
	For Each MetadataName In ArrayOfMetadataNames Do
		MetadataObject = Metadata.FindByFullName(MetadataName);
		If Metadata.Catalogs.Contains(MetadataObject) Then
			FillRoleTree_Catalog(MetadataObject, Tree);
		EndIf;
	EndDo; 
EndProcedure

&AtServer
Procedure FillRoleTree_Catalog(MetadataObject, Tree)
	MetadataInfo = GetMetadataInfo_Catalog(MetadataObject);
	Row0 = Tree.GetItems().Add();
	Row0.Object = MetadataInfo.FullName;
	
	Row1 = Row0.GetItems().Add();
	Row1.Attributes = "Attributes";
	For Each Attribute In MetadataInfo.Attributes Do
		Row2 = Row1.GetItems().Add();
		Row2.AttributeName = Attribute.Name;
	EndDo;
	
	Row1 = Row0.GetItems().Add();
	Row1.Commands = "Commands";
	For Each Command In MetadataInfo.Commands Do
		Row2 = Row1.GetItems().Add();
		Row2.CommandName = Command.Name;
	EndDo;
	
	Row1 = Row0.GetItems().Add();
	Row1.StandardAttributes = "Standard attributes";
	For Each StandardAttribute In MetadataInfo.StandardAttributes Do
		Row2 = Row1.GetItems().Add();
		Row2.StandardAttributeName = StandardAttribute.Name;
		Row2.StandardAttributeIsExist = StandardAttribute.IsExist;
	EndDo;
	
	Row1 = Row0.GetItems().Add();
	Row1.TabularSections = "Tabular sections";
	For Each TabularSection In MetadataInfo.TabularSections Do
		Row2 = Row1.GetItems().Add();
		Row2.TabularSectionName = TabularSection.Name;
		For Each TabularSectionAttribute In TabularSection.Attributes Do
			Row3 = Row2.GetItems().Add();
			Row3.TabularSectionAttributeName = TabularSectionAttribute.Name;
		EndDo;
	EndDo;
	
EndProcedure


&AtServerNoContext
Function GetMetadataInfo_Catalog(MetadataObject)
	MetadataInfo = New Structure();
	MetadataInfo.Insert("FullName", MetadataObject.FullName());
	MetadataInfo.Insert("Attributes", New Array());
	MetadataInfo.Insert("Commands", New Array());
	MetadataInfo.Insert("StandardAttributes", New Array());
	MetadataInfo.Insert("TabularSections", New Array());
	
	For Each Attribute In MetadataObject.Attributes Do
		AttributeInfo = New Structure();
		AttributeInfo.Insert("Name", Attribute.Name);
		MetadataInfo.Attributes.Add(AttributeInfo);
	EndDo;
	
	For Each Command In MetadataObject.Commands Do
		CommandInfo = New Structure();
		CommandInfo.Insert("Name", Command.Name);
		MetadataInfo.Commands.Add(CommandInfo);
	EndDo;
	
	ArrayOfPossibleStandardAttributes = New Array();
	ArrayOfPossibleStandardAttributes.Add("Code");
	ArrayOfPossibleStandardAttributes.Add("DeletionMark");
	ArrayOfPossibleStandardAttributes.Add("Description");
	ArrayOfPossibleStandardAttributes.Add("IsFolder");
	ArrayOfPossibleStandardAttributes.Add("Owner");
	ArrayOfPossibleStandardAttributes.Add("Parent");
	ArrayOfPossibleStandardAttributes.Add("Predefined");
	ArrayOfPossibleStandardAttributes.Add("PredefinedDataName");
	ArrayOfPossibleStandardAttributes.Add("Ref");
	
	TableOfExistsStandardAttributes = New ValueTable();
	TableOfExistsStandardAttributes.Columns.Add("Name");
	TableOfExistsStandardAttributes.Columns.Add("Info");
	
	For Each StandardAttribute In MetadataObject.StandardAttributes Do
		NewRow = TableOfExistsStandardAttributes.Add();
		NewRow.Name = StandardAttribute.Name;
		
		StandardAttributeInfo = New Structure();
		StandardAttributeInfo.Insert("Name", StandardAttribute.Name);
		StandardAttributeInfo.Insert("IsExist", True);
		NewRow.Info = StandardAttributeInfo;
	EndDo;
	
	For Each StandardAttribute In ArrayOfPossibleStandardAttributes Do
		TableRow = TableOfExistsStandardAttributes.Find(StandardAttribute, "Name");
		If TableRow <> Undefined Then
			MetadataInfo.StandardAttributes.Add(TableRow.Info);
		Else
			StandardAttributeInfo = New Structure();
			StandardAttributeInfo.Insert("Name", StandardAttribute);
			StandardAttributeInfo.Insert("IsExist", False);
			MetadataInfo.StandardAttributes.Add(StandardAttributeInfo);
		EndIf;
	EndDo;
	
	For Each TabularSection In MetadataObject.TabularSections Do
		TabularSectionInfo = New Structure();
		TabularSectionInfo.Insert("Name", TabularSection.Name);
		TabularSectionInfo.Insert("Attributes", New Array());
		MetadataInfo.TabularSections.Add(TabularSectionInfo);
		For Each TabularSectionAttribute In TabularSection.Attributes Do
			TabularSectionAttributeInfo = New Structure();
			TabularSectionAttributeInfo.Insert("Name", TabularSectionAttribute.Name);
			TabularSectionInfo.Attributes.Add(TabularSectionAttributeInfo);
		EndDo;
	EndDo;
	
	Return MetadataInfo;
EndFunction

