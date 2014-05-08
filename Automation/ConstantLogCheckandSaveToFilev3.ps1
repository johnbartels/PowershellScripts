$SummaryFile = "C:\Users\John\Desktop\johnseventlog.txt"
$Receiver = "jdbartels@bsu.edu"
$Subject = "Summary Event Log Script"
$EventLogPollingInterval = 60

function SendEmail([string]$Bodyinput)
{
	$outlook = new-object -com Outlook.Application -ErrorAction Stop
	$session = $outlook.Session
	$session.Logon()
	$mail = $outlook.CreateItem(“olMailItem”)
	$mail.To = $Receiver
	$mail.Subject = $Subject
	$mail.body = $Bodyinput
	$mail.send()
}

function GetIndexValuesFromFile()
{
	#This function gets all Indexes from the Summary log File and returns them
	#in the form of an array of strings
	
	#The line below looks in a file for strings in the Summary File that match the specified 
	#pattern. These matches are passed into variable a
	$a = Select-String $SummaryFile -pattern "Index" -ErrorAction SilentlyContinue
	#Empty Array List
	$ArrayList = @()
	
	for($num = 0;$num -lt $a.Count;$num++)
	{
		#next line is commented out -- prints full object
		#$a[$num]
		#Temporary Variable set equal to child property Line of Previous Matches
		$tempvar = $a[$num].Line
		$len = $tempvar.Length - 7
		#Substring that produces only the Index VALUE for the given Line
		$subtemp = $tempvar.Substring($tempvar.Length - $len, $len)
		#next line is commented out -- prints substring or Index VALUE
		#$subtemp
		#adds substring that is the Index VALUE to the Array Created Prior
		$ArrayList += $subtemp
	}
	#Return the Array List after all the substrings have been added to the array
	return $ArrayList
}
function WriteToFile([string]$Entry)
{
	#This function appends the inputted string to the file specified with the out-file command
	#variable set equal to inputted string and extra line (this is important for future parsing)
	$c = $Entry + "`n"
	#Appends the c variable to the Summary File
	Out-File -FilePath $SummaryFile -Append -InputObject $c
}
function CompareValues([string]$inputString)
{
	#This function will compare the inputString(an Index VALUE) to each Index VALUE in the Summary Log File
	
	#Variable set equal to function that returns all Index VALUES from Summary Log File
	$tempor = GetIndexValuesFromFile
	#Foreach loop that traverses each item in tempor variable which contains all the 
	#Index VALUES from the Summary Log File
	foreach($item in $tempor)
	{
		#if any item in the tempor array is equal to the inputted string, return true
		if($item -eq $inputString)
		{
			#True Value returned because match was found
			return "True"
		}
	}
}
function GetRecentLogEvents([string]$SourceName, [string]$LogName)
{
	#This function will return all of the recent log events (Warnings & Errors Currently) for the specified
	#Log/Source/EntryType/Date
	$a = Get-Eventlog $LogName -Newest 1000 | Where-Object {$_.Source -eq "$SourceName"} | where {$_.entryType -eq "Warning" -or $_.entryType -eq "Error"} 
	#| Where-Object {($_.TimeWritten).Date -eq (Get-Date).Date} 
	return $a
}

"Press Ctrl + Q to Exit the Script..."
$Qkey = 81
For(;;)
{
	#For loop that will check for a key Press (Ctrl + Q)
	#The exit does not happen immediately but allows for a graceful exit
	#this allows for a log to be written to at the end of the script
	#log might tell how long script ran for... etc.
	
	#variable set equal to the recent log events for the Source SideBySide
	#GetRecentLogEvents first param is the Source (Service Name) of the Event Entry
	#param2 is the Windows Log Name that is Searched through for the Source
	$RecentLogEvents = GetRecentLogEvents "Bonjour Service" "Application"
	
	#check to determine whether or not the previous variable is null or not
	#If the variable is null, there are no recent log events
	if($RecentLogEvents -eq $null)
	{
		#This following line clears the console screen to avoid excessive output to the console
		Clear-Host
		"There are currently no Application Log entries for the specified Service/Date/EntryType"
		#optional part here to send e-mail because event log was written to, but nothing to do with specified service
		#this would simply describe that the script is working as expected but there are no log entries
	}
	else
	{
		#This following line clears the console screen to avoid excessive output to the console
		clear-host
		"There are log entries"
		#Count the Log Entries
		$RecentLogEvents.Count
		#Look at each Recent Log Event & Compare the Event to events that already exist
		#in the summary file
		for($int = 0;$int -lt $RecentLogEvents.Count;$int++)
		{
			#Variable set equal to the return value of the CompareValues function
			$test = CompareValues $RecentLogEvents[$int].Index
			#Look at the previous variable and if true the entry already exists
			if($test -eq "True")
			{	
				#Print message to screen as to why the entry was not inputted into the file
				#This line could be commented out to avoid excessive output to the console...
				"The Log Entry Index: " + $RecentLogEvents[$int].Index + " Already Exists in the File"
			}
			else
			{
				#Print message to screen as to why the entry needs to be inputted into the file
				"The Log Entry Index: " + $RecentLogEvents[$int].Index + " Does NOT Yet Exist And Is Being Written To The Summary File"
				#Write the Index of the Event Log Entry to the Summary Text File
				$aa = "Index: " + $RecentLogEvents[$int].Index
				WriteToFile $aa
				#Write the Time of the Event Log Entry to the Summary Text File
				$ab = "Time: " + $RecentLogEvents[$int].TimeWritten
				WriteToFile $ab
				#Write the Entry Type of the Event Log Entry to the Summary Text File
				$ac = "Entry Type: " + $RecentLogEvents[$int].EntryType
				WriteToFile $ac
				#Write the Source of the Event Log Entry to the Summary Text File
				$ad = "Source: " + $RecentLogEvents[$int].Source
				WriteToFile $ad
				#Write the InstanceID of the Event Log Entry to the Summary Text File
				$ae = "InstanceID: " + $RecentLogEvents[$int].InstanceID
				WriteToFile $ae
				#Write the Message of the Event Log Entry to the Summary Text File
				$af = "Message: " + $RecentLogEvents[$int].Message
				WriteToFile $af
				WriteToFile "`n"
				
				$b = "Index: " + $RecentLogEvents[$int].Index + "`n" + " Time: " + $RecentLogEvents[$int].TimeWritten + "`n" + " Entry Type: " + $RecentLogEvents[$int].EntryType + "`n" + " Source: " + $RecentLogEvents[$int].Source + "`n" + " InstanceID: " + $RecentLogEvents[$int].InstanceID + "`n" + " Message: " + $RecentLogEvents[$int].Message
				
				#Send an Email to the Recipients Specified in the Beginning of the Script
				#SendEmail $b
			}
	
		}
		
	}
	
	#This allows the user to press Ctrl + Q to end the script which allows for 
	#a log file to be written to if one wishes to do so
    if ($host.ui.RawUi.KeyAvailable)
    { 
    	$key = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp") 
	   
        if (($key.VirtualKeyCode -eq $Qkey) -AND ($key.ControlKeyState -match "LeftCtrlPressed"))
        { 
         Write-Host ""
          Write-Host "You pressed the key Ctrl+q; Script Stopped."
          break
        }
    }
	#wait for sixty seconds before checking the event logs again
    sleep $EventLogPollingInterval
}