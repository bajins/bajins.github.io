1>1/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: by bajins https://www.bajins.com

@echo off
md "%~dp0$testAdmin$" 2>nul
if not exist "%~dp0$testAdmin$" (
    echo bajins���߱�����Ŀ¼��д��Ȩ��! >&2
    exit /b 1
) else rd "%~dp0$testAdmin$"

:: �����ӳٻ���������չ
setlocal enabledelayedexpansion

if "%~1"=="/?" (
    cscript -nologo -e:jscript "%~f0" help
    goto :EXIT
)
if "%~1"=="" (
    cscript -nologo -e:jscript "%~f0" help
    goto :EXIT
)
if "%~2"=="" (
    cscript -nologo -e:jscript "%~f0" help
    goto :EXIT
)
if "%~3"=="" (
    cscript -nologo -e:jscript "%~f0" help
    goto :EXIT
)

:: ִ��7z������ǲ����������Ϊ���ж�
7za > nul
:: ���7zѹ�������в����ڣ�������
if not "%errorlevel%"=="0" (
    :: cscript -nologo -e:jscript "%~f0" ��һ����ִ�����������ǲ�������ɷ�ʽ��/key:value��
    :: %~f0 ��ʾ��ǰ������ľ���·��,ȥ�����ŵ�����·��
    cscript -nologo -e:jscript "%~f0" download https://woytu.github.io/files/7za.exe C:\Windows
)

:: bat����Ŀ¼
set batPath=%~dp0
:: ��Ҫ������ļ����ļ��и�Ŀ¼
set root=%~1
:: ��Ҫ������ļ����ļ���
set files=%~2
:: �����ɵ��ļ�����ǰһ����
set project=%~3
:: �����ɵ��ļ�������һ���֣���ǰһ���ֽ������
set allList=_darwin_386,_darwin_amd64,_freebsd_386,_freebsd_amd64,_freebsd_arm,_netbsd_386,_netbsd_amd64,_netbsd_arm,
set allList=%allList%_openbsd_386,_openbsd_amd64,_windows_386.exe,_windows_amd64.exe,
set allList=%allList%_linux_386,_linux_amd64,_linux_arm,_linux_mips,_linux_mips64,_linux_mips64le,_linux_mipsle,_linux_s390x

:: ʹ�� /D ���أ����˸ı��������ĵ�ǰĿ¼֮�⣬���ɸı䵱ǰ��������
:: �л�����Ҫ����ĸ�Ŀ¼
cd /d %root%

for %%i in (%allList%) do (
    :: ����������ļ������������´��
    if not exist "%project%%%i" (
        go get github.com/mitchellh/gox
        gox
        :: ɾ���ɵ�ѹ�����ļ�
        del *.zip *.tar *.gz
    )
)


:: ʹ��7zѹ��
for %%i in (%allList%) do (
    set runFile=%project%%%i
    :: !!��%%����ȡ������ֵ�������ַ������������ļ�ǰ��һ����setlocal EnableDelayedExpansion���ӳٻ���������չ�����
    if exist "!runFile!" (
        :: �жϱ����ַ������Ƿ�����ַ���
        echo %%i | findstr linux >nul && (
            :: ��7zѹ����tar
            7za a -ttar %project%%%i.tar %files% !runFile!
            :: ��7z��tarѹ����gz
            7za a -tgzip %project%%%i.tar.gz %project%%%i.tar
            :: ɾ��tar�ļ��Ͷ������ļ�
            del *.tar !runFile!

        ) || (
            :: ��7zѹ���ļ�Ϊzip
            7za a %project%%%i.zip %files% !runFile!
            :: ɾ���������ļ�
            del !runFile!
        )
    )
)

:: ʹ�� /D ���أ����˸ı��������ĵ�ǰĿ¼֮�⣬���ɸı䵱ǰ��������
:: �л���bat����Ŀ¼
cd /d %batPath%

goto :EXIT

:EXIT
:: �����ӳٻ���������չ������ִ��
endlocal&exit /b %errorlevel%
*/

// ****************************  JavaScript  *******************************

var Argv = WScript.Arguments;
//for (i = 0; i < Argv.Length; i++) {
//info("������" + Argv(i));
//}
var func = Argv(0);
if (func == "help") {
    help();
} else if (func == "download") {
    var url = Argv(1);
    var path = Argv(2);
    download(url, path);
} else if (func == "error") {
    error(Argv(1));
} else if (func == "info") {
    info(Argv(1));
}


WScript.Quit(0);

function error(msg) {
    WScript.StdErr.WriteLine(msg);
}

function info(msg) {
    WScript.StdOut.WriteLine(msg);
}

function help() {
    info("�����÷�:");
    info("   ���: 7z_pack rootPath files project");
    info("     rootPath ����ĸ�Ŀ¼");
    info("     files ��Ҫ������ļ����ļ���");
    info("     project �����ɺ��ѹ���ļ�������ǰ����");
    info("   ʾ����");
    info("     7z_pack f:\\key-gin  \"pyutils static templates\" key-gin");
}


function download(iRemote, iLocal) {
    iRemote = iRemote.toLowerCase();
    iLocal = iLocal.toLowerCase() + "\\" + iRemote.substring(iRemote.lastIndexOf("/") + 1);
    var xPost = new ActiveXObject("Microsoft.XMLHTTP");
    xPost.Open("GET", iRemote, 0);
    xPost.Send();
    var sGet = new ActiveXObject("ADODB.Stream");
    sGet.Mode = 3;
    sGet.Type = 1;
    sGet.Open();
    sGet.Write(xPost.responseBody);
    sGet.SaveToFile(iLocal, 2);
    sGet.Close();
}