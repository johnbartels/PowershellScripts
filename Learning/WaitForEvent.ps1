$alarm = New-Object Management.EventQuery

$alarm.QueryString = "Select * from __InstanceCreationEvent WITHIN 1 WHERE targetinstance isa 'Win32_Process' AND targetinstance.name = 'notepad.exe'"
$watch = New-Object Management.ManagementEventWatcher $alarm
$result = $watch.WaitForNextEvent()
$result.GetText
if($result -eq $null)
{
	"You did not yet open notepad"
}
else
{
	"You Opened Notepad!"
}
#$result.targetinstance
#$path = $result.targetinstance.__path
#$live = [wmi]$path

$a = Get-Process | Where-Object {$_.Name -eq "Notepad"}
$a
$a.Name
$a.MainWindowTitle