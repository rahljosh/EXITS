<!--- Kill Extra Output --->
<cfsilent>

    <cfsetting requesttimeout="9999">

    <cfinclude template="querys/get_latest_status.cfm">
    <cfinclude template="querys/get_student_info.cfm">	
    
    <cfscript>
		get_field = '';
		countRed = 0;
	</cfscript>
    
    <cfloop from="1" to="14" index="i">
    	<cfset "count#i#" = 0>
    </cfloop>
    
    <cfquery name="smg_students" datasource="MySql">
        SELECT 
            s.*, 
            u.businessname, 
            u.businessname, 
            u.master_accountid, 
            app_indicated_program
        FROM 
            smg_students s
        INNER JOIN 
            smg_users u ON u.userid = s.intrep
        WHERE 
            studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentid#">
    </cfquery>
    
    <cfquery name="smg_student_siblings" datasource="MySql">
        SELECT 
        	childid, 
            studentid, 
            birthdate, 
            sex, 
            liveathome, 
            name 
        FROM 
        	smg_student_siblings
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#smg_students.studentid#">
        ORDER BY 
        	childid
    </cfquery>
    
    <cfquery name="smg_student_app_family_album" datasource="MySql">
        SELECT 	
        	id, 
            studentid, 
            description, 
            filename
        FROM 
        	smg_student_app_family_album
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#smg_students.studentid#">
    </cfquery>
    
    <cfquery name="smg_student_app_school_year" datasource="MySql">
        SELECT 
        	yearid, 
            studentid, 
            beg_year, 
            end_year, 
            class_year 
        FROM 
        	smg_student_app_school_year
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#smg_students.studentid#">
    </cfquery>
    
    <cfquery name="smg_student_app_grades" datasource="MySql">
        SELECT 
        	gradesid, 
            smg_student_app_grades.yearid, 
            class_name, 
            hours, grade 
        FROM 
        	smg_student_app_grades
        INNER JOIN 
        	smg_student_app_school_year ON smg_student_app_school_year.yearid = smg_student_app_grades.yearid
        WHERE 
        	smg_student_app_school_year.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#smg_students.studentid#">
    </cfquery>
    
    <cfquery name="smg_student_app_health" datasource="MySql">
        SELECT 
        	* 
        FROM 
        	smg_student_app_health
        WHERE 
        	studentid = <cfqueryparam value="#smg_students.studentid#" cfsqltype="cf_sql_integer">
    </cfquery>
    
    <cfquery name="smg_student_app_state_requested" datasource="MySql">
        SELECT 
            statechoiceid, 
            studentid, 
            state1, 
            state2, 
            state3
        FROM 
            smg_student_app_state_requested
        WHERE 
            studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#smg_students.studentid#">
    </cfquery>
    <cfquery name="smg_student_app_city_requested" datasource="MySql">
        SELECT 
            citychoiceid, 
            studentid, 
            city1, 
            city2, 
            city3
        FROM 
            smg_student_app_city_requested
        WHERE 
            studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#smg_students.studentid#">
    </cfquery>
    <cfquery name="qGetPages" datasource="MySql">
        SELECT
            page
        FROM 
            smg_student_app_field
        GROUP BY 
            page
        ORDER BY 
            page 
    </cfquery>
    
    <cfloop query="qGetPages">
        
        <cfquery name="page#qGetPages.page#" datasource="MySql">
            SELECT 
                fieldid, 
                field_label, 
                required, 
                section, 
                page, 
                field_order, 
                field_name, 
                table_located 
            FROM 
                smg_student_app_field
            WHERE 
                page = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPages.page#">
            ORDER BY 
                field_order
        </cfquery>
        
    </cfloop>
   
    <!--- Check for Uploaded Files --->
    
    <!--- Passport Photo --->
    <cfdirectory directory="#AppPath.onlineApp.picture#" name="check_01_upload" filter="#smg_students.studentid#.*">
    
    <!--- Family Album --->
    <cfdirectory name="page04_family_album" directory="#AppPath.onlineApp.familyAlbum##smg_students.studentid#">
    
    <!--- Students Letter --->
    <cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="check_05_upload" filter="#smg_students.studentid#.*">
    
    <!--- Parents Letter --->
    <cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="check_06_upload" filter="#smg_students.studentid#.*">
    
    <!--- Inserts --->
    <cfloop list="08,09,10,11,12,13,14,15,16,17,18,19,20,21" index="i">
        <cfdirectory directory="#AppPath.onlineApp.inserts#page#i#" name="check_#i#_upload" filter="#smg_students.studentid#.*">	
    </cfloop>
    
</cfsilent>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Check List</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfoutput>
<div class="section"><br>
<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
    	<td>
        	<div align="justify">
            	This page lists all the items that have not been completed. 
                Items in <font color="FF0000"><b>RED ARE REQUIRED</b></font> AND
                items in <font color="0000FF"><b>BLUE ARE OPTIONAL.</b></font> 
                For your convenience, the list is divided by pages.
            </div>
    	</td>
	</tr>
    
	<tr><td>&nbsp;</td></tr>

	<!--- PAGE 01 --->
	<tr><td><a href="index.cfm?curdoc=section1/page1&id=1&p=1"><h3>Page [01] - Student's Information</h3></a></td></tr>
	<cfif NOT check_01_upload.recordcount>
		<tr><td><font color="FF0000">Student Passport Picture</font><br></td></tr>
		<cfset count1 = 1> 
		<cfset countRed = countRed + 1>
	</cfif>	
    	
	<cfloop query="page1">
		<cfset get_field = page1.table_located &"."& page1.field_name>
		<cfif NOT LEN(get_field) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr>
			<cfset count1 = 1> 
			<cfset countRed = countRed + 1>
		<cfelseif NOT LEN(get_field) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr>
			<cfset count1 = 1>
		</cfif>
	</cfloop>
	
	<cfif NOT VAL(count1)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>
	
	<!--- PAGE 02 --->
	<tr><td><a href="index.cfm?curdoc=section1/page2&id=1&p=2"><h3>Page [02] - Brothers & Sisters</h3></a></td></tr>
	<cfloop query="page2">
		<cfset get_field = page2.table_located &"."& page2.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr>
			<cfset count2 = 1> 
			<cfset countRed = countRed + 1>		 
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr>
			<cfset count2 = 1>		
		</cfif>
	</cfloop>
	
	<cfif NOT VAL(count2)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
    
	<tr><td>&nbsp;</td></tr>
	
	<!--- PAGE 03 --->
	<tr><td><a href="index.cfm?curdoc=section1/page3&id=1&p=3"><h3>Page [03] - Personal Data</h3></a></td></tr>
	<cfloop query="page3">
		<cfset get_field = page3.table_located &"."& page3.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr>
			<cfset count3 = 1> 
			<cfset countRed = countRed + 1>		 
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr>
			<cfset count3 = 1>		
		</cfif>
	</cfloop>
    
	<cfif NOT VAL(count3)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>
	
	<!--- PAGE 04 --->
	<tr><td><a href="index.cfm?curdoc=section1/page4&id=1&p=4"><h3>Page [04] - Family Pictures</h3></a></td></tr>
	<cfloop query="page4">
		<cfset get_field = page4.table_located &"."& page4.field_name>
		<cfif required EQ 1 AND page04_family_album.recordcount EQ 0>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr>
			<cfset count4 = 1> 
			<cfset countRed = countRed + 1>
		<cfelse>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr>
			<cfset count4 = 1>
		</cfif>
	</cfloop>
	
	<cfif NOT VAL(count4)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>	
    
	<tr><td>&nbsp;</td></tr>
	
	<!--- PAGE 05 --->
	<tr><td><a href="index.cfm?curdoc=section1/page5&id=1&p=5"><h3>Page [05] - Student's Letter</h3></a></td></tr>
	<cfif NOT check_05_upload.recordcount>
		<cfloop query="page5">
			<cfset get_field = page5.table_located &"."& page5.field_name>
			<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
				<tr><td><font color="FF0000">#field_label#</font><br></td></tr>
				<cfset count5 = 1> 
				<cfset countRed = countRed + 1>
			<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
				<tr><td><font color="0000FF">#field_label#</font><br></td></tr>
				<cfset count5 = 1>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif NOT VAL(count5)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>	
	
    <tr><td>&nbsp;</td></tr>
	
	<!--- PAGE 06 --->
	<tr><td><a href="index.cfm?curdoc=section1/page6&id=1&p=6"><h3>Page [06] - Parent's Letter</h3></a></td></tr>
	<cfif NOT check_06_upload.recordcount>
		<cfloop query="page6">
			<cfset get_field = page6.table_located &"."& page6.field_name>
			<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
				<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
				<cfset count6 = 1> 
				<cfset countRed = countRed + 1>
			<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
				<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
				<cfset count6 = 1>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif NOT VAL(count6)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>	
	
	<!--- PAGE 07 --->
	<tr><td><a href="index.cfm?curdoc=section2/page7&id=2&p=7"><h3>Page [07] - School Information</h3></a></td></tr>
	<cfloop query="page7">
		<cfset get_field = page7.table_located &"."& page7.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
			<cfset count7 = 1> 
			<cfset countRed = countRed + 1>
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
			<cfset count7 = 1>
		</cfif>
	</cfloop>
	
	<cfif NOT VAL(count7)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>	
	
	<!--- PAGE 08 --->
	<tr><td><a href="index.cfm?curdoc=section2/page8&id=2&p=8"><h3>Page [08] - Transcript of Grades</h3></a></td></tr>
	<cfloop query="page8">
		<cfset get_field = page8.table_located &"."& page8.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
			<cfset count8 = 1> 
			<cfset countRed = countRed + 1>
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
			<cfset countRed = countRed + 1>
		</cfif>
	</cfloop>
	
	<cfif check_08_upload.recordcount EQ 0>
		<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		<cfset countRed = countRed + 1>
	<cfelse>	
		<cfif NOT VAL(count8)><tr><td><font color="0000FF">Complete</font><br></td></tr></cfif>
	</cfif>	
    	
	<tr><td>&nbsp;</td></tr>
	
	<!--- PAGE 09 --->
	<tr><td><a href="index.cfm?curdoc=section2/page9&id=2&p=9"><h3>Page [09] - Language Evaluation</h3></a></td></tr>
	<cfloop query="page9">
		<cfset get_field = page9.table_located &"."& page9.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
			<cfset count9 = 1> 
			<cfset countRed = countRed + 1>
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
			<cfset count9 = 1>
		</cfif>
	</cfloop>
	
	<cfif NOT VAL(count9)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>
	
	<!--- PAGE 10 --->
	<tr><td><a href="index.cfm?curdoc=section2/page10&id=2&p=10"><h3>Page [10] - Social Skills</h3></a></td></tr>
	<cfloop query="page10">
		<cfset get_field = page10.table_located &"."& page10.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
			<cfset count10 = 1> <cfset countRed = countRed + 1>
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
			<cfset count10 = 1>
		</cfif>
	</cfloop>
    
	<cfif check_10_upload.recordcount EQ 0>
		<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		<cfset countRed = countRed + 1>
	</cfif>	
    	
	<cfif NOT VAL(count10)>
   		<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>	
	
	<!--- PAGE 11 --->
	<tr><td><a href="index.cfm?curdoc=section3/page11&id=3&p=11"><h3>Page [11] - Health Questionnaire</h3></a></td></tr>
	<cfloop query="page11">
		<cfset get_field = page11.table_located &"."& page11.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
			<cfset count11 = 1> <cfset countRed = countRed + 1>
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
			<cfset count11 = 1>
		</cfif>
	</cfloop>
	
	<cfif NOT VAL(count11)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>

	<!--- PAGE 12 --->
	<tr><td><a href="index.cfm?curdoc=section3/page12&id=3&p=12"><h3>Page [12] - Clinical Evaluation</h3></a></td></tr>
	<cfloop query="page12">
		<cfset get_field = page12.table_located &"."& page12.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
			<cfset count12 = 1> <cfset countRed = countRed + 1>
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
			<cfset count12 = 1>
		</cfif>
	</cfloop>
	
	<cfif check_12_upload.recordcount EQ 0>
		<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		<cfset countRed = countRed + 1>
	</cfif>	
	
	<cfif NOT VAL(count12)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>

	<!--- PAGE 13 --->
	<tr><td><a href="index.cfm?curdoc=section3/page13&id=3&p=13"><h3>Page [13] - Immunization Record</h3></a></td></tr>
	<cfset lastvaccine = ''>
	<cfloop query="page13">
		<cfif lastvaccine NEQ page13.field_label>
			<cfquery name="smg_student_app_shots" datasource="MySql">
				SELECT vaccineid, studentid, vaccine, disease, shot1, shot2, shot3, shot4, shot5, booster  
				FROM smg_student_app_shots
				WHERE vaccine = '#page13.field_label#' AND studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		<cfset lastvaccine = page13.field_label>
		
		<cfset get_field = page13.table_located &"."& page13.field_name>
		<cfif LEN(Evaluate(get_field)) AND page13.required EQ 1>
			<tr><td><font color="FF0000">#page13.field_label# - #page13.field_name# </font><br></td></tr> 
			<cfset count13 = 1> <cfset countRed = countRed + 1>
		<cfelseif LEN(Evaluate(get_field)) AND page13.required EQ 0>
			<tr><td><font color="0000FF">#page13.field_label# - #page13.field_name#</font><br></td></tr> 
			<cfset count13 = 1> 
		</cfif>
	</cfloop>
    
	<cfif check_13_upload.recordcount EQ 0>
		<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		<cfset countRed = countRed + 1>
	</cfif>	
    	
	<cfif NOT VAL(count13)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>

	<!--- PAGE 14 --->
	<tr><td><a href="index.cfm?curdoc=section3/page14&id=3&p=14"><h3>Page [14] - Authorization to Treat a Minor</h3></a></td></tr>
	<cfloop query="page14">
		<cfset get_field = page14.table_located &"."& page14.field_name>
		<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
			<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
			<cfset count14 = 1> <cfset countRed = countRed + 1>
		<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
			<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
			<cfset count14 = 1>
		</cfif>
	</cfloop>
    
	<cfif check_14_upload.recordcount EQ 0>
		<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		<cfset count14 = 1>
		<cfset countRed = countRed + 1>
	</cfif>	
    
	<cfif NOT VAL(count14)>
    	<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>
	
	<!--- PAGE 15 --->
	<tr><td><a href="index.cfm?curdoc=section4/page15&id=4&p=15"><h3>Page [15] - Program Agreement</h3></a></td></tr>
	<cfif check_15_upload.recordcount EQ 0>
		<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		<cfset countRed = countRed + 1> 
	<cfelse>
		<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>		
	
	<!--- PAGE 16 --->
	<tr><td><a href="index.cfm?curdoc=section4/page16&id=4&p=16"><h3>Page [16] - Liability Release</h3></a></td></tr>
	<cfif check_16_upload.recordcount EQ 0>
		<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		<cfset countRed = countRed + 1> 
	<cfelse>
		<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>		

	<!--- PAGE 17 --->
	<tr><td><a href="index.cfm?curdoc=section4/page17&id=4&p=17"><h3>Page [17] - Travel Authorization</h3></a></td></tr>
	<cfif check_17_upload.recordcount EQ 0>
		<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		<cfset countRed = countRed + 1> 
	<cfelse>
		<tr><td><font color="0000FF">Complete</font><br></td></tr>
	</cfif>
	
    <tr><td>&nbsp;</td></tr>	
	<!----Page 18 doesn't apply to ESI---->
    <cfif client.companyid neq 14>
		<!--- PAGE 18 --->
        <tr><td><a href="index.cfm?curdoc=section4/page18&id=4&p=18"><h3>Page [18] - Private School</h3></a></td></tr>
        <cfloop query="page18">
            <cfset get_field = page18.table_located &"."& page18.field_name>
            <cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
                <tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
                <cfset countRed = countRed + 1>
            <cfelseif Evaluate(get_field) GT 0 AND check_18_upload.recordcount EQ 0>
                <tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
                <cfset countRed = countRed + 1> 
            <cfelseif (Evaluate(get_field) EQ 0) OR (Evaluate(get_field) GT 0 AND check_18_upload.recordcount NEQ 0)>
                <tr><td><font color="0000FF">Complete</font><br></td></tr>
            </cfif>
        </cfloop> 
	</cfif>
    <tr><td>&nbsp;</td></tr>	

	<!--- PAGE 19 --->
	<tr><td><a href="index.cfm?curdoc=section4/page19&id=4&p=19"><h3>Page [19] - Personal Interview & English Fluency Assessment</h3></a></td></tr>
	<!--- Intl. Representative Documents --->
	<cfif (client.usertype LTE 8 AND get_latest_status.status GT 2) OR (client.usertype EQ 11 AND get_latest_status.status GT 2)>
		<cfloop query="page19">
			<cfset get_field = page19.table_located &"."& page19.field_name>
			<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
				<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
				<cfset count19 = 1> <cfset countRed = countRed + 1>
			<cfelseif NOT LEN(Evaluate(get_field)) AND NOT VAL(required)>
				<tr><td><font color="0000FF">#field_label#</font><br></td></tr> 
				<cfset count19 = 1>
			</cfif>
		</cfloop>
		<cfif check_19_upload.recordcount NEQ 0>
			<tr><td><font color="0000FF">Complete</font><br></td></tr>
		<cfelse>
			<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
		</cfif>
	<!--- Intl. Representative Documents --->				
	<cfelse>
		<tr><td>This page will be completed and uploaded by <b><i>#smg_students.businessname#.</i></b></td></tr>
	</cfif> 	
		
    <tr><td>&nbsp;</td></tr>	
	<!----Page 18 doesn't apply to ESI---->
    <cfif client.companyid neq 14>
		<!--- PAGE 20 --->
        <tr><td><a href="index.cfm?curdoc=section4/page20&id=4&p=20"><h3>Page [20] - Regional Guarantee</h3></a></td></tr>
        <!--- Not Available in April or May - PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
        
        <cfif (DateFormat(now(), 'mm') EQ 4 OR dateFormat(now(), 'mm') EQ 5) AND (get_student_info.app_indicated_program EQ 1 OR get_student_info.app_indicated_program EQ '2')> 
            <tr><td><font color="0000FF">This page is not available in April or May.</font><br></td></tr> 
        <cfelse>
            <!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
            <cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (smg_students.master_accountid EQ 10115 OR smg_students.intrep EQ 10115 OR smg_students.intrep EQ 8318)>
                <tr><td><font color="0000FF">This page is not required or will be completed by <b><i>#smg_students.businessname#.</i></b></font><br></td></tr> 
            <cfelse>
                <cfloop query="page20">
                    <cfset get_field = page20.table_located &"."& page20.field_name>
                    <cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
                        <tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
                        <cfset countRed = countRed + 1>
                    <cfelseif Evaluate(get_field) GT 0 AND check_20_upload.recordcount EQ 0>
                        <tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
                        <cfset countRed = countRed + 1> 
                    <cfelseif (Evaluate(get_field) EQ 0) OR (Evaluate(get_field) GT 0 AND check_20_upload.recordcount NEQ 0)>
                        <tr><td><font color="0000FF">Complete</font><br></td></tr>
                    </cfif>
                </cfloop> 
            </cfif>
        </cfif>
	</cfif>
    <tr><td>&nbsp;</td></tr>

	<!--- PAGE 21 --->
	<tr><td><a href="index.cfm?curdoc=section4/page21&id=4&p=21"><h3>Page [21] - State Guarantee</h3></a></td></tr>
	<Cfif client.companyid eq 14>
		<cfif smg_student_app_city_requested.city1 EQ 0 AND smg_student_app_city_requested.city2 EQ 0 AND smg_student_app_city_requested.city3 EQ 0>
                    <tr><td><font color="0000FF">Complete</font><br></td></tr>
        <cfelse>
                <cfset countRed = countRed + 1>
                <tr><td><font color="FF0000">Please choose 3 city choices</font><br></td></tr>
        </cfif>	
    <cfelse>
	<!--- Not Available in April or May - PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
	<cfif (DateFormat(now(), 'mm') EQ 4 OR dateFormat(now(), 'mm') EQ 5)<!---- AND (get_student_info.app_indicated_program EQ 1 OR get_student_info.app_indicated_program EQ '2')---->> 
		<tr><td><font color="0000FF">This page is not available in April or May.</font><br></td></tr> 
	<cfelse>
		<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
		<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (smg_students.master_accountid EQ 10115 OR smg_students.intrep EQ 10115 OR smg_students.intrep EQ 8318)>
			<tr><td><font color="0000FF">This page is not required or will be completed by <b><i>#smg_students.businessname#.</i></b></font><br></td></tr> 
		<cfelse>
			<!--- student has choosen state guarantee --->
			<cfif smg_student_app_state_requested.recordcount GT 0 AND smg_student_app_state_requested.state1 GT 0>
				<cfif check_21_upload.recordcount EQ 0>
						<tr><td><font color="FF0000">This page has not been uploaded. You must print, sign, scan and upload this page.</font><br></td></tr>
						<cfset countRed = countRed + 1>
				<cfelse>
						<tr><td><font color="0000FF">Complete</font><br></td></tr>
				</cfif>
			<!--- student has not choosen if accetps state guarantee --->
			<cfelseif smg_student_app_state_requested.recordcount EQ 0>
				<cfloop query="page21">
					<cfset get_field = page21.table_located &"."& page21.field_name>
					<cfif NOT LEN(Evaluate(get_field)) AND required EQ 1>
						<tr><td><font color="FF0000">#field_label#</font><br></td></tr> 
					</cfif>
				</cfloop>		
				<cfset countRed = countRed + 1>
			<cfelseif smg_student_app_state_requested.state1 EQ 0 AND smg_student_app_state_requested.state2 EQ 0 AND smg_student_app_state_requested.state3 EQ 0>
				<tr><td><font color="0000FF">Complete</font><br></td></tr>
			</cfif>
		</cfif>
	</cfif>
    </Cfif>
	
    <tr><td><br><hr class="bar"></hr><br></td></tr>
	
	<!--- Application has been submitted --->
	<cfif (client.usertype EQ 10 AND get_latest_status.status EQ 3) or (client.usertype EQ 10 AND get_latest_status.status GTE 5)>
		<tr><td align="center">You have submitted your application on #DateFormat(get_latest_status.date, 'mm-dd-yyyy')#.</td></tr>
	</cfif>
	
	<cfif countRed EQ 0>
		<!--- Student to Intl. Rep --->
		<cfif get_latest_status.status LTE 2>
			<tr><td align="center">There are no required items that need to be filled out. <br> You are ready to submit your application to <b><i>Student Management Group</i></b>.</td></tr>
			<tr><td align="center">Please go to the <a href="?curdoc=initial_welcome">Welcome Page</a> and click on the submit button to submit this application.</td></tr>

		<!--- Intl. Rep to SMG --->
		<cfelseif get_latest_status.status EQ 3>
			<tr><td align="center">There are no required items that need to be filled out. <br> You are ready to submit your application to <b><i>Student Management Group</i></b>.</td></tr>
			<tr><td align="center">Please go to the <a href="?curdoc=initial_welcome">Welcome Page</a> and click on the submit button to submit this application.</td></tr>

		<!--- Application Approved by SMG --->
		<cfelseif get_latest_status.status EQ 7>
			<tr><td align="center">This application has been approved as of #DateFormat(get_latest_status.date, 'mm-dd-yyyy')#.</td></tr>
		</cfif>
	<cfelse>
		<tr>
        	<td align="center">
            	There are <font color="FF0000">	<b>#countRed# required field(s)</b></font> that have not been filled out yet. 
                In order to submit your online application you must fill out all required items.
            </td>
        </tr>	
	</cfif>	
	
    <tr><td>&nbsp;</td></tr>
	
    </table>
</div>
</cfoutput>

<!--- FOOTER OF TABLE --->
<cfinclude template="footer_table.cfm">
