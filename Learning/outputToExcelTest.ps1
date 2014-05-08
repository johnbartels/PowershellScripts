#$ServerList = "John-Desktop"
$ServerList = ("John-Desktop",".")



function addServerInfoToExcelSpreadSheet($colItems)
{
	$Excel = New-Object -Com Excel.Application
	$Excel.visible = $True
	$Excel = $Excel.Workbooks.Add()

	$Sheet = $Excel.WorkSheets.Item(1)
	$Sheet.Cells.Item(1,1) = “Computer”
	$Sheet.Cells.Item(1,2) = “Drive Letter”
	$Sheet.Cells.Item(1,3) = “Description”
	$Sheet.Cells.Item(1,4) = “File System”
	$Sheet.Cells.Item(1,5) = “Size in GB”
	$Sheet.Cells.Item(1,6) = “Free Space in GB”
	$Sheet.Cells.Item(1,7) = “Percent Free %”

	$WorkBook = $Sheet.UsedRange
	$WorkBook.Interior.ColorIndex = 8
	$WorkBook.Font.ColorIndex = 11
	$WorkBook.Font.Bold = $True

	$intRow = 2

	foreach($server in $colItems)
	{
		Write-Host "Server Name: " + $server
		#sleep 5

		"Getting Logical DIsks for Server: " + $server
		$collection = Get-wmiObject Win32_LogicalDisk -computername $server
		"Count"
		#$collection.Count
		#sleep 5
		"Adding Items for Server to Excel SpreadSheet..."
		#addServerInfoToExcelSpreadSheet($collection);
		
		foreach ($objItem in $collection) 
		{
			$Sheet.Cells.Item($intRow,1) = $objItem.SystemName
			$Sheet.Cells.Item($intRow,2) = $objItem.DeviceID
			$Sheet.Cells.Item($intRow,3) = $ojbItem.Description
			$Sheet.Cells.Item($intRow,4) = $objItem.FileSystem
			$Sheet.Cells.Item($intRow,5) = $objItem.Size / 1GB
			$Sheet.Cells.Item($intRow,6) = $objItem.FreeSpace / 1GB  
			
			#"Checking to See if Object Size is 0..."
			#$objItem.Size
			
			if($objItem.Size -eq 0 -or $objItem.Size -eq $null)
			{
				$Sheet.Cells.Item($intRow,7) = 0;
			}
			else
			{
				#"Checking to See if Object FreeSpace is 0..."
				#$objItem.FreeSpace
			
				if($objItem.FreeSpace -eq 0 -or $objItem.FreeSpace -eq $null)
				{
					$Sheet.Cells.Item($intRow,7) = 0;
				}
				else
				{
					$Sheet.Cells.Item($intRow,7) = ($objItem.FreeSpace/$objItem.Size) * 100
				}
			}

			$intRow = $intRow + 1

		}
		
		#sleep -s 6
	}

	 $WorkBook.EntireColumn.AutoFit()
}

function addServerInfoToExcelSpreadSheetNew($colItems)
{
	$Excel = New-Object -Com Excel.Application
	$Excel.visible = $True
	$Excel = $Excel.Workbooks.Add()

	$Sheet = $Excel.WorkSheets.Item(1)
	$Sheet.Cells.Item(1,1) = “Computer”
	$Sheet.Cells.Item(1,2) = “Drive Letter”
	$Sheet.Cells.Item(1,3) = “Description”
	$Sheet.Cells.Item(1,4) = “File System”
	$Sheet.Cells.Item(1,5) = “Size in GB”
	$Sheet.Cells.Item(1,6) = “Free Space in GB”
	$Sheet.Cells.Item(1,7) = “Percent Free %”

	$WorkBook = $Sheet.UsedRange
	$WorkBook.Interior.ColorIndex = 8
	$WorkBook.Font.ColorIndex = 11
	$WorkBook.Font.Bold = $True

	$intRow = 2

	foreach($server in $colItems)
	{
		Write-Host "Server Name: " + $server
		#sleep 5

		"Getting Logical DIsks for Server: " + $server
		$collection = Get-wmiObject Win32_LogicalDisk -computername $server
		"Count"
		#$collection.Count
		#sleep 5
		"Adding Items for Server to Excel SpreadSheet..."
		#addServerInfoToExcelSpreadSheet($collection);
		
		foreach ($objItem in $collection) 
		{
			$Sheet.Cells.Item($intRow,1) = $objItem.SystemName
			$Sheet.Cells.Item($intRow,2) = $objItem.DeviceID
			$Sheet.Cells.Item($intRow,3) = $ojbItem.Description
			$Sheet.Cells.Item($intRow,4) = $objItem.FileSystem
			$Sheet.Cells.Item($intRow,5) = $objItem.Size / 1GB
			$Sheet.Cells.Item($intRow,6) = $objItem.FreeSpace / 1GB  
			
			#"Checking to See if Object Size is 0..."
			#$objItem.Size
			
			if($objItem.Size -eq 0 -or $objItem.Size -eq $null)
			{
				$Sheet.Cells.Item($intRow,7) = 0;
			}
			else
			{
				#"Checking to See if Object FreeSpace is 0..."
				#$objItem.FreeSpace
			
				if($objItem.FreeSpace -eq 0 -or $objItem.FreeSpace -eq $null)
				{
					$Sheet.Cells.Item($intRow,7) = 0;
				}
				else
				{
					$Sheet.Cells.Item($intRow,7) = ($objItem.FreeSpace/$objItem.Size) * 100
				}
			}

			$intRow = $intRow + 1

		}
		
		#sleep -s 6
	}

	 $WorkBook.EntireColumn.AutoFit()
}

addServerInfoToExcelSpreadSheet($ServerList);



 #Clear
