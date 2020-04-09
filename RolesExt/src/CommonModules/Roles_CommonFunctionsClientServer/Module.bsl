#Region Internal
Procedure ShowUsersMessage(Text, Field = Undefined, Data = Undefined, AddInfo = Undefined) Export
	Message = New UserMessage();
	Message.Text = Text;
	Message.Field = Field;
	Message.SetData(Data);
	Message.Message();
EndProcedure
#EndRegion