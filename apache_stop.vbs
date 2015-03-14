':#######################################################################
':# File name: server_stop.vbs
':#######################################################################
option explicit ' force all variables to be declared
Dim wmiService, processList, currProcess, retCode, productName

productName = "PortApache 2.2.11"

Set wmiService = GetObject ("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Set processList = wmiService.ExecQuery ("SELECT * FROM Win32_Process WHERE Name = 'httpd.exe'")

If processList.Count = 0 Then
  WSCript.Echo "The " & productName & " process is not running"
  WScript.Quit 
End If

For Each currProcess in processList
  retCode = currProcess.Terminate()
  If retCode <> 0 Then
     Wscript.Echo "Could not kill process. Error code: " & retCode
  End If
Next 

WSCript.Echo "The " & productName & " process has been terminated"
WScript.Quit 
