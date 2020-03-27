

&AtClient
Procedure OK(Command)
	Close(Text);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Text = Parameters.Text;
EndProcedure

