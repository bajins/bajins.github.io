1>1/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  bcn 5.3  by bailong360 @www.bathome.net
:: �׷�����µ�ַ:http://www.bathome.net/thread-32322-1-1.html
::
:: ʹ��ʱ�뽫bcn.bat��������һ��PATH�е�Ŀ¼�Ա����
:: ����ȷ��bcn.batӵ�и�Ŀ¼�Ķ�дȨ��(�����ò�Ҫѡ��system32)
:: �����½�һ��Ŀ¼ר��bcn.batʹ��,�ٽ����Ŀ¼��ӵ�PATH��
::
:: �����÷�:
::   ����: bcn command filename [v:version] [/f] [/o:path]
::     ��Batch-CN������ָ���ĵ�����
::      command
::        ��ѡ:get-tool get gt down
::        ǰ����Ч����ͬ,���һ����Ч����ͬ��get-tool /f
::      filename
::        �����صĵ���������
::      (��ѡ)v:version
::        �����صĵ������汾(��������Ĭ�ϰ汾)
::      (��ѡ)/f
::        ��ʹ�������Ѵ���Ҳ����,��ͬ��down
::      (��ѡ)/o:path
::        ���ص�ָ��Ŀ¼,pathΪ'-'�����ص���ǰĿ¼
::      ��:bcn get sed v:4.0.7 /f
::         bcn get capi
::         bcn get sed "/o:New Folder"
::         bcn get sed /o:-
::
::   ɾ��: bcn command filename
::     ��bcn.bat������Ŀ¼��ɾ��һ���ļ�(��)
::      command:
::        ��ѡ:del-tool del dt
::      filename:
::         ��ɾ�����ļ�(��)����,���Ӻ�׺��ɾ����������ļ�(��)
::      ��:bcn del capi.rar
::         bcn del capi
::
::   ����: bcn command keyword [col:length] ...
::     ���ݹؼ��ʲ��ҵ�����
::      command:
::         ��ѡ:find-tool find ft
::      keyword:
::         ��Ҫ���ҵĹؼ���,�ᱻ����ΪJScript������ʽ
::      (��ѡ)col:length
::         ��ѡ:name ver info size
::         ָ������еĿ��,��ָ�����
::         length��ʾ���еĿ��,Ϊ0ʱ�����ظ���
::         Ĭ�Ͽ��name:14 ver:12 info:38 size:8
::      ��:bcn find ����
::         bcn find �滻 ver:0 info:50
::         bcn find "^sed "
::
:: ��ʾ:�����Ҽ��޸�Դ������ø��ߵĿɶ�����
::
:: Batch-CN��Ŀ������
:: �Ľ���ά���� CrLf, bailong360, Batcher
:: �Ƽ��ͽ��飺 templinshi, ��ɽ��, tigerpower

:+ 5.3
:+  �滻bcn������Ϊbcn.bathome.net
:+  �Ż�����Ч�ʣ������嵥����1����
:+
:+ 5.2
:+  �޸�����bcnʱ���ܳ��ֵĴ���
:+
:+ 5.1
:+  �޸����ж�listʱ��ʱ���߼�����
:+  �޸���find remʱ���ֵĴ���
:+  ������EasyUSeģʽ
:+  ������/f����
:+  ������/o����
:+  ����˶�����
:+
:+ 5.0
:+  ��д�˴���,ʹ��bat/Js���,��������get-tool,find-tool,del-tool
:+  ��ǿ��find-tool�Ĺ���
:+
:+ 4.1.2
:+  �޸���Get-Tool��ȡ��������list������
:+  �޸���Get-Update��ѹʱĿ¼���Ե�����
:+
:+ 4.1.1
:+  �޸��˲���bug
:+  �޸��˵������б�Ļ�ȡԴ

@echo off

set "EasyUse=false"    //EasyUse���ڶ����������ɵ���������,���û���ҵ�ָ�����������ִ��find-tool

md "%~dp0$testAdmin$" 2>nul
if not exist "%~dp0$testAdmin$" (
    echo bcn���߱�����Ŀ¼��д��Ȩ��! >&2
    exit /b 1
) else rd "%~dp0$testAdmin$"

setlocal enabledelayedexpansion

set /a name=14,ver=12,info=38,size=8
set cmdList=get-tool del-tool find-tool
set get-tool=get-tool gt get
set del-tool=del-tool dt del
set find-tool=find-tool ft find
set cover=false

for %%j in ("%~3" "%~4" "%~5" "%~6") do (
    if /i not "%%~j"=="/f" (
        for /f "tokens=1,* delims=:" %%k in ("%%~j") do set %%k=%%l
    ) else set cover=true
)

if /i "%EasyUse%"=="true" (
    cscript /nologo /e:jscript "%~f0" /func:get-tool /name:%~1 "/ver:%v%" /cover:false /cols:%name%-%ver%-%info%-%size% "/path:%/o%" /easyuse:true|more
    goto :EXIT
)

if /i "%~1"=="down" (
    set cmd=get-tool
    set cover=false
) else (
    for %%i in (%cmdList%) do (
        for %%j in (!%%i!) do (
            if /i "%%j"=="%~1" set cmd=%%i
        )
    )
)

if "%cmd%"=="" (
    echo �������^^! >&2
    findstr "^::" "%~f0"|more
    endlocal&exit /b 1
) else if "%cmd%"=="del-tool" (
    rd /s /q "%~dp0%~2" 2>nul
    del "%~dp0%~2.exe","%~dp0%~2.*" 2>nul
    echo ��ɾ��
    endlocal&exit /b 0
)

if "%cmd%"=="find-tool" (
    cscript    /nologo /e:jscript "%~f0" /func:find-tool "/keyword:%~2" /cols:%name%-%ver%-%info%-%size% "/path:%/o%" |more
) else (
    cscript /nologo /e:jscript "%~f0" /func:%cmd% /name:%~2 "/ver:%v%" /cover:%cover% "/path:%/o%"
    goto :EXIT
)

:EXIT
endlocal&exit /b %errorlevel%
*/
try {
    var DownMode = '';       //���ط�ʽ,������ʹ���ڽ�����.����ʹ������������,��:'wget -q "$URL" -O "$SavePath"'
    var URARMode = 'unrar x -o+ -y "$File" "$SavePath"';  //��ѹ��ʽ,Ĭ��ʹ��unrar��ѹ

    var WShell  = new ActiveXObject('WScript.Shell');
    var FSO     = new ActiveXObject('Scripting.FileSystemObject');
    var XMLHTTP = new ActiveXObject('Microsoft.XMLHTTP');
    var ADO     = new ActiveXObject('ADODB.Stream');
    var Argv    = WScript.Arguments.Named;
    var bcnPath = FSO.GetFile(WScript.ScriptFullName).ParentFolder.Path + '\\'; //��������ŵ�ַ,Ĭ��Ϊbcn.bat����Ŀ¼
    var SavPath = Argv.Item('path') == '' ? bcnPath : (Argv.Item('path') == '-' ? WShell.CurrentDirectory + '\\' : Argv.Item('path').replace(/\\$/, '') + '\\');
    var host    = 'http://bcn.bathome.net';

    if (!(FSO.FileExists(bcnPath + 'tool.@version.txt') && CheckListDate())) {
        download('/list/tool.@version.txt', bcnPath);
    }

    switch (Argv.Item('func')) {
        case 'get-tool':
            get_tool(Argv.Item('name'), Argv.Item('ver'), Argv.Item('cover'));
            break;
        case 'find-tool':
            var cols = Argv.Item('cols').split('-');
            find_tool(Argv.Item('keyword'), cols[0], cols[1], cols[2], cols[3]);
            break;
    }
    WScript.Quit(0);
} catch (e) {
    WScript.StdErr.WriteLine('JScript����ʱ����:' + e.message);
    WScript.Quit(1);
}

function get_tool(fileName, fileVer, coverMode)
{
    var list     = FSO.OpenTextFile(bcnPath + 'tool.@version.txt', 1).ReadAll();
    var fullName = list.match(new RegExp('^' + fileName + '(\\.[a-z]+ | )@?[^ ]+ [^ ]+ [^ ]+', 'mgi'));

    if (!(fullName instanceof Array)) {
        WScript.StdErr.WriteLine('δ�ҵ�ƥ��ĵ�����!');
        if (Argv.Item('easyuse') == 'true') {
            var cols = Argv.Item('cols').split('-');
            find_tool(fileName, cols[0], cols[1], cols[2], cols[3]);
        }
        WScript.Quit(1);
    }

    var ver, name, size, info, withVer;
    if (fileVer == '') {  //û��ָ���汾,�����ذ汾��ǰ��'@'��(�Ƽ���)
        info    = fullName.join('\n').match(/^.+@.+$/m)[0];
        withVer = fullName.length == 1 ? false : true;

    } else {             //ָ���˰汾��
        info = fullName.join('\n').match(new RegExp('^.+' + fileVer + '.+$', 'mi'));
        if (!(info instanceof Array)) {
            WScript.StdErr.WriteLine('δ�ҵ�ƥ��ĵ�����!');
            if (Argv.Item('easyuse') == 'true') {
                var cols = Argv.Item('cols').split('-');
                find_tool(fileName, cols[0], cols[1], cols[2], cols[3]);
            }
            WScript.Quit(1);
        }
        info = info[0];
        withVer = true;
    }

    name = info.match(/[^ ]+/ );info = info.replace(/[^ ]+/, '');
    ver  = info.match(/[^@ ]+/);
    size = info.match(/\d+(?=Bytes)/);

    if (!/\.[^/]+$/.test(name)) {
        name += '.exe';
    }

    if (coverMode == 'false') { 
        if (FSO.FileExists(SavPath + name) && FSO.GetFile(SavPath + name).Size == size) {
            WScript.StdErr.WriteLine('�õ������Ѵ���,�������Ҫ������ʹ��/f����');
            WScript.Quit(1);
        }
    }

    fullName = (withVer ? ver + '/' : '') + name;

    WScript.StdOut.WriteLine('����:' + name + ' �汾:' + ver + ' ��С:'  + (size / 1024).toFixed(1) + 'KB');
    WScript.StdOut.Write('������...');
    download('/tool/' + fullName, SavPath);
    if (FSO.GetFile(SavPath + name).Size == size) {
        WScript.StdOut.WriteLine('�������!');
    } else {
        WScript.StdErr.WriteLine('����ʧ��!');
        WScript.StdErr.WriteLine('URL:' + host + '/tool/' + fullName);
        WScript.Quit(1);
    }

    if (/\.rar$/.test(name)) {
        WScript.StdOut.Write('��ѹ��...');
        unrar(name);
        WScript.StdOut.WriteLine('��ѹ���!');
    }
}

function find_tool(keyword, namel, verl, infol, sizel)
{
    var file = FSO.OpenTextFile(bcnPath + 'tool.@version.txt', 1);
    var pat  = new RegExp(keyword, 'i');
    while (!file.AtEndOfStream) {
        var line = file.ReadLine().replace(/@/, '').replace(/^rem .+$/im, '');
        if (pat.test(line)) {
            var name = line.match(/[^. ]+/)[0];line = line.replace(/[^ ]+/, '');
            var ver  = line.match(/[^ ]+/)[0] ;line = line.replace(/[^ ]+/, '');
            var info = line.match(/[^ ]+/)[0] ;line = line.replace(/[^ ]+/, '');
            var size = line.match(/\d+/)[0];
            WScript.StdOut.WriteLine(cutStr(name, namel) + cutStr(ver, verl) + cutStr(info, infol) + cutStr((size / 1024).toFixed(1) + 'KB', sizel));
        }
    }

}

function cutStr(str, max) //��ȡһ���ֽڵ��ַ���, ���㲹�ո�,������'...'�ض�
{
    if (max == 0) {
        return '\b'; //����ռλ�Ŀո�
    }
    var l = 0, i, j, space = ' ';
    var strl = str.length, strl2 = 0;

    for (i = 0; i < strl; i++) {
        var c = str.charCodeAt(i);
        strl2 += ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xcff9f)) ? 1 : 2;
    }

    max = strl2 > max ? max - 3 : max; //Ϊ'...'Ԥ���ռ�
    for (i = 0; i < strl && l < max; i++) {
        var c = str.charCodeAt(i);
        l += ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xcff9f)) ? 1 : 2;
    }
    for (j = 0; j < max - l + 1; j++) {
        space += ' ';
    }
    return str.substr(0, i) + (strl2 > max ? '...' : '') + space;
}

function unrar(fileName) {
    if (/unrar/.test(URARMode) && !FSO.FileExists(bcnPath + 'unrar.exe')) {
        download('/tool/unrar.exe', bcnPath);
    }
    WShell.Run(URARMode.replace(/\$File/, SavPath + fileName).replace(/\$SavePath/, SavPath), 0, true);
}

function download(URL, downPath)
{
    var SavePath = downPath + URL.match(/[^/]+$/);
    var DownURL  = host + URL + '?' + Math.random();

    if (DownMode == '') {
        XMLHTTP.Open('GET', DownURL, 0);
        XMLHTTP.Send();
        ADO.Mode = 3;
        ADO.Type = 1;
        ADO.Open();
        ADO.Write(XMLHTTP.ResponseBody);
        ADO.SaveToFile(SavePath, 2);
        ADO.Close();
    } else {
        WShell.Run(DownMode.replace(/\$URL/, DownURL).replace(/\$SavePath/, SavePath), 0, true);
    }
}

function CheckListDate() //�����б��ļ��޸�ʱ���time.txt��ʾ���ϴθ���ʱ������Ƿ����list
{
    //�޸�ʱ�����1���ӵ��б�������
    var listLastModified = new Date(FSO.GetFile(bcnPath + 'tool.@version.txt').DateLastModified || null)
    if(Math.abs(listLastModified - new Date()) > 60000) return true
    
    //�޸�ʱ������time.txt���б�������
    XMLHTTP.Open('GET', host + '/list/time.txt?' + Math.random(), 0);
    XMLHTTP.Send();
    ADO.Mode = 3;
    ADO.Type = 1;
    ADO.Open();
    ADO.Write(XMLHTTP.ResponseBody);
    ADO.Position = 0;
    ADO.Type     = 2;
    ADO.CharSet  = 'GB2312';
    var str = ADO.ReadText().replace(/[^0-9]/g, '');
    var UpdateTime = Date.parse(new Date(str.substr(0,4), str.substr(4,2), str.substr(6,2), str.substr(8,2), str.substr(12,2), str.substr(14,2)));
    ADO.Close();
    if (UpdateTime > Date.parse(FSO.GetFile(bcnPath + 'tool.@version.txt').DateLastModified)) {
        return false;
    } else {
        return true;
    }
}
