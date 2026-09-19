' sIniDir 为初始化目录
' sFilter 为文件后缀 示例："*.*,*.txt"
Function GetFileDlgEx(sIniDir, sFilter, sTitle)
    sIniDir = Replace(sIniDir, "\", "\\")
    ' Set regex = New RegExp
    Set regex = CreateObject("VBScript.RegExp")
    regex.Global = True
    regex.MultiLine = True
    regex.Pattern = ";|\|"
    sFilter = regex.Replace(sFilter, ",")
    DIM sf
    For Each i In Split(sFilter, ",")
        sf = sf & i & "|" & i & "|"
    Next
    sFilter = sf
    hta="""about:<object id=d classid=clsid:3050f4e1-98b5-11cf-bb82-00aa00bdce0b></object>" & _
    "<script>moveTo(0,-9999);" & _
    "eval(new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0)" & _
    ".Read("&Len(sIniDir)+Len(sFilter)+Len(sTitle)+41&"));" & _
    "function window.onload(){" & _
    "var p=/[^\0]*/;" & _
    "new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1)" & _
    ".Write(p.exec(d.object.openfiledlg(iniDir,null,filter,title)));" & _
    "close();" & _
    "}</script><hta:application showintaskbar=no />"""
    Set oDlg = CreateObject("WScript.Shell").Exec("mshta.exe " & hta) 
    oDlg.StdIn.Write "var iniDir='" & sIniDir & "';var filter='" & sFilter & "';var title='" & sTitle & "';" 
    GetFileDlgEx = oDlg.StdOut.ReadAll 
End Function

Set WshShell = Wscript.CreateObject("Wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 获取当前用户桌面
f = GetFileDlgEx(WshShell.SpecialFolders("Desktop"), "*.war", "选择WAR包")
If f = "" Or IsNull(f) Then
    MsgBox "请选择WAR包！", 48
    Wscript.Quit
End If

Set fObj = fso.GetFile(f)
Set fPf = fObj.ParentFolder
fName = fObj.name
oldFolder = Replace(fObj.path, ".war", "")

If fso.folderExists(oldFolder) Then
    MsgBox "文件夹" & oldFolder & "已经存在！", 48
    Wscript.Quit
End If

unWar = oldFolder & "\" & fName
' 创建文件夹
fso.CreateFolder(oldFolder)
' 复制文件
fso.CopyFile f, unWar, True
' 切换工作目录
WshShell.CurrentDirectory = oldFolder
' 解压WAR包
resCode = WshShell.Run("jar -xvf " & unWar, 0, True)
If resCode <> 0 Then
    MsgBox "WAR包解压错误！", 48
    Wscript.Quit
End If
' 删除文件
fso.DeleteFile(unWar)
' WshShell.CurrentDirectory = fso.GetFolder(".").Path
WshShell.CurrentDirectory = fso.GetFile(Wscript.ScriptFullName).ParentFolder.Path

' On Error Resume Next ' 捕获异常

copyPath = oldFolder & "_copy" ' 复制后的路径

' If Err <> 0 Then
    ' MsgBox "文件夹未正确选择！" & Err.Description, 48
    ' Err.clear ' 错误被手工处理后要记得清除err对象的内容
    ' Wscript.Quit
' End If
' On Error Goto 0 ' 关闭错误捕获

' 输出选择的文件路径
' MsgBox "当前选择的文件：" & chr(13) & f, 64

' 打开对话框
Set oExec = WshShell.Exec("mshta javascript:""<HTA:APPLICATION SCROLL = 'No' MinimizeButton='No'/><span>提示：可从SVN日志中查找到文件</span><textarea id='t' cols='60' rows='20' style='width:100%;height:100%'></textarea><script>document.title='要打包的文件';resizeTo(500, 450);document.body.onunload = function(){new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(t.value);}</script>""")

arg = oExec.StdOut.ReadAll
' arg = InputBox("多个文件之间以空格分割" & vbCrLf & vbCrLf & "提示：可从SVN日志中查找到文件", "要打包的文件", "")

If arg = "" Then
    MsgBox "请输入要打包的文件！", 48
    Wscript.Quit
End If

s = Replace(arg, ".java", "*")
With New RegExp
    .Global = True
    .MultiLine = True
    .Pattern = vbCrLf & "|" & vbCr & "|" & vbLf
    s = .Replace(s, " ")
End With

' https://docs.microsoft.com/zh-cn/windows-server/administration/windows-commands/robocopy
resCode = WshShell.Run("robocopy /ndl /njh /njs /s """ & oldFolder & """ """ & copyPath & """ " & s, 0, True)

If resCode > 8 Then
    MsgBox "增量文件复制错误！", 48
    Wscript.Quit
End If
' 删除文件
fso.DeleteFolder(oldFolder)

If fso.folderExists(copyPath) Then
    MsgBox "执行成功！", 64
    ' WshShell.Explore(copyPath)
Else
    MsgBox "执行失败！", 48
End If