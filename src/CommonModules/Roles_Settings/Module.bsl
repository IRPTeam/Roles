#Region Service
Function RolesSet() Export
	Settings = New Map;
	
	#Region HTTPService
	HTTPService = New Array;
	HTTPService.Add(Enums.Roles_Rights.Use);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.HTTPService, HTTPService);

	#Region WebService
	WebService = New Array;
	WebService.Add(Enums.Roles_Rights.Use);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.WebService, WebService);

	#Region BusinessProcess
	BusinessProcess = New Array;
	BusinessProcess.Add(Enums.Roles_Rights.Read);
	BusinessProcess.Add(Enums.Roles_Rights.Insert);
	BusinessProcess.Add(Enums.Roles_Rights.Update);
	BusinessProcess.Add(Enums.Roles_Rights.Delete);
	BusinessProcess.Add(Enums.Roles_Rights.View);
	BusinessProcess.Add(Enums.Roles_Rights.InteractiveInsert);
	BusinessProcess.Add(Enums.Roles_Rights.Edit);
	BusinessProcess.Add(Enums.Roles_Rights.InteractiveDelete);
	BusinessProcess.Add(Enums.Roles_Rights.InteractiveSetDeletionMark);
	BusinessProcess.Add(Enums.Roles_Rights.InteractiveClearDeletionMark);
	BusinessProcess.Add(Enums.Roles_Rights.InteractiveDeleteMarked);
	BusinessProcess.Add(Enums.Roles_Rights.InputByString);
	BusinessProcess.Add(Enums.Roles_Rights.InteractiveActivate);
	BusinessProcess.Add(Enums.Roles_Rights.Start);
	BusinessProcess.Add(Enums.Roles_Rights.InteractiveStart);
	BusinessProcess.Add(Enums.Roles_Rights.ReadDataHistory);
	BusinessProcess.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	BusinessProcess.Add(Enums.Roles_Rights.UpdateDataHistory);
	BusinessProcess.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	BusinessProcess.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	BusinessProcess.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	BusinessProcess.Add(Enums.Roles_Rights.ViewDataHistory);
	BusinessProcess.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	BusinessProcess.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.BusinessProcess, BusinessProcess);

	#Region Catalog
	Catalog = New Array;
	Catalog.Add(Enums.Roles_Rights.Read);
	Catalog.Add(Enums.Roles_Rights.Insert);
	Catalog.Add(Enums.Roles_Rights.Update);
	Catalog.Add(Enums.Roles_Rights.Delete);
	Catalog.Add(Enums.Roles_Rights.View);
	Catalog.Add(Enums.Roles_Rights.InteractiveInsert);
	Catalog.Add(Enums.Roles_Rights.Edit);
	Catalog.Add(Enums.Roles_Rights.InteractiveDelete);
	Catalog.Add(Enums.Roles_Rights.InteractiveSetDeletionMark);
	Catalog.Add(Enums.Roles_Rights.InteractiveClearDeletionMark);
	Catalog.Add(Enums.Roles_Rights.InteractiveDeleteMarked);
	Catalog.Add(Enums.Roles_Rights.InputByString);
	Catalog.Add(Enums.Roles_Rights.InteractiveDeletePredefinedData);
	Catalog.Add(Enums.Roles_Rights.InteractiveSetDeletionMarkPredefinedData);
	Catalog.Add(Enums.Roles_Rights.InteractiveClearDeletionMarkPredefinedData);
	Catalog.Add(Enums.Roles_Rights.InteractiveDeleteMarkedPredefinedData);
	Catalog.Add(Enums.Roles_Rights.ReadDataHistory);
	Catalog.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	Catalog.Add(Enums.Roles_Rights.UpdateDataHistory);
	Catalog.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	Catalog.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	Catalog.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	Catalog.Add(Enums.Roles_Rights.ViewDataHistory);
	Catalog.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	Catalog.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.Catalog, Catalog);


	#Region Document
	Document = New Array;
	Document.Add(Enums.Roles_Rights.Read);
	Document.Add(Enums.Roles_Rights.Insert);
	Document.Add(Enums.Roles_Rights.Update);
	Document.Add(Enums.Roles_Rights.Delete);
	Document.Add(Enums.Roles_Rights.Posting);
	Document.Add(Enums.Roles_Rights.UndoPosting);
	Document.Add(Enums.Roles_Rights.View);
	Document.Add(Enums.Roles_Rights.InteractiveInsert);
	Document.Add(Enums.Roles_Rights.Edit);
	Document.Add(Enums.Roles_Rights.InteractiveDelete);
	Document.Add(Enums.Roles_Rights.InteractiveSetDeletionMark);
	Document.Add(Enums.Roles_Rights.InteractiveClearDeletionMark);
	Document.Add(Enums.Roles_Rights.InteractiveDeleteMarked);
	Document.Add(Enums.Roles_Rights.InteractivePosting);
	Document.Add(Enums.Roles_Rights.InteractivePostingRegular);
	Document.Add(Enums.Roles_Rights.InteractiveUndoPosting);
	Document.Add(Enums.Roles_Rights.InteractiveChangeOfPosted);
	Document.Add(Enums.Roles_Rights.InputByString);
	Document.Add(Enums.Roles_Rights.ReadDataHistory);
	Document.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	Document.Add(Enums.Roles_Rights.UpdateDataHistory);
	Document.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	Document.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	Document.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	Document.Add(Enums.Roles_Rights.ViewDataHistory);
	Document.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	Document.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.Document, Document);

	#Region DocumentJournal
	DocumentJournal = New Array;
	DocumentJournal.Add(Enums.Roles_Rights.Read);
	DocumentJournal.Add(Enums.Roles_Rights.View);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.DocumentJournal, DocumentJournal);

	#Region Task
	Task = New Array;
	Task.Add(Enums.Roles_Rights.Read);
	Task.Add(Enums.Roles_Rights.Insert);
	Task.Add(Enums.Roles_Rights.Update);
	Task.Add(Enums.Roles_Rights.Delete);
	Task.Add(Enums.Roles_Rights.View);
	Task.Add(Enums.Roles_Rights.InteractiveInsert);
	Task.Add(Enums.Roles_Rights.Edit);
	Task.Add(Enums.Roles_Rights.InteractiveDelete);
	Task.Add(Enums.Roles_Rights.InteractiveSetDeletionMark);
	Task.Add(Enums.Roles_Rights.InteractiveClearDeletionMark);
	Task.Add(Enums.Roles_Rights.InteractiveDeleteMarked);
	Task.Add(Enums.Roles_Rights.InputByString);
	Task.Add(Enums.Roles_Rights.InteractiveActivate);
	Task.Add(Enums.Roles_Rights.Execute);
	Task.Add(Enums.Roles_Rights.InteractiveExecute);
	Task.Add(Enums.Roles_Rights.ReadDataHistory);
	Task.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	Task.Add(Enums.Roles_Rights.UpdateDataHistory);
	Task.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	Task.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	Task.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	Task.Add(Enums.Roles_Rights.ViewDataHistory);
	Task.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	Task.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.Task, Task);

	#Region Constant
	Constant = New Array;
	Constant.Add(Enums.Roles_Rights.Read);
	Constant.Add(Enums.Roles_Rights.Update);
	Constant.Add(Enums.Roles_Rights.View);
	Constant.Add(Enums.Roles_Rights.Edit);
	Constant.Add(Enums.Roles_Rights.ReadDataHistory);
	Constant.Add(Enums.Roles_Rights.UpdateDataHistory);
	Constant.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	Constant.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	Constant.Add(Enums.Roles_Rights.ViewDataHistory);
	Constant.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	Constant.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.Constant, Constant);

	#Region FilterCriterion
	FilterCriterion = New Array;
	FilterCriterion.Add(Enums.Roles_Rights.View);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.FilterCriterion, FilterCriterion);

	#Region DataProcessor
	DataProcessor = New Array;
	DataProcessor.Add(Enums.Roles_Rights.Use);
	DataProcessor.Add(Enums.Roles_Rights.View);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.DataProcessor, DataProcessor);

	#Region CommonCommand
	CommonCommand = New Array;
	CommonCommand.Add(Enums.Roles_Rights.View);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.CommonCommand, CommonCommand);

	#Region CommonForm
	CommonForm = New Array;
	CommonForm.Add(Enums.Roles_Rights.View);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.CommonForm, CommonForm);

	#Region CommonAttribute
	CommonAttribute = New Array;
	CommonAttribute.Add(Enums.Roles_Rights.View);
	CommonAttribute.Add(Enums.Roles_Rights.Edit);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.CommonAttribute, CommonAttribute);

	#Region Report
	Report = New Array;
	Report.Add(Enums.Roles_Rights.Use);
	Report.Add(Enums.Roles_Rights.View);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.Report, Report);

	#Region SessionParameter
	SessionParameter = New Array;
	SessionParameter.Add(Enums.Roles_Rights.Get);
	SessionParameter.Add(Enums.Roles_Rights.Set);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.SessionParameter, SessionParameter);

	#Region ChartOfCalculationTypes
	ChartOfCalculationTypes = New Array;
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.Read);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.Insert);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.Update);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.Delete);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.View);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveInsert);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.Edit);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveDelete);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveSetDeletionMark);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveClearDeletionMark);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveDeleteMarked);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InputByString);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveDeletePredefinedData);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveSetDeletionMarkPredefinedData);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveClearDeletionMarkPredefinedData);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.InteractiveDeleteMarkedPredefinedData);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.ReadDataHistory);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.UpdateDataHistory);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.ViewDataHistory);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	ChartOfCalculationTypes.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.ChartOfCalculationTypes, ChartOfCalculationTypes);

	#Region ChartOfCharacteristicTypes
	ChartOfCharacteristicTypes = New Array;
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.Read);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.Insert);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.Update);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.Delete);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.View);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveInsert);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.Edit);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveDelete);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveSetDeletionMark);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveClearDeletionMark);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveDeleteMarked);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InputByString);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveDeletePredefinedData);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveSetDeletionMarkPredefinedData);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveClearDeletionMarkPredefinedData);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.InteractiveDeleteMarkedPredefinedData);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.ReadDataHistory);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.UpdateDataHistory);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.ViewDataHistory);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	ChartOfCharacteristicTypes.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.ChartOfCharacteristicTypes, ChartOfCharacteristicTypes);

	#Region ExchangePlan
	ExchangePlan = New Array;
	ExchangePlan.Add(Enums.Roles_Rights.Read);
	ExchangePlan.Add(Enums.Roles_Rights.Insert);
	ExchangePlan.Add(Enums.Roles_Rights.Update);
	ExchangePlan.Add(Enums.Roles_Rights.Delete);
	ExchangePlan.Add(Enums.Roles_Rights.View);
	ExchangePlan.Add(Enums.Roles_Rights.InteractiveInsert);
	ExchangePlan.Add(Enums.Roles_Rights.Edit);
	ExchangePlan.Add(Enums.Roles_Rights.InteractiveDelete);
	ExchangePlan.Add(Enums.Roles_Rights.InteractiveSetDeletionMark);
	ExchangePlan.Add(Enums.Roles_Rights.InteractiveClearDeletionMark);
	ExchangePlan.Add(Enums.Roles_Rights.InteractiveDeleteMarked);
	ExchangePlan.Add(Enums.Roles_Rights.InputByString);
	ExchangePlan.Add(Enums.Roles_Rights.ReadDataHistory);
	ExchangePlan.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	ExchangePlan.Add(Enums.Roles_Rights.UpdateDataHistory);
	ExchangePlan.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	ExchangePlan.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	ExchangePlan.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	ExchangePlan.Add(Enums.Roles_Rights.ViewDataHistory);
	ExchangePlan.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	ExchangePlan.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.ExchangePlan, ExchangePlan);

	#Region ChartOfAccounts
	ChartOfAccounts = New Array;
	ChartOfAccounts.Add(Enums.Roles_Rights.Read);
	ChartOfAccounts.Add(Enums.Roles_Rights.Insert);
	ChartOfAccounts.Add(Enums.Roles_Rights.Update);
	ChartOfAccounts.Add(Enums.Roles_Rights.Delete);
	ChartOfAccounts.Add(Enums.Roles_Rights.View);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveInsert);
	ChartOfAccounts.Add(Enums.Roles_Rights.Edit);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveDelete);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveSetDeletionMark);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveClearDeletionMark);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveDeleteMarked);
	ChartOfAccounts.Add(Enums.Roles_Rights.InputByString);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveDeletePredefinedData);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveSetDeletionMarkPredefinedData);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveClearDeletionMarkPredefinedData);
	ChartOfAccounts.Add(Enums.Roles_Rights.InteractiveDeleteMarkedPredefinedData);
	ChartOfAccounts.Add(Enums.Roles_Rights.ReadDataHistory);
	ChartOfAccounts.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	ChartOfAccounts.Add(Enums.Roles_Rights.UpdateDataHistory);
	ChartOfAccounts.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	ChartOfAccounts.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	ChartOfAccounts.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	ChartOfAccounts.Add(Enums.Roles_Rights.ViewDataHistory);
	ChartOfAccounts.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	ChartOfAccounts.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.ChartOfAccounts, ChartOfAccounts);

	#Region Subsystem
	Subsystem = New Array;
	Subsystem.Add(Enums.Roles_Rights.View);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.Subsystem, Subsystem);

	#Region Sequence
	Sequence = New Array;
	Sequence.Add(Enums.Roles_Rights.Read);
	Sequence.Add(Enums.Roles_Rights.Update);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.Sequence, Sequence);

	#Region AccountingRegister
	AccountingRegister = New Array;
	AccountingRegister.Add(Enums.Roles_Rights.Read);
	AccountingRegister.Add(Enums.Roles_Rights.Update);
	AccountingRegister.Add(Enums.Roles_Rights.View);
	AccountingRegister.Add(Enums.Roles_Rights.Edit);
	AccountingRegister.Add(Enums.Roles_Rights.TotalsControl);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.AccountingRegister, AccountingRegister);

	#Region AccumulationRegister
	AccumulationRegister = New Array;
	AccumulationRegister.Add(Enums.Roles_Rights.Read);
	AccumulationRegister.Add(Enums.Roles_Rights.Update);
	AccumulationRegister.Add(Enums.Roles_Rights.View);
	AccumulationRegister.Add(Enums.Roles_Rights.Edit);
	AccumulationRegister.Add(Enums.Roles_Rights.TotalsControl);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.AccumulationRegister, AccumulationRegister);

	#Region CalculationRegister
	CalculationRegister = New Array;
	CalculationRegister.Add(Enums.Roles_Rights.Read);
	CalculationRegister.Add(Enums.Roles_Rights.Update);
	CalculationRegister.Add(Enums.Roles_Rights.View);
	CalculationRegister.Add(Enums.Roles_Rights.Edit);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.CalculationRegister, CalculationRegister);
 
	#Region InformationRegister
	InformationRegister = New Array;
	InformationRegister.Add(Enums.Roles_Rights.Read);
	InformationRegister.Add(Enums.Roles_Rights.Update);
	InformationRegister.Add(Enums.Roles_Rights.View);
	InformationRegister.Add(Enums.Roles_Rights.Edit);
	InformationRegister.Add(Enums.Roles_Rights.TotalsControl);
	InformationRegister.Add(Enums.Roles_Rights.ReadDataHistory);
	InformationRegister.Add(Enums.Roles_Rights.ReadDataHistoryOfMissingData);
	InformationRegister.Add(Enums.Roles_Rights.UpdateDataHistory);
	InformationRegister.Add(Enums.Roles_Rights.UpdateDataHistoryOfMissingData);
	InformationRegister.Add(Enums.Roles_Rights.UpdateDataHistorySettings);
	InformationRegister.Add(Enums.Roles_Rights.UpdateDataHistoryVersionComment);
	InformationRegister.Add(Enums.Roles_Rights.ViewDataHistory);
	InformationRegister.Add(Enums.Roles_Rights.EditDataHistoryVersionComment);
	InformationRegister.Add(Enums.Roles_Rights.SwitchToDataHistoryVersion);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.InformationRegister, InformationRegister);

	#Region Configuration
	Configuration = New Array;
	Configuration.Add(Enums.Roles_Rights.Administration);
	Configuration.Add(Enums.Roles_Rights.DataAdministration);
	Configuration.Add(Enums.Roles_Rights.UpdateDataBaseConfiguration);
	Configuration.Add(Enums.Roles_Rights.ExclusiveMode);
	Configuration.Add(Enums.Roles_Rights.ActiveUsers);
	Configuration.Add(Enums.Roles_Rights.EventLog);
	Configuration.Add(Enums.Roles_Rights.ThinClient);
	Configuration.Add(Enums.Roles_Rights.WebClient);
	Configuration.Add(Enums.Roles_Rights.MobileClient);
	Configuration.Add(Enums.Roles_Rights.ThickClient);
	Configuration.Add(Enums.Roles_Rights.ExternalConnection);
	Configuration.Add(Enums.Roles_Rights.Automation);
	Configuration.Add(Enums.Roles_Rights.TechnicalSpecialistMode);
	Configuration.Add(Enums.Roles_Rights.CollaborationSystemInfoBaseRegistration);
	Configuration.Add(Enums.Roles_Rights.MainWindowModeNormal);
	Configuration.Add(Enums.Roles_Rights.MainWindowModeWorkplace);
	Configuration.Add(Enums.Roles_Rights.MainWindowModeEmbeddedWorkplace);
	Configuration.Add(Enums.Roles_Rights.MainWindowModeFullscreenWorkplace);
	Configuration.Add(Enums.Roles_Rights.MainWindowModeKiosk);
	Configuration.Add(Enums.Roles_Rights.AnalyticsSystemClient);
	Configuration.Add(Enums.Roles_Rights.SaveUserData);
	Configuration.Add(Enums.Roles_Rights.ConfigurationExtensionsAdministration);
	Configuration.Add(Enums.Roles_Rights.InteractiveOpenExtDataProcessors);
	Configuration.Add(Enums.Roles_Rights.InteractiveOpenExtReports);
	Configuration.Add(Enums.Roles_Rights.Output);
	#EndRegion 
//	Settings.Insert(Enums.Roles_MetadataTypes.Configuration, Configuration);

	#Region IntegrationService
	IntegrationService = New Array;
	IntegrationService.Add(Enums.Roles_Rights.Use);
	#EndRegion 
	Settings.Insert(Enums.Roles_MetadataTypes.IntegrationService, IntegrationService);
	
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
	
	Configuration = New Structure;
	MetaDataObject.Insert("Configuration", Configuration);
	
	Return MetaDataObject;
EndFunction

Function MetaDataObjectNames() Export
	Structure = New Map;
	Structure.Insert(Enums.Roles_MetadataTypes.AccountingRegister, "AccountingRegisters");
	Structure.Insert(Enums.Roles_MetadataTypes.AccumulationRegister, "AccumulationRegisters");
	Structure.Insert(Enums.Roles_MetadataTypes.BusinessProcess, "BusinessProcesses");
	Structure.Insert(Enums.Roles_MetadataTypes.CalculationRegister, "CalculationRegisters");
	Structure.Insert(Enums.Roles_MetadataTypes.Catalog, "Catalogs");
	Structure.Insert(Enums.Roles_MetadataTypes.ChartOfAccounts, "ChartsOfAccounts");
	Structure.Insert(Enums.Roles_MetadataTypes.ChartOfCalculationTypes, "ChartsOfCalculationTypes");
	Structure.Insert(Enums.Roles_MetadataTypes.ChartOfCharacteristicTypes, "ChartsOfCharacteristicTypes");
	Structure.Insert(Enums.Roles_MetadataTypes.CommonAttribute, "CommonAttributes");
	Structure.Insert(Enums.Roles_MetadataTypes.CommonCommand, "CommonCommands");
	Structure.Insert(Enums.Roles_MetadataTypes.CommonForm, "CommonForms");
	Structure.Insert(Enums.Roles_MetadataTypes.Constant, "Constants");
	Structure.Insert(Enums.Roles_MetadataTypes.DataProcessor, "DataProcessors");
	Structure.Insert(Enums.Roles_MetadataTypes.DocumentJournal, "DocumentJournals");
	Structure.Insert(Enums.Roles_MetadataTypes.Document, "Documents");
	Structure.Insert(Enums.Roles_MetadataTypes.ExchangePlan, "ExchangePlans");
	Structure.Insert(Enums.Roles_MetadataTypes.FilterCriterion, "FilterCriteria");
	Structure.Insert(Enums.Roles_MetadataTypes.HTTPService, "HTTPServices");
	Structure.Insert(Enums.Roles_MetadataTypes.InformationRegister, "InformationRegisters");
	Structure.Insert(Enums.Roles_MetadataTypes.Report, "Reports");
	Structure.Insert(Enums.Roles_MetadataTypes.Sequence, "Sequences");
	Structure.Insert(Enums.Roles_MetadataTypes.SessionParameter, "SessionParameters");
	Structure.Insert(Enums.Roles_MetadataTypes.Subsystem, "Subsystems");
	Structure.Insert(Enums.Roles_MetadataTypes.Task, "Tasks");
	Structure.Insert(Enums.Roles_MetadataTypes.WebService, "WebServices");
	Structure.Insert(Enums.Roles_MetadataTypes.Role, "Roles");
	Structure.Insert(Enums.Roles_MetadataTypes.ExternalDataSource, "ExternalDataSources");
	Return Structure;
EndFunction

Function MetadataInfo() Export
	
	Structure = MetaDataObjectNames();
	MetaStructure = New Map;
	For Each Row In Structure Do
		ValueList = New ValueList();
		For Each Data In Metadata[Row.Value] Do
			ValueList.Add(Data.Name, Data.Synonym);
		EndDo;
		MetaStructure.Insert(Row.Key, ValueList); 
	EndDo;
	Return MetaStructure;
EndFunction


Function hasAttributes(MetaName) Export
	Array = New Array;
	Array.Add(Enums.Roles_MetadataTypes.Catalog);	
    Array.Add(Enums.Roles_MetadataTypes.Document);
    Array.Add(Enums.Roles_MetadataTypes.Task);
    Array.Add(Enums.Roles_MetadataTypes.DataProcessor);
    Array.Add(Enums.Roles_MetadataTypes.Report);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfCalculationTypes);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfCharacteristicTypes);
    Array.Add(Enums.Roles_MetadataTypes.ExchangePlan);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfAccounts);
    Array.Add(Enums.Roles_MetadataTypes.AccountingRegister);
    Array.Add(Enums.Roles_MetadataTypes.AccumulationRegister);
    Array.Add(Enums.Roles_MetadataTypes.CalculationRegister);
    Array.Add(Enums.Roles_MetadataTypes.InformationRegister);
    Array.Add(Enums.Roles_MetadataTypes.BusinessProcess);
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasCommands(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.BusinessProcess);
    Array.Add(Enums.Roles_MetadataTypes.Catalog);
    Array.Add(Enums.Roles_MetadataTypes.Document);
    Array.Add(Enums.Roles_MetadataTypes.DocumentJournal);
    Array.Add(Enums.Roles_MetadataTypes.Task);
    Array.Add(Enums.Roles_MetadataTypes.FilterCriterion);
    Array.Add(Enums.Roles_MetadataTypes.DataProcessor);
    Array.Add(Enums.Roles_MetadataTypes.Report);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfCalculationTypes);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfCharacteristicTypes);
    Array.Add(Enums.Roles_MetadataTypes.ExchangePlan);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfAccounts);
    Array.Add(Enums.Roles_MetadataTypes.AccountingRegister);
    Array.Add(Enums.Roles_MetadataTypes.AccumulationRegister);
    Array.Add(Enums.Roles_MetadataTypes.CalculationRegister);
    Array.Add(Enums.Roles_MetadataTypes.InformationRegister);
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasDimensions(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.AccountingRegister);
    Array.Add(Enums.Roles_MetadataTypes.AccumulationRegister);
    Array.Add(Enums.Roles_MetadataTypes.CalculationRegister);
    Array.Add(Enums.Roles_MetadataTypes.InformationRegister);
    Array.Add(Enums.Roles_MetadataTypes.Sequence);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasResources(MetaName) Export
	Array = New Array;
	Array.Add(Enums.Roles_MetadataTypes.AccumulationRegister);
    Array.Add(Enums.Roles_MetadataTypes.CalculationRegister);
    Array.Add(Enums.Roles_MetadataTypes.InformationRegister);
    Array.Add(Enums.Roles_MetadataTypes.AccountingRegister);
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction
 
Function hasStandardAttributes(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.Catalog);
    Array.Add(Enums.Roles_MetadataTypes.Document);
    Array.Add(Enums.Roles_MetadataTypes.DocumentJournal);
    Array.Add(Enums.Roles_MetadataTypes.Task);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfCalculationTypes);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfCharacteristicTypes);
    Array.Add(Enums.Roles_MetadataTypes.ExchangePlan);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfAccounts);
    Array.Add(Enums.Roles_MetadataTypes.AccountingRegister);
    Array.Add(Enums.Roles_MetadataTypes.AccumulationRegister);
    Array.Add(Enums.Roles_MetadataTypes.CalculationRegister);
    Array.Add(Enums.Roles_MetadataTypes.InformationRegister);
    Array.Add(Enums.Roles_MetadataTypes.BusinessProcess);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasTabularSections(MetaName) Export
	Array = New Array;
	Array.Add(Enums.Roles_MetadataTypes.Catalog);
    Array.Add(Enums.Roles_MetadataTypes.Document);
    Array.Add(Enums.Roles_MetadataTypes.Task);
    Array.Add(Enums.Roles_MetadataTypes.DataProcessor);
    Array.Add(Enums.Roles_MetadataTypes.Report);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfCalculationTypes);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfCharacteristicTypes);
    Array.Add(Enums.Roles_MetadataTypes.ExchangePlan);
    Array.Add(Enums.Roles_MetadataTypes.ChartOfAccounts);
    Array.Add(Enums.Roles_MetadataTypes.BusinessProcess);
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasRecalculations(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.CalculationRegister);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasAccountingFlags(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.ChartOfAccounts);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasExtDimensionAccountingFlags(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.ChartOfAccounts);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasStandardTabularSections(MetaName) Export
	Array = New Array;
	Array.Add(Enums.Roles_MetadataTypes.ChartOfCalculationTypes);
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasAddressingAttributes(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.Task);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasURLTemplates(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.HTTPService);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function hasOperations(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.WebService);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function isSubsystem(MetaName) Export
	Array = New Array;
    Array.Add(Enums.Roles_MetadataTypes.Subsystem);	
	Return NOT Array.Find(MetaName) = Undefined;
EndFunction

Function MetaName(RefData) Export
	Return Roles_SettingsReUse.MetaNameByRef(RefData);
EndFunction

#EndRegion