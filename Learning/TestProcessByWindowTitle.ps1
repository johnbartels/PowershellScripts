function Test-ProcessByWindowTitle([string]$WindowName)
{
	$a=Get-Process |where {$_.mainWindowTItle -eq $WindowName} |format-table id,name,mainwindowtitle –AutoSize

	if($a -eq $null)
	{
		"The Process is not running"
	}
	else
	{
		"The Process is running"
	}

}
$b = "Untitled - Notepad"
Test-ProcessByWindowTitle $b
