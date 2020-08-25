Set objShell = CreateObject("WScript.Shell")
Dim cur
cur = "C:\\Users\\Akshay\\Downloads\\NOP-backup-21.08.20-master\\NOP-backup-21.08.20-master\\NOP 21.08.20 BACKUP\\NOP 21.08.20 BACKUP\\NOP QuickFixes\\NOP Part 3.xlsm"
WScript.Echo cur

ExcelMacroExample

Sub ExcelMacroExample() 

Dim xlApp 
Dim xlBook 
Dim xlsFile
xlsFile = cur

Set xlApp = CreateObject("Excel.Application") 
Set xlBook = xlApp.Workbooks.Open(xlsFile) 
xlApp.Run "cleaning_NOP_Summary"
xlApp.Save
xlApp.Quit 

MsgBox("Successfully completed.",0,"Completed")

End Sub 
