 <?php
  @ $db = new mysqli('119cooper.com', 'externalSite', 'externalSite7*', 'externalSite');
 
 if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}

  $query = "SELECT pageTitle, pageKeywords, pageDescription FROM metadata WHERE url = ".$_SERVER['SCRIPT_NAME'];
  
  $result = $db->query($query);
	
  $num_results = $result->num_rows;
 
 for($i=0; $i <$num_results; $i++){
  echo "<title> ".$row['pageTitle']."</title>";
  echo "Josh";

}
?>
<!---
<title>#APPLICATION.METADATA.pageTitle#</title>
content="#APPLICATION.METADATA.pageDescription#" />
<META NAME="keywords" content="#APPLICATION.METADATA.pageKeywords#">
--->