###################################################
## Launch as :                                   ##
## cmd /k powershell -Sta [-File] .\balloon.ps1  ##
###################################################

sleep 2

# This post put me on the right track "http://social.technet.microsoft.com/Forums/en-US/winserverpowershell/thread/10983ec3-7aa6-4011-a87e-a30a25ab484a/"

Write-Host -ForeGround Yellow " ###### START OF SCRIPT ! ######"
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

#This is the Title Of the Balloon
$Title = "Click Here For More Information"
#This is the Text that is displayed in the Balloon
$Text = "http:\\www.google.com"
$EventTimeOut = 5

$balloon = New-Object System.Windows.Forms.NotifyIcon -Property @{
    Icon = [System.Drawing.SystemIcons]::Information
    BalloonTipTitle = $Title
    BalloonTipText = $Text
    Visible = $True
}

# Value "1" here is meaningless. $EventTimeOut will force bubble to close.
$balloon.ShowBalloonTip(1)

Register-ObjectEvent $balloon BalloonTipClicked -SourceIdentifier event_BalloonTipClicked
Register-ObjectEvent $balloon BalloonTipClosed -SourceIdentifier event_BalloonTipClosed

# "Wait-Event" pauses the script here until an event_BalloonTip* is triggered
# TimeOut is necessary or balloon and script hangs there forever. 
# This could be okay but event subscription gets messed up by following script instances generating the same event names1.
$retEvent = Wait-Event event_BalloonTip* -TimeOut $EventTimeOut

# Script resumes here.
$retSourceIdentifier = $retEvent.SourceIdentifier
If ($retSourceIdentifier -eq $null){
    Write-Host  -ForeGround Green "TimeOut occured !"
}Else{
    Write-Host  -ForeGround Green "$retSourceIdentifier occured !"
    }
#Change the following value to the Program you wish to Open when the Balloon is Clicked
If ($retSourceIdentifier -eq "event_BalloonTipClicked"){
    notepad.exe
    }

# Gets rid of icon. This is absolutely necessary, otherwise icon is stuck event if parent script/shell closes
$balloon.Dispose()

# Tidy up, This is needed if returning to parent shell.
Unregister-Event -SourceIdentifier event_BalloonTip*
Get-Event event_BalloonTip* | Remove-Event
Write-Host -ForeGround Gray "Should be empty -- start --"
Get-EventSubscriber
Write-Host -ForeGround Gray "Should be empty -- end --"

#[System.Windows.Forms.MessageBox]::Show("Done !!")
Write-Host -ForeGround Yellow " ###### END OF SCRIPT ! ######"
