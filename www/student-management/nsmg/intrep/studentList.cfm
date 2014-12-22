<!--- ------------------------------------------------------------------------- ----
	
	File:		studentList.cfm
	Author:		Marcus Melo
	Date:		June 28, 2012
	Desc:		Intl. Rep Student List

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param URL variables --->
    <cfparam name="URL.sortBy" default="">
    <cfparam name="URL.sortOrder" default="ASC">
    <cfparam name="URL.status" default="unplaced">
	
    <cfscript>
        // make sure we have a valid sortOrder value
		if ( NOT ListFind("ASC,DESC", URL.sortOrder) ) {
			URL.sortOrder = "ASC";				  
		}
	</cfscript>
    
	<!--- Get Approved Applications --->
    <cfquery name="qGetStudents" datasource="MySql">
        SELECT  
        	s.studentid, 
            s.firstname, 
            s.familyLastName, 
            s.sex, 
            s.regionassigned, 
            s.programID, 
            s.dateapplication, 
            s.regionguar,
            s.companyID, 
            s.state_guarantee, 
            s.uniqueid, 
            s.branchID, 
            s.host_fam_approved, 
            sh.hostID, 
            sh.datePlaced,
            sh.datePISEmailed,
            r.regionname,
            rg.regionname as r_guarantee,
            c.countryName,
            st.state,
            h.familyLastName as hostlastname,
            branch.businessname as branchName,
            office.businessname as officeName, 
            <!--- Used for EF Central Office --->
            office.master_account,
            p.programname,
            camp.name AS campName
        FROM 
        	smg_students s
		LEFT OUTER JOIN
        	smg_hosthistory sh ON sh.studentID = s.studentID
            AND
            	sh.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND	
            	sh.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
		LEFT OUTER JOIN
        	smg_programs p ON s.programID = p.programID
		LEFT OUTER JOIN
        	smg_regions r ON s.regionassigned = r.regionID
		LEFT OUTER JOIN
        	smg_countrylist c ON c.countryID = s.countryresident
		LEFT OUTER JOIN
        	smg_regions rg on s.regionalguarantee = rg.regionID
		LEFT OUTER JOIN
        	smg_states st ON s.state_guarantee = st.id
		LEFT OUTER JOIN
        	smg_hosts h ON sh.hostID = h.hostID
		LEFT OUTER JOIN
        	smg_users branch ON s.branchID = branch.userID
		LEFT OUTER JOIN
        	smg_users office ON s.intrep = office.userID
		LEFT OUTER JOIN
            smg_aypcamps camp ON s.aypenglish = camp.campID
        WHERE 
        	<!--- SHOW ONLY APPS APPROVED APPS --->
	        s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
		
		<cfif listFind("1,2,3,4,5", CLIENT.companyID)>
        	AND
            	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> ) 
        <cfelse>
        	AND
            	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        
        <cfswitch expression="#URL.status#">
        	
            <cfcase value="placed">
                AND 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
                AND 
                    sh.datePlaced IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                AND 
                    s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> ) 
            </cfcase>
        	
            <cfcase value="pending">
                AND 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">  
                AND 
                    sh.hostID IS NOT NULL
				AND 
                    s.host_fam_approved > <cfqueryparam cfsqltype="cf_sql_integer" value="4">	
				AND
					sh.datePISEmailed IS NOT NULL
            </cfcase>
            
            <cfcase value="unplaced">
                AND 
                	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                AND 
                	(
                    	sh.hostID IS NULL
                    OR 
                    	(
                            sh.hostID IS NOT NULL
                        AND 
                            s.host_fam_approved > <cfqueryparam cfsqltype="cf_sql_integer" value="4">	
                        AND
                            sh.datePISEmailed IS NULL
                   		)
                   )
            </cfcase>

            <cfcase value="inactive">
                AND 
                	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">  
                AND 
                	s.canceldate IS NULL
            </cfcase>

            <cfcase value="cancelled">
                AND 
                	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">  
                AND 
                	s.canceldate IS NOT NULL
            </cfcase>
        
        </cfswitch>
        
        <cfif CLIENT.usertype EQ 8>
            AND 
            	(
                	s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#"> 
                OR 
                	office.master_accountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                )
        <cfelse>
            AND 
            	s.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
        </cfif>
        
        ORDER BY 
        	<cfswitch expression="#URL.sortBy#">
            
				<cfcase value="studentid,familyLastName,firstname,sex,countryName,regionName,programName,hostlastname,datePlaced,companyShort,branchName,officeName,campName">
					#URL.sortBy# #URL.sortOrder#               
                </cfcase>            
            
            	<cfdefaultcase>
                	familyLastName #URL.sortOrder#
                </cfdefaultcase>
            
            </cfswitch>
            
    </cfquery>
	
	<cfsavecontent variable="vBuildOptions">
		<cfoutput>
            <font size=-1>
                [ <a href="?curdoc=intrep/int_php_students">Private High School</a> ] &nbsp; &middot; &nbsp;
                [ 
					<span class="<cfif URL.status EQ "placed">edit_link_selected<cfelse>edit_link</cfif>"><a href="?curdoc=intrep/studentList&status=placed">Placed</a></span> &middot;
                    <span class="<cfif URL.status EQ "pending">edit_link_selected<cfelse>edit_link</cfif>"><a href="?curdoc=intrep/studentList&status=pending">Pending</a></span> &middot;
					<span class="<cfif URL.status EQ "unplaced">edit_link_selected<cfelse>edit_link</cfif>"><a href="?curdoc=intrep/studentList&status=unplaced">Unplaced</a></span> &middot; 
					<span class="<cfif URL.status EQ "all">edit_link_selected<cfelse>edit_link</cfif>"><a href="?curdoc=intrep/studentList&status=all">All</a></span> &middot; 
					<span class="<cfif URL.status EQ "inactive">edit_link_selected<cfelse>edit_link</cfif>"><a href="?curdoc=intrep/studentList&status=inactive">Inactive</a></span> &middot; 
					<span class="<cfif URL.status EQ "cancelled">edit_link_selected<cfelse>edit_link</cfif>"><a href="?curdoc=intrep/studentList&status=cancelled">Cancelled</a></span>
                ] 
                
                #qGetStudents.recordcount# students displayed 
            </font>
        </cfoutput>
    </cfsavecontent>    

</cfsilent>

<!--- INTL AGENT --->
<cfif NOT ListFind("8,11", CLIENT.usertype)>
	You do not have rights to see the students.
	<cfabort>
</cfif>

<style type="text/css">
	<!--
	div.scroll {
		height: 500px;
		width: 100%;
		overflow: auto;
		border-left: 1px solid #c6c6c6; 
		border-right: 1px solid #c6c6c6;
		background: #Ffffe6;
	}
	-->
</style>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="students.gif"
	tableTitle="Public High School Students"
    tableRightTitle="#vBuildOptions#"
	width="100%"
/>    

<table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
	<tr><td width="3%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='studentID',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Student ID">ID</a></td>
		<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='familyLastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Last Name">Last Name</a></td>
		<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='firstName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By First Name">First Name</a></td>
		<td width="5%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='sex',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Sex">Sex</a></td>
		<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='countryName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Country">Country</a></td>
		<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='regionName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Region">Region</a></td>
		<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='programName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Program">Program</a></td>
        <td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='campName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Program">Pre-Ayp Camp</a></td>
		<cfif URL.status NEQ "unplaced">
			<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='hostLastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Family">Family</a></td>
			<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='datePlaced',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Placement Date">Placement Date</a></td>
		</cfif>
		<cfif NOT VAL(qGetStudents.master_account)>
			<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='offieName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Office">Office</a></td>
		<cfelse>
			<td width="10%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='branchName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Branch">Branch</a></td>
		</cfif>
		<td width="2%">&nbsp;</td>
	</tr>
</table>

<div class="scroll">
    <table width="100%">
        <cfloop query="qGetStudents">
        	
            <cfscript>
				// Public Students Link
				urllink="index.cfm?curdoc=intrep/int_student_info&unqid=#qGetStudents.uniqueid#";
			</cfscript>
            
            <tr bgcolor="<cfif qGetStudents.dateapplication GT CLIENT.lastlogin>##e2efc7<cfelse>#iif(qGetStudents.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#</cfif>">
                <td width="3%"><a href="#urllink#" title="view student detail page">#qGetStudents.Studentid#</a></td>
                <td width="10%"><a href="#urllink#" title="view student detail page">#qGetStudents.familyLastName#</a></td>
                <td width="10%"><a href="#urllink#" title="view student detail page">#qGetStudents.firstname#</a></td>
                <td width="5%">#qGetStudents.sex#</td>
                <td width="10%">#qGetStudents.countryName#</td>
                <td width="10%">
                    #qGetStudents.regionname# 
                    <cfif qGetStudents.regionguar EQ 'yes'>
                        <font color="CC0000">
                            <cfif NOT LEN(qGetStudents.r_guarantee) AND NOT VAL(qGetStudents.state_guarantee)>
                                * Missing
                            <cfelseif LEN(qGetStudents.r_guarantee)>
                                * #qGetStudents.r_guarantee#
                            <cfelseif VAL(qGetStudents.state_guarantee)>
                                * #qGetStudents.state#
                            </cfif>
                        </font>
                    </cfif>
                </td>
                <td width="10%">#qGetStudents.programname#</td>
                <td width="10%">#qGetStudents.campName#</td>
                <cfif URL.status NEQ "unplaced">
                    <td width="10%">
						<cfif VAL(qGetStudents.hostID) AND isDate(qGetStudents.datePISEmailed)>#qGetStudents.hostlastname#</cfif>
                    </td>
                    <td width="10%">
						<cfif VAL(qGetStudents.hostID) AND isDate(qGetStudents.datePISEmailed)>#DateFormat(qGetStudents.datePlaced, 'mm/dd/yy')#</cfif>
					</td>
                </cfif>
                <cfif VAL(qGetStudents.master_account)>
                    <td width="12%">#qGetStudents.officeName#</td>
                <cfelse>
                    <td width="12%"><cfif NOT VAL(qGetStudents.branchID)>Main Office<cfelse>#qGetStudents.branchName#</cfif></td>
                </cfif>
            </tr>
        </cfloop>
    </table>
</div>

<table width="100%" bgcolor="##ffffe6" class="section">
	<tr>
		<td>Students in Green have been added since your last vist.</td>
        <td align="center"><font color="##CC0000">* Region / State Preference.</font></td>
        <td align="right">CTRL-F to search</td>
	</tr>
</table>

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>