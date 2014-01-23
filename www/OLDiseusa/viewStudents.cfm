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
p {
	text-align: left;
	padding-left: 20px;
}
-->
</style>
</head>
<body class="oneColFixCtr">
<cfinclude template="slidingLogin.cfm">
<div id="topBar">

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
          <table width="600" border="0" color="8DC540" cellpadding="10" cellspacing="10"> 
        
   <Cfif not isdefined('cookie.iseLead')>
   	<cfoutput>
    <tr>
    	<td>
   			You must register to view students. <br />
			If you need to register, visit <a href="http://#cgi.SERVER_NAME#/meet-our-students.cfm">http://#cgi.SERVER_NAME#/meet-our-students.cfm</a>.
        </td>
     </tr>
     </table>
     </cfoutput>
   <cfelse>
   
   	<cfquery name="get_students" datasource="#APPLICATION.DSN.Source#">
        SELECT     	
            studentid,  
            dob, 
            firstname, 
            interests, 
            interests_other, 
            countryresident,
            smg_countrylist.countryname, 
            smg_religions.religionname
        FROM
            smg_students
        INNER JOIN 	
            smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
        LEFT JOIN 	
            smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
        WHERE 	   	
            active = '1' 
        <!--- August 2011 Programs - Set this up in the DB later so users can change in the program information --->
        <!--- 
		AND 
            programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="318,319,320,321" list="yes"> ) 
		--->			
        AND 
            hostid = '0' 
        AND 
            direct_placement = '0'
        <!--- Only ISE Students --->
        AND 
            companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes">)
        ORDER BY rand()
        LIMIT 5
	</cfquery>
	
	<cfoutput query="get_students">  
      <tr <cfif get_students.currentrow mod 2> class="lightGreen" </cfif>>
        <td>
			<cfif FileExists('c:\websites\student-management\nsmg\pics\flags\#get_students.countryresident#.jpg')>
            	<span class="style1" style="float:left; padding:10px;"><img src="http://ise.exitsapplication.com/nsmg/pics/flags/#get_students.countryresident#.jpg" width="133"></span>
            <cfelse>
                <span class="style1" style="float:left; padding:10px;"><img src="http://ise.exitsapplication.com/nsmg/pics/flags/0.jpg" width="133"></span>
            </cfif>
          <p class="StudentName"><strong>Name:</strong> #get_students.firstname# <cfif IsDate(dob)>(#datediff('yyyy',dob,now())#)</cfif><br />
            <strong>Home Country:</strong> #get_students.countryname#<br />
            <strong>Religion:</strong> #get_students.religionname#<br />
            <strong>Interests:</strong>
                <cfloop list=#get_students.interests# index=i>
				<cfquery name="get_interests" datasource="#APPLICATION.DSN.Source#">
				Select interest 
				from smg_interests 
				where interestid = #i#
				</cfquery>
				#LCASE(get_interests.interest)#,  
			</cfloop></p>
            
          <p><span class="StudentName"><strong>About #get_students.firstname#:</strong></span> <span class="incomingstudenttext">#get_students.interests_other#</span></p>
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

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">

</body>
</html>
