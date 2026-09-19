<# ::
@powershell -WindowStyle Hidden -ExecutionPolicy Bypass -<%~f0 &goto:eof
#>
# 保存到bat文件中可以双击执行，从这里开始是Power Shell代码

<# 选择文件夹弹窗 #>
function Select-FolderDialog {
    # https://docs.microsoft.com/zh-cn/dotnet/api/system.environment.specialfolder
    param([string]$Directory = [System.Environment+SpecialFolder]::Desktop,
        [string]$Description, [boolean]$ShowNewFolderButton)
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
    $objForm.RootFolder = $Directory
    $objForm.Description = $Description
    # $objForm.SelectedPath = ""
    $objForm.ShowNewFolderButton = $ShowNewFolderButton
    if ($objForm.ShowDialog() -eq "OK") {
        return $objForm.SelectedPath
    }
    else {
        # 输出错误信息
        Write-Error "error information here"
    }
}

Select-FolderDialog

<# 选择文件弹窗 #>
function Select-OpenFileDialog {
    param([string]$Title = '选择文件', [string]$Filter = 'All|*.*|PowerShell|*.ps1|Executable files (*.exe)|*.exe')
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog;
    $OpenFileDialog.Title = $Title
    $OpenFileDialog.Filter = $Filter
    if ($OpenFileDialog.ShowDialog() -eq $true) {
        return $OpenFileDialog.FileName;
    }
    else {
        # Out-Null
        Write-Warning 'Cancelled'
    }
}
Select-OpenFileDialog

# $currentDirectory = Split-Path -Parent $PSCommandPath; 
# $isConverterInCurrentDirectory = Test-Path $($currentDirectory + "\test.exe")

<# VBScript弹窗 #>
function Read-MessageBoxDialog {
    $PopUpWin = new-object -comobject wscript.shell
    $PopUpWin.popup("Hello World")
}

Read-MessageBoxDialog

<# VB弹窗 #>
function Read-MessageBoxDialog {

    param ([string]$Message, [string]$WindowTitle)

    Add-Type -AssemblyName Microsoft.VisualBasic

    return [Microsoft.VisualBasic.Interaction]::MsgBox($Message, 'Information', $WindowTitle)

}

Read-MessageBoxDialog -Message "Hello World" -WindowTitle "CustomTitleHere"

<# WPF弹窗 #>
function Read-MessageBoxDialog {

    param ([string]$Message, [string]$WindowTitle,
        [System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]$Icon = [System.Windows.Forms.MessageBoxIcon]::None)

    Add-Type -AssemblyName System.Windows.Forms

    return [System.Windows.Forms.MessageBox]::Show($Message, $WindowTitle, $Buttons, $Icon)

}
Read-MessageBoxDialog -Message "Hello World" -WindowTitle "CustomTitleHere" -Buttons OK -Icon Information
Read-MessageBoxDialog -Message "Hello World" -WindowTitle "CustomTitleHere" -Buttons OKCancel -Icon Information


<# 下载安装7z #>
function Install-7z {
    $response = Invoke-WebRequest -Uri https://www.7-zip.org/download.html
    # 获取文件名
    $match = $response.Content | Select-String -Pattern '<A href="(?<url>a\/7z\d+-x64\.msi)">Download<\/A>'
    # 拼接下载url
    $url = "https://www.7-zip.org/" + $match.Matches[0].Groups['url'].Value
    # 请求下载
    Invoke-WebRequest -Uri $url -OutFile 7zip.msi
    # 使用msiexec解压msi到7zip目录
    $process = Start-Process msiexec -ArgumentList "/a 7zip.msi /qn TARGETDIR=`"$(Get-Location)\7zip`"" -PassThru
    Wait-Process -Id $process.id
    Move-Item 7zip/Files/7-Zip/7z.exe 7z.exe -Force
    Move-Item 7zip/Files/7-Zip/7z.dll 7z.dll -Force
    Remove-Item –path 7zip –Recurse
    Remove-Item –path 7zip.msi
}