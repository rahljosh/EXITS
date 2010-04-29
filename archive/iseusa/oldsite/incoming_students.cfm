<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="qGetStudents" datasource="MySql">
        SELECT     	
        	s.studentid,  
            s.firstName,
            s.dob, 
            s.interests,
            c.countryname, 
            r.religionname
        FROM       	
        	smg_students s
        INNER JOIN 	
        	smg_countrylist c ON c.countryid = s.countryresident
        LEFT JOIN 	
        	smg_religions r ON r.religionid = s.religiousaffiliation
        WHERE 	   	
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
        <!--- Do Not Get Students Placed --->
        AND 
        	s.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        <!--- Do Not Get Applications on Hold --->
        AND
        	onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> 
        <!--- Approved Applications --->
        AND
        	app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11"> 
        <!--- Do Not Get Direct Placement --->
        AND 
        	s.direct_placement = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        <!--- Get ISE Students --->
        AND 
        	s.companyid  < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
        <!--- Do Not Get US Citizens --->
        AND
        	s.countryresident != <cfqueryparam cfsqltype="cf_sql_integer" value="232">
        ORDER BY 
        	rand()
        LIMIT 50  
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//Dtd Xhtml 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ISE - International Student Exchange | Private and Public High School Programs | Incoming Students </title>
<META NAME="Keywords" CONTENT="homestay, exchange student, foreign students, student exchange, foreign exchange, foreign exchange program, academic exchange, student exchange program, high school, high school program, host family, host families, public high school program, private high school program, public high school, private high school, American exchange">
<META NAME="Description" CONTENT="ISE offers semester programs, as well as school year programs, that allow foreign students the opportunity to become familiar with the American way of life by experiencing its schools, homes and communities. ISE can also now offer students the opportunity to study at some of America's finest Private High Schools. ISE works with a network of independent international educational partners who provide information, screening and orientations for prospective applicants to a variety of education and training programs in the United States.">
<META NAME="Author" CONTENT="support@student-management.com">
<script src="menu.js"></script>
<style type="text/css">
	<!--
	body {
		background-color: #000343;
	}
	.style1 {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 10px;
	}
	.style2 {color: #000066}
	-->
</style>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
    <tr>
        <td colspan=3><script>menutop();</script></td>
    </tr>
    
    <tr>
        <td width="17" background="images/blank_02.gif">&nbsp;</td>
        <td width="736" bgcolor="#FFFFFF"> 
        	
            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="42%"><div align="center"><img src="images/incoming-students.gif" width="266" height="70"></div></td>
                    <td width="58%"><img src="images/top6.jpg" width="400" height="70"></td>
                </tr>
			</table>                
			
            <br />
            
            <table width="80%" border="0" align="center" cellpadding="2" cellspacing="2">
                <tr>
                    <td>
                    <span class="style1">
                        Below are some of the students that are in the program this year.<br>
                        Request more information and be contacted by a representative in your region by filling out this 
                        <a href="request_info.cfm?request=host" class="style2">form</a>.
                    </span>
                    </td>
                </tr>
            </table>
			
            <br />
            
            <table width=80% align="center" cellpadding="2" cellspacing="2">
                <Tr>
                    <td>
                        <span class="style1">
                            <font color="red">
                                ALL STUDENTS SHOWING ON THIS WEB PAGE HAVE BEEN ASSIGNED TO A SPECIFIC
                                REGION.  ACCORDING TO OUR INTERNATIONAL AGREEMENTS, WE CANNOT TRANSFER
                                STUDENTS OUT OF SPECIFIC REGIONS. THESE STUDENTS ARE ONLY TO BE USED AS A
                                SAMPLE OF ISE STUDENTS AND MIGHT NOT BE AVAILABLE IN YOUR SPECIFIC REGION.
                            </font>
                        </span>
                    </td>
                </tr>
            </table>
			
            <br />
            
            <table width="80%" align="center" cellpadding="2" cellspacing="2">
                <cfoutput query="qGetStudents">
                    <cfset image_path="/var/www/html/student-management/nsmg/uploadedfiles/web-students/#qGetStudents.studentid#.jpg">
            
                    <cfquery name="qGetInterests" datasource="MySQL">
                        SELECT 
                            interest 
                        FROM 
                            smg_interests 
                        WHERE 
                            interestID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.interests#" list="yes"> )
                    </cfquery>
                    <tr>
                        <td width="133px" valign="top">
                            <cfif FileExists(image_path)>
                                <img src="http://www.student-management.com/nsmg/uploadedfiles/web-students/#qGetStudents.studentid#.jpg" width="133"> 
                            <cfelse>
                                <span class="style1">Sorry, no picture available at this time.</span>	
                            </cfif>
                         </td>
                        <td class="style1">
                            Name: #qGetStudents.firstName#<br>
                            Age: #DateDiff('yyyy', qGetStudents.dob, now())# <br>
                            From: #qGetStudents.countryname#<br>
                            Interests: #ValueList(qGetInterests.interest, ", ")# <br>
                            <br>
                        </td>
                    </tr>
                </cfoutput>
            </table>
			
            <br />
            
            <div align="center" class="style1">
                Request more information and be contacted by a representative in your region by filling out this 
                <a href="request_info.cfm?request=host" class="style2">form</a>. <br /><br />
            </div>
        </td>
        <td width="17" background="images/blank_04.gif">&nbsp;</td>
    </tr>
	<tr>
		<td colspan=3>
			<IMG SRC="images/blank_05.gif" ALT="" WIDTH=770 HEIGHT=34 border="0" usemap="#Map">
        </td>
	</tr>
</table>
<map name="Map">
  <area shape="rect" coords="522,6,653,22" href="mailto:contact@iseusa.com">
</map>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
<script type="text/javascript">
_uacct = "UA-880717-2";
urchinTracker();
</script>
</body>
</html>