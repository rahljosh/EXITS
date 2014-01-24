<?php 
		//connection information 
		@ $db = new mysqli('blog.iseusa.com','webAccess','Web@ccess$','blog');
			if ($mysqli->connect_errno) {
				echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
			}
		//build the query
		  $query='SELECT post_title, post_content, post_date, guid
					FROM  wp_posts 
					WHERE post_status = "publish"
					ORDER BY post_Date DESC 
					LIMIT 2';
			
		//run the query
		$result = $db->query($query);
		
		
		//display results
		$num_results = $result->num_rows;
		
		//set up a loop
        for ($i=0; $i <$num_results; $i++)	{
		$row = $result->fetch_assoc();
		
		//dispaly the things on screen
		echo "<h3>".($row['post_title'])."</h3>";
		echo "Content: ".($row['post_content'])."<br>";
		echo "Date: ".($row['post_date'])."<br>";
		echo "Link: ".($row['guid'])."<br><br>";
		echo "<br><br>--------------";
	
		echo "<br><br><br><Br>";
		}
		


?>		


	 
<!------
<Cfquery name="latestPosts" datasource="iseblog" username="iseblog" password="Iseusa123">
SELECT post_title, post_content, post_date, guid
FROM  wp_posts 
where post_status = 'publish'
ORDER BY post_Date DESC 
LIMIT 2
</Cfquery>


<cfoutput>
<Cfloop query="latestPosts">
<cfset postVerbiage = REReplace(post_content,'<[^>]*>','','all')>
      <li><small>Posted on #DateFormat(post_date, 'MMMM d,YYYY')#</small>
      <h5>#post_title#</h5>
      <p>#LEFT(postVerbiage,100)#....<a href="#guid#" class="red">Read more &##187;</a></p></li>
   
</Cfloop>
</cfoutput>
---->