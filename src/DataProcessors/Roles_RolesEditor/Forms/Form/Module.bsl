
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillRoles();
EndProcedure

&AtClient
Procedure RolesSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
EndProcedure

&AtServer
Procedure FillRoles()
	ThisObject.Roles.GetItems().Clear();
	ArrayOfRoles = GetArrayOfRoles();
	For Each Role In ArrayOfRoles Do
		NewRow = ThisObject.Roles.GetItems().Add();
		NewRow.Synonym = Role.Synonym;
		NewRow.Name = Role.Name;
	EndDo;
EndProcedure

&AtServerNoContext
Function GetRoleInfo()
	RoleInfo = New Structure();
	RoleInfo.Insert("Synonym", "");
	RoleInfo.Insert("Name", "");
	Return RoleInfo;
EndFunction

&AtServerNoContext
Function GetArrayOfRoles()
	ArrayOfRoles = New Array();
	For Each Role In Metadata.Roles Do
		RoleInfo = GetRoleInfo();
		RoleInfo.Synonym = Role.Synonym;
		RoleInfo.Name = Role.FullName();
		ArrayOfRoles.Add(RoleInfo);
	EndDo;
	Return ArrayOfRoles;
EndFunction

&AtServerNoContext
Function GetPossibleAccessRightFor_Catalog()
	ArrayOfAccessRight = New Array();
	ArrayOfAccessRight.Add("Insert");
	ArrayOfAccessRight.Add("Read");
	ArrayOfAccessRight.Add("Update");
	ArrayOfAccessRight.Add("Delete");
	Return ArrayOfAccessRight;
EndFunction

&AtServerNoContext
Function GetAccessRightsFor_Catalog(RoleInfo)
	RoleMetadataObject = Metadata.FindByFullName(RoleInfo.Name);
	For Each MetadataItem In Metadata.Catalogs Do
		For Each AccessRight In GetPossibleAccessRightFor_Catalog() Do
			IsAccess = AccessRight(AccessRight, MetadataItem, RoleMetadataObject);
		EndDo;
	EndDo;
EndFunction

&AtClient
Procedure TestRoleEditor(Command)
	OpenForm("DataProcessor.Roles_RolesEditor.Form.EditRole", , ThisObject, ThisObject.UUID);
EndProcedure

#Region Extention
&AtClient
Procedure UpdateExtention(Command)
	Roles_GenerateExtension.UpdateRoleExt();
EndProcedure
#EndRegion

