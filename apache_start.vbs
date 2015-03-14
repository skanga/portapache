':####################################################################################
':# File name: server_start.vbs
':# Usage:
':# apache-start - Start the httpd on port 80 and serve the current dir
':# apache-start 8080 - Start the httpd on port 8080 and serve the current dir
':# apache-start 80 c:\temp - Start the httpd on port 8080 and serve c:\temp
':####################################################################################

option explicit ' force all variables to be declared

Dim httpPort, docRoot, httpdHome, productName

productName = "PortApache 2.2.11"

' Bail out if apache is already running
If (IsProcessRunning ("httpd.exe") = "True") Then
  MsgBox "This " & productName & " server is already running." & vbCrLf & _
    "You can stop it using apache_stop.vbs"
  WScript.Quit
End If

' Set some defaults
httpPort = 80
docRoot = CreateObject ("Scripting.FileSystemObject").GetAbsolutePathName (".")

' Parse the command line and prompt for missing values
If Wscript.Arguments.Count = 0 Then
  httpPort = InputBox ("Enter the port to listen on", productName, httpPort)
  docRoot = InputBox ("Enter the document root folder to expose on the web", productName, docRoot)
ElseIf Wscript.Arguments.Count = 1 Then
  httpPort = Wscript.Arguments.Item (0)
  docRoot = InputBox ("Enter the document root folder to expose on the web", productName, docRoot)
ElseIf Wscript.Arguments.Count = 2 Then
  httpPort = Wscript.Arguments.Item (0)
  docRoot = Wscript.Arguments.Item (1)
End If

'Determine the full path to the Apache home
httpdHome = Replace (Wscript.ScriptFullName, "\" & Wscript.ScriptName, "") & "\apache"

DelPidFile (httpdHome)
FixConfigFiles httpPort, docRoot, httpdHome
RunHttpd (httpdHome)

Function DelPidFile (httpdHome)
  Dim pidFile
  pidFile = httpdHome & "logs\httpd.pid"
  If CreateObject ("Scripting.FileSystemObject").FileExists (pidFile) Then
    CreateObject ("Scripting.FileSystemObject").DeleteFile (pidFile)
  End If
End Function

Function FixConfigFiles (httpPort, docRoot, httpdHome)
  Dim httpdConf, httpIndex, searchWords (3), replaceWords (3)

  searchWords (0) = "@@Port@@"
  searchWords (1) = "@@DocRoot@@"
  searchWords (2) = "@@ServerRoot@@"
  searchWords (3) = "@@IPAddress@@"

  replaceWords (0) = httpPort
  replaceWords (1) = Replace (docRoot, "\", "/")
  replaceWords (2) = Replace (httpdHome, "\", "/")
  replaceWords (3) = "localhost"

  httpdConf = httpdHome & "\conf\httpd.conf"
  httpIndex = httpdHome & "\www\index.html"

  SearchReplace httpdHome & "\conf\httpd.conf.in", httpdConf, searchWords, replaceWords
  SearchReplace httpdHome & "\www\index.html.in", httpIndex, searchWords, replaceWords

  RunFile (httpIndex)

End Function

Function RunHttpd (httpdHome)
  Dim httpdCmd, httpdConf, fullCmd
  'MsgBox "Starting the Apache server." & vbCrLf & _
  '  "To view site type http://localhost:" & httpPort & "/ into your browser." & vbCrLf & _
  '  "Alternatively you may also try http://" & GetIPAddress & ":" & httpPort & _
  '  "/ or http://127.0.0.1:" & httpPort & "/"

  httpdCmd = Chr (34) & httpdHome & "\bin\httpd.exe" & Chr (34)
  httpdConf = Chr (34) & httpdHome & "\conf\httpd.conf" & Chr (34)
  fullCmd = httpdCmd & " -f " & httpdConf
'Wscript.Echo "Running: " & fullCmd
  CreateObject ("WScript.Shell").Run fullCmd, 0, False
End Function

Function RunFile (theFile)
  rem ### Display index page in browser
  If CreateObject ("Scripting.FileSystemObject").FileExists (theFile) Then
    CreateObject ("WScript.Shell").Run (Chr (34) & theFile & Chr (34))
  End If
End Function

Function IsProcessRunning (processName)
  Dim wmiService, processList
  Set wmiService = GetObject ("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Set processList = wmiService.ExecQuery ("Select * from Win32_Process Where Name = '" & processName & "'")

  If processList.Count = 0 Then
    IsProcessRunning = "False"
  Else
    IsProcessRunning = "True"
  End If

End Function

' This function does file based search and replace
Function SearchReplace (inFile, outFile, searchWords, replaceWords)
  Dim objFSO, objFile, strText, i

  Const ForReading = 1
  Const ForWriting = 2

  Set objFSO = CreateObject ("Scripting.FileSystemObject")
  Set objFile = objFSO.OpenTextFile (inFile, ForReading)

  strText = objFile.ReadAll
  objFile.Close

  'For i = 0 To searchWords.Count
  For i = 0 To UBound (searchWords)
    strText = Replace (strText, searchWords (i), replaceWords (i))
  Next

  Set objFile = objFSO.OpenTextFile (outFile, ForWriting)
  objFile.WriteLine strText
  objFile.Close
End Function
