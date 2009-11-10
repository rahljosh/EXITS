<?php
//asign the data passed from Flex to variables
$username = $_POST["username"];
$password = $_POST["password"];

//start outputting the XML
$output = "<loginsuccess>";

//if the query returned true, the output <loginsuccess>yes</loginsuccess> else output <loginsuccess>no</loginsuccess>
if($username == "bruno")
{
$output .= "yes";            
}else{
$output .= "no";     
}
$output .= "</loginsuccess>";

//output all the XML
print ($output);
?>