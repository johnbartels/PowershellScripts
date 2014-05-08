[void] [Reflection.Assembly]::Load('UIAutomationClient, ' + 'Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35')
[void] [Reflection.Assembly]::Load('UIAutomationTypes, ' + 'Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35')


#shows all Custom Profile Functions
function Show-Custom-Functions
{
    # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    write-host "** Custom Variables and Functions **".padright(50) -back black -fore yellow
    write-host "Category		Type	   Name              		Alias 		Description".padright(50) -back yellow -fore black
    write-host "Miscellaneous	Function  Get-CmdletAlias 			gca			Returns all aliases for the Specified Cmdlet".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  Show-Custom-Functions   	scf			Returns all Custom Functions In Profile".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  Get-Current-Directory   	gcd			Returns the Current Working Directory".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  Get-CHM               	gchm		Opens Windows Powershell Help".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  Open-Profile 		       	pro			Opens the Users Powershell Profile in Notepad".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  Split-Envpath 			epath		Splits the Current EnvPath Var and Returns the List".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  Get-LocalDisk		   		gld			Returns Disk Information for the Localhost".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  Get-RemoteDiskInfo	   	grdi		Returns Disk Information for the Remote Host".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  CountDown		   			cntd		Displays a CountDown Timer".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  HelloWorldCSharp			hwcs		Prints 'Hello World!' to Console using CSharp Code".padright(50) -back black -fore yellow
    write-host "Miscellaneous	Function  Get-HyperV_VM_Info		getvminf	Gets IP address, OS Version, etc. for VM".padright(50) -back black -fore yellow
    write-host "System			Function  reboot					rbt			Reboots the Specified Server".padright(50) -back black -fore yellow
    write-host "System			Function  Wait-ProcessCreationEvent	wpce		Waits for Specified Process to Start".padright(50) -back black -fore yellow
    write-host "System			Function  Create-ShortcutWithArgs	cshrt		Creates the Shortcut with Specified Args".padright(50) -back black -fore yellow
    write-host "System			Function  changeServiceStartMode	chgsvcsm	Changes Service StartMode to Value Specified".padright(50) -back black -fore yellow
    write-host "System			Function  stopService				stpsvc		Stops the Specified Service".padright(50) -back black -fore yellow
    write-host "System			Function  startService				strtsvc		Starts the Specified Service".padright(50) -back black -fore yellow
    write-host "System			Function  pauseService				psesvc		Pauses the Specified Service".padright(50) -back black -fore yellow
    write-host "System			Function  resumeService				rsmsvc		Resumes the Specified Service".padright(50) -back black -fore yellow  
    write-host "Automation		Function  Send-KeyStroke			sndk		Sends the Specified Keystroke".padright(50) -back black -fore yellow
    write-host "Automation		Function  Activate-Window			actw		Activates the Specified Window".padright(50) -back black -fore yellow
    write-host "Automation		Function  Set-WindowLocationCSharp	swlcs		Sets the Window to the Position Specified".padright(50) -back black -fore yellow
    write-host "Automation		Function  Set-WindowSizeCSharp		swscs		Sets the Window to the Size Specified".padright(50) -back black -fore yellow
    write-host "Automation		Function  Set-CursorPosition		scp			Sets Cursor Location To Specified Coordinates".padright(50) -back black -fore yellow
    write-host "Automation		Function  Click-MouseButton			cmb			Simulates Click of the Specified Mouse Button".padright(50) -back black -fore yellow
    write-host ""
    # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}
new-item -path alias:scf -value Show-Custom-Functions |out-null


function Check-AliasExists($aliasCheck)
{
    if((get-alias $aliasCheck -errorAction SilentlyContinue) -eq $null)
    {
	return $false 
    }
    else
    {
	return $true
    }
}



function View-AvailableModules
{
    get-module -listavailable
}



function View-CommandsForModule($module)
{
    get-command -module $module
}



function View-AvailableSnapins
{
    Get-PSSnapin
}


function View-CommandsForSnapin($snapin)
{
    get-command -pssnapin $snapin
}




function Activate-Window
{
    param(
    [string]$WindowName, 
    [switch]$help)
    $HelpInfo = @'

    Function : Activate-Window
    By       : John Bartels
    Date     : 12/16/2012 
    Purpose  : Brings Focus to the Specified Window
    Usage    : Activate-Window [-Help][-WindowName x]
               where      
                      -Help       	displays this help
                      -WindowName	specify the Window Title of the Window you Wish to Activate
                      
'@ 


    if ($help -or (!$WindowName))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        #Param ([string] $WindowName)
        [void] [System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
        [Microsoft.VisualBasic.Interaction]::AppActivate("$WindowName")
        #$string = $WindowName + "Activated"
    }

    
}
new-item -path alias:actw -value Activate-Window |out-null



function Get-HyperV_VM_Info
{
    param(
    [string]$HyperVHost,
    [string]$VM_Name, 
    [switch]$help)
    $HelpInfo = @'

    Function : Get-HyperV_VM_Info
    By       : John Bartels
    Date     : 12/16/2012 
    Purpose  : Gets IP Address and other information about Virtual Machine
    Usage    : Get-HyperV_VM_Info [-Help][-HyperVHost x][-VM_Name x]
               where      
                      -Help       	Displays this help
                      -HyperVHost	Specify the Host on which the VM Resides
                      -VM_Name      	Specify the Name of the VM
                      
'@ 


    if ($help -or (!$HyperVHost -and !$VM_Name))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        $namespc = "root\virtualization"
        $quer = "Select * From Msvm_ComputerSystem Where ElementName='" + $VM_Name + "'"
 
        $VmObj = gwmi -Namespace $namespc -ComputerName $HyperVHost -Query $quer
        $KvpObj = gwmi -Namespace $namespc -ComputerName $HyperVHost -Query "Associators of {$VmObj} Where AssocClass=Msvm_SystemDevice ResultClass=Msvm_KvpExchangeComponent"
 

        $KvpObj.GuestIntrinsicExchangeItems | Import-CimXml
    }

}

filter Import-CimXml
{
    $CimXml = [Xml]$_
    $CimObj = New-Object -TypeName System.Object
    foreach ($CimProperty in $CimXml.SelectNodes("/INSTANCE/PROPERTY"))
    {
        if ($CimProperty.Name -eq "Name" -or $CimProperty.Name -eq "Data")
        {
            $CimObj | Add-Member -MemberType NoteProperty -Name $CimProperty.NAME -Value $CimProperty.VALUE
        }
    }
    $CimObj
}

new-item -path alias:getvminf -value Get-HyperV_VM_Info |out-null




function Set-CursorPosition
{
    param(
    [int]$XCoord,
    [int]$YCoord, 
    [switch]$help)
    $HelpInfo = @'

    Function : Set-CursorPosition
    By       : John Bartels
    Date     : 12/17/2012 
    Purpose  : Sets the Cursors position to the X and Y Coordinates specified
    Usage    : Set-CursorPosition [-Help][-XCoord n][-YCoord n]
               where      
                      -Help       	displays this help
                      -XCoord		The X Coordinate for the point where you want to move the mouse
		      -YCoord		The Y Coordinate for the point where you want to move the mouse 
                      
'@ 
    #write-Host $help
    #write-Host $XCoord
    #write-Host $YCoord
    if (($help -eq "help") -or ($help -eq "Help") -or ($help -eq "/?") -or (!$XCoord -and !$YCoord))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($XCoord,$YCoord)
    }
    
}
new-item -path alias:scp -value Set-CursorPosition |out-null


function Click-MouseButton
{
    param(
    [string]$Button, 
    [switch]$help)
    $HelpInfo = @'

    Function : Click-MouseButton
    By       : John Bartels
    Date     : 12/16/2012 
    Purpose  : Brings Focus to the Specified Window
    Usage    : Activate-Window [-Help][-WindowName x]
               where      
                      -Help       	displays this help
                      -Button		specify the Button You Wish to Click {left, middle, right}
                      
'@ 
    #write-Host $Button

    if ($help -or (!$Button))
    {
        write-host $HelpInfo
        return
    }
    else
    {
	#write-Host "Where we want to be..."
        $signature=@' 
          [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
          public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@ 

        # call Add-Type to compile code 
        $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru 
        if($Button -eq "left")
		{
			#"We Made it to left portion of logic"
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
            $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
		}
		if($Button -eq "right")
		{
			$SendMouseClick::mouse_event(0x00000008, 0, 0, 0, 0);
            $SendMouseClick::mouse_event(0x00000010, 0, 0, 0, 0);
		}
		if($Button -eq "middle")
		{
			$SendMouseClick::mouse_event(0x00000020, 0, 0, 0, 0);
            $SendMouseClick::mouse_event(0x00000040, 0, 0, 0, 0);
		}
        
    }

    
}
new-item -path alias:cmb -value Click-MouseButton |out-null


function WriteToEventLog
{
    param(
    [int]$EventId,
    [string]$LogName, 
    [string]$Message,
    [string]$Source,
    [switch]$help)
    $HelpInfo = @'

    Function : WriteToEventLog
    By       : John Bartels
    Date     : 12/16/2012 
    Purpose  : Writes to an Event Log
    Usage    : WriteToEventLog [-Help][-EventId n][LogName x][-Message x][-Source x]
               where      
                      -Help       	displays this help
                      -EventId		Number used to help track Different Types of Errors (default=0)
		      -LogName		Name of the Log Where you Want to Store the Message
		      -Message		Contents of the Log Entry
		      -Source		The Process,Agent,Thread,Method that Caused the Error or Warning
                      
'@ 
    if ($help -or (!$EventId -and !$LogName -and !$Message -and !$Source))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        Write-EventLog -EventId $EventId -LogName $LogName -Message $Message -Source $Source
    }
    
}


function Send-KeyStroke
{
    Param ([string] $keysToSimulate)
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [System.Windows.Forms.SendKeys]::SendWait("$keysToSimulate")
}
new-item -path alias:sndk -value Send-Keystroke |out-null



function Wait-ProcessCreationEvent
{
    param(
    [string]$procName, 
    [switch]$help)
    $alarm = New-Object Management.EventQuery
    $HelpInfo = @'

    Function : Wait-ProcessCreationEvent
    By       : John Bartels
    Date     : 12/16/2012 
    Purpose  : Waits for the specified process to start
    Usage    : Wait-ProcessCreationEvent [-Help][-ProcessName x.exe]
               where      
                      -Help       	displays this help
                      -ProcessName	specify the ProcessName you wish to Wait for
                      
'@ 


    if ($help -or (!$procName))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        $alarm.QueryString = "Select * from __InstanceCreationEvent WITHIN 1 WHERE targetinstance isa 'Win32_Process' AND targetinstance.name = '$procName'"
        $watch = New-Object Management.ManagementEventWatcher $alarm
        $result = $watch.WaitForNextEvent()
        $result.GetText
        if($result -eq $null)
        {
	    "$procName Not Yet Opened"
        }
        else
        {
	    "$procName Opened"
        }
    }
    
}
new-item -path alias:wpce -value Wait-ProcessCreationEvent |out-null



#function will open the profile item in notepad
function Open-Profile 
{
    notepad $profile.CurrentUserAllHosts
}
new-item -path alias:pro -value Open-Profile |out-null




function Get-CHM
{
   (invoke-item $env:windir\help\mui\0409\WindowsPowerShellHelp.chm)
}
new-item -path alias:gchm -value Get-CHM |out-null




function Get-CmdletAlias ($cmdletname)
{
   get-alias | Where {$_.definition -like "*$cmdletname*"} | ft Definition, Name -auto
}
new-item -path alias:gca -value Get-CmdletAlias |out-null



function Split-Envpath 
{
    #display system path components in a human-readable format
    $p = @(get-content env:path|% {$_.split(";")})
    "Path"
    "===="
    foreach ($p1 in $p)
    {
        if ($p1.trim() -gt "")
        {
          $i+=1;
         "$i : $p1"
        }
    }
    ""
}
new-item -path alias:epath -value Split-Envpath |out-null




function Get-LocalDisk
{
  Param ([string] $hostname="localhost")
  #Quick Local Disk check
  "***************************************************************"
  "*** $hostname : Local Disk Info"
  Get-WmiObject `
    -computer $hostname `
    -query "SELECT * from Win32_LogicalDisk WHERE DriveType=3" `
    | format-table -autosize `
      DeviceId, `
      VolumeName, `
      @{Label="FreeSpace(GB)"; Alignment="right"; Expression={"{0:N2}" -f ($_.FreeSpace/1GB)}},`
      @{Label="Size(GB)"; Alignment="right"; Expression={"{0:N2}" -f ($_.size/1GB)}} `
    | out-default
}
#adds the alias for get-LocalDisk
new-item -path alias:gld -value Get-LocalDisk |out-null



function Get-RemoteDiskInfo
{
  Param ([string] $hostname)
  #Quick Remote Disk check
  "***************************************************************"
  "*** $hostname : Remote Disk Info"
  Get-WmiObject `
    -computer $hostname `
    -query "SELECT * from Win32_LogicalDisk WHERE DriveType=3" `
    | format-table -autosize `
      DeviceId, `
      VolumeName, `
      @{Label="FreeSpace(GB)"; Alignment="right"; Expression={"{0:N2}" -f ($_.FreeSpace/1GB)}},`
      @{Label="Size(GB)"; Alignment="right"; Expression={"{0:N2}" -f ($_.size/1GB)}} `
    | out-default
}
new-item -path alias:grdi -value Get-RemoteDiskInfo |out-null



#This function can be used to create a shortcut
Function Create-ShortcutWithArgs
{  
    param(
    [string]$SourceEXE, 
    [string]$Arguments, 
    [string]$DestinationPath,
    [switch]$help)
    $HelpInfo = @'

    Function : Create-ShortcutWithArgs
    By       : John Bartels
    Date     : 12/18/2012 
    Purpose  : Creates a Shortcut in the Specified Location to the Specified 
	       SourceEXE with the Specified Arguments
    Usage    : Countdown [-Help][-SourceEXE x][-Arguments x][-DestinationPath x]
               where      
                      -Help		displays this help
                      -SourceEXE	specify the Full Path of the program or file you wish to Create a Shortcut for
                      -Arguments	specify the arguments for the Shortcut 
                      -DestinationPath  specify the destination for the Shortcut
                      
'@  
    if ($help -or (!$SourceEXE -and !$Arguments -and !$DestinationPath))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($DestinationPath)
        $Shortcut.TargetPath = $SourceEXE
        $Shortcut.Arguments = $Arguments
  
        $Shortcut.Save()
    }
    
} #end function Create-Shortcut
new-item -path alias:cshrt -value Create-ShortcutWithArgs |out-null


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function CountDown() 
{
    param(
    [int]$hours=0, 
    [int]$minutes=0, 
    [int]$seconds=0,
    [switch]$help)
    $HelpInfo = @'

    Function : CountDown
    By       : xb90 at http://poshtips.com
    Date     : 02/22/2011 
    Purpose  : Pauses a script for the specified period of time and displays
               a count-down timer to indicate the time remaining.
    Usage    : Countdown [-Help][-hours n][-minutes n][seconds n]
               where      
                      -Help       displays this help
                      -Hours n    specify the number of hours (default=0)
                      -Minutes n  specify the number of minutes (default=0)
                      -Seconds n  specify the number of seconds (default=0)
                      
'@    
    if ($help -or (!$hours -and !$minutes -and !$seconds)){
        write-host $HelpInfo
        return
        }
    $startTime = get-date
    $endTime = $startTime.addHours($hours)
    $endTime = $endTime.addMinutes($minutes)
    $endTime = $endTime.addSeconds($seconds)
    $timeSpan = new-timespan $startTime $endTime
    write-host $([string]::format("`nScript paused for {0:#0}:{1:00}:{2:00}",$hours,$minutes,$seconds)) -backgroundcolor black -foregroundcolor yellow
    while ($timeSpan -gt 0) {
        $timeSpan = new-timespan $(get-date) $endTime
        write-host "`r".padright(40," ") -nonewline
        write-host "`r" -nonewline
        write-host $([string]::Format("`rTime Remaining: {0:d2}:{1:d2}:{2:d2}", `
            $timeSpan.hours, `
            $timeSpan.minutes, `
            $timeSpan.seconds)) `
            -nonewline -backgroundcolor black -foregroundcolor yellow
        sleep 1
        }
    write-host ""
}
new-item -path alias:cntd -value CountDown |out-null


#This function shows us how to execute CSharp code from powershell
function HelloWorldCSharp
{
    # HelloWorldCS - Demo of C# 
    Add-Type @' 
    using System; 
    using System.IO; 
    using System.Text; 
      
    public static class HelloCS
    { 
        public static void SayHello()
        { 
          Console.WriteLine("Hello World!"); 
        } 
    } 
'@ 
 
    [hellocs]::SayHello()
}
new-item -path alias:hwcs -value HelloWorldCSharp |out-null



function Set-WindowLocationCSharp
{
    param(
    [string]$WindowTitle="", 
    [int]$XCoord=0, 
    [int]$YCoord=0,
    [switch]$help)
    $HelpInfo = @'

    Function : SetWindowLocationCSharp
    By       : John Bartels
    Date     : 12/17/2012 
    Purpose  : Sets the Location to the X and Y Coordinates specified
    Usage    : Set-CursorPosition [-Help][-XCoord n][-YCoord n]
               where      
                      -Help       	displays this help
		      -WindowTitle	The Title of the Window you Wish to Manipulate
                      -XCoord		The X Coordinate for the Upper-Left Point of the Destination
		      -YCoord		The Y Coordinate for the Upper-Left Point of the Destination
                      
'@ 

    

    

    # HelloWorldCS - Demo of C# 
    Add-Type @' 
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Runtime.InteropServices;
      
    public static class WindowSteps
    {
        [DllImport("user32.dll", SetLastError = true)]
        internal static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        /// <summary> 
        /// Sets the Location of the Specified Window Title to the Specified Location. 
	/// </summary>
        /// <param name="windowTitle">The Window Title of the Window you Wish to Move.</param>
        /// <param name="XCoord">The X-Coord of the Upper-Left Point of the Destination.</param>
	/// <param name="YCoord">The Y-Coord of the Upper-Left Point of the Destination.</param>
        public static void SetWindowLocation(string windowTitle, int XCoord, int YCoord)
        {
            //const short SWP_NOMOVE = 0X2;
            //const short SWP_NOSIZE = 1;
            //const short SWP_NOZORDER = 0X4;
            //const int SWP_SHOWWINDOW = 0x0040;

            System.Diagnostics.Process[] plist = System.Diagnostics.Process.GetProcesses();
            System.Diagnostics.Process foundProcess = new System.Diagnostics.Process();
            IntPtr handle = new IntPtr();
            int height = 0;
            int width = 0;
            foreach (System.Diagnostics.Process x in plist)
            {
                if (x.MainWindowTitle == windowTitle)
                {
                    foundProcess = x;
                    handle = x.MainWindowHandle;
                    RECT pRect;
                    System.Drawing.Size wSize = new System.Drawing.Size();
                    GetWindowRect(handle, out pRect);
                    wSize.Width = pRect.Right - pRect.Left;
                    wSize.Height = pRect.Bottom - pRect.Top;
                    height = wSize.Height;
                    width = wSize.Width;
                    break;
                }
            }
            MoveWindow(handle, XCoord, YCoord, width, height, false);
            foundProcess.Refresh();
            foundProcess.Dispose();
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct RECT
        {
            public int Left;
            public int Top;
            public int Right;
            public int Bottom;
        } 
    } 
'@ -ReferencedAssemblies System.Drawing
 

    if (($help -eq "help") -or ($help -eq "Help") -or ($help -eq "/?") -or (!$XCoord -and !$YCoord))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        [WindowSteps]::SetWindowLocation($WindowTitle, $XCoord, $YCoord)
    }

}
new-item -path alias:swlcs -value Set-WindowLocationCSharp |out-null



function Set-WindowSizeCSharp
{
    param(
    [string]$WindowTitle="", 
    [int]$Width=0, 
    [int]$Height=0,
    [switch]$help)
    $HelpInfo = @'

    Function : SetWindowSizeCSharp
    By       : John Bartels
    Date     : 12/17/2012 
    Purpose  : Sets the Size of the Window to the specified width and height
    Usage    : SetWindowSizeCSharp [-Help][-WindowTitle x][-width n][-height n]
               where      
                      -Help       	displays this help
		      -WindowTitle	The Title of the Window you Wish to Manipulate
                      -Width		The Desired Width for the Window
		      -HSeight		The Desired Height for the Window
                      
'@ 

    # HelloWorldCS - Demo of C# 
    Add-Type @' 
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Runtime.InteropServices;
      
    public static class SetWindowSizeFunction
    {
        [DllImport("user32.dll", SetLastError = true)]
        internal static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        /// <summary> 
        /// Resizes the Window. 
		/// </summary>
        /// <param name="windowTitle">The Window Title of the Window you Wish to Move.</param>
        /// <param name="width">The Desired Width.</param>
		/// <param name="height">The Desired Height.</param>
        public static void SetWindowSize(string windowTitle, int width, int height)
        {
			System.Diagnostics.Process[] plist = System.Diagnostics.Process.GetProcesses();
            IntPtr handle = new IntPtr();
            int xLoc = 0;
            int yLoc = 0;
            int totalResX = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width;
            int totalResY = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height;
            foreach (System.Diagnostics.Process x in plist)
            {
                if (x.MainWindowTitle == windowTitle)
                {
                    handle = x.MainWindowHandle;
                    RECT pRect;
                    System.Drawing.Size wSize = new System.Drawing.Size();
                    GetWindowRect(handle, out pRect);
                    wSize.Width = pRect.Right - pRect.Left;
                    wSize.Height = pRect.Bottom = pRect.Top;
                    xLoc = pRect.Right - wSize.Width;
                    yLoc = pRect.Top;
                    break;
                }
            }
            try
            {
                MoveWindow(handle, xLoc, yLoc, width, height, true);
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
            }

            //foundProcess.Refresh();
            //foundProcess.Dispose();
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct RECT
        {
            public int Left;
            public int Top;
            public int Right;
            public int Bottom;
        } 
    } 
'@ -ReferencedAssemblies System.Drawing,System.Windows.Forms
 
    if ($help -or (!$Width -and !$Height))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        [SetWindowSizeFunction]::SetWindowSize($WindowTitle, $Width, $Height)
    }
	
}
new-item -path alias:swscs -value Set-WindowSizeCSharp |out-null




function changeServiceStartMode
{
    param(
    [string]$Service, 
    [string]$StartMode,
    [string]$Hostname=".",
    [switch]$help)
    $HelpInfo = @'

    Function : changeServiceStartMode
    By       : John Bartels
    Date     : 12/18/2012 
    Purpose  : Changes the Start Mode of the Specified Service to the Type Specified
    Usage    : changeServiceStartMode [-Help][-Service x][-StartMode x][-Hostname x]
               where      
                      -Help       	displays this help
                      -Service		The Service You Wish to Alter
		      -StartMode	The Desired StartMode for the Service (automatic,manual,disabled)
		      -Hostname		The Hostname the Service Resides On (Default = localhost)
                      
'@ 
  # HelloWorldCS - Demo of C# 
    Add-Type @' 
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Management;
      
    public static class ChgSvcStrtMode
    {

        public static void changeServiceStartMode(string serviceName, string startMode, string hostname)
        {
            try
            {
				//Console.WriteLine("Entering Try Block...");
                ManagementObject classInstance =
                            new ManagementObject(@"\\" + hostname + @"\root\cimv2",
                            "Win32_Service.Name='" + serviceName + "'",
                            null);
				
				//Console.WriteLine("Obtaining params for the Method...");
                // Obtain in-parameters for the method
                ManagementBaseObject inParams =
                    classInstance.GetMethodParameters("ChangeStartMode");
				
				//Console.WriteLine("Adding Input Parameters");
                // Add the input parameters.
                inParams["StartMode"] = startMode;

				//Console.WriteLine("Executing Method and Obtaining Return Values...");
                // Execute the method and obtain the return values.
                ManagementBaseObject outParams =
                    classInstance.InvokeMethod("ChangeStartMode", inParams, null);

				//Console.WriteLine("Listing Out Params:");
                // List outParams
                Console.WriteLine(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
				int check = int.Parse(outParams["ReturnValue"].ToString());
				if(check == 0)
				{
					Console.WriteLine("Success");
				}
				else if(check == 1)
				{
					Console.WriteLine("Not Supported");
				}
				else if(check == 2)
				{
					Console.WriteLine("Access Denied");
				}
				else if(check == 3)
				{
					Console.WriteLine("Dependent Services Running");
				}
				else if(check == 4)
				{
					Console.WriteLine("Innvalid Service Control");
				}
				else if(check == 5)
				{
					Console.WriteLine("Service Cannot Accept Control");
				}
				else if(check == 6)
				{
					Console.WriteLine("Service Not Active");
				}
				else if(check == 7)
				{
					Console.WriteLine("Service Request Timeout");
				}
				else if(check == 8)
				{
					Console.WriteLine("Unknown Failure");
				}
				else if(check == 9)
				{
					Console.WriteLine("Path Not Found");
				}
				else if(check == 10)
				{
					Console.WriteLine("Service Already Running");
				}
				else if(check == 11)
				{
					Console.WriteLine("Service Database Locked");
				}
				else if(check == 12)
				{
					Console.WriteLine("Service Dependency Deleted");
				}
				else if(check == 13)
				{
					Console.WriteLine("Service Dependency Failure");
				}
				else if(check == 14)
				{
					Console.WriteLine("Service Disabled");
				}
				else if(check == 15)
				{
					Console.WriteLine("Service Logon Failure");
				}
				else if(check == 16)
				{
					Console.WriteLine("Service Marked For Deletion");
				}
				else if(check == 17)
				{
					Console.WriteLine("Service No Thread");
				}
				else if(check == 18)
				{
					Console.WriteLine("Status Circular Dependency");
				}
				else if(check == 19)
				{
					Console.WriteLine("Status Duplicate Name");
				}
				else if(check == 20)
				{
					Console.WriteLine("Status Invalid Name");
				}
				else if(check == 21)
				{
					Console.WriteLine("Status Invalid Parameter");
				}
				else if(check == 22)
				{
					Console.WriteLine("Status Invalid Service Account");
				}
				else if(check == 23)
				{
					Console.WriteLine("Status Service Exists");
				}
				else if(check == 24)
				{
					Console.WriteLine("Service Already Paused");
				}
				
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
            }
            catch (ManagementException err)
            {
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": An error occurred: " + err.Message);
				Console.WriteLine(err.Message);
            }
        }
    } 
'@ -ReferencedAssemblies System.Management
 
    if ($help -or (!$Service -and !$StartMode))
    {
	#"Still Good..."
        write-host $HelpInfo
        return
    }
    else
    {
        [ChgSvcStrtMode]::changeServiceStartMode($Service, $StartMode, $Hostname)
    }
    
}
new-item -path alias:chgsvcsm -value changeServiceStartMode |out-null



function stopService
{
    param(
    [string]$Service, 
    [string]$Hostname=".",
    [switch]$help)
    $HelpInfo = @'

    Function : stopService
    By       : John Bartels
    Date     : 12/18/2012 
    Purpose  : Stops the Specified Service on the Specified Host
    Usage    : stopService[-Help][-Service x][-Hostname x]
               where      
                      -Help       	displays this help
                      -Service		The Service You Wish to Alter
		      -Hostname		The Hostname the Service Resides On (Default = localhost)
                      
'@
  # HelloWorldCS - Demo of C# 
    Add-Type @' 
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Management;
      
    public static class StopServiceCSharp
    {

        public static void stopService(string serviceName, string hostname)
        {
            try
            {
				//Console.WriteLine("Entering Try Block...");
                ManagementObject classInstance =
                            new ManagementObject(@"\\" + hostname + @"\root\cimv2",
                            "Win32_Service.Name='" + serviceName + "'",
                            null);

                // no method in-parameters to define


                // Execute the method and obtain the return values.
                ManagementBaseObject outParams =
                    classInstance.InvokeMethod("StopService", null, null);

				//Console.WriteLine("Listing Out Params:");
                // List outParams
                Console.WriteLine(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
				int check = int.Parse(outParams["ReturnValue"].ToString());
				if(check == 0)
				{
					Console.WriteLine("Success");
				}
				else if(check == 1)
				{
					Console.WriteLine("Not Supported");
				}
				else if(check == 2)
				{
					Console.WriteLine("Access Denied");
				}
				else if(check == 3)
				{
					Console.WriteLine("Dependent Services Running");
				}
				else if(check == 4)
				{
					Console.WriteLine("Innvalid Service Control");
				}
				else if(check == 5)
				{
					Console.WriteLine("Service Cannot Accept Control");
				}
				else if(check == 6)
				{
					Console.WriteLine("Service Not Active");
				}
				else if(check == 7)
				{
					Console.WriteLine("Service Request Timeout");
				}
				else if(check == 8)
				{
					Console.WriteLine("Unknown Failure");
				}
				else if(check == 9)
				{
					Console.WriteLine("Path Not Found");
				}
				else if(check == 10)
				{
					Console.WriteLine("Service Already Running");
				}
				else if(check == 11)
				{
					Console.WriteLine("Service Database Locked");
				}
				else if(check == 12)
				{
					Console.WriteLine("Service Dependency Deleted");
				}
				else if(check == 13)
				{
					Console.WriteLine("Service Dependency Failure");
				}
				else if(check == 14)
				{
					Console.WriteLine("Service Disabled");
				}
				else if(check == 15)
				{
					Console.WriteLine("Service Logon Failure");
				}
				else if(check == 16)
				{
					Console.WriteLine("Service Marked For Deletion");
				}
				else if(check == 17)
				{
					Console.WriteLine("Service No Thread");
				}
				else if(check == 18)
				{
					Console.WriteLine("Status Circular Dependency");
				}
				else if(check == 19)
				{
					Console.WriteLine("Status Duplicate Name");
				}
				else if(check == 20)
				{
					Console.WriteLine("Status Invalid Name");
				}
				else if(check == 21)
				{
					Console.WriteLine("Status Invalid Parameter");
				}
				else if(check == 22)
				{
					Console.WriteLine("Status Invalid Service Account");
				}
				else if(check == 23)
				{
					Console.WriteLine("Status Service Exists");
				}
				else if(check == 24)
				{
					Console.WriteLine("Service Already Paused");
				}
				
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
            }
            catch (ManagementException err)
            {
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": An error occurred: " + err.Message);
				Console.WriteLine(err.Message);
            }
        }
    } 
'@ -ReferencedAssemblies System.Management
 
    if ($help -or (!$Service))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        [StopServiceCSharp]::stopService($Service, $Hostname)
    }
    
}
new-item -path alias:stpsvc -value stopService |out-null




function startService
{
    param(
    [string]$Service,
    [string]$Hostname=".", 
    [switch]$help)
    $HelpInfo = @'

    Function : startService
    By       : John Bartels
    Date     : 12/18/2012 
    Purpose  : Starts the Specified Service on the Specified Host
    Usage    : startService[-Help][-Service x][-Hostname x]
               where      
                      -Help       	displays this help
                      -Service		The Service You Wish to Alter
		      -Hostname		The Hostname the Service Resides On (Default = localhost)
                      
'@
  # HelloWorldCS - Demo of C# 
    Add-Type @' 
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Management;
      
    public static class StartServiceNew
    {

        public static void startService(string hostname, string serviceName)
        {
            try
            {
				ManagementObject classInstance =
                    new ManagementObject(@"\\" + hostname + @"\root\cimv2",
                    "Win32_Service.Name='" + serviceName + "'",
                    null);

                // no method in-parameters to define


                // Execute the method and obtain the return values.
                ManagementBaseObject outParams =
                    classInstance.InvokeMethod("StartService", null, null);

				//Console.WriteLine("Listing Out Params:");
                // List outParams
                Console.WriteLine(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
				int check = int.Parse(outParams["ReturnValue"].ToString());
				if(check == 0)
				{
					Console.WriteLine("Success");
				}
				else if(check == 1)
				{
					Console.WriteLine("Not Supported");
				}
				else if(check == 2)
				{
					Console.WriteLine("Access Denied");
				}
				else if(check == 3)
				{
					Console.WriteLine("Dependent Services Running");
				}
				else if(check == 4)
				{
					Console.WriteLine("Innvalid Service Control");
				}
				else if(check == 5)
				{
					Console.WriteLine("Service Cannot Accept Control");
				}
				else if(check == 6)
				{
					Console.WriteLine("Service Not Active");
				}
				else if(check == 7)
				{
					Console.WriteLine("Service Request Timeout");
				}
				else if(check == 8)
				{
					Console.WriteLine("Unknown Failure");
				}
				else if(check == 9)
				{
					Console.WriteLine("Path Not Found");
				}
				else if(check == 10)
				{
					Console.WriteLine("Service Already Running");
				}
				else if(check == 11)
				{
					Console.WriteLine("Service Database Locked");
				}
				else if(check == 12)
				{
					Console.WriteLine("Service Dependency Deleted");
				}
				else if(check == 13)
				{
					Console.WriteLine("Service Dependency Failure");
				}
				else if(check == 14)
				{
					Console.WriteLine("Service Disabled");
				}
				else if(check == 15)
				{
					Console.WriteLine("Service Logon Failure");
				}
				else if(check == 16)
				{
					Console.WriteLine("Service Marked For Deletion");
				}
				else if(check == 17)
				{
					Console.WriteLine("Service No Thread");
				}
				else if(check == 18)
				{
					Console.WriteLine("Status Circular Dependency");
				}
				else if(check == 19)
				{
					Console.WriteLine("Status Duplicate Name");
				}
				else if(check == 20)
				{
					Console.WriteLine("Status Invalid Name");
				}
				else if(check == 21)
				{
					Console.WriteLine("Status Invalid Parameter");
				}
				else if(check == 22)
				{
					Console.WriteLine("Status Invalid Service Account");
				}
				else if(check == 23)
				{
					Console.WriteLine("Status Service Exists");
				}
				else if(check == 24)
				{
					Console.WriteLine("Service Already Paused");
				}
				
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
            }
            catch (ManagementException err)
            {
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": An error occurred while trying to execute the WMI method: " + err.Message);
				Console.WriteLine(err.Message);
            }
        }
    } 
'@ -ReferencedAssemblies System.Management
 
    if ($help -or (!$Service))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        [StartServiceNew]::startService($Hostname, $Service)
    }
    
}
new-item -path alias:strtsvc -value startService |out-null




function pauseService
{
	param(
    [string]$Service,
    [string]$Hostname=".", 
    [switch]$help)
    $HelpInfo = @'

    Function : pauseService
    By       : John Bartels
    Date     : 12/18/2012 
    Purpose  : Pauses Specified Service
    Usage    : pauseService[-Help][-Service x][-Hostname x]
               where      
                      -Help       	displays this help
                      -Service		The Service You Wish to Alter
		      -Hostname		The Hostname the Service Resides On (Default = localhost)
                      
'@
  # HelloWorldCS - Demo of C# 
    Add-Type @' 
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Management;
      
    public static class PauseServiceNew
    {

        public static void pauseService(string hostname, string serviceName)
        {
            try
            {
				ManagementObject classInstance =
                            new ManagementObject(@"\\" + hostname + @"\root\cimv2",
                            "Win32_Service.Name='" + serviceName + "'",
                            null);

                // no method in-parameters to define


                // Execute the method and obtain the return values.
                ManagementBaseObject outParams =
                    classInstance.InvokeMethod("PauseService", null, null);

				//Console.WriteLine("Listing Out Params:");
                // List outParams
                Console.WriteLine(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
				int check = int.Parse(outParams["ReturnValue"].ToString());
				if(check == 0)
				{
					Console.WriteLine("Success");
				}
				else if(check == 1)
				{
					Console.WriteLine("Not Supported");
				}
				else if(check == 2)
				{
					Console.WriteLine("Access Denied");
				}
				else if(check == 3)
				{
					Console.WriteLine("Dependent Services Running");
				}
				else if(check == 4)
				{
					Console.WriteLine("Innvalid Service Control");
				}
				else if(check == 5)
				{
					Console.WriteLine("Service Cannot Accept Control");
				}
				else if(check == 6)
				{
					Console.WriteLine("Service Not Active");
				}
				else if(check == 7)
				{
					Console.WriteLine("Service Request Timeout");
				}
				else if(check == 8)
				{
					Console.WriteLine("Unknown Failure");
				}
				else if(check == 9)
				{
					Console.WriteLine("Path Not Found");
				}
				else if(check == 10)
				{
					Console.WriteLine("Service Already Running");
				}
				else if(check == 11)
				{
					Console.WriteLine("Service Database Locked");
				}
				else if(check == 12)
				{
					Console.WriteLine("Service Dependency Deleted");
				}
				else if(check == 13)
				{
					Console.WriteLine("Service Dependency Failure");
				}
				else if(check == 14)
				{
					Console.WriteLine("Service Disabled");
				}
				else if(check == 15)
				{
					Console.WriteLine("Service Logon Failure");
				}
				else if(check == 16)
				{
					Console.WriteLine("Service Marked For Deletion");
				}
				else if(check == 17)
				{
					Console.WriteLine("Service No Thread");
				}
				else if(check == 18)
				{
					Console.WriteLine("Status Circular Dependency");
				}
				else if(check == 19)
				{
					Console.WriteLine("Status Duplicate Name");
				}
				else if(check == 20)
				{
					Console.WriteLine("Status Invalid Name");
				}
				else if(check == 21)
				{
					Console.WriteLine("Status Invalid Parameter");
				}
				else if(check == 22)
				{
					Console.WriteLine("Status Invalid Service Account");
				}
				else if(check == 23)
				{
					Console.WriteLine("Status Service Exists");
				}
				else if(check == 24)
				{
					Console.WriteLine("Service Already Paused");
				}
				
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
            }
            catch (ManagementException err)
            {
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": An error occurred while trying to execute the WMI method: " + err.Message);
				Console.WriteLine(err.Message);
            }
        }
    } 
'@ -ReferencedAssemblies System.Management
 
    if ($help -or (!$Service))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        [PauseServiceNew]::pauseService($Hostname, $Service)
    }
    
}
new-item -path alias:psesvc -value pauseService |out-null




function resumeService
{
	param(
    [string]$Service,
    [string]$Hostname=".", 
    [switch]$help)
    $HelpInfo = @'

    Function : resumeService
    By       : John Bartels
    Date     : 12/18/2012 
    Purpose  : Resumes Specified Paused Service
    Usage    : resumeService[-Help][-Service x][-Hostname x]
               where      
                      -Help       	displays this help
                      -Service		The Service You Wish to Alter
		      -Hostname		The Hostname the Service Resides On (Default = localhost)
                      
'@
  # HelloWorldCS - Demo of C# 
    Add-Type @' 
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Management;
      
    public static class ResumeServiceNew
    {

        public static void resumeService(string hostname, string serviceName)
        {
            try
            {
				ManagementObject classInstance =
                            new ManagementObject(@"\\" + hostname + @"\root\cimv2",
                            "Win32_Service.Name='" + serviceName + "'",
                            null);

                // no method in-parameters to define


                // Execute the method and obtain the return values.
                ManagementBaseObject outParams =
                    classInstance.InvokeMethod("ResumeService", null, null);

				//Console.WriteLine("Listing Out Params:");
                // List outParams
                Console.WriteLine(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
				int check = int.Parse(outParams["ReturnValue"].ToString());
				if(check == 0)
				{
					Console.WriteLine("Success");
				}
				else if(check == 1)
				{
					Console.WriteLine("Not Supported");
				}
				else if(check == 2)
				{
					Console.WriteLine("Access Denied");
				}
				else if(check == 3)
				{
					Console.WriteLine("Dependent Services Running");
				}
				else if(check == 4)
				{
					Console.WriteLine("Innvalid Service Control");
				}
				else if(check == 5)
				{
					Console.WriteLine("Service Cannot Accept Control");
				}
				else if(check == 6)
				{
					Console.WriteLine("Service Not Active");
				}
				else if(check == 7)
				{
					Console.WriteLine("Service Request Timeout");
				}
				else if(check == 8)
				{
					Console.WriteLine("Unknown Failure");
				}
				else if(check == 9)
				{
					Console.WriteLine("Path Not Found");
				}
				else if(check == 10)
				{
					Console.WriteLine("Service Already Running");
				}
				else if(check == 11)
				{
					Console.WriteLine("Service Database Locked");
				}
				else if(check == 12)
				{
					Console.WriteLine("Service Dependency Deleted");
				}
				else if(check == 13)
				{
					Console.WriteLine("Service Dependency Failure");
				}
				else if(check == 14)
				{
					Console.WriteLine("Service Disabled");
				}
				else if(check == 15)
				{
					Console.WriteLine("Service Logon Failure");
				}
				else if(check == 16)
				{
					Console.WriteLine("Service Marked For Deletion");
				}
				else if(check == 17)
				{
					Console.WriteLine("Service No Thread");
				}
				else if(check == 18)
				{
					Console.WriteLine("Status Circular Dependency");
				}
				else if(check == 19)
				{
					Console.WriteLine("Status Duplicate Name");
				}
				else if(check == 20)
				{
					Console.WriteLine("Status Invalid Name");
				}
				else if(check == 21)
				{
					Console.WriteLine("Status Invalid Parameter");
				}
				else if(check == 22)
				{
					Console.WriteLine("Status Invalid Service Account");
				}
				else if(check == 23)
				{
					Console.WriteLine("Status Service Exists");
				}
				else if(check == 24)
				{
					Console.WriteLine("Service Already Paused");
				}
				
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": ReturnValue: " + outParams["ReturnValue"]);
            }
            catch (ManagementException err)
            {
                //richTextBox1.AppendText(DateTime.Now.ToString() + ": An error occurred while trying to execute the WMI method: " + err.Message);
				Console.WriteLine(err.Message);
            }
        }
    } 
'@ -ReferencedAssemblies System.Management
 
    if ($help -or (!$Service))
    {
        write-host $HelpInfo
        return
    }
    else
    {
        [ResumeServiceNew]::resumeService($Hostname, $Service)
    }
    
}
new-item -path alias:rsmsvc -value resumeService |out-null




function reboot($servername)
{
	(gwmi win32_operatingSystem -ComputerName $servername).Reboot()
}
new-item -path alias:rbt -value reboot |out-null



###############################################################################################
#HyperV Functions:
$HyperVNamespace = "root\virtualization"

#VM Functions:








###############################################################################################
#System Management Functions:


Function New-LocalUser 
{ 
	<# 
		.SYNOPSIS 
			Create a new user account on the local computer. 
		.DESCRIPTION 
			This function will create a user account on the local computer. 
		.PARAMETER Computer 
			The NetBIOS name of the computer that you will create the account on. 
		.PARAMETER User 
			The user name of the account that will be created. 
		.PARAMETER Password 
			The password for the account, this must follow password policies enforced 
			on the destination computer. 
		.PARAMETER Description 
			A description of what this account will be used for. 
		.NOTES 
			You will need to run this with either UAC disabled or from an elevated prompt. 
		.EXAMPLE 
			New-LocalUser -ComputerName MyComputer -User MyUserAccount -Password MyP@ssw0rd -Description "Account." 
			 
			Description 
			----------- 
			Creates a user named MyUserAccount on MyComputer. 
		.LINK 
			http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#New-LocalUser 
	#> 
	Param 
		( 
			[Parameter(Mandatory=$true)] 
			[string]$ComputerName = (& hostname), 
			[Parameter(Mandatory=$true)] 
			[string]$User, 
			[Parameter(Mandatory=$true)] 
			[string]$Password, 
			[string]$Description 
		) 

	Begin 
	{ 
	} 
	 
	Process 
	{ 
		Try 
		{ 
			$objComputer = [ADSI]("WinNT://$($ComputerName)") 
			$objUser = $objComputer.Create("User", $User) 
			$objUser.SetPassword($password) 
			$objUser.SetInfo() 
			$objUser.description = $Description 
			$objUser.SetInfo() 
			Return $? 
			} 
		Catch 
		{ 
			Return $Error[0].Exception.InnerException.Message.ToString().Trim() 
			} 
	} 
	 
	End 
	{ 
	} 
} 

Function Set-Pass 
{ 
	<# 
		.SYNOPSIS 
			Change the password of an existing user account. 
		.DESCRIPTION 
			This function will change the password for an existing user account.  
		.PARAMETER ComputerName 
			The NetBIOS name of the computer that you will add the account to. 
		.PARAMETER UserName 
			The user name of the account that will be created. 
		.PARAMETER Password 
			The password for the account, this must follow password policies enforced 
			on the destination computer. 
		.NOTES 
			You will need to run this with either UAC disabled or from an elevated prompt. 
		.EXAMPLE 
			Set-Pass -ComputerName MyComputer -UserName MyUserAccount -Password N3wP@ssw0rd 
		.LINK 
			http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#Set-Pass 
	#> 
	Param 
	( 
		[Parameter(Mandatory=$true)] 
		[string]$ComputerName = (& hostname), 
		[Parameter(Mandatory=$true)] 
		[string]$UserName, 
		[Parameter(Mandatory=$true)] 
		[string]$Password 
	) 

	Begin 
	{ 
	} 
	 
	Process 
	{ 
		Try 
			{ 
				$User = [adsi]("WinNT://$ComputerName/$UserName, user") 
				$User.psbase.invoke("SetPassword", $Password) 
				 
				Return "Password updated" 
				} 
		Catch 
			{ 
				Return $Error[0].Exception.InnerException.Message.ToString().Trim() 
				} 
	} 
	 
	End 
	{ 
	} 
}     

Function Add-LocalUserToGroup 
{ 
	<# 
		.SYNOPSIS 
			Add an existing user to a local group. 
		.DESCRIPTION 
			This function will add an existing user to an existing group. 
		.PARAMETER Computer 
			The NetBIOS name of the computer that you will add the account to. 
		.PARAMETER User 
			The user name of the account that will be created. 
		.PARAMETER Group 
			The name of an existing group to add this user to. 
		.NOTES 
			You will need to run this with either UAC disabled or from an elevated prompt. 
		.EXAMPLE 
			Add-LocalUserToGroup -ComputerName MyComputer -User MyUserAccount -Group Administrators 
		.LINK 
			http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#Add-LocalUserToGroup 
	#> 
	Param 
		( 
			[Parameter(Mandatory=$true)] 
			[string]$ComputerName = (& hostname), 
			[Parameter(Mandatory=$true)] 
			[string]$User, 
			[Parameter(Mandatory=$true)] 
			[string]$Group 
		) 

	Begin 
	{ 
	} 
	 
	Process 
	{ 
		Try 
		{ 
			$objComputer = [ADSI]("WinNT://$($ComputerName)/$($Group),group") 
			$objComputer.add("WinNT://$($ComputerName)/$($User),group") 
			Return $? 
			} 
		Catch 
		{ 
			Return $Error[0].Exception.InnerException.Message.ToString().Trim() 
			} 
	} 
	 
	End 
	{ 
	} 
} 
Function New-ScheduledTask 
{ 
	<# 
	.SYNOPSIS 
		Create a Scheduled Task on a computer. 
	.DESCRIPTION 
		Create a Scheduled Task on a local or remote computer.  
	.PARAMETER TaskName 
		Specifies a name for the task. 
	.PARAMETER TaskRun 
		Specifies the program or command that the task runs. Type  
		the fully qualified path and file name of an executable file,  
		script file, or batch file. If you omit the path, SchTasks.exe  
		assumes that the file is in the Systemroot\System32 directory.  
	.PARAMETER TaskSchedule 
		Specifies the schedule type. Valid values are  
			MINUTE 
			HOURLY 
			DAILY 
			WEEKLY 
			MONTHLY 
			ONCE 
			ONSTART 
			ONLOGON 
			ONIDLE 
	.PARAMETER StartTime 
		Specifies the time of day that the task starts in HH:MM:SS 24-hour  
		format. The default value is the current local time when the command  
		completes. The /st parameter is valid with MINUTE, HOURLY, DAILY,  
		WEEKLY, MONTHLY, and ONCE schedules. It is required with a ONCE  
		schedule.  
	.PARAMETER StartDate 
		Specifies the date that the task starts in MM/DD/YYYY format. The  
		default value is the current date. The /sd parameter is valid with all  
		schedules, and is required for a ONCE schedule.  
	.PARAMETER TaskUser 
		Runs the tasks with the permission of the specified user account. By  
		default, the task runs with the permissions of the user logged on to the  
		computer running SchTasks. 
	.PARAMETER Server 
		The NetBIOS name of the computer to create the scheduled task on. 
	.NOTES 
		You will need to run this with either UAC disabled or from an elevated prompt. 
		The full syntax of the command can be found here: 
			http://technet.microsoft.com/en-us/library/bb490996.aspx 
	.EXAMPLE 
		New-ScheduledTask -TaskName "Reboot Computer" -TaskRun "shutdown /r" -TaskSchedule ONCE ` 
		-StartTime "18:00:00" -StartDate "03/16/2011" -TaskUser SYSTEM -Server MyDesktopPC 
	.LINK 
		http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#New-ScheduledTask 
	#> 
	 
	Param 
		( 
			[Parameter(Mandatory=$true)] 
			[string]$TaskName, 
			[Parameter(Mandatory=$true)] 
			[string]$TaskRun, 
			[Parameter(Mandatory=$true)] 
			[string]$TaskSchedule, 
			[Parameter(Mandatory=$true)] 
			[string]$StartTime, 
			[Parameter(Mandatory=$true)] 
			[string]$StartDate, 
			[Parameter(Mandatory=$true)] 
			[string]$TaskUser, 
			[Parameter(Mandatory=$true)] 
			[string]$Server     
		) 

	schtasks /create /tn $TaskName /tr $TaskRun /sc $TaskSchedule /st $StartTime /sd $StartDate /ru $TaskUser /s $Server 
} 
Function Remove-UserFromLocalGroup 
{ 
	<# 
		.SYNOPSIS 
			Removes a user/group from a local computer group. 
		.DESCRIPTION 
			Removes a user/group from a local computer group. 
		.PARAMETER Computer 
			Name of the computer to connect to. 
		.PARAMETER User 
			Name of the user or group to remove. 
		.PARAMETER GroupName 
			Name of the group where that the user/group is a member of. 
		.NOTES 
			You will need to run this with either UAC disabled or from an elevated prompt. 
		.EXAMPLE 
			Remove-UserFromLocalGroup -ComputerName MyComputer -UserName RandomUser 
			 
			Description 
			----------- 
			This example removes a user from the local administrators group. 
		.Example 
			Remove-UserFromLocalGroup -ComputerName MyComputer -UserName RandomUser -GroupName Users 
			 
			Description 
			----------- 
			This example removes a user from the local users group. 
		.LINK 
			http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#Remove-UserFromLocalGroup 
	#> 
	 
	Param 
		( 
			[Parameter(Mandatory=$true)] 
			[string]$ComputerName = (& hostname), 
			[Parameter(Mandatory=$true)] 
			[string]$UserName, 
			[Parameter(Mandatory=$true)] 
			[string]$GroupName="Administrators" 
		) 
	 
	$Group = $Computer.psbase.children.find($GroupName) 
	$Group.Remove("WinNT://$Computer/$User") 
} 




Function Get-LocalUserAccounts 
{ 
	<# 
		.SYNOPSIS 
			Return a list of local user accounts. 
		.DESCRIPTION 
			This function returns the Name and SID of any local user accounts that are found 
			on the remote computer. 
		.PARAMETER ComputerName 
			The NetBIOS name of the remote computer 
		.EXAMPLE 
			Get-LocalUserAccounts -ComputerName Desktop-PC01 

			Name                                                      SID                                                                                   
			----                                                      ---                                                                                   
			Administrator                                             S-1-5-21-1168524473-3979117187-4153115970-500 
			Guest                                                     S-1-5-21-1168524473-3979117187-4153115970-501 
			 
			Description 
			----------- 
			This example shows the basic usage 
		.EXAMPLE 
			Get-LocalUserAccounts -ComputerName citadel -Credentials $Credentials 

			Name                                                      SID 
			----                                                      --- 
			Administrator                                             S-1-5-21-1168524473-3979117187-4153115970-500 
			Guest                                                     S-1-5-21-1168524473-3979117187-4153115970-501 
			 
			Description 
			----------- 
			This example shows using the optional Credentials variable to pass administrator credentials 
		.NOTES 
			You will need to provide credentials when running this against computers in a diffrent domain. 
		.LINK 
			http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#Get-LocalUserAccounts 
	#> 
	 
	Param 
		( 
			[string]$ComputerName = (& hostname), 
			[System.Management.Automation.PSCredential]$Credentials 
		) 

	$Filter = "LocalAccount=True" 
	$ScriptBlock = "Get-WmiObject Win32_UserAccount -Filter $Filter" 
	$isAlive = Test-Connection -ComputerName $ComputerName -Count 1 -ErrorAction SilentlyContinue 
	 
	if ($isAlive -ne $null) 
		{ 
			$ScriptBlock += " -ComputerName $ComputerName" 
			if ($Credentials) 
				{ 
					if ($isAlive.__SERVER.ToString() -eq $ComputerName) 
						{} 
					else 
						{ 
							$ScriptBlock += " -Credential `$Credentials" 
						} 
				} 
		} 
	else 
		{ 
			Return "Unable to connect to $ComputerName" 
		} 

	Return Invoke-Expression $ScriptBlock |Select-Object Name, SID 
} 
Function Get-PendingUpdates 
{ 
	<# 
		.SYNOPSIS 
			Retrieves the updates waiting to be installed from WSUS 
		.DESCRIPTION 
			Retrieves the updates waiting to be installed from WSUS 
		.PARAMETER ComputerName 
			Computer or computers to find updates for. 
		.EXAMPLE 
			Get-PendingUpdates  
			Description 
			----------- 
			Retrieves the updates that are available to install on the local system 
		.NOTES 
			Author: Boe Prox 
			Date Created: 05Mar2011 
			RPC Dynamic Ports need to be enabled on inbound remote servers. 
		.LINK 
			http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#Get-PendingUpdates 
	#>  

	Param 
		( 
			[Parameter(ValueFromPipeline = $True)] 
			[string]$ComputerName 
		) 
	 
	Begin  
		{ 
		} 
	Process  
		{ 
			ForEach ($Computer in $ComputerName)  
				{ 
					If (Test-Connection -ComputerName $Computer -Count 1 -Quiet)  
						{ 
							Try  
							{ 
								$Updates =  [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$Computer)) 
								$Searcher = $Updates.CreateUpdateSearcher()  
								$searchresult = $Searcher.Search("IsInstalled=0")      
							} 
							Catch  
							{ 
							Write-Warning "$($Error[0])" 
							Break 
							}  
						} 
				} 
		} 
	End  
		{ 
			Return $SearchResult.Updates 
		} 
} 
 
Function Get-ServiceTag 
{ 
    <# 
        .SYNOPSIS 
            Get the serial number (Dell ServiceTag) from Win32_BIOS 
        .DESCRIPTION 
            This function grabs the SerialNumber property from Win32_BIOS for the  
            provided ComputerName 
        .PARAMETER ComputerName 
            The NetBIOS name of the computer. 
        .EXAMPLE 
            Get-ServiceTag -ComputerName Desktop-01 
 
            SerialNumber 
            ------------ 
            1AB2CD3 
 
            Description 
            ----------- 
            An example showing the only parameter. 
        .NOTES 
            This space intentionally left blank. 
        .LINK 
            http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#Get-ServiceTag 
    #> 
     
    Param 
    ( 
        $ComputerName 
    ) 
     
    Begin 
    { 
        $ErrorActionPreference = "SilentlyContinue" 
    } 
     
    Process 
    { 
        Try 
        { 
            $null = Test-Connection -ComputerName $ComputerName -Count 1 -quiet 
            $Return = New-Object PSObject -Property @{ 
                ComputerName = $ComputerName 
                SerialNumber = (Get-WmiObject -Class Win32_BIOS -ComputerName $ComputerName -Credential $Credentials).SerialNumber  
            } 
        } 
        Catch 
        { 
            $Return = New-Object PSObject -Property @{ 
                ComputerName = $ComputerName 
                SerialNumber = "Offline" 
            } 
        } 
    } 
     
    End 
    { 
        Return $Return 
    } 
} 
 
Function Backup-EventLogs 
{ 
    <# 
        .SYNOPSIS 
            Backup Eventlogs from remote computer 
        .DESCRIPTION 
            This function copies event log files from a remote computer to a backup location. 
        .PARAMETER ComputerName 
            The NetBIOS name of the computer to connect to. 
        .PARAMETER LogPath 
            The path to the logs you wish to backup. The default logpath "C:\Windows\system32\winevt\Logs" 
            is used if left blank. 
        .PARAMETER BackupPath 
            The location to copy the logs to. 
        .EXAMPLE 
            Backup-EventLogs -ComputerName dc1 
        .NOTES 
            May need to be a user with rights to access various logs, such as security on remote computer. 
        .LINK 
            http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#Backup-EventLogs 
    #> 
     
    Param 
    ( 
        [string]$ComputerName, 
        [string]$LogPath = "C:\Windows\system32\winevt\Logs", 
        [string]$BackupPath = "C:\Logs" 
    ) 
     
    Begin 
    { 
        $EventLogs = "\\$($Computername)\$($LogPath.Replace(":","$"))" 
        If ((Test-Path $BackupPath) -ne $True) 
        { 
            New-Item $BackupPath -Type Directory |Out-Null 
            } 
        } 
 
    Process 
    { 
        Try 
        { 
            Copy-Item $EventLogs -Destination $BackupPath -Recurse 
            } 
        Catch 
        { 
            Return $Error 
            } 
        } 
 
    End 
    { 
        Return $? 
        } 
} 
 
Function Export-EventLogs 
{ 
    <# 
        .SYNOPSIS 
            Export Eventlogs from remote computer 
        .DESCRIPTION 
            This function backs up all logs on a Windows computer that have events written in them. This 
            log is stored as a .csv file in the current directory, where the filename is the ComputerName+ 
            Logname+Date+Time the backup was created. 
        .PARAMETER ComputerName 
            The NetBIOS name of the computer to connect to. 
        .EXAMPLE 
            Export-EventLogs -ComputerName dc1 
        .NOTES 
            May need to be a user with rights to access various logs, such as security on remote computer. 
        .LINK 
            http://scripts.patton-tech.com/wiki/PowerShell/ComputerManagemenet#Export-EventLogs 
    #> 
     
    Param 
    ( 
        [string]$ComputerName 
    ) 
     
    Begin 
    { 
        $EventLogs = Get-WinEvent -ListLog * -ComputerName $ComputerName 
        } 
 
    Process 
    { 
        Foreach ($EventLog in $EventLogs) 
        { 
            If ($EventLog.RecordCount -gt 0) 
            { 
                $LogName = ($EventLog.LogName).Replace("/","-") 
                $BackupFilename = "$($ComputerName)-$($LogName)-"+(Get-Date -format "yyy-MM-dd HH-MM-ss").ToString()+".csv" 
                Get-WinEvent -LogName $EventLog.LogName -ComputerName $ComputerName |Export-Csv -Path ".\$($BackupFilename)" 
                } 
            } 
        } 
 
    End 
    { 
        Return $? 
        } 
} 

function get-ProcessorUtilization($hostname)
{
	$a = gwmi -computer $hostname -query "select * from win32_PerfFormattedData_PerfOS_Processor"
	$b
	foreach($prop in $a){$b = $b + $prop.PercentIdleTime}
	100 - $b/$a.Count
}
new-item -path alias:gtpu -value get-ProcessorUtilization | out-null

function collect-InfoForTables($allTables)
{
    $allTableInfo = @()
    foreach($tblName in $allTables)
    {
        $currTbl = get-DDB_TableDescription $region $accessKey $secretKey $tblName
        $obj = create-CustomObject($currTbl)
        $allTableInfo += ,$obj;
    }
    
    return $allTableInfo
}


function create-CustomObject($currTbl)
{
    $obj = New-Object PSObject
    $obj | Add-Member NoteProperty "TableName" $currTbl.TableName
    $obj | Add-Member NoteProperty "CreateDate" $currTbl.CreationDateTime.ToShortDateString()
    $obj | Add-Member NoteProperty "HashKey" $currTbl.KeySchema[0].AttributeName
    $obj | Add-Member NoteProperty "RangeKey" $currTbl.KeySchema[1].AttributeName
    $obj | Add-Member NoteProperty "ReadUnits" $currTbl.ProvisionedThroughput.ReadCapacityUnits
    $obj | Add-Member NoteProperty "WriteUnits" $currTbl.ProvisionedThroughput.WriteCapacityUnits
    $obj | Add-Member NoteProperty "GSIName" $currTbl.GlobalSecondaryIndexes.IndexName
    $obj | Add-Member NoteProperty "GSISize" $currTbl.GlobalSecondaryIndexes.IndexSizeBytes
    $obj | Add-Member NoteProperty "GSICount" $currTbl.GlobalSecondaryIndexes.ItemCount

    $obj | Add-Member NoteProperty "ItemCount" $currTbl.ItemCount
    $obj | Add-Member NoteProperty "TableSizeBytes" $currTbl.TableSizeBytes
    if($currTbl.ItemCount -gt 0)
    {
    	$obj | Add-Member NoteProperty "BytesPerItem" ($currTbl.TableSizeBytes / $currTbl.ItemCount)
    }
    else
    {
	$obj | Add-Member NoteProperty "BytesPerItem" 0
    }

    return $obj
}


###############################################################################################

#powershell customizations:


#show computername in command line path
function prompt
{
   $env:computername + "\" + (get-location) + "> "
}

#alter backcolor and forecolor of Console
function Color-Console
{
     #$host = (Get-Host).UI.RawUI
     $winSize = $host.UI.RawUI.WindowSize
     $host.ui.rawui.backgroundcolor = "black"
     $host.ui.rawui.foregroundcolor = "white"
     #$hosttime = (dir $pshome\powershell.exe).creationtime
     $hosttime = get-date -format g
     $Host.UI.RawUI.WindowTitle = "Windows PowerShell $hostversion ($hosttime)"
     $winSize.Width = 135
     $winSize.Height = 60
     $host.UI.RawUI.WindowSize = $winSize
     clear-host
}


#executes the color-console function
Color-console

#executes the showcustomfunctions function
Show-Custom-Functions