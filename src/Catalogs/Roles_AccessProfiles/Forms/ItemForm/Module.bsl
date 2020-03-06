

&AtClient
Procedure UpdateMatrix(Command)
	UpdateMatrixAtServer();
EndProcedure

&AtServer
Procedure UpdateMatrixAtServer()
	
	RoleTree = Roles_SettingsReUse.RoleTree();
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Roles_AccessRoles.Ref
		|INTO Roles
		|FROM
		|	Catalog.Roles_AccessRoles AS Roles_AccessRoles
		|WHERE
		|	Roles_AccessRoles.Ref IN (&Ref)
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Roles_AccessRolesRights.Ref,
		|	Roles_AccessRolesRights.ObjectType,
		|	Roles_AccessRolesRights.ObjectName,
		|	Roles_AccessRolesRights.RightName,
		|	Roles_AccessRolesRights.RowID,
		|	Roles_AccessRolesRights.ObjectPath,
		|	Roles_AccessRolesRights.RightValue,
		|	Roles_AccessRolesRights.Disable
		|FROM
		|	Roles AS Roles
		|		INNER JOIN Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|		ON Roles_AccessRolesRights.Ref = Roles.Ref
		|WHERE
		|	NOT Roles_AccessRolesRights.Disable
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Roles_AccessRolesRestrictionByCondition.Ref,
		|	Roles_AccessRolesRestrictionByCondition.RowID,
		|	Roles_AccessRolesRestrictionByCondition.Fields,
		|	Roles_AccessRolesRestrictionByCondition.Condition
		|FROM
		|	Roles AS Roles
		|		INNER JOIN Catalog.Roles_AccessRoles.RestrictionByCondition AS Roles_AccessRolesRestrictionByCondition
		|		ON Roles_AccessRolesRestrictionByCondition.Ref = Roles.Ref";
	
	Query.SetParameter("Ref", Object.Roles.Unload().UnloadColumn("Role"));
	
	QueryResult = Query.ExecuteBatch();
	
	ObjectData = New Structure;
	ObjectData.Insert("RightTable", QueryResult[1].Unload());
	ObjectData.Insert("RestrictionByCondition", QueryResult[2].Unload());
	ObjectData.Insert("SetRightsForNewNativeObjects", True);
	ObjectData.Insert("SetRightsForAttributesAndTabularSectionsByDefault", True);
	ObjectData.Insert("SubordinateObjectsHaveIndependentRights", True);
	TabDocMartix = Roles_RoleMatrix.GenerateRoleMatrix(RoleTree, ObjectData, True, True);

EndProcedure
