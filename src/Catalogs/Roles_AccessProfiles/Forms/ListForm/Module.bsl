
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Items.FormCopyCurrentProfiles.Visible = Roles_Settings.isMetadataExist("Catalog.ПрофилиГруппДоступа");
EndProcedure

#EndRegion

&AtClient
Procedure CopyCurrentProfiles(Command)
	 CopyAndUpdateProfiles();
EndProcedure

&AtServer
Procedure CopyAndUpdateProfiles()
	
	Query = New Query;
	Query.Text = 
		"SELECT
		|	Profile.Ref AS Profile,
		|	Roles_AccessRoles.Ref AS AccessRoles
		|FROM
		|	Catalog.%1 AS Profile
		|		LEFT JOIN Catalog.Roles_AccessRoles AS Roles_AccessRoles
		|		ON (Profile.%2 = Roles_AccessRoles.Description)
		|TOTALS BY
		|	Profile
		|";
	If Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.English Then
		Query.Text = StrTemplate(Query.Text, "AccessGroupProfiles.Roles", "Role.Name")
	Else
		Query.Text = StrTemplate(Query.Text, "ПрофилиГруппДоступа.Роли", "Роль.Имя")
	EndIf;
	
	ProfileList = Query.Execute().Select(QueryResultIteration.ByGroups);
	
	While ProfileList.Next() Do
		
		Profile = CopyAndUpdateProfiles_CreateProfile(ProfileList.Profile);
		Roles = ProfileList.Select();	
		Profile.Roles.Clear();
		While Roles.Next() Do
			RoleRow = Profile.Roles.Add();
			RoleRow.Role = Roles.AccessRoles; 
		EndDo;
		Profile.Write();
	EndDo;

EndProcedure

&AtServer
Function CopyAndUpdateProfiles_CreateProfile(MainProfile)
	ProfileRef = Catalogs.Roles_AccessProfiles.GetRef(MainProfile.UUID());
	Profile = ProfileRef.GetObject();
	If Profile = Undefined Then
		If MainProfile.IsFolder Then
			Profile = Catalogs.Roles_AccessProfiles.CreateFolder();
		Else
			Profile = Catalogs.Roles_AccessProfiles.CreateItem();
		EndIf;
		Profile.SetNewObjectRef(ProfileRef);
	EndIf;	
	
	Profile.Description = MainProfile.Description;
	Profile.DeletionMark = MainProfile.DeletionMark;
	
	If NOT MainProfile.Parent.isEmpty() Then
		Profile.Parent = CopyAndUpdateProfiles_CreateProfile(MainProfile.Parent);
	EndIf;
	
	If MainProfile.isFolder Then
		Profile.Write();
		Return Profile.Ref;
	Else
		Return Profile;
	EndIf;
	
EndFunction

