<script src="linked/js/jquery.colorbox.js"></script>
	<!----open window details---->
	<script>
        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"60%", height:"60%", iframe:true, 
            
               onClosed:function(){ location.reload(true); } });

        });
    </script>
<!--- delete school date. --->
<cfif isDefined("url.delete_date")>
    <cfquery datasource="#application.dsn#">
        DELETE FROM smg_school_dates
        WHERE schooldateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.delete_date#">
    </cfquery>
</cfif>

<cfparam name="url.schoolid" default="">
<cfif not isNumeric(url.schoolid)>
    a numeric schoolid is required to view a school.
    <cfabort>
</cfif>

<cfquery name="get_school" datasource="#application.dsn#">
	SELECT *
	FROM smg_schools
	WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schoolid#">
</cfquery>

<cfif get_school.recordcount EQ 0>
	The school ID you are looking for, <cfoutput>#url.schoolid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the school record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view this host family
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top"><td>

	<cfoutput>
	<!--- HEADER OF TABLE --- School Information --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>School Information</h2></td>
			<cfif client.usertype LTE '4'>
            	<td background="pics/header_background.gif"><a href="?curdoc=querys/delete_school&schoolid=#get_school.schoolid#" onClick="return confirm('You are about to delete this School. You will not be able to recover this information. Click OK to continue.')"><img src="pics/deletex.gif" border="0" alt="Delete"></a></td>
            </cfif>
			<td background="pics/header_background.gif" width=16><a href="?curdoc=forms/school_form&schoolid=#get_school.schoolid#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<!--- BODY OF A TABLE --->
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td>School Name:</td><td>#get_school.schoolname#</td><td>ID:</td><td>#get_school.schoolid#</td></tr>
		<tr><td>Address:</td><td>#get_school.address#<br />#get_school.address2#</td></tr>
		<tr><td>City:</td><td>#get_school.city#</td></tr>
		<tr><td>State:</td><td>#get_school.state#</td><td>Zip:</td><td>#get_school.zip#</td></tr>
		<tr><td>Contact:</td><td>#get_school.principal#</td><td>Contact Email:</td><td><a href="mailto:#get_school.email#">#get_school.email#</a></td></tr>
		<tr><td>Phone:</td><td>#get_school.phone#</td><td>Fax:</td><td>#get_school.fax#</td></tr>
		<tr>
			<td>Web Site:</td>
			<td>
	        	<!--- url validation was recently added to the form, so some values might have http:// and some might not. --->
	            <cfif get_school.url neq ''>
					<cfif left(get_school.url, 7) eq 'http://'>
	                    <a href="#get_school.url#" target="_blank">#get_school.url#</a>
	                <cfelse>
	                    <a href="http://#get_school.url#" target="_blank">http://#get_school.url#</a>
	                </cfif>
	            </cfif>
       	 	</td>
			<td>Number of Students</td>
			<td>#get_school.numberOfStudents#</td>
		</tr>
	</table>
	<!--- BOTTOM OF A TABLE --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>
    </cfoutput>
    	
</td>
<!--- SEPARATE TABLES --->
<td width="2%"></td>
<td>

    <cfquery name="get_school_dates" datasource="#application.dsn#">
        SELECT schooldateid, enrollment, year_begins, semester_ends, semester_begins, year_ends, fiveStudentAssigned,smg_seasons.season, smg_school_dates.seasonid
        FROM smg_school_dates INNER JOIN smg_seasons ON smg_seasons.seasonid = smg_school_dates.seasonid
        WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_school.schoolid#">
        AND smg_seasons.active = '1'
        ORDER BY smg_seasons.season
    </cfquery>

	<!--- HEADER OF TABLE --- School Dates --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>School Dates</h2></td>
    	    <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/school_date_form&schoolid=<cfoutput>#get_school.schoolid#</cfoutput>">Add School Date</a></td>
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
    <!--- BODY OF TABLE --->
    <table width=100% border=0 cellpadding=2 cellspacing=0 class="section">
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><u>Season</u></td>
            <td><u>Enroll/Orient.</u></td>
            <td><u>Year Begins</u></td>
            <td><u>1st Sem. Ends</u></td>
            <td><u>2nd Sem. Begins</u></td>
            <td><u>Year Ends</u></td>
            <td><u>5th Student</u></td>
        </tr>
        <cfif get_school_dates.recordcount is 0>
            <tr><td colspan="8" align="center">There are no dates for this school.</td></tr>
        <cfelse>		
            <cfoutput query="get_school_dates">
			   <cfscript>	
                    // Get the letter info
                    qGetSchoolDocs = APPCFC.DOCUMENT.getDocuments(foreignTable='school_info',foreignid=get_school.schoolid,seasonid=get_school_dates.seasonid);
              </cfscript>
            
                <tr <cfif currentRow MOD 2 EQ 0>bgcolor="EAE8E8"</cfif>>
                    <td><a href="index.cfm?curdoc=school_info&delete_date=#schooldateid#&schoolid=#get_school.schoolid#" onClick="return confirm('Are you sure you want to delete this School Date?')"><img src="pics/deletex.gif" border="0" alt="Delete"></a></td>
                    <td><a href="index.cfm?curdoc=forms/school_date_form&schooldateid=#schooldateid#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>
                    <td>#season#</td>
                    <td >#DateFormat(enrollment, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(year_begins, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(semester_ends, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(semester_begins, 'mm/dd/yyyy')#</td>
                    <td>#DateFormat(year_ends, 'mm/dd/yyyy')#</td>
                    <td <Cfif isDate(fiveStudentAssigned) AND qGetSchoolDocs.recordcount eq 0>bgcolor="##FFFF99"</cfif>>
						<!---If a date is showen, but no file, dispaly upload dialog---->
						<Cfif isDate(fiveStudentAssigned)>
                    		<a class='iframe' href="schoolInfo/fifthStudentLetter.cfm?schoolid=#get_school.schoolid#&season=#seasonid#&seasonLabel=#season#&letterDate=#DateFormat(fiveStudentAssigned, 'mm/dd/yyyy')#">#DateFormat(fiveStudentAssigned, 'mm/dd/yyyy')#</a>
                        </Cfif>
                    </td>
                </tr>
            </cfoutput>
        </cfif>
    </table>
	<!--- BOTTOM OF A TABLE --->
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>	

</td></tr>
</table><br>

<cfif client.usertype LTE 5>

    <cfquery name="hosting_students" datasource="#application.dsn#">
        SELECT
        	s.firstname, 
            s.familylastname, 
            s.studentid, 
            s.sex, 
            s.countryresident, 
            s.schoolid, 
            s.programid, 
            s.active,
			u.businessname, 
            c.companyshort, 
            country.countryname, 
            p.programname
        FROM 
        	smg_students s 
        INNER JOIN 
        	smg_users u 
        ON 
        	s.intrep = u.userid
        INNER JOIN 
        	smg_companies c 
        ON
        	c.companyid = s.companyid
        LEFT JOIN 
        	smg_programs p 
        ON 
        	p.programid = s.programid
        LEFT JOIN 
        	smg_countrylist country 
        ON 
        	s.countryresident = country.countryid
        WHERE 
        	s.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_school.schoolid#">
		<cfif CLIENT.companyID EQ 10>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelseif CLIENT.companyID EQ 14>
        	AND 
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>   
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        </cfif>
        and s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        ORDER BY 
        	c.companyshort, 
            p.programname, 
            s.firstname
    </cfquery>
    
    <cfquery name="hosted_students" datasource="#application.dsn#">
        SELECT 
        	s.firstname, 
        	s.familylastname, 
        	s.studentid, 
        	s.sex, 
        	s.countryresident, 
        	s.programid, 
        	s.active,
			u.businessname, 
        	c.companyshort, 
        	country.countryname, 
        	p.programname, 
        	hist.reason
        FROM 
        	smg_students s 
        INNER JOIN 
        	smg_users u 
        ON 
        	s.intrep = u.userid
        INNER JOIN 
        	smg_companies c 
        ON 
        	c.companyid = s.companyid
        INNER JOIN 
        	smg_hosthistory hist 
        ON 
        	hist.studentid = s.studentid
        LEFT JOIN 
        	smg_programs p 
        ON 
       		p.programid = s.programid
        LEFT JOIN 
        	smg_countrylist country 
        ON 
        	s.countryresident = country.countryid
        WHERE 
        	hist.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_school.schoolid#">
        AND 
        	hist.reason != 'Original Placement'
		<cfif CLIENT.companyID EQ 10>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelseif CLIENT.companyID EQ 14>
        	AND 
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        </cfif>	
        and s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        ORDER BY 
        	c.companyshort, 
        	p.programname, 
        	s.firstname
    </cfquery>

	<style type="text/css">
    div.scroll {
        height: 250px;
        width:auto;
        overflow:auto;
        border-left: 2px solid #c6c6c6;
        border-right: 2px solid #c6c6c6;
        left:auto;
    }
    </style>

    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    <tr valign="top"><td>
              
        <!--- HEADER OF TABLE --- STUDENTS --->
        <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
            <tr height=24>
                <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
                <td background="pics/header_background.gif"><h2>Students</h2></td>
                <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
            </tr>
        </table>
        <table width=100% class="section">
            <tr>
                <td></td>
            </tr>
        </table>
        <!--- BODY OF TABLE --->
        <div class="scroll">
        <table width=100% border=0 cellpadding=2 cellspacing=0>
            <tr align="center"><th colspan="8">Current Students</th></tr>
            <tr>
            	<td><u>Program Manager</u></td>
            	<td><u>ID</u></td>
                <td><u>Name</u></td>
                <td><u>Sex</u></td>
                <td><u>Country</u></td>
                <td><u>Intl. Rep.</u></td>
                <td><u>Program</u></td>
                <td><u>Active</u></td>
            </tr>
            <cfif hosting_students.recordcount is 0>
                <tr><td colspan="8" align="center">There are no current students assigned to this school.</td></tr>
            <cfelse>		
                <cfoutput query="hosting_students">
                    <tr <cfif currentRow MOD 2 EQ 0>bgcolor="EAE8E8"</cfif>>
                    	<td>#companyshort#</td>
                    	<td>#studentid#</td>
                        <td><A href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</A></td>
                        <td>#sex#</td>
                        <td>#countryname#</td>
                        <td>#businessname#</td>
                        <td>#programname#</td>
                        <td>#yesNoFormat(active)#</td>
                    </tr>
                </cfoutput>
            </cfif>
        </table><br />
        <table width=100% border=0 cellpadding=2 cellspacing=0>
            <tr align="center"><th colspan="8">School History</th></tr>
            <tr>
            	<td><u>Program Manager</u></td>
            	<td><u>ID</u></td>
                <td><u>Name</u></td>
                <td><u>Sex</u></td>
                <td><u>Country</u></td>
                <td><u>Intl. Rep.</u></td>
                <td><u>Program</u></td>
                <td><u>Active</u></td>
            </tr>
            <cfif hosted_students.recordcount is 0>
                <tr><td colspan="8" align="center">There are no history records for this school.</td></tr>
            <cfelse>			
                <cfoutput query="hosted_students">
                    <tr <cfif currentRow MOD 2 EQ 0>bgcolor="EAE8E8"</cfif>>
                    	<td>#companyshort#</td>
                    	<td>#studentid#</td>
                        <td><A href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</A></td>
                        <td>#sex#</td>
                        <td>#countryname#</td>
                        <td>#businessname#</td>
                        <td>#programname#</td>
                        <td>#yesNoFormat(active)#</td>
                    </tr>
					<tr <cfif currentRow MOD 2 EQ 0>bgcolor="EAE8E8"</cfif>><td colspan="8">Reason for changing: #reason#</td></tr>	
                </cfoutput>
            </cfif>
        </table>
        </div>			
        <!--- BOTTOM OF A TABLE --- STUDENTS  --->
        <table width=100% cellpadding=0 cellspacing=0 border=0>
            <tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
        </table>

    </td></tr>
    </table>
    
</cfif>