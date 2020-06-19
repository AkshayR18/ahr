'Constants

Const xlOpenXMLWorkbook = 51             '(without macro's in 2007-2016, xlsx)

Const xlOpenXMLWorkbookMacroEnabled = 52 '(with or without macro's in 2007-2016, xlsm)

Const xlExcel12 = 50                     '(Excel Binary Workbook in 2007-2016 with or without macro's, xlsb)

Const xlExcel8 =56                       '(97-2003 format in Excel 2007-2016, xls)

 

' Extensions for old and new files

strExcel = "xlsx"

strCSV = "csv"

strXLS = "xls"

strXLSB = "xlsb"

 

' Set up filesystem object for usage

Set objFSO = CreateObject("Scripting.FileSystemObject")

 

 

 

dim fso

dim curDir

dim WinScriptHost

set fso = CreateObject("Scripting.FileSystemObject")

curDir = fso.GetAbsolutePathName(".")

' set fso = nothing

' Set WinScriptHost = CreateObject("WScript.Shell")

' WinScriptHost.Run curDir & "\testme.bat", 1

' set WinScriptHost = nothing

 

' msgbox curDir

 

strFolder = curDir

 

' Access the folder to process

Set objFolder = objFSO.GetFolder(strFolder)

 

' Load Excel (hidden) for conversions

Set objExcel = CreateObject("Excel.Application")

objExcel.Visible = False

objExcel.DisplayAlerts = False

 

' Process all files

For Each objFile In objFolder.Files

    ' Get full path to file

    strPath = objFile.Path

    ' Only convert CSV files

    If LCase(objFSO.GetExtensionName(strPath)) = LCase(strCSV) Or LCase(objFSO.GetExtensionName(strPath)) = LCase(strXLS) Or LCase(objFSO.GetExtensionName(strPath)) = LCase(strXLSB)Then

        ' Display to console each file being converted

       ' Wscript.Echo "Converting """ & strPath & """"

        ' Load CSV into Excel and save as native Excel file

        Set objWorkbook = objExcel.Workbooks.Open(strPath, False, True)

        strNewPath = objFSO.GetParentFolderName(strPath) & "\" & objFSO.GetBaseName(strPath) & "." & strExcel

        objWorkbook.SaveAs strNewPath, xlOpenXMLWorkbook

        objWorkbook.Close False

        Set objWorkbook = Nothing

    End If

Next

 

'Wrap up

objExcel.Quit

Set objExcel = Nothing

Set objFSO = Nothing
