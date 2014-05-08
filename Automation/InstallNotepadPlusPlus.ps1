if (test-path "C:\Program Files\Notepad++\notepad++.exe")
{
"The Program has already been installed..."
break
}
else
{

Start-Process "C:\Users\John\Desktop\Scripts\npp.5.9.3.Installer.exe"

sleep 3

[void] [System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
[Microsoft.VisualBasic.Interaction]::AppActivate("Installer Language")

#[void] [System.Reflection.Assembly]::LoadWithPartialName("'System.Windows.Forms")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep 10
[System.Windows.Forms.SendKeys]::SendWait(" ")
sleep 1
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

}