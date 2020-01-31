Procedure UpdateUsersRoleOnWrite(Source, Cancel = False) Export
	If Cancel Then
		Return;
	EndIf;
	
	If TypeOf(Source) = Type("CatalogObject.Roles_AccessGroups") Then
		Result = UpdateUsersRolesByGroup(Source.Ref);
	ElsIf TypeOf(Source) = Type("CatalogObject.Roles_AccessProfiles") Then
		Result = UpdateUsersRole(Source.Ref);
	Else
		Return;
	EndIf;
	If Source.AdditionalProperties.Property("UsersEventOnWriteResult") Then
		Source.AdditionalProperties["UsersEventOnWriteResult"] = Result;
	Else
		Source.AdditionalProperties.Insert("UsersEventOnWriteResult", Result);
	EndIf;
EndProcedure

Function UpdateUsersRolesByGroup(AccessGroup)
	
	For Each Row In AccessGroup.Profiles Do
		UpdateUsersRole(Row.Profile);
	EndDo;
	
	Return Undefined;
	
EndFunction

Function UpdateUsersRole(AccessProfile)
	Result = New Structure();
	Result.Insert("Success", True);
	Result.Insert("ArrayOfResults", New Array());
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	AccessGroupsProfiles.Ref
		|INTO vt_AccessGroups
		|FROM
		|	Catalog.Roles_AccessGroups.Profiles AS AccessGroupsProfiles
		|WHERE
		|	AccessGroupsProfiles.Profile = &Profile
		|GROUP BY
		|	AccessGroupsProfiles.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	AccessGroupsUsers.User
		|FROM
		|	Catalog.Roles_AccessGroups.Users AS AccessGroupsUsers
		|		INNER JOIN vt_AccessGroups AS vt_AccessGroups
		|		ON AccessGroupsUsers.Ref = vt_AccessGroups.Ref
		|GROUP BY
		|	AccessGroupsUsers.User";
	Query.SetParameter("Profile", AccessProfile);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		If ValueIsFilled(QuerySelection.User.InfobaseUserID) Then
			User = InfoBaseUsers.FindByUUID(QuerySelection.User.InfobaseUserID);
		ElsIf ValueIsFilled(QuerySelection.User.Description) Then
			User = InfoBaseUsers.FindByName(QuerySelection.User.Description);
		Else
			User = Undefined;
		EndIf;
		If User = Undefined Then
			Result.Success = False;
			Result.ArrayOfResults.Add(New Structure("Success, Message", False,
					StrTemplate(R()["UsersEvent_001"], QuerySelection.User.InfobaseUserID, QuerySelection.User.Description)));
		Else
			Result.ArrayOfResults.Add(New Structure("Success, Message", True,
					StrTemplate(R()["UsersEvent_002"], QuerySelection.User.InfobaseUserID, QuerySelection.User.Description)));
			User.Roles.Clear();
			AddRoles(AccessProfile.Roles, User);
			User.Write();
		EndIf;
	EndDo;
	Return Result;
EndFunction

Procedure AddRoles(Roles, User)
	For Each Row In Roles Do
		MetadataRole = Metadata.Roles.Find(Row.Role);
		If MetadataRole <> Undefined Then
			User.Roles.Add(MetadataRole);
		EndIf;
	EndDo;
EndProcedure