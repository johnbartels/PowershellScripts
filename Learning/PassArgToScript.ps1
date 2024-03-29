$global:input=$null

if($args.Length -eq 0)
{
  "No Arguments Supplied..."
  "This script requires n number of Arguments"
  exit;
}
else
{
  "yay"
  $global:input = $args[0]
  $global:input
}

function WriteToFile([string]$Entry)
{
	$c = $Entry + "`n"
	Out-File -FilePath "C:\Users\John\Desktop\johnseventlog.txt" -Append -InputObject $c
}

#example function showing how to set a global variable from within a function
function WaitForInput()
{
	$input2 = Read-Host -Prompt "Please specify Message..."
    "Here it is: " 
    $input2
    Set-Variable -Name input -Value $input2 -Scope Global

}

do
{
	WaitForInput
	"Here it is: " 
    $global:input
}
while($global:input -ne "Q")