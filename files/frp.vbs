'�����д�������shell:startup���ȷ�����һ���ļ��У��Ѵ��ļ������ļ�����

'��������
runCommand = "D:\frp������͸����\frpc.exe -c D:\frp������͸����\frpc.ini"

'�������к���
call run(runCommand)

'WScript.Echo OSver()
'MsgBox(OSver())

'���У�����Ϊ��������
Function run(runCommand)
    dim ws
	'Windows10֮ǰ��ϵͳ����һ���ű������
    Set ws = CreateObject("Wscript.Shell")

    dim wsh
	'Windows10����һ���ű������
    Set wsh=WScript.CreateObject("WScript.Shell")

	'ƴ��Windows10֮ǰ��ϵͳ��������
    runWs= "cmd /c " & runCommand

	'Windows10��������
    runWsh= runCommand
    
    '��ȡϵͳ��Ϣ
    'infoItem = showOsInfo()
    infoItem = OSver()
    
    select case infoItem
        case "Windows Server 2003"
            ws.run runWs,vbhide
        
        case "Windows 2000"
            ws.run runWs,vbhide
        
        case "Windows XP"
            ws.run runWs,vbhide
        
        case "windows visita"
            ws.run runWs,vbhide
        
        case "windows 7"
            ws.run runWs,vbhide
            
        case "windows 10"
            wsh.Run runWsh,0
        
        case else
            wscript.echo infoItem
            wscript.quit
    end select
End Function

'ϵͳ�汾��ϵͳλ��ƴ��
Function showOsInfo()
    'wscript.echo OSver() & X86orX64()
    showOsInfo = OSver() & X86orX64()
End Function

'��ȡ��ǰϵͳλ��
Function X86orX64()
    Set objWMIService = GetObject("winmgmts:!\\.\root\cimv2")
    Set colItems = objWMIService.ExecQuery("Select * from Win32_ComputerSystem")
    For Each objItem in colItems
        strOSsystype=objitem.SystemType
    Next
    set objWMIService = nothing
    set colItems = nothing
    If InStr( strOSsystype, "86") <> 0 Then
        X86orX64 = "_x86"
    elseif InStr(strOSsystype, "64") <> 0 Then
        X86orX64 = "_x64"
    else
        wscript.echo "��֪��32λ����64λ��"
        wscript.quit
    end if
End Function

'��ȡ��ǰϵͳ�汾
Function OSver()
    Set objWMIService = GetObject("winmgmts:!\\.\root\cimv2")
    Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
    For Each objItem in colItems
        strOScaption=objitem.Caption
        strOSversion=objitem.Version
    Next
    set objWMIService = nothing
    set colItems = nothing
    '��ȡstrOSversionΪ���һ��"."�����沿��
    strOSversion=left(strOSversion,InStrRev(strOSversion,".",-1,1) - 1)
    select case strOSversion
        case "5.2" '"5.2.3790"
            OSver = "Windows Server 2003"
        case "5.0" '"5.0.2195"
            OSver = "Windows 2000"
        case "5.1" '"5.1.2600"
            OSver = "Windows XP"
        case "6.0" '"6.0.6001"
            OSver = "windows visita"
        case "6.1" '"6.1.7601"
            OSver = "windows 7"
        case "10.0"
            OSver = "windows 10"
        case else
            OSver = strOSversion
            'wscript.quit
    end select
End Function