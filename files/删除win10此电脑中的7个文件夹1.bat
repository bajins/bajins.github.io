@echo off

cacls.exe "%SystemDrive%\System Volume Information" >nul 2>nul

if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs" /f
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"

echo ɾ���ҵĵ���"��Ƶ"�ļ���
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f

echo ɾ���ҵĵ���"�ĵ�"�ļ���
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f

echo ɾ���ҵĵ���"����"�ļ���
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f

echo ɾ���ҵĵ���"����"�ļ���
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f

echo ɾ���ҵĵ���"����"�ļ���
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f

echo ɾ���ҵĵ���"ͼƬ"�ļ���
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f

echo ɾ���ҵĵ���"3D����"�ļ���
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f


exit