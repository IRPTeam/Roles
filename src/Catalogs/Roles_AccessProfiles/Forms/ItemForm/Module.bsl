&AtClient
Var AllRights Export;

&AtClient
Procedure UpdateMatrix(Command)
	UpdateMatrixAtServer(AllRights);
EndProcedure

&AtClient
Procedure TabDocMartixOnActivate(Item)
	
	If Object.Roles.Total("CurrentRole") Then
		For Each RoleRow In Object.Roles Do
			RoleRow.CurrentRole = False;
		EndDo;
	EndIf;
	
	SelectedAreas = Items.TabDocMartix.GetSelectedAreas();
	If Not SelectedAreas.Count() Then
		Return;
	EndIf;
	ObjectPath = Undefined;
	RightName = Undefined;
	Top = SelectedAreas[0].Top;
	Left = SelectedAreas[0].Left;
	If Top Then
		ObjectPath = TabDocMartix.Area(Top, 3).Text;
	EndIf;
	If Left Then
		RightName =  TabDocMartix.Area(1, Left).Details;
	EndIf;
	If Not ValueIsFilled(RightName) Or Not ValueIsFilled(ObjectPath) Then
		Return;
	EndIf;
	DataPath = AllRights.Get(ObjectPath);
	If DataPath = Undefined Then
		Return;
	EndIf;
	RoleRefArray = DataPath.Get(RightName);
	If RoleRefArray = Undefined Then
		Return;
	EndIf;
	
	For Each RoleRow In Object.Roles Do
		RoleRow.CurrentRole = Not RoleRefArray.Find(RoleRow.Role) = Undefined;
	EndDo;
EndProcedure


&AtServer
Procedure UpdateMatrixAtServer(AllRights)
	
	RoleTree = Roles_SettingsReUse.RoleTree();
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Roles_AccessRoles.Ref AS Ref
		|INTO Roles
		|FROM
		|	Catalog.Roles_AccessRoles AS Roles_AccessRoles
		|WHERE
		|	Roles_AccessRoles.Ref IN(&Ref)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Roles_AccessRolesRights.Ref AS Ref,
		|	Roles_AccessRolesRights.ObjectType AS ObjectType,
		|	Roles_AccessRolesRights.ObjectName AS ObjectName,
		|	Roles_AccessRolesRights.RightName AS RightName,
		|	Roles_AccessRolesRights.RowID AS RowID,
		|	Roles_AccessRolesRights.ObjectPath AS ObjectPath,
		|	Roles_AccessRolesRights.RightValue AS RightValue,
		|	Roles_AccessRolesRights.Disable AS Disable
		|FROM
		|	Roles AS Roles
		|		INNER JOIN Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|		ON (Roles_AccessRolesRights.Ref = Roles.Ref)
		|WHERE
		|	NOT Roles_AccessRolesRights.Disable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Roles_AccessRolesRestrictionByCondition.Ref AS Ref,
		|	Roles_AccessRolesRestrictionByCondition.RowID AS RowID,
		|	Roles_AccessRolesRestrictionByCondition.Fields AS Fields,
		|	Roles_AccessRolesRestrictionByCondition.Condition AS Condition
		|FROM
		|	Roles AS Roles
		|		INNER JOIN Catalog.Roles_AccessRoles.RestrictionByCondition AS Roles_AccessRolesRestrictionByCondition
		|		ON (Roles_AccessRolesRestrictionByCondition.Ref = Roles.Ref)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Roles_AccessRolesRights.Ref AS Ref,
		|	Roles_AccessRolesRights.RightName AS RightName,
		|	Roles_AccessRolesRights.ObjectPath AS ObjectPath
		|FROM
		|	Roles AS Roles
		|		INNER JOIN Catalog.Roles_AccessRoles.Rights AS Roles_AccessRolesRights
		|		ON (Roles_AccessRolesRights.Ref = Roles.Ref)
		|WHERE
		|	NOT Roles_AccessRolesRights.Disable
		|TOTALS BY
		|	ObjectPath,
		|	RightName";
	
	Query.SetParameter("Ref", Object.Roles.Unload(New Structure("Hide", False)).UnloadColumn("Role"));
	
	QueryResult = Query.ExecuteBatch();
	AllRightsVT =  QueryResult[1].Unload();
	ObjectData = New Structure;
	ObjectData.Insert("RightTable",AllRightsVT);
	ObjectData.Insert("RestrictionByCondition", QueryResult[2].Unload());
	ObjectData.Insert("SetRightsForNewNativeObjects", True);
	ObjectData.Insert("SetRightsForAttributesAndTabularSectionsByDefault", True);
	ObjectData.Insert("SubordinateObjectsHaveIndependentRights", True);
	TabDocMartix = Roles_RoleMatrix.GenerateRoleMatrix(RoleTree, ObjectData, True, True);
	
	AllRightsTree = QueryResult[3].Unload(QueryResultIteration.ByGroups);
	AllRights.Clear();
	For Each ObjectPath In AllRightsTree.Rows Do
		
		RightNameMap = New Map;
		For Each RightName In ObjectPath.Rows Do
			Array = New Array;
			For Each Ref In RightName.Rows Do
		   		Array.Add(Ref.Ref);
			EndDo;
			RightNameMap.Insert(RightName.RightName, Array);
		EndDo;
		AllRights.Insert(ObjectPath.ObjectPath, RightNameMap);
	EndDo;
	Items.TabDocMartix.BlackAndWhiteView = False;
EndProcedure

&AtClient
Procedure RolesOnChange(Item)
	Items.TabDocMartix.BlackAndWhiteView = True;
EndProcedure

&AtClient
Procedure EditOn(Command)
	Items.TabDocMartixEditOn.Check = Not Items.TabDocMartixEditOn.Check;
	Items.TabDocMartix.Protection = Not Items.TabDocMartixEditOn.Check;
EndProcedure


AllRights = New Map;