$array = 1,2,3,4,5,6,7,8,9

$array

foreach($item in $array)
{
	"The number is: " + $item
}

for($int=$array.Count;$int -gt 0;$int--)
{
	"Here ya go: "
	$item2=$array[$int - 1]
	$item2
}