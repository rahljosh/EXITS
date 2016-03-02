<!--- Kill Extra Output --->
<cfsilent>

	<cfparam name="URL.status" default="active">
	<cfparam name="URL.order" default="familylastname">
	<cfparam name="URL.placed" default="All">
    <cfparam name="URL.programID" default="0">
    <cfparam name="URL.schoolID" default="0">
    <cfparam name="URL.userID" default="0">
    <cfparam name="URL.name" default="">
    
    <cfquery name="qGetStudentListBeforeFilters" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT
        	s.studentid,
            s.uniqueid,
            s.firstname, 
            s.familylastname, 
            s.sex, 
            s.country, 
            u.userid, 
            u.businessname,
            sc.schoolid, 
            sc.schoolname,
            smg_countrylist.countryname, 
            smg_programs.programname,
            stu_prog.programid, 
            stu_prog.assignedid, 
            IFNULL(alp.name, 'n/a') AS PHPReturnOption
        FROM smg_students s
        INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
        LEFT JOIN smg_countrylist ON smg_countrylist.countryid = s.country  
        LEFT JOIN smg_programs ON smg_programs.programid = stu_prog.programid 
        LEFT JOIN smg_users u on u.userid = s.intrep 
        LEFT JOIN php_schools sc ON sc.schoolid = stu_prog.schoolid
        LEFT OUTER JOIN applicationlookup alp ON alp.fieldID = stu_prog.return_student
       		AND fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="PHPReturnOptions">
		
		<cfif client.usertype eq 7>
        	LEFT JOIN php_school_contacts on php_school_contacts.schoolid = stu_prog.schoolid
        </cfif>
        
        WHERE stu_prog.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            
		<cfif url.status EQ 'active'>
            AND stu_prog.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND stu_prog.canceldate IS NULL
        <cfelseif url.status EQ 'inactive'>
            AND stu_prog.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">            
            AND stu_prog.canceldate IS NULL
        <cfelseif url.status EQ 'cancelled'>
            AND stu_prog.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
            AND stu_prog.canceldate IS NOT NULL
        </cfif>
        
        <cfif url.placed EQ 'yes'>
            AND stu_prog.hostid != '0'	
        </cfif>
        
        <!----Limit by User---->
        <cfif client.usertype EQ 8>
            AND s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfif>
        
        <cfif client.usertype EQ 11>
        	AND s.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfif>
		
		<cfif client.usertype EQ 12>
	        AND stu_prog.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfif>
        
        <cfif client.usertype EQ 7>
        	AND php_school_contacts.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfif>
        
        ORDER BY #url.order#<cfif url.order EQ 'familylastname'>, firstname</cfif>
    </cfquery>
    
    <cfquery name="qGetPrograms" dbtype="query">
    	SELECT DISTINCT programID, programName
        FROM qGetStudentListBeforeFilters
        WHERE programID != 0
        ORDER BY programName
    </cfquery>
    
    <cfquery name="qGetSchools" dbtype="query">
    	SELECT DISTINCT schoolID, schoolName
        FROM qGetStudentListBeforeFilters
        ORDER BY schoolName
    </cfquery>
    
    <cfquery name="qGetReps" dbtype="query">
    	SELECT DISTINCT userID, businessName
        FROM qGetStudentListBeforeFilters
        ORDER BY businessName
    </cfquery>
    
    <cfscript>
		nameAsList = Replace(UCASE(URL.name)," ",",");
		placeInList = 1;
	</cfscript>
    
    <cfquery name="qGetStudentList" dbtype="query">
    	SELECT *
        FROM qGetStudentListBeforeFilters
        WHERE 1=1
        <cfif URL.programID GT 0>
        	AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.programID)#">
        </cfif>
        <cfif URL.schoolID GT 0>
        	AND schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.schoolID)#">
        </cfif>
        <cfif URL.userID GT 0>
        	AND userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.userID)#">
        </cfif>
        <cfif ListLen(nameAsList) GTE 1>
        	AND (
            	<cfloop list="#nameAsList#" index="i">
                	<cfif placeInList GT 1> OR </cfif>
                    UPPER(firstName) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
                    OR UPPER(familyLastName) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
                    OR studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(i)#">
                    <cfset placeInList = placeInList + 1>
                </cfloop>
          	)
        </cfif>
    </cfquery>
    
</cfsilent>

<cfoutput>

	<script type="text/javascript">
		function filterResultsByProgram(programID) {
			location="?curdoc=lists/students&order=#URL.order#&placed=#url.placed#&status=#url.status#&name=#URL.name#&schoolID=#URL.schoolID#&userID=#URL.userID#&programID=" + programID.value;
		}
		function filterResultsBySchool(schoolID) {
			location="?curdoc=lists/students&order=#URL.order#&placed=#url.placed#&status=#url.status#&name=#URL.name#&userID=#URL.userID#&programID=#URL.programID#&schoolID=" + schoolID.value;
		}
		function filterResultsByUser(userID) {
			location="?curdoc=lists/students&order=#URL.order#&placed=#url.placed#&status=#url.status#&name=#URL.name#&schoolID=#URL.schoolID#&programID=#URL.programID#&userID=" + userID.value;
		}
		function filterResultsByName(name) {
			location="?curdoc=lists/students&order=#URL.order#&placed=#url.placed#&status=#url.status#&schoolID=#URL.schoolID#&programID=#URL.programID#&userID=#URL.userID#&name=" + name.value;
		}
	</script>

	<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
        <tr valign=middle height=24>
            <td width="25%" valign="middle" bgcolor="##e9ecf1"><h2 align="left" class="style1">S t u d e n t s - #qGetStudentList.recordcount# records</h2></td>
            <td width="32%" height="24">
            	<b>
                    Program:&nbsp;
                   	<select name="programID" style="width:300px;" onchange="filterResultsByProgram(this);">
                    	<option value="-1">All</option>
                        <cfloop query="qGetPrograms">
                        	<option value="#programID#" <cfif URL.programID EQ programID>selected="selected"</cfif>>#programName#</option>
                        </cfloop>
                    </select>
                    <br/>
                    School:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <select name="schoolID" style="width:300px;" onchange="filterResultsBySchool(this);">
                    	<option value="-1">All</option>
                        <cfloop query="qGetSchools">
                        	<option value="#schoolID#" <cfif URL.schoolID EQ schoolID>selected="selected"</cfif>>#schoolName#</option>
                        </cfloop>
                    </select>
                    <br/>
                    Intl. Rep:&nbsp;
                    <select name="userID" style="width:300px;" onchange="filterResultsByUser(this);">
                    	<option value="-1">All</option>
                        <cfloop query="qGetReps">
                        	<option value="#userID#" <cfif URL.userID EQ userID>selected="selected"</cfif>>#businessName#</option>
                        </cfloop>
                    </select>
                    <br/>
                    Name/ID:
                    <input type="text" name="name" style="width:298px;" value="#URL.name#" onchange="filterResultsByName(this);" />
                </b>
            </td>
            <td width="42%" align="right" valign="top" bgcolor="##e9ecf1"><br>
                Filter: &nbsp;  <a href="?curdoc=lists/students&order=#url.order#&placed=all&status=all">All</a>
                &nbsp; | &nbsp; <a href="?curdoc=lists/students&order=#url.order#&placed=all&status=active">Active</a>
                &nbsp; | &nbsp; <a href="?curdoc=lists/students&order=#url.order#&placed=yes&status=active">Active Placed with HF</a> 
                &nbsp; | &nbsp; <a href="?curdoc=lists/students&order=#url.order#&status=inactive">Inactive</a> 
                &nbsp; | &nbsp; <a href="?curdoc=lists/students&order=#url.order#&status=cancelled">Cancelled</a></td>
            <td width="1%"></td>
        </tr>
    </table>
    
    <table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
        <tr>
            <th width=30 align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/students&order=studentid&placed=#url.placed#&status=#url.status#">ID</a></th>
            <th width=120 background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/students&order=firstname&placed=#url.placed#&status=#url.status#">First Name</a></th>
            <th width=120 background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/students&order=familylastname&placed=#url.placed#&status=#url.status#">Last Name</a></th>
            <th width=50 background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/students&order=sex&placed=#url.placed#&status=#url.status#">Sex</a></th>
            <th width=90 background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/students&order=countryname&placed=#url.placed#&status=#url.status#">Country</a></th>
            <th width=80 background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/students&order=programname&placed=#url.placed#&status=#url.status#">Program</a></th>
            <th width=80 background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/students&order=schoolname&placed=#url.placed#&status=#url.status#">School</a></th>
            <th width=80 background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/students&order=schoolname&placed=#url.placed#&status=#url.status#">Return/Trans/Ext</a></th>
            <cfif client.usertype lte 4>
            	<th width=100 background="images/back_menu2.gif" align="left"><a href="?curdoc=lists/students&order=businessname&placed=#url.placed#&status=#url.status#">Intl. Rep.</a></th>
         	</cfif>
        </tr>
    	<cfif qGetStudentList.recordcount eq 0>
        	<tr>
            	<td colspan=9 align="center"><br>You currently have no students in the system.</td>
        	</tr>
    	<cfelse>
    		<cfloop query="qGetStudentList">
				<tr bgcolor="###iif(qGetStudentList.currentrow MOD 2 ,DE("e9ecf1") ,DE("FFFFFF") )#">
            		<td>
						<cfif client.usertype GTE 5>
                        	<a href="?curdoc=student/student_profile&unqid=#uniqueid#&assignedid=#assignedid#">#studentid#</a>
                     	<cfelse>
                        	<a href="?curdoc=student/student_info&unqid=#uniqueid#&assignedid=#assignedid#">#studentid#</a>
                      	</cfif>
               		</td>
            		<td>
						<cfif client.usertype GTE 5>
                        	<a href="?curdoc=student/student_profile&unqid=#uniqueid#&assignedid=#assignedid#">#firstname#</a>
                      	<cfelse>
                        	<a href="?curdoc=student/student_info&unqid=#uniqueid#&assignedid=#assignedid#">#firstname#</a>
                     	</cfif>
                 	</td>
            		<td>
						<cfif client.usertype GTE 5>
                        	<a href="?curdoc=student/student_profile&unqid=#uniqueid#&assignedid=#assignedid#">#familylastname#</a>
                     	<cfelse>
                        	<a href="?curdoc=student/student_info&unqid=#uniqueid#&assignedid=#assignedid#">#familylastname#</a>
                    	</cfif>
                	</td>
                    <td>#sex#</td>
                    <td>#countryname#</td>
                    <td>#programname#</td>
                    <td>
                        <cfif client.usertype LTE 4>
                            <a href="?curdoc=forms/view_school&sc=#schoolid#" target="_blank">#schoolname#</a>
                        <cfelse>
                            #schoolname#
                        </cfif>
                    </td>
                    <td>#qGetStudentList.PHPReturnOption#</td>
                    <cfif client.usertype lte 4>
                        <td>
                            <a href="?curdoc=users/user_info&userid=#userid#" target="_blank">#businessname#</a>
                        </td>
                    </cfif>
                </tr>
    		</cfloop>
    	</cfif>
    </table>
    
    <br/><br/>

</cfoutput>

<cfif client.usertype lte 4>
	<div align="center">
		<a href="index.cfm?curdoc=student/new_student"><img src="pics/add-student.gif" border="0" align="middle" alt="Add a Student"></img></a>
	</div>
    <br/>
</cfif>