function GetAllFactors([decimal]$passedNumber)
{
	$timeStart = get-date	
	$numFact = 0
	for($int1 = 1; $int1 -le [math]::sqrt($passedNumber); $int1++) 
	{
		$int2 = $passedNumber / $int1
		$rem = $passedNumber % $int1
		if($rem -eq 0) 
		{
			"Applicable Factors: " + $int1 + " X " + $int2
			$numFact++
		}
	}
	$timeElapsed =  (Get-Date) - $timeStart
	"Completion Time: " + $timeElapsed
	"The number: " + $passedNumber + " has " + $numFact * 2 + " factors"
}
GetAllFactors 6756565776000