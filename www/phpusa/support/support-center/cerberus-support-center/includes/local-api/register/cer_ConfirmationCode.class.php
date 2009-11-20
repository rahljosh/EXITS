<?php

class cer_ConfirmationCode {
	
	function generateConfirmationCode() {
		$code_parts = array();
		$code_chars = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','1','2','3','4','5','6','7','8','9');
		
		for($x = 0; $x < 4; $x++) {
			$part = "";
			
			for($y = 0; $y < 4; $y++) {
				$choice = rand(1,count($code_chars)) - 1; // 0 to last element of array
				$part .= $code_chars[$choice];
			}
			
			$code_parts[$x] = $part;
		}
		
		return implode("-",$code_parts);
	}
	
	
	
}

?>