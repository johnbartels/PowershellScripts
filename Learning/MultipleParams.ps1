﻿Function Test([string]$arg1, [string]$arg2)
{
    Write-Host "`$arg1 value: $arg1"
    Write-Host "`$arg2 value: $arg2"
	$arg1
	$arg2
}

Test "ABC" "DEF"