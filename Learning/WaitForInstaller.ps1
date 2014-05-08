#Test-WSMan -ApplicationName "npp.5.9.3.Installer"
#This doesn't work at all

function ActivateWindow([string]$WindowName)
{
	[void] [System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
	[Microsoft.VisualBasic.Interaction]::AppActivate("$WindowName")
	$string = $WindowName + "Activated"
	Write-EventLog -EventId 1001 -LogName TestLog -Message $string -Source "WaitForInstaller.ps1"
}

function Test-WindowExists([string]$WindowName)
{
	#This function requires for the WASP plugin to be added previously to the 
	#Powershell environment from which it is ran
	$a = Select-Window -Title $WindowName
	if($a -eq $null)
	{
		#"The Window is not Open"
		return 0
	}
	else
	{
		#"The Window is Open"
		return 1
	}
}

function Test-ProcessExists([string]$ProcessName)
{
	$b=Get-Process $ProcessName -ErrorAction SilentlyContinue
	if ($b -eq $null)
	{
   		#"The Program Is NOT Running"
		return 0
	}
	else
	{
		#"The Program Is running"
		return 1
	}
}

function Test-ProcessByWindowTitle([string]$WindowName)
{
	$a=Get-Process |where {$_.mainWindowTItle -eq $WindowName} |format-table id,name,mainwindowtitle –AutoSize

	if($a -eq $null)
	{
		#"The Process is not running"
		return 0
	}
	else
	{
		#"The Process is running"
		return 1
	}

}
#$b = "Untitled - Notepad"
#Test-ProcessByWindowTitle $b

#Start of script
do
{
	$c=Test-ProcessExists npp.5.9.3.Installer
	#$c
}

while($c -eq 0)

#$c
#"This Should Not Be Seen Until After the 1"

if (test-path "C:\Program Files\Notepad++\notepad++.exe")
{
"The Program has already been installed..."
break
}
else
{

#Start-Process "C:\Users\John\Desktop\Scripts\npp.5.9.3.Installer.exe"

do
{
	$e=Test-ProcessByWindowTitle "Installer Language"
	#$e
	#$d=Test-WindowExists "Installer Language"
	
	#$d
}
while($e -eq 0)
#$d
#sleep 5
#"We Should See This After D turns to 1"

#[void] [System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
#[Microsoft.VisualBasic.Interaction]::AppActivate("Installer Language")

sleep 3

#
ActivateWindow "Installer Language"
sleep 1
[void] [System.Reflection.Assembly]::LoadWithPartialName("'System.Windows.Forms")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1

do
{
	$f=Test-ProcessByWindowTitle "Notepad++ v5.9.3 Setup"
	#$f
	
}
while($f -eq 0)

sleep 10

ActivateWindow "Notepad++ v5.9.3 Setup"
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1

ActivateWindow "Notepad++ v5.9.3 Setup"
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1

ActivateWindow "Notepad++ v5.9.3 Setup"
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1

ActivateWindow "Notepad++ v5.9.3 Setup"
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1

ActivateWindow "Notepad++ v5.9.3 Setup"
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 4

ActivateWindow "Notepad++ v5.9.3 Setup"
[System.Windows.Forms.SendKeys]::SendWait(" ")
sleep 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

}