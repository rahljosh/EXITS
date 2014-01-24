<?php
$db = new mysqli('204.12.102.10', 'rahljosh', 'f8qvVpF[@v', 'smg');

  $hostID = "select max(id) as lastID
	 			from smg_host_lead";
					
   	$result = $db->query($hostID);
	 while($fieldData=$result->fetch_object())
	 {
		$newID = ($fieldData->lastID+1);
		$hashid = (($newID*64) % 29).chr((substr($newID,-1,1)+65)).($newID % 4);
		echo 'Josh'.$hashid;
	 }
  
	
?>
