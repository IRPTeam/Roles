#Region Service
Function RolesSet() Export
	Settings = New Structure;
	
	#Region HTTPService
	HTTPService = New Array;
	HTTPService.Add("Use");
	#EndRegion 
	Settings.Insert("HTTPService", HTTPService);

	#Region WebService
	WebService = New Array;
	WebService.Add("Use");
	#EndRegion 
	Settings.Insert("WebService", WebService);

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

	#Region Catalog
	Catalog = New Array;
	Catalog.Add("Read");
	Catalog.Add("Insert");
	Catalog.Add("Update");
	Catalog.Add("Delete");
	Catalog.Add("View");
	Catalog.Add("InteractiveInsert");
	Catalog.Add("Edit");
	Catalog.Add("InteractiveDelete");
	Catalog.Add("InteractiveSetDeletionMark");
	Catalog.Add("InteractiveClearDeletionMark");
	Catalog.Add("InteractiveDeleteMarked");
	Catalog.Add("InputByString");
	Catalog.Add("InteractiveDeletePredefinedData");
	Catalog.Add("InteractiveSetDeletionMarkPredefinedData");
	Catalog.Add("InteractiveClearDeletionMarkPredefinedData");
	Catalog.Add("InteractiveDeleteMarkedPredefinedData");
	Catalog.Add("ReadDataHistory");
	Catalog.Add("ReadDataHistoryOfMissingData");
	Catalog.Add("UpdateDataHistory");
	Catalog.Add("UpdateDataHistoryOfMissingData");
	Catalog.Add("UpdateDataHistorySettings");
	Catalog.Add("UpdateDataHistoryVersionComment");
	Catalog.Add("ViewDataHistory");
	Catalog.Add("EditDataHistoryVersionComment");
	Catalog.Add("SwitchToDataHistoryVersion");
	#EndRegion 
	Settings.Insert("Catalog", Catalog);


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

	#Region DocumentJournal
	DocumentJournal = New Array;
	DocumentJournal.Add("Read");
	DocumentJournal.Add("View");
	#EndRegion 
	Settings.Insert("DocumentJournal", DocumentJournal);

	#Region Task
	Task = New Array;
	Task.Add("Read");
	Task.Add("Insert");
	Task.Add("Update");
	Task.Add("Delete");
	Task.Add("View");
	Task.Add("InteractiveInsert");
	Task.Add("Edit");
	Task.Add("InteractiveDelete");
	Task.Add("InteractiveSetDeletionMark");
	Task.Add("InteractiveClearDeletionMark");
	Task.Add("InteractiveDeleteMarked");
	Task.Add("InputByString");
	Task.Add("InteractiveActivate");
	Task.Add("Execute");
	Task.Add("InteractiveExecute");
	Task.Add("ReadDataHistory");
	Task.Add("ReadDataHistoryOfMissingData");
	Task.Add("UpdateDataHistory");
	Task.Add("UpdateDataHistoryOfMissingData");
	Task.Add("UpdateDataHistorySettings");
	Task.Add("UpdateDataHistoryVersionComment");
	Task.Add("ViewDataHistory");
	Task.Add("EditDataHistoryVersionComment");
	Task.Add("SwitchToDataHistoryVersion");
	#EndRegion 
	Settings.Insert("Task", Task);

	#Region Constant
	Constant = New Array;
	Constant.Add("Read");
	Constant.Add("Update");
	Constant.Add("View");
	Constant.Add("Edit");
	Constant.Add("ReadDataHistory");
	Constant.Add("UpdateDataHistory");
	Constant.Add("UpdateDataHistorySettings");
	Constant.Add("UpdateDataHistoryVersionComment");
	Constant.Add("ViewDataHistory");
	Constant.Add("EditDataHistoryVersionComment");
	Constant.Add("SwitchToDataHistoryVersion");
	#EndRegion 
	Settings.Insert("Constant", Constant);

	#Region FilterCriterion
	FilterCriterion = New Array;
	FilterCriterion.Add("View");
	#EndRegion 
	Settings.Insert("FilterCriterion", FilterCriterion);

	#Region DataProcessor
	DataProcessor = New Array;
	DataProcessor.Add("Use");
	DataProcessor.Add("View");
	#EndRegion 
	Settings.Insert("DataProcessor", DataProcessor);

	#Region CommonCommand
	CommonCommand = New Array;
	CommonCommand.Add("View");
	#EndRegion 
	Settings.Insert("CommonCommand", CommonCommand);

	#Region CommonForm
	CommonForm = New Array;
	CommonForm.Add("View");
	#EndRegion 
	Settings.Insert("CommonForm", CommonForm);

	#Region CommonAttribute
	CommonAttribute = New Array;
	CommonAttribute.Add("View");
	CommonAttribute.Add("Edit");
	#EndRegion 
	Settings.Insert("CommonAttribute", CommonAttribute);

	#Region Report
	Report = New Array;
	Report.Add("Use");
	Report.Add("View");
	#EndRegion 
	Settings.Insert("Report", Report);

	#Region SessionParameter
	SessionParameter = New Array;
	SessionParameter.Add("Get");
	SessionParameter.Add("Set");
	#EndRegion 
	Settings.Insert("SessionParameter", SessionParameter);

	#Region ChartOfCalculationTypes
	ChartOfCalculationTypes = New Array;
	ChartOfCalculationTypes.Add("Read");
	ChartOfCalculationTypes.Add("Insert");
	ChartOfCalculationTypes.Add("Update");
	ChartOfCalculationTypes.Add("Delete");
	ChartOfCalculationTypes.Add("View");
	ChartOfCalculationTypes.Add("InteractiveInsert");
	ChartOfCalculationTypes.Add("Edit");
	ChartOfCalculationTypes.Add("InteractiveDelete");
	ChartOfCalculationTypes.Add("InteractiveSetDeletionMark");
	ChartOfCalculationTypes.Add("InteractiveClearDeletionMark");
	ChartOfCalculationTypes.Add("InteractiveDeleteMarked");
	ChartOfCalculationTypes.Add("InputByString");
	ChartOfCalculationTypes.Add("InteractiveDeletePredefinedData");
	ChartOfCalculationTypes.Add("InteractiveSetDeletionMarkPredefinedData");
	ChartOfCalculationTypes.Add("InteractiveClearDeletionMarkPredefinedData");
	ChartOfCalculationTypes.Add("InteractiveDeleteMarkedPredefinedData");
	ChartOfCalculationTypes.Add("ReadDataHistory");
	ChartOfCalculationTypes.Add("ReadDataHistoryOfMissingData");
	ChartOfCalculationTypes.Add("UpdateDataHistory");
	ChartOfCalculationTypes.Add("UpdateDataHistoryOfMissingData");
	ChartOfCalculationTypes.Add("UpdateDataHistorySettings");
	ChartOfCalculationTypes.Add("UpdateDataHistoryVersionComment");
	ChartOfCalculationTypes.Add("ViewDataHistory");
	ChartOfCalculationTypes.Add("EditDataHistoryVersionComment");
	ChartOfCalculationTypes.Add("SwitchToDataHistoryVersion");
	#EndRegion 
	Settings.Insert("ChartOfCalculationTypes", ChartOfCalculationTypes);

	#Region ChartOfCharacteristicTypes
	ChartOfCharacteristicTypes = New Array;
	ChartOfCharacteristicTypes.Add("Read");
	ChartOfCharacteristicTypes.Add("Insert");
	ChartOfCharacteristicTypes.Add("Update");
	ChartOfCharacteristicTypes.Add("Delete");
	ChartOfCharacteristicTypes.Add("View");
	ChartOfCharacteristicTypes.Add("InteractiveInsert");
	ChartOfCharacteristicTypes.Add("Edit");
	ChartOfCharacteristicTypes.Add("InteractiveDelete");
	ChartOfCharacteristicTypes.Add("InteractiveSetDeletionMark");
	ChartOfCharacteristicTypes.Add("InteractiveClearDeletionMark");
	ChartOfCharacteristicTypes.Add("InteractiveDeleteMarked");
	ChartOfCharacteristicTypes.Add("InputByString");
	ChartOfCharacteristicTypes.Add("InteractiveDeletePredefinedData");
	ChartOfCharacteristicTypes.Add("InteractiveSetDeletionMarkPredefinedData");
	ChartOfCharacteristicTypes.Add("InteractiveClearDeletionMarkPredefinedData");
	ChartOfCharacteristicTypes.Add("InteractiveDeleteMarkedPredefinedData");
	ChartOfCharacteristicTypes.Add("ReadDataHistory");
	ChartOfCharacteristicTypes.Add("ReadDataHistoryOfMissingData");
	ChartOfCharacteristicTypes.Add("UpdateDataHistory");
	ChartOfCharacteristicTypes.Add("UpdateDataHistoryOfMissingData");
	ChartOfCharacteristicTypes.Add("UpdateDataHistorySettings");
	ChartOfCharacteristicTypes.Add("UpdateDataHistoryVersionComment");
	ChartOfCharacteristicTypes.Add("ViewDataHistory");
	ChartOfCharacteristicTypes.Add("EditDataHistoryVersionComment");
	ChartOfCharacteristicTypes.Add("SwitchToDataHistoryVersion");
	#EndRegion 
	Settings.Insert("ChartOfCharacteristicTypes", ChartOfCharacteristicTypes);

	#Region ExchangePlan
	ExchangePlan = New Array;
	ExchangePlan.Add("Read");
	ExchangePlan.Add("Insert");
	ExchangePlan.Add("Update");
	ExchangePlan.Add("Delete");
	ExchangePlan.Add("View");
	ExchangePlan.Add("InteractiveInsert");
	ExchangePlan.Add("Edit");
	ExchangePlan.Add("InteractiveDelete");
	ExchangePlan.Add("InteractiveSetDeletionMark");
	ExchangePlan.Add("InteractiveClearDeletionMark");
	ExchangePlan.Add("InteractiveDeleteMarked");
	ExchangePlan.Add("InputByString");
	ExchangePlan.Add("ReadDataHistory");
	ExchangePlan.Add("ReadDataHistoryOfMissingData");
	ExchangePlan.Add("UpdateDataHistory");
	ExchangePlan.Add("UpdateDataHistoryOfMissingData");
	ExchangePlan.Add("UpdateDataHistorySettings");
	ExchangePlan.Add("UpdateDataHistoryVersionComment");
	ExchangePlan.Add("ViewDataHistory");
	ExchangePlan.Add("EditDataHistoryVersionComment");
	ExchangePlan.Add("SwitchToDataHistoryVersion");
	#EndRegion 
	Settings.Insert("ExchangePlan", ExchangePlan);

	#Region ChartOfAccounts
	ChartOfAccounts = New Array;
	ChartOfAccounts.Add("Read");
	ChartOfAccounts.Add("Insert");
	ChartOfAccounts.Add("Update");
	ChartOfAccounts.Add("Delete");
	ChartOfAccounts.Add("View");
	ChartOfAccounts.Add("InteractiveInsert");
	ChartOfAccounts.Add("Edit");
	ChartOfAccounts.Add("InteractiveDelete");
	ChartOfAccounts.Add("InteractiveSetDeletionMark");
	ChartOfAccounts.Add("InteractiveClearDeletionMark");
	ChartOfAccounts.Add("InteractiveDeleteMarked");
	ChartOfAccounts.Add("InputByString");
	ChartOfAccounts.Add("InteractiveDeletePredefinedData");
	ChartOfAccounts.Add("InteractiveSetDeletionMarkPredefinedData");
	ChartOfAccounts.Add("InteractiveClearDeletionMarkPredefinedData");
	ChartOfAccounts.Add("InteractiveDeleteMarkedPredefinedData");
	ChartOfAccounts.Add("ReadDataHistory");
	ChartOfAccounts.Add("ReadDataHistoryOfMissingData");
	ChartOfAccounts.Add("UpdateDataHistory");
	ChartOfAccounts.Add("UpdateDataHistoryOfMissingData");
	ChartOfAccounts.Add("UpdateDataHistorySettings");
	ChartOfAccounts.Add("UpdateDataHistoryVersionComment");
	ChartOfAccounts.Add("ViewDataHistory");
	ChartOfAccounts.Add("EditDataHistoryVersionComment");
	ChartOfAccounts.Add("SwitchToDataHistoryVersion");
	#EndRegion 
	Settings.Insert("ChartOfAccounts", ChartOfAccounts);

	#Region Subsystem
	Subsystem = New Array;
	Subsystem.Add("View");
	#EndRegion 
	Settings.Insert("Subsystem", Subsystem);

	#Region Sequence
	Sequence = New Array;
	Sequence.Add("Read");
	Sequence.Add("Update");
	#EndRegion 
	Settings.Insert("Sequence", Sequence);

	#Region AccountingRegister
	AccountingRegister = New Array;
	AccountingRegister.Add("Read");
	AccountingRegister.Add("Update");
	AccountingRegister.Add("View");
	AccountingRegister.Add("Edit");
	AccountingRegister.Add("TotalsControl");
	#EndRegion 
	Settings.Insert("AccountingRegister", AccountingRegister);

	#Region AccumulationRegister
	AccumulationRegister = New Array;
	AccumulationRegister.Add("Read");
	AccumulationRegister.Add("Update");
	AccumulationRegister.Add("View");
	AccumulationRegister.Add("Edit");
	AccumulationRegister.Add("TotalsControl");
	#EndRegion 
	Settings.Insert("AccumulationRegister", AccumulationRegister);

	#Region CalculationRegister
	CalculationRegister = New Array;
	CalculationRegister.Add("Read");
	CalculationRegister.Add("Update");
	CalculationRegister.Add("View");
	CalculationRegister.Add("Edit");
	#EndRegion 
	Settings.Insert("CalculationRegister", CalculationRegister);

	#Region InformationRegister
	InformationRegister = New Array;
	InformationRegister.Add("Read");
	InformationRegister.Add("Update");
	InformationRegister.Add("View");
	InformationRegister.Add("Edit");
	InformationRegister.Add("TotalsControl");
	InformationRegister.Add("ReadDataHistory");
	InformationRegister.Add("ReadDataHistoryOfMissingData");
	InformationRegister.Add("UpdateDataHistory");
	InformationRegister.Add("UpdateDataHistoryOfMissingData");
	InformationRegister.Add("UpdateDataHistorySettings");
	InformationRegister.Add("UpdateDataHistoryVersionComment");
	InformationRegister.Add("ViewDataHistory");
	InformationRegister.Add("EditDataHistoryVersionComment");
	InformationRegister.Add("SwitchToDataHistoryVersion");
	#EndRegion 
	Settings.Insert("InformationRegister", InformationRegister);

//	#Region Configuration
//	Configuration = New Array;
//	Configuration.Add("Administration");
//	Configuration.Add("DataAdministration");
//	Configuration.Add("UpdateDataBaseConfiguration");
//	Configuration.Add("ExclusiveMode");
//	Configuration.Add("ActiveUsers");
//	Configuration.Add("EventLog");
//	Configuration.Add("ThinClient");
//	Configuration.Add("WebClient");
//	Configuration.Add("MobileClient");
//	Configuration.Add("ThickClient");
//	Configuration.Add("ExternalConnection");
//	Configuration.Add("Automation");
//	Configuration.Add("TechnicalSpecialistMode");
//	Configuration.Add("CollaborationSystemInfoBaseRegistration");
//	Configuration.Add("MainWindowModeNormal");
//	Configuration.Add("MainWindowModeWorkplace");
//	Configuration.Add("MainWindowModeEmbeddedWorkplace");
//	Configuration.Add("MainWindowModeFullscreenWorkplace");
//	Configuration.Add("MainWindowModeKiosk");
//	Configuration.Add("AnalyticsSystemClient");
//	Configuration.Add("SaveUserData");
//	Configuration.Add("ConfigurationExtensionsAdministration");
//	Configuration.Add("InteractiveOpenExtDataProcessors");
//	Configuration.Add("InteractiveOpenExtReports");
//	Configuration.Add("Output");
//	#EndRegion 
//	Settings.Insert("Configuration", Configuration);

	#Region IntegrationService
	IntegrationService = New Array;
	IntegrationService.Add("Use");
	#EndRegion 
	Settings.Insert("IntegrationService", IntegrationService);
	
	Return Settings;
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

Function MetadataInfo() Export
	
	Structure = MetaDataObjectNames();
	MetaStructure = New Structure;
	For Each Row In Structure Do
		ValueList = New ValueList();
		For Each Data In Metadata[Row.Value] Do
			ValueList.Add(Data.Name, Data.Synonym);
		EndDo;
		MetaStructure.Insert(Row.Key, ValueList); 
	EndDo;
	Return MetaStructure;
EndFunction
#EndRegion