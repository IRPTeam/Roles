#Region Service
Function RolesSet() Export
	Settings = New Structure;
	
	#Region Configuration
	Configuration = New Array;
	Configuration.Add("Administration");
	Configuration.Add("DataAdministration");
	Configuration.Add("UpdateDataBaseConfiguration");
	Configuration.Add("ExclusiveMode");
	Configuration.Add("ActiveUsers");
	Configuration.Add("EventLog");
	Configuration.Add("ThinClient");
	Configuration.Add("WebClient");
	Configuration.Add("MobileClient");
	Configuration.Add("ThickClient");
	Configuration.Add("ExternalConnection");
	Configuration.Add("Automation");
	Configuration.Add("TechnicalSpecialistMode");
	Configuration.Add("CollaborationSystemInfoBaseRegistration");
	Configuration.Add("MainWindowModeNormal");
	Configuration.Add("MainWindowModeWorkplace");
	Configuration.Add("MainWindowModeEmbeddedWorkplace");
	Configuration.Add("MainWindowModeFullscreenWorkplace");
	Configuration.Add("MainWindowModeKiosk");
	Configuration.Add("AnalyticsSystemClient");
	Configuration.Add("SaveUserData");
	Configuration.Add("ConfigurationExtensionsAdministration");
	Configuration.Add("InteractiveOpenExtDataProcessors");
	Configuration.Add("InteractiveOpenExtReports");
	Configuration.Add("Output");
	#EndRegion
	Settings.Insert("Configuration", Configuration);

	#Region BusinessProcess
	BusinessProcess = New Array;
	BusinessProcess.Add("Read");
	BusinessProcess.Add("Insert");
	BusinessProcess.Add("Update");
	BusinessProcess.Add("Delete");
	BusinessProcess.Add("View");
	BusinessProcess.Add("InteractiveInsert");
	BusinessProcess.Add("Edit");
	BusinessProcess.Add("InteractiveDelete");
	BusinessProcess.Add("InteractiveSetDeletionMark");
	BusinessProcess.Add("InteractiveClearDeletionMark");
	BusinessProcess.Add("InteractiveDeleteMarked");
	BusinessProcess.Add("InputByString");
	BusinessProcess.Add("InteractiveActivate");
	BusinessProcess.Add("Start");
	BusinessProcess.Add("InteractiveStart");
	BusinessProcess.Add("ReadDataHistory");
	BusinessProcess.Add("ReadDataHistoryOfMissingData");
	BusinessProcess.Add("UpdateDataHistory");
	BusinessProcess.Add("UpdateDataHistoryOfMissingData");
	BusinessProcess.Add("UpdateDataHistorySettings");
	BusinessProcess.Add("UpdateDataHistoryVersionComment");
	BusinessProcess.Add("ViewDataHistory");
	BusinessProcess.Add("EditDataHistoryVersionComment");
	BusinessProcess.Add("SwitchToDataHistoryVersion");
	#EndRegion
	Settings.Insert("BusinessProcess", BusinessProcess);
	
	#Region Document
	Document = New Array;
	Document.Add("Read");
	Document.Add("Insert");
	Document.Add("Update");
	Document.Add("Delete");
	Document.Add("Posting");
	Document.Add("UndoPosting");
	Document.Add("View");
	Document.Add("InteractiveInsert");
	Document.Add("Edit");
	Document.Add("InteractiveDelete");
	Document.Add("InteractiveSetDeletionMark");
	Document.Add("InteractiveClearDeletionMark");
	Document.Add("InteractiveDeleteMarked");
	Document.Add("InteractivePosting");
	Document.Add("InteractivePostingRegular");
	Document.Add("InteractiveUndoPosting");
	Document.Add("InteractiveChangeOfPosted");
	Document.Add("InputByString");
	Document.Add("ReadDataHistory");
	Document.Add("ReadDataHistoryOfMissingData");
	Document.Add("UpdateDataHistory");
	Document.Add("UpdateDataHistoryOfMissingData");
	Document.Add("UpdateDataHistorySettings");
	Document.Add("UpdateDataHistoryVersionComment");
	Document.Add("ViewDataHistory");
	Document.Add("EditDataHistoryVersionComment");
	Document.Add("SwitchToDataHistoryVersion");
	#EndRegion
	Settings.Insert("Document", Document);
	
EndFunction

Function MetaDataObject() Export
	MetaDataObject = New Structure;
	
	AccumulationRegister = New Structure;
	AccumulationRegister.Insert("AccumulationRegisterRecord"   , "Record"	);
	AccumulationRegister.Insert("AccumulationRegisterManager"  , "Manager"	);
	AccumulationRegister.Insert("AccumulationRegisterSelection", "Selection");
	AccumulationRegister.Insert("AccumulationRegisterList"	   , "List"		);
	AccumulationRegister.Insert("AccumulationRegisterRecordSet", "RecordSet");
	AccumulationRegister.Insert("AccumulationRegisterRecordKey", "RecordKey");
	MetaDataObject.Insert("AccumulationRegister", AccumulationRegister);
	
	AccountingRegister = New Structure;
	AccountingRegister.Insert("AccountingRegisterRecord"   		, "Record"		 );
	AccountingRegister.Insert("AccountingRegisterExtDimensions" , "ExtDimensions");
	AccountingRegister.Insert("AccountingRegisterRecordSet"		, "RecordSet"    );
	AccountingRegister.Insert("AccountingRegisterRecordKey"		, "RecordKey"    );
	AccountingRegister.Insert("AccountingRegisterSelection"		, "Selection"	 );
	AccountingRegister.Insert("AccountingRegisterList"			, "List" 		 );
	AccountingRegister.Insert("AccountingRegisterManager"		, "Manager"		 );
	MetaDataObject.Insert("AccountingRegister", AccountingRegister);
	
	BusinessProcess = New Structure;
	BusinessProcess.Insert("BusinessProcessObject"   	 , "Object"		  );
	BusinessProcess.Insert("BusinessProcessRef" 		 , "Ref"          );
	BusinessProcess.Insert("BusinessProcessSelection"	 , "Selection"    );
	BusinessProcess.Insert("BusinessProcessList"		 , "List"         );
	BusinessProcess.Insert("BusinessProcessManager"		 , "Manager"	  );
	BusinessProcess.Insert("BusinessProcessRoutePointRef", "RoutePointRef");
	MetaDataObject.Insert("BusinessProcess", BusinessProcess);
	
	CalculationRegister = New Structure;
	CalculationRegister.Insert("CalculationRegisterRecord"   , "Record"   );
	CalculationRegister.Insert("CalculationRegisterManager"  , "Manager"  );
	CalculationRegister.Insert("CalculationRegisterSelection", "Selection");
	CalculationRegister.Insert("CalculationRegisterList"	 , "List"	  );
	CalculationRegister.Insert("CalculationRegisterRecordSet", "RecordSet");
	CalculationRegister.Insert("CalculationRegisterRecordKey", "RecordKey");
	CalculationRegister.Insert("RecalculationsManager"		 , "Recalcs"  );
	MetaDataObject.Insert("CalculationRegister", CalculationRegister);
	
	Catalog = New Structure;
	Catalog.Insert("CatalogObject"   	 , "Object"	  );
	Catalog.Insert("CatalogRef" 		 , "Ref"      );
	Catalog.Insert("CatalogSelection"	 , "Selection");
	Catalog.Insert("CatalogList"		 , "List"     );
	Catalog.Insert("CatalogManager"		 , "Manager"  );
	MetaDataObject.Insert("Catalog", Catalog);
	
	ChartOfAccounts = New Structure;
	ChartOfAccounts.Insert("ChartOfAccountsObject"   			, "Object"   			);
	ChartOfAccounts.Insert("ChartOfAccountsRef"  				, "Ref"  				);
	ChartOfAccounts.Insert("ChartOfAccountsSelection"			, "Selection"			);
	ChartOfAccounts.Insert("ChartOfAccountsList"	 			, "List"	  			);
	ChartOfAccounts.Insert("ChartOfAccountsManager"				, "Manager"				);
	ChartOfAccounts.Insert("ChartOfAccountsExtDimensionTypes"	, "ExtDimensionTypes"   );
	ChartOfAccounts.Insert("ChartOfAccountsExtDimensionTypesRow", "ExtDimensionTypesRow");
	MetaDataObject.Insert("ChartOfAccounts", ChartOfAccounts);
	
	ChartOfCalculationTypes = New Structure;
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesObject"   , "Object"   					  );
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesRef"  	 , "Ref"  				 		  );
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesSelection", "Selection"					  );
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesList"	 , "List"	  			    	  );
	ChartOfCalculationTypes.Insert("ChartOfCalculationTypesManager"	 , "Manager"					  );
	ChartOfCalculationTypes.Insert("DisplacingCalculationTypes"		 , "DisplacingCalculationTypes"   );
	ChartOfCalculationTypes.Insert("DisplacingCalculationTypesRow"	 , "DisplacingCalculationTypesRow");
	ChartOfCalculationTypes.Insert("BaseCalculationTypes"	 		 , "BaseCalculationTypes"	  	  );
	ChartOfCalculationTypes.Insert("BaseCalculationTypesRow"		 , "BaseCalculationTypesRow"	  );
	ChartOfCalculationTypes.Insert("LeadingCalculationTypes"		 , "LeadingCalculationTypes"   	  );
	ChartOfCalculationTypes.Insert("LeadingCalculationTypesRow"		 , "LeadingCalculationTypesRow"	  );
	MetaDataObject.Insert("ChartOfCalculationTypes", ChartOfCalculationTypes);
	
	ChartOfCharacteristicTypes = New Structure;
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesObject"   , "Object"   		);
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesRef"  	   , "Ref"  			);
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesSelection", "Selection"		);
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesList"	   , "List"	  			);
	ChartOfCharacteristicTypes.Insert("Characteristic"					   , "Characteristic"	);
	ChartOfCharacteristicTypes.Insert("ChartOfCharacteristicTypesManager"  , "Manager"			);
	MetaDataObject.Insert("ChartOfCharacteristicTypes", ChartOfCharacteristicTypes);
	
	CommandGroup = New Structure;
	MetaDataObject.Insert("CommandGroup", CommandGroup);
	
	CommonAttribute = New Structure;
	MetaDataObject.Insert("CommonAttribute", CommonAttribute);	
	
	CommonCommand = New Structure;
	MetaDataObject.Insert("CommonCommand", CommonCommand);	
	
	CommonForm = New Structure;
	MetaDataObject.Insert("CommonForm", CommonForm);
	
	CommonModule = New Structure;
	MetaDataObject.Insert("CommonModule", CommonModule);
	
	CommonPicture = New Structure;
	MetaDataObject.Insert("CommonPicture", CommonPicture);	
	
	CommonTemplate = New Structure;
	MetaDataObject.Insert("CommonTemplate", CommonTemplate);	
	
	Constant = New Structure;
	Constant.Insert("ConstantManager"     , "Manager"     );
	Constant.Insert("ConstantValueManager", "ValueManager");
	Constant.Insert("ConstantValueKey"	  , "ValueKey"	  );
	MetaDataObject.Insert("Constant", Constant);
	
	DataProcessor = New Structure;
	DataProcessor.Insert("DataProcessorObject" , "Object" );
	DataProcessor.Insert("DataProcessorManager", "Manager");
	MetaDataObject.Insert("DataProcessor", DataProcessor);
	
	DefinedType = New Structure;
	DefinedType.Insert("DefinedType" , "DefinedType" );
	MetaDataObject.Insert("DefinedType", DefinedType);
	
	DocumentJournal = New Structure;
	DocumentJournal.Insert("DocumentJournalSelection", "Selection");
	DocumentJournal.Insert("DocumentJournalList"	 , "List"	  );
	DocumentJournal.Insert("DocumentJournalManager"	 , "Manager"  );
	MetaDataObject.Insert("DocumentJournal", DocumentJournal);
	
	DocumentNumerator = New Structure;
	MetaDataObject.Insert("DocumentNumerator", DocumentNumerator);
	
	Document = New Structure;
	Document.Insert("DocumentObject"   , "Object"   );
	Document.Insert("DocumentRef"  	   , "Ref"  	);
	Document.Insert("DocumentSelection", "Selection");
	Document.Insert("DocumentList"	   , "List"	  	);
	Document.Insert("DocumentManager"  , "Manager"	);
	MetaDataObject.Insert("Document", Document);
	
	Enum = New Structure;
	Enum.Insert("EnumRef"	 , "Ref"    );
	Enum.Insert("EnumManager", "Manager");
	Enum.Insert("EnumList"	 , "List"   );
	MetaDataObject.Insert("Enum", Enum);
	
	EventSubscription = New Structure;
	MetaDataObject.Insert("EventSubscription", EventSubscription);
	
	ExchangePlan = New Structure;
	ExchangePlan.Insert("ExchangePlanObject"   , "Object"   );
	ExchangePlan.Insert("ExchangePlanRef"  	   , "Ref"  	);
	ExchangePlan.Insert("ExchangePlanSelection", "Selection");
	ExchangePlan.Insert("ExchangePlanList"	   , "List"	  	);
	ExchangePlan.Insert("ExchangePlanManager"  , "Manager"	);
	MetaDataObject.Insert("ExchangePlan", ExchangePlan);	
	
	ExternalDataSource = New Structure;
	ExternalDataSource.Insert("ExternalDataSourceManager"      , "Manager"      );
	ExternalDataSource.Insert("ExternalDataSourceTablesManager", "TablesManager");
	ExternalDataSource.Insert("ExternalDataSourceCubesManager" , "CubesManager" );
	MetaDataObject.Insert("ExternalDataSource", ExternalDataSource);
	
	FilterCriterion = New Structure;
	FilterCriterion.Insert("FilterCriterionManager", "Manager");
	FilterCriterion.Insert("FilterCriterionList"   , "List"	  );
	MetaDataObject.Insert("FilterCriterion", FilterCriterion);
	
	FunctionalOption = New Structure;
	MetaDataObject.Insert("FunctionalOption", FunctionalOption);	
	
	FunctionalOptionsParameter = New Structure;
	MetaDataObject.Insert("FunctionalOptionsParameter", FunctionalOptionsParameter);
	
	HTTPService = New Structure;
	MetaDataObject.Insert("HTTPService", HTTPService);
	
	InformationRegister = New Structure;
	InformationRegister.Insert("InformationRegisterRecord"   	 , "Record"   	  );
	InformationRegister.Insert("InformationRegisterManager"  	 , "Manager"  	  );
	InformationRegister.Insert("InformationRegisterSelection"	 , "Selection"	  );
	InformationRegister.Insert("InformationRegisterList"	 	 , "List"	      );
	InformationRegister.Insert("InformationRegisterRecordSet"	 , "RecordSet"	  );
	InformationRegister.Insert("InformationRegisterRecordKey"	 , "RecordKey"	  );
	InformationRegister.Insert("InformationRegisterRecordManager", "RecordManager");
	MetaDataObject.Insert("InformationRegister", InformationRegister);	
	
	Language = New Structure;
	MetaDataObject.Insert("Language", Language);
	
	Report = New Structure;
	Report.Insert("ReportObject" , "Object" );
	Report.Insert("ReportManager", "Manager");
	MetaDataObject.Insert("Report", Report);
	
	Role = New Structure;
	MetaDataObject.Insert("Role", Role);
	
	ScheduledJob = New Structure;
	MetaDataObject.Insert("ScheduledJob", ScheduledJob);	
	
	Sequence = New Structure;
	Sequence.Insert("SequenceRecord"   	 , "Record"   );
	Sequence.Insert("SequenceManager"  	 , "Manager"  );
	Sequence.Insert("SequenceRecordSet"	 , "RecordSet");
	MetaDataObject.Insert("Sequence", Sequence);	
	
	SessionParameter = New Structure;
	MetaDataObject.Insert("SessionParameter", SessionParameter);
	
	SettingsStorage = New Structure;
	SettingsStorage.Insert("SettingsStorageManager"   	 , "Manager");
	MetaDataObject.Insert("SettingsStorage", SettingsStorage);	

	StyleItem = New Structure;
	MetaDataObject.Insert("StyleItem", StyleItem);		
	
	Style = New Structure;
	MetaDataObject.Insert("Style", Style);	

	Subsystem = New Structure;
	MetaDataObject.Insert("Subsystem", Subsystem);
	
	Task = New Structure;
	Task.Insert("TaskObject"   , "Object"   );
	Task.Insert("TaskRef"  	   , "Ref"  	);
	Task.Insert("TaskSelection", "Selection");
	Task.Insert("TaskList"	   , "List"	  	);
	Task.Insert("TaskManager"  , "Manager"	);
	MetaDataObject.Insert("Task", Task);	
	
	WebService = New Structure;
	MetaDataObject.Insert("WebService", WebService);	
	
	Return MetaDataObject;
EndFunction

Function MetaDataObjectNames() Export
	Structure = New Structure();
	Structure.Insert("AccountingRegister", "AccountingRegisters");
	Structure.Insert("AccumulationRegister", "AccumulationRegisters");
	Structure.Insert("BusinessProcess", "BusinessProcesses");
	Structure.Insert("CalculationRegister", "CalculationRegisters");
	Structure.Insert("Catalog", "Catalogs");
	Structure.Insert("ChartOfAccounts", "ChartsOfAccounts");
	Structure.Insert("ChartOfCalculationTypes", "ChartsOfCalculationTypes");
	Structure.Insert("ChartOfCharacteristicTypes", "ChartsOfCharacteristicTypes");
	Structure.Insert("CommandGroup", "CommandGroups");
	Structure.Insert("CommonAttribute", "CommonAttributes");
	Structure.Insert("CommonCommand", "CommonCommands");
	Structure.Insert("CommonForm", "CommonForms");
	Structure.Insert("CommonModule", "CommonModules");
	Structure.Insert("CommonPicture", "CommonPictures");
	Structure.Insert("CommonTemplate", "CommonTemplates");
	Structure.Insert("Constant", "Constants");
	Structure.Insert("DataProcessor", "DataProcessors");
	Structure.Insert("DefinedType", "DefinedTypes");
	Structure.Insert("DocumentJournal", "DocumentJournals");
	Structure.Insert("DocumentNumerator", "DocumentNumerators");
	Structure.Insert("Document", "Documents");
	Structure.Insert("Enum", "Enums");
	Structure.Insert("EventSubscription", "EventSubscriptions");
	Structure.Insert("ExchangePlan", "ExchangePlans");
	Structure.Insert("ExternalDataSource", "ExternalDataSources");
	Structure.Insert("FilterCriterion", "FilterCriteria");
	Structure.Insert("FunctionalOption", "FunctionalOptions");
	Structure.Insert("FunctionalOptionsParameter", "FunctionalOptionsParameters");
	Structure.Insert("HTTPService", "HTTPServices");
	Structure.Insert("InformationRegister", "InformationRegisters");
	Structure.Insert("Language", "Languages");
	Structure.Insert("Report", "Reports");
	Structure.Insert("Role", "Roles");
	Structure.Insert("ScheduledJob", "ScheduledJobs");
	Structure.Insert("Sequence", "Sequences");
	Structure.Insert("SessionParameter", "SessionParameters");
	Structure.Insert("SettingsStorage", "SettingsStorages");
	Structure.Insert("StyleItem", "StyleItems");
	Structure.Insert("Style", "Styles");
	Structure.Insert("Subsystem", "Subsystems");
	Structure.Insert("Task", "Tasks");
	Structure.Insert("WebService", "WebServices");
	Return Structure;
EndFunction
#EndRegion