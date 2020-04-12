#Region Internal
Function DeserializeXMLUseXDTOFactory(Value) Export
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = XDTOFactory.ReadXML(Reader);
	Reader.Close();
	Return Result;
EndFunction

Function SerializeXMLUseXDTOFactory(Value) Export
	Writer = New XMLWriter();
	Writer.SetString();
	XDTOFactory.WriteXML(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

Function DeserializeXML(Value) Export
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = XDTOSerializer.ReadXML(Reader);
	Reader.Close();
	Return Result;
EndFunction

Function SerializeXML(Value) Export
	Writer = New XMLWriter();
	Writer.SetString();
	XDTOSerializer.WriteXML(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

Function HashMD5(Data) Export
	  
    Hash = New DataHashing(HashFunction.MD5);
    Hash.Append(Data);
    HashSum = Hash.HashSum;
    
    HashSumString = String(HashSum);
    HashSumString = StrReplace(HashSumString, " ", "");
    
    HashSumStringUUID = Left(HashSumString, 8)      + "-" + 
                        Mid(HashSumString, 9, 4)    + "-" + 
                        Mid(HashSumString, 15, 4)   + "-" + 
                        Mid(HashSumString, 18, 4)   + "-" + 
                        Right(HashSumString, 12);
    Return HashSumStringUUID;
    
EndFunction


Function HeadTemplate() Export
	Return Roles_SettingsReUse.MatrixTemplates().GetArea("Head");
EndFunction
Function RowTemplate() Export
	Str = Roles_SettingsReUse.MatrixTemplates_Rows();
	Template = Str.Template;
	Template.Parameters.Fill(Str.Params);
	Return Template;
EndFunction
Function RLSTemplate() Export
	Return Roles_SettingsReUse.MatrixTemplates().GetArea("RLS");
EndFunction
Function FooterTemplate() Export
	Return Roles_SettingsReUse.MatrixTemplates().GetArea("Footer");
EndFunction
#EndRegion