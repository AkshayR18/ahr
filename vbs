Dim objExcel, objWorkbook, filePath 

filePath = "C:\\Users\\Akshay\\Downloads\\NOP-backup-21.08.20-master\\NOP-backup-21.08.20-master\\NOP 21.08.20 BACKUP\\NOP 21.08.20 BACKUP\\NOP QuickFixes\\NOP Part 3.xlsm"
Set objExcel = CreateObject("Excel.Application")
Set objWorkbook = objExcel.Workbooks.Open(filePath)
objExcel.Visible = True
objExcel.Run "cleaning_NOP_Summary"
objWorkbook.Save
objExcel.Quit

Set objWorkbook = Nothing
Set objExcel = Nothing

WScript.Quit
