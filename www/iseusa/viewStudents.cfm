<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #0B954E;
}
a:active {
	text-decoration: none;
}
-->
</style>
</head>
<body class="oneColFixCtr">
<div id="topBar">
<cfinclude template="topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><img src="images/spacer.gif" width="170" height="33" /><img src="images/ISEtitle.png" width="464" height="65" alt="ISE Title" /><img src="images/facebook.png" width="38" height="49" alt="facebook" /><a href="http://twitter.com/ISEHQ"><img src="images/twitter.png" width="39" height="50" alt="twitter" border="0"/></a><!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddleStretch">
        <div class="shopping">
          <h1 class="enter">Meet Our Students</h1>
          <table width="600" border="0" color="8DC540"> 
          
   <Cfif not isdefined('client.hostid') or client.hostid eq 0>
   	<cfoutput>
    <tr>
    	<td>
   			You must be logged into to view students. <br />
			If you have your login or need to register, visit <a href="http://#cgi.SERVER_NAME#/meet-our-students.cfm">http://#cgi.SERVER_NAME#/meet-our-students.cfm</a>.
        </td>
     </tr>
     </table>
     </cfoutput>
   <cfelse>
   
   	<cfquery name="get_students" datasource="#APPLICATION.DSN.Source#">
	SELECT     	studentid,  dob, firstname, interests, interests_other, smg_countrylist.countryname, smg_religions.religionname
	FROM       	smg_students
	INNER JOIN 	smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
	LEFT JOIN 	smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
	WHERE 	   	active = '1' 
    			and ( programid = 316 or programid =314) 
			 	AND hostid = '0' 
				AND direct_placement = '0'
                <!--- Only ISE Students --->
                AND companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes">)
	ORDER BY rand()
	LIMIT 5
</cfquery>
     <cfoutput query="get_students">  
     

  <CFSET image_path1="C:\websites\student-management\nsmg\uploadedfiles\web-students\#get_students.studentid#.*">
   <CFSET image_path2="C:\websites\student-management\nsmg\uploadedfiles\web-students\#get_students.studentid#.jpg">
      <tr>
        <td><CFIF FileExists(image_path1)>
      						<span class="style1"><img src="http://www.student-management.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.*" width="133"> 			<cfelseif FileExists(image_path2)>
                            <span class="style1"><img src="http://www.student-management.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.jpg" width="133">
	   					    <CFELSE>
	        				Sorry, no picture available at this time.</span>	
	    				</CFIF></td>
        <td bgcolor="##FFFFFF">&nbsp;</td>
        <td class="lightGreen">
          <p class="StudentName">Name: #get_students.firstname#<cfif dob EQ ''><cfelse>(#datediff('yyyy',dob,now())#)</cfif><br />
            Home Country: #get_students.countryname#<br />
            Religion: #get_students.religionname#<br />
            Interests:
                 <cfloop list=#get_students.interests# index=i>
				<cfquery name="get_interests" datasource="#APPLICATION.DSN.Source#">
				Select interest 
				from smg_interests 
				where interestid = #i#
				</cfquery>
				#LCASE(get_interests.interest)# &nbsp;&nbsp; 
			</cfloop></p>
            
          <p><span class="StudentName">About #get_students.firstname#:</span> <span class="incomingstudenttext">#get_students.interests_other#</span></p>
        </td>
      </tr>
      </cfoutput>
     <tr>
     	<Td colspan=4 align="center"><h2><a href="viewStudents.cfm">View More Students</a> </h2></Td>
    </table>
    
          </cfif><p class="p1">&nbsp;</p>
        </div>
        
        
        <p class="p1">&nbsp;</p>
        <p class="p1">&nbsp;</p>
<p class="p1">&nbsp;</p>
        <!-- end whtMiddle -->
      </div>
      <div class="whtBottom"></div>
      <!-- end lead --></div>
    <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="bottomLinks.cfm">
</div> <!-- end footer -->

<!--- Google AdWords Conversion Code --->
<cfif CLIENT.isAdWords>
    <!-- Google Code for Meet Our Students Conversion Page -->
    <script type="text/javascript">
    <!--
    var google_conversion_id = 1068621920;
    var google_conversion_language = "en";
    var google_conversion_format = "1";
    var google_conversion_color = "ffffff";
    var google_conversion_label = "epVpCNS10AEQ4MDH_QM"; var google_conversion_value = 0; 
    //--> 
    </script> 
    <script type="text/javascript" src="http://www.googleadservices.com/pagead/conversion.js"></script>
    <noscript>
    <div style="display:inline;">
    <img height="1" width="1" style="border-style:none;" alt="" src="http://www.googleadservices.com/pagead/conversion/1068621920/?label=epVpCNS10AEQ4MDH_QM&amp;guid=ON&amp;script=0"/>
    </div>
    </noscript>
</cfif>    
<!--- End of Google AdWords Conversion Code --->

</body>
</html>
