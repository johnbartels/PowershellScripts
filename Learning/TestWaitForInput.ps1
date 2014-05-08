$input = ""

function WaitForInput()
{
	$input = Read-Host -Prompt "Press Q to quit..."
}

do
{
	WaitForInput
	$a = Get-Eventlog "Application" -Newest 1000 | Where-Object {$_.Source -eq "Bonjour Service"} | Where-Object {($_.TimeWritten).Date -eq (Get-Date).Date} | where {$_.entryType -eq "Warning" -or $_.entryType -eq "Error"}
}
while($input -ne "Q")