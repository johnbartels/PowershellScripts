#$dec = 0
#$arr[$dec] 
function GetIndexValuesFromFile()
{
	$a = Select-String C:\users\john\desktop\johnseventlog.txt -pattern "Index"
	$ArrayList = @()
	
	for($num = 0;$num -lt $a.Count;$num++)
	{
		#next line is commented out -- prints full object
		#$a[$num]
		$tempvar = $a[$num].Line
		$subtemp = $tempvar.Substring($tempvar.Length - 5, 5)
		#$subtemp
		$ArrayList += $subtemp
		
	}
	
	return $ArrayList
	
}

function SendEmail([string]$EmailBody)
{
	$outlook = new-object -com Outlook.Application
	$session = $outlook.Session
	$session.Logon()
	$mail = $outlook.CreateItem(“olMailItem”)
	$mail.To = “jdbartels@bsu.edu”
	$mail.Subject = “Powershell and Outlook”
	$mail.body = $EmailBody
	$mail.send()
}
function WriteToFile([string]$Entry)
{
	$c = $Entry + "`n"
	Out-File -FilePath "C:\Users\John\Desktop\johnseventlog.txt" -Append -InputObject $c
}
function WaitForInput()
{
	$input = Read-Host
	return $input
}
function CompareValues([string]$inputString)
{
	$tempor = GetIndexValuesFromFile
	foreach($item in $tempor)
	{
		if($item -eq $inputString)
		{
			return "True"
		}
	}
}
#"Press Q to quit..."
#do
#{
#	$UserInput = WaitForInput
#	$a = Get-Eventlog "Application" -Newest 1000 | Where-Object {$_.Source -eq "Bonjour Service"} | Where-Object {($_.TimeWritten).Date -eq (Get-Date).Date} | where {$_.entryType -eq "Warning" -or $_.entryType -eq "Error"}
#	$a
#	sleep -Milliseconds 500
#}
#while($UserInput -ne "Q")

$a = Get-Eventlog "Application" -Newest 1000 | Where-Object {$_.Source -eq "Bonjour Service"} | Where-Object {($_.TimeWritten).Date -eq (Get-Date).Date} | where {$_.entryType -eq "Warning" -or $_.entryType -eq "Error"}

#| where {$_.entryType -match "Error"}

if($a -eq $null)
{
	"There are currently no Application Log entries for the specified Service/Date/EntryType"
	#optional part here to send e-mail because event log was written to, but nothing to do with specified service
	
}
else
{
	"There are log entries"
	$a.Count
	$b = GetIndexValuesFromFile
	#print the log entries to the file specified in the writetofile function
	for($int = 0;$int -lt $a.Count;$int++)
	{
		$test = CompareValues $a[$int].Index
		if($test -eq "True")
		{		
			"This Already Exists in the File"
		}
		
		else
		{
			"The Event Needs to be written to the log because it does not yet exist"
			$aa = "Index: " + $a[$int].Index
			WriteToFile $aa
			#
			$ab = "Time: " + $a[$int].TimeWritten
			WriteToFile $ab
			#
			$ac = "Entry Type: " + $a[$int].EntryType
			WriteToFile $ac
			#
			$ad = "Source: " + $a[$int].Source
			WriteToFile $ad
			#
			$ae = "InstanceID: " + $a[$int].InstanceID
			WriteToFile $ae
			#
			$af = "Message: " + $a[$int].Message
			WriteToFile $af
			WriteToFile "`n"
		}
	
	}
	
	
		#

		#sleep 100
		#$b = "Index: " + $a[$int].Index + "`n" + " Time: " + $a[$int].TimeWritten + "`n" + " Entry Type: " + $a[$int].EntryType + "`n" + " Source: " + $a[$int].Source + "`n" + " InstanceID: " + $a[$int].InstanceID + "`n" + " Message: " + $a[$int].Message
		#$b
		#WriteToFile $b
		#SendEmail $b
}