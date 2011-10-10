<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CASE: view students</title>
<link href="css/maincss.css" rel="stylesheet" type="text/css" />
<!----
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
	color: #333;
}
a:active {
	text-decoration: none;
	color: #333;
}
-->
</style>
---->
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
	color: #98002E;
}
a:active {
	text-decoration: none;
	color: #000;
}
.clearfix {
	display: block;
	clear: both;
	height: 30px;
}
-->
</style>

<link rel="shortcut icon" href="favicon.ico" />

</head>

<body>
<div id="wrapper">
<!----REmove 1=1 to view students again---->

  <cfinclude template="includes/header.cfm">
  <div id= "mainbody">
   <cfinclude template="includes/leftsidebar.cfm">
    <cfif not isDefined('client.viewstudents') or client.viewstudents neq 1 or 1 eq 1>
    	<cflocation url="viewStudentslogin.cfm">
    
    <cfelse>
 		
 
    
	<cfquery name="get_students" datasource="mysql">
	SELECT     	studentid,  dob, firstname, interests, interests_other, smg_countrylist.countryname, smg_religions.religionname
	FROM       	smg_students
	INNER JOIN 	smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
	LEFT JOIN 	smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
    LEFT JOIN 	smg_programs ON smg_programs.programid = smg_students.programid
	WHERE 	   	smg_students.active = '1' 
			 	AND hostid = '0' 
				AND direct_placement = '0'
                AND smg_students.companyid = 10
                
	ORDER BY rand()
	LIMIT 9 
</cfquery>
<div id="mainContent">
<div id="ContentTop"></div>
<div id="content">
  <div id="aboutCase">
    <p class="header2">Incoming Students    </p>
    <p class="incomingstudenttext">Below are some of the students that are in the program this year.</p>
    <p class="incomingstudenttext"> Request more information and be contacted by a representative in your region by filling out this form.<br />
      </p>
    <p class="12ptRed">ALL STUDENTS SHOWING ON THIS WEB PAGE HAVE BEEN ASSIGNED TO A SPECIFIC REGION. ACCORDING TO OUR INTERNATIONAL AGREEMENTS, WE CANNOT TRANSFER STUDENTS OUT OF SPECIFIC REGIONS. THESE STUDENTS ARE ONLY TO BE USED AS A SAMPLE OFCASE STUDENTS AND MIGHT NOT BE AVAILABLE IN YOUR SPECIFIC REGION.</p>
    <p class="12ptRed">Refreshing your page will enable you to view more students </p>
    
   <table width="600" border="0"> 
     <cfoutput query="get_students">  
     

  <CFSET image_path1="C:\websites\student-management\nsmg\uploadedfiles\web-students\#get_students.studentid#.*">
   <CFSET image_path2="C:\websites\student-management\nsmg\uploadedfiles\web-students\#get_students.studentid#.jpg">
      <tr>
        <td><CFIF FileExists(image_path1)>
      						<span class="style1"><img src="http://case.exitsapplication.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.*" width="133"> 			<cfelseif FileExists(image_path2)>
                            <span class="style1"><img src="http://case.exitsapplication.com/nsmg/uploadedfiles/web-students/#get_students.studentid#.jpg" width="133">
	   					    <CFELSE>
	        				Sorry, no picture available at this time.</span>	
	    				</CFIF></td>
        <td bgcolor="##FFFFFF">&nbsp;</td>
        <td class="gradient">
          <p class="StudentName">Name: #get_students.firstname# #get_students.studentid#<cfif dob EQ ''><cfelse>(#datediff('yyyy',dob,now())#)</cfif><br />
            Home Country: #get_students.countryname#<br />
            Religion: #get_students.religionname#<br />
            Interests:
                 <cfloop list=#get_students.interests# index=i>
				<cfquery name="get_interests" datasource="caseusa">
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
     
    </table>
    <p class="12ptRed">&nbsp;</p>

  </div>
</div>
</cfif>
<div id="Contentbottom"></div>
</div><!-- end mainbody -->
    <!-- This clearing element should immediately follow the mainContent div in order to force the container div to contain all child floats --><br class="clearfloat" />
<cfinclude template="includes/footer.cfm">
</div><!-- end wrapper -->
</body>
</html>
