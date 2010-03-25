<!--- ------------------------------------------------------------------------- ----
	
	File:		student_app_list.cfm
	Author:		Marcus Melo
	Date:		March 17, 2010
	Desc:		Student Application List

	Updated:	03/17/2010 - Group Applications by Season for Intl. Representatives	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<!--- Param URL Variables --->
	<cfparam name="URL.status" default="1">
	<cfparam name="URL.intRep" default="0">
    <cfparam name="URL.ef" default="">

    <!--- Sort Feature --->
    <cfparam name="URL.sortBy" default="app_sent_student">
    <cfparam name="URL.sortOrder" default="DESC">

	<cfscript>
        // make sure we have a valid sortOrder value
		if ( NOT ListFind("ASC,DESC", URL.sortOrder) ) {
			URL.sortOrder = "ASC";				  
		}
		
		// rebuilt QueryString and remove sortBy and sortOrder
        newQueryString = CGI.QUERY_STRING;

		if ( ListContainsNoCase(newQueryString, "sortBy", "&") ) {
			newQueryString = ListDeleteAt(newQueryString, ListContainsNoCase(newQueryString, "sortBy", "&"), "&");
		}

		if ( ListContainsNoCase(newQueryString, "sortOrder", "&") ) {
			newQueryString = ListDeleteAt(newQueryString, ListContainsNoCase(newQueryString, "sortOrder", "&"), "&");
		}
    </cfscript>

	<cffunction name="setURL" access="private" hint="Sets sortOrder: ASC or DESC values" returntype="string">
    	<cfargument name="curColumn" hint="CurColumn is required">
        
        <cfscript>
			// New sortOrder value
			var sortOrderVal = '&sortOrder=ASC';
		
			if (curColumn EQ URL.sortBy AND URL.sortOrder EQ 'ASC') {
				sortOrderVal = "&sortOrder=DESC";	
			} 
			
			// Build URL
			return CGI.SCRIPT_NAME & "?" & newQueryString & "&sortBy=" & ARGUMENTS.curColumn & sortOrderVal;
		</cfscript>
    	
    </cffunction>


    <cfquery name="qStudents" datasource="MySQL">
        SELECT  
        	s.studentid, 
            s.familylastname, 
            s.uniqueid, 
            s.firstname, 
            s.email, 
            s.phone, 
            s.sex, 
            s.lastchanged, 
            s.app_sent_student, 
            s.branchid, 
            s.application_expires, 
            appProgram.short_name as programApplied,
            u.businessname, 
            c.companyshort,
            branch.businessname as branchname,
            season.seasonID,
			IF(s.companyID = 6, "PHP Program", season.season) AS seasonName
        FROM 
        	smg_students s 
        INNER JOIN 
        	smg_users u ON u.userid = s.intRep
        INNER JOIN
        	smg_student_app_programs appProgram ON appProgram.app_programID = s.app_indicated_program
        LEFT JOIN 
        	smg_companies c ON c.companyid = s.companyid
        LEFT JOIN 
        	smg_users branch ON branch.userid = s.branchid
		LEFT JOIN
        	smg_programs p ON p.programID = s.programID
        LEFT JOIN
        	smg_seasons season ON season.seasonID = p.seasonID            
        WHERE 
        	s.randid != <cfqueryparam cfsqltype="cf_sql_bit" value="0">         
            
			<cfif NOT ListFind("4,6,9", URL.status)>
                AND 
                    s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            </cfif>
            
			<cfif VAL(URL.intRep)>
                AND 
                    s.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.intRep#">
            </cfif>
            
			<!--- Intl. Rep / EF Central Office --->
            <cfif LEN(URL.ef) AND CLIENT.usertype EQ 8>
                AND 
                	u.master_accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                AND 
                	u.userid != <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            <cfelseif CLIENT.usertype EQ 8>
                AND 
                	s.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            <cfelseif CLIENT.usertype EQ 11>
                AND 
                	s.branchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            </cfif>
            
            <!--- Filter for WEP Site --->
            <cfif NOT ListFind("1,2,3,4,5,10,12", CLIENT.companyID)>
            	AND 
	                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
            </cfif>			

			<!--- Display Branch Applications (3/4) in the Active list --->
			<cfif CLIENT.usertype NEQ 11 AND URL.status EQ 2>
                AND 
                    s.app_current_status IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.status#,3,4" list="yes"> )
            <!--- Display Current Status --->
            <cfelse>            
                AND 
                    s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.status#"> 
            </cfif>

        ORDER BY 
        	
            <!--- Group Students by Season ID if status is Approved and User is Intl. Rep, Intl. Branch, PHP School or Intl. User --->
            <cfif ListFind("8,11,12,13", CLIENT.userType) AND URL.status EQ 11>
        		season.season DESC,
        	</cfif>
        
        	<cfswitch expression="#URL.sortBy#">
            	
                <cfcase value="app_sent_student">                    
                    s.app_sent_student #URL.sortOrder#,
                    s.familyLastName,
                    s.firstName                    
                </cfcase>
            
                <cfcase value="familyLastName">
                	s.familyLastName #URL.sortOrder#,
                    s.firstName
                </cfcase>

                <cfcase value="firstName">
                	s.firstName #URL.sortOrder#,
                    s.familyLastName
                </cfcase>

                <cfcase value="studentID,sex,email,phone">
                	s.#URL.sortBy# #URL.sortOrder#
                </cfcase>
				
                <cfcase value="businessName">
                	u.businessName #URL.sortOrder#,
                    branchName #URL.sortOrder#
                </cfcase>

                <cfcase value="programApplied">
                	appProgram.short_name #URL.sortOrder#,
                    s.familyLastName
                </cfcase>

                <cfcase value="lastChanged">
                	s.lastChanged #URL.sortOrder#,
                    s.familyLastName,
                    s.firstName                    
                </cfcase>
                
                <cfdefaultcase>
                	s.app_sent_student #URL.sortOrder#,
                    s.familyLastName,
                    s.firstName                    
                </cfdefaultcase>

            </cfswitch>   

    </cfquery>

</cfsilent>    

<script language="JavaScript" type="text/JavaScript">
	<!--
	function displayAppList(seasonID) {
		var trID = 'seasonList' + seasonID;
		var spanID = 'seasonLink' + seasonID;
		
		if ( $("#" + trID).css("display") == "none" ) {						
			// Display Table
			$("#" + trID).fadeIn("slow");
			$("#" + spanID).text("[ - Collapse ]");
		} else {
			// Hide Table
			$("#" + trID).fadeOut("slow");
			$("#" + spanID).text("[ + Expand ]");
		}
	}

	// Expand/Collapse All
	function expandAll() {
		if ( $(".studentList").css("display") == "none" ) {						
			$(".studentList").fadeIn("slow");
		} else {
			$(".studentList").fadeOut("slow");
		}
	}

	var newwindow;
	
	function OpenApp(url)
	{
		newwindow=window.open(url, 'Application', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	
	function LoginInfo(url)
	{
		newwindow=window.open(url, 'logininfo', 'height=310, width=630, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	
	function AppReceived(url)
	{
		newwindow=window.open(url, 'logininfo', 'height=200, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	
	function areYouSure() { 
	   if(confirm("Please click OK if this application has been printed correctly.")) { 
		 form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	} 
	//-->
</script>


<cfswitch expression="#URL.status#">

	<cfcase value="1">
    	<h2>Access has been sent to these students, they have not followed the link to activate their account.</h2>
    </cfcase>

	<cfcase value="2">
    	<h2>These students have activated their accounts and are working on their applications.</h2>
    </cfcase>

	<cfcase value="3">
    	<h2>These applications are waiting for <cfif CLIENT.usertype EQ 11>your<cfelse>the branch</cfif> approval.</h2>
    </cfcase>

	<cfcase value="4">
    	<h2>These applications have been rejected by <cfif CLIENT.usertype EQ 11>you<cfelse>the branch</cfif>.</h2>
    </cfcase>

	<cfcase value="5">
    	<h2>These applications are waiting for <cfif CLIENT.usertype EQ 8>your<cfelse>the international rep</cfif> approval.</h2>
    </cfcase>

	<cfcase value="6">
    	<h2>These applications have been rejected by <cfif CLIENT.usertype EQ 8>you<cfelse>the international rep</cfif>.</h2>
    </cfcase>

	<cfcase value="7">
    	<h2>These applications have been approved by <cfif CLIENT.usertype EQ 8>you<cfelse>the international rep</cfif> and are waiting for SMG.</h2>
    </cfcase>

	<cfcase value="8">
    	<h2>These applications have been approved by <cfif CLIENT.usertype EQ 8>you<cfelse>the international rep</cfif> and are waiting for the SMG approval.</h2>
    </cfcase>

	<cfcase value="9">
    	<h2>These applications have been rejected by SMG.</h2>
    </cfcase>

	<cfcase value="10">
    	<h2>These applications are on hold by SMG.</h2>	
    </cfcase>

	<cfcase value="11">
    	<h2>These applications have been approved by SMG.</h2>	
    </cfcase>

	<cfcase value="25">
    	<h2>These students have active applications, but won't be applying to programs until a future date.</h2>
    </cfcase>

</cfswitch>

<br>

<!--- Include Table Header --->
<gui:tableHeader
    imageName="students.gif"
    tableTitle="Online Applications - Total of #qStudents.recordCount# students."
    tableRightTitle=""
/>


<!--- Group Students by Season ID if status is Approved, User is Intl. Rep, Intl. Branch or PHP School --->
<cfif ListFind("8,11,12,13", CLIENT.userType) AND URL.status EQ 11>

		<cfoutput query="qStudents" group="seasonName">   
			<table width="100%" border="0" cellpadding="4" cellspacing="2" class="section">
                <tr>
                    <td>
                        <a href="javascript:displayAppList(#VAL(qStudents.seasonID)#);"> 
                            <span id="seasonLink#VAL(qStudents.seasonID)#"> 
                            <cfif qStudents.currentRow NEQ 1>
	                            [ + Expand ] 
    						<cfelse>
	                            [ - Collapse ] 
                            </cfif>                        
                            </span>
                            &nbsp; - &nbsp;
                                
                            <cfif qStudents.seasonName EQ "PHP Program">
                                <strong> #qStudents.seasonName# </strong>
                            <cfelse>
                                <strong> Season: &nbsp; #qStudents.seasonName# </strong>
                            </cfif>
                        </a>
                    </td>                    
                </tr>                    
    
                <tr id="seasonList#VAL(qStudents.seasonID)#" class="studentList" <cfif qStudents.currentRow NEQ 1> style="display:none" </cfif> >
                    <td>
               
                        <!--- Detail Table --->
                        <table width="100%" border="0" cellpadding="4" cellspacing="0">
                            <tr>
                                <td><a href="#setURL('studentID')#" title="Sort By Student ID"><strong>ID</strong></a></td>
                                <td><a href="#setURL('familyLastName')#" title="Sort by Last Name"><strong>Last Name</strong></a></td>
                                <td><a href="#setURL('firstName')#" title="Sort by First Name"><strong>First Name</strong></a></td>
                                <td><a href="#setURL('sex')#" title="Sort by Gender"><strong>Gender</strong></a></td>
                                <td><a href="#setURL('email')#" title="Sorty by Email"><strong>Email</strong></a></td>
                                <td><strong>Login Info</strong></td>
                                <td><a href="#setURL('phone')#" title="Sort By Phone"><strong>Phone</strong></a></td>
                                <td><a href="#setURL('app_sent_student')#" title="Sort by App Sent"><strong>App Sent</strong></a></td>
                                <cfif CLIENT.usertype EQ 8>
                                    <td><a href="#setURL('businessName')#" title="Sort by Created By"><strong>Created by</strong></a></td>
                                </cfif>
                            </tr>
    
                            <cfoutput>
                        
                                <cfquery name="qCheckIntAgentInput" datasource="MySQL">
                                    SELECT 
                                        studentid, 
                                        status
                                    FROM 
                                        smg_student_app_status
                                    WHERE 
                                        status = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                                    AND 
                                        studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudents.studentid#">
                                </cfquery>
                                
                                <tr bgcolor="#iif(qStudents.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
                                    <td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#studentid#</a></td>
                                    <td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#familylastname#</a></td>
                                    <td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#firstname#</a></td>
                                    <td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#sex#</a></td>
                                    <td>#email#</td>
                                    <td align="center"><a href="javascript:LoginInfo('student_app/login_information.cfm?unqid=#uniqueid#&status=#URL.status#');"><img src="student_app/pics/info.gif" border="0" alt="Login Information"></a></td>
                                    <td>#phone#</td>
                                    <td>#DateFormat(app_sent_student, 'mm/dd/yyyy')#</td>
                                    
                                    <cfif CLIENT.usertype EQ 8>
                                        <td>
                                            <!--- EF CENTRAL OFFICE --->
                                            <cfif LEN(URL.ef)> 
                                                #businessname#
                                            <cfelseif branchid EQ 0>
                                                Main Office
                                            <cfelse>
                                                #branchname#
                                            </cfif> 
                                        </td>
                                    </cfif>		
                                </tr>
                            
                            </cfoutput>
                            
                        </table>
                    </td>			
                </tr>
                
            </cfoutput>
		</table>

<!--- Intl. Reps, Branches users OR Office Users when status not Submitted AND not Received --->
<cfelseif CLIENT.usertype GTE 5 OR (URL.status NEQ 7 AND URL.status NEQ 8)>
	
	<cfoutput>    

	<table width="100%" border="0" cellpadding="4" cellspacing="0" class="section">
		<tr>
        	<td><a href="#setURL('studentID')#" title="Sort By Student ID"><strong>ID</strong></a></td>
			<td><a href="#setURL('familyLastName')#" title="Sort by Last Name"><strong>Last Name</strong></a></td>
			<td><a href="#setURL('firstName')#" title="Sort by First Name"><strong>First Name</strong></a></td>
			<td><a href="#setURL('sex')#" title="Sort by Gender"><strong>Gender</strong></a></td>
			<td><a href="#setURL('email')#" title="Sorty by Email"><strong>Email</strong></a></td>
			<td><strong>Login Info</strong></td>
            
			<cfif CLIENT.usertype GTE 5>
				<td><a href="#setURL('phone')#" title="Sort By Phone"><strong>Phone</strong></a></td>
			</cfif>
			
            <td><a href="#setURL('app_sent_student')#" title="Sort by App Sent"><strong>App Sent</strong></a></td>
			
			<cfif CLIENT.usertype EQ 8>
				<td><a href="#setURL('businessName')#" title="Sort by Created By"><strong>Created by</strong></a></td>
			</cfif>
			
			<cfif CLIENT.usertype LTE 4>
				<td><a href="#setURL('businessName')#" title="Sort by Business Name"><strong>Intl. Rep.</strong></a></td>
				<td><a href="#setURL('programApplied')#" title="Sort by Program"><strong>Program Applied</strong></a></td>
			</cfif>
            
            <cfif URL.status LT 10>
				<td><a href="#setURL('lastChanged')#" title="Sort by Last Edit"><strong>Last Edit</strong></a></td>
            </cfif>
            
			<cfif URL.status LTE 5 OR URL.status EQ 6 OR URL.status EQ 9>
				<td>&nbsp;</td>
			</cfif>
            
			 <cfif (URL.status EQ 7 OR URL.status EQ 10 OR URL.status EQ 11) AND CLIENT.usertype LTE 4>
                <td><strong>Company</strong></td>
                <td><strong>Cover Page</strong></td>
			</cfif>
            
		</tr>
    
    </cfoutput>

	<cfoutput query="qStudents">

        <cfquery name="qCheckIntAgentInput" datasource="MySQL">
            SELECT 
                studentid, 
                status
            FROM 
                smg_student_app_status
            WHERE 
                status = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
            AND 
                studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qStudents.studentid#">
        </cfquery>
        
        <cfif qStudents.recordcount AND NOT VAL(qCheckIntAgentInput.recordcount) AND CLIENT.usertype GTE 5>
            <tr bgcolor="##e2efc7">
        <cfelseif (qStudents.application_expires LT now() AND URL.status LTE 2)>
            <tr bgcolor="##EEDFE1">
        <cfelse>
            <tr bgcolor="#iif(qStudents.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
        </cfif>
        
            <td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#studentid#</a></td>
            <td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#familylastname#</a></td>
            <td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#firstname#</a></td>
            <td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#sex#</a></td>
            <td>#email#</td>
            <td align="center"><a href="javascript:LoginInfo('student_app/login_information.cfm?unqid=#uniqueid#&status=#URL.status#');"><img src="student_app/pics/info.gif" border="0" alt="Login Information"></a></td>
            
            <cfif CLIENT.usertype GTE 5>
                <td>#phone#</td>
            </cfif>
            
            <td>#DateFormat(app_sent_student, 'mm/dd/yyyy')#</td>
            
            <cfif CLIENT.usertype EQ 8>
                <td>
                    <cfif LEN(URL.ef)> <!--- EF CENTRAL OFFICE --->
                        #businessname#
                    <cfelseif branchid EQ 0>
                        Main Office
                    <cfelse>
                        #branchname#
                    </cfif> 
                </td>
            </cfif>		
            
            <cfif CLIENT.usertype LTE 4>
                <td>#businessname#</td>
                <td>#programApplied#</td>
            </cfif>		
            
            <cfif URL.status LT 10>
                <td>#DateFormat(lastchanged, 'mm/dd/yyyy')# @ #TimeFormat(lastchanged, 'h:mm:ss tt')#</td>
            </cfif>
            
            <cfif URL.status LTE 5 OR URL.status EQ 6 OR URL.status EQ 9> <!--- inactivate application --->
                <td>
                    <form name="inactive_#studentid#" action="?curdoc=student_app/querys/qr_inactivate_student" method="post" onsubmit="return confirm ('You are about to inactivate student #firstname# #familylastname# (###studentid#). You will no longer have access to this application. Please click OK to confirm.')">
                        <input type="hidden" name="studentid" value="#studentid#">
                        <input type="hidden" name="status" value="#URL.status#">
                        <input type="image" name="submit" src="student_app/pics/delete.gif">
                    </form>
                </td>
            </cfif>
            
            <cfif (URL.status EQ 7 OR URL.status EQ 10 OR URL.status EQ 11) AND CLIENT.usertype LTE 4>
                <td>#companyshort#</td>
                <td><a href="javascript:OpenApp('student_app/cover_page.cfm?unqid=#uniqueid#');">Cover Page</a></td>
            </cfif> 
        </tr>
    
    </cfoutput>
	
    <tr><td colspan="11">&nbsp;</td></tr>
    
	<cfif qStudents.recordcount AND NOT VAL(qCheckIntAgentInput.recordcount) AND CLIENT.usertype GTE 5>
        <tr bgcolor="#e2efc7">
            <td colspan="11">Students highlighted in green are applications you are filling / filled out on behalf of the student.</td>
        </tr>
	</cfif>
	
	<cfif URL.status LTE 2>
        <tr bgcolor="#EEDFE1">
            <td colspan="11">Students highlighted in this color have expired.  Click the name to extend the deadline.</td></td>
        </tr>
	</cfif>
    
	</table>
    
<!--- SMG OFFICE - NEEDS TO BE PRINTED - STATUS RECEIVED = 7 --->
<cfelseif CLIENT.usertype LTE 4 AND URL.status EQ 7>
	
	<cfoutput>

    <table width="100%" border="0" cellpadding="4" cellspacing="0" class="section">	
		<tr><th colspan="12" bgcolor="e2efc7">#qStudents.recordcount# &nbsp; APPLICATION(S) TO BE PRINTED / RECEIVED</th></tr>
		<tr>
			<td><a href="#setURL('studentID')#" title="Sort By Student ID"><strong>ID</strong></a></td>
			<td><a href="#setURL('familyLastName')#" title="Sort by Last Name"><strong>Last Name</strong></a></td>
			<td><a href="#setURL('firstName')#" title="Sort by First Name"><strong>First Name</strong></a></td>
			<td><a href="#setURL('sex')#" title="Sort by Gender"><strong>Gender</strong></a></td>
			<td><a href="#setURL('email')#" title="Sorty by Email"><strong>Email</strong></a></td>
            <td><strong>Login</strong></td>
            <td><strong>Future</strong></td>
			<td><a href="#setURL('app_sent_student')#" title="App Submitted"><strong>App Received</strong></a></td>
			<td><a href="#setURL('businessName')#" title="Sort by Business Name"><strong>Intl. Rep.</strong></a></td>
            <td><a href="#setURL('programApplied')#" title="Sort by Program"><strong>Program Applied</strong></a></td>
			<td><strong>Cover Page</strong></td>
			<td><strong>Confirm Receipt</strong></td>
		</tr>
        
		<cfloop query="qStudents">
			<tr bgcolor="#iif(qStudents.currentrow MOD 2 ,DE("FFFFFF") ,DE("e2efc7") )#">
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#studentid#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#familylastname#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#firstname#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#sex#</a></td>
				<td>#email#</td>
				<td align="center"><a href="javascript:LoginInfo('student_app/login_information.cfm?unqid=#uniqueid#&status=#URL.status#');"><img src="student_app/pics/info.gif" border="0" alt="Login Information"></a></td>
                <td><a href="student_app/change_future.cfm?studentid=#studentid#&status=#URL.status#" >Change</a></td>
				<td>#DateFormat(app_sent_student, 'mm/dd/yyyy')#</td>
				<td>#businessname#</td>
                <td>#programApplied#</td>
				<td><a href="javascript:OpenApp('student_app/cover_page.cfm?unqid=#uniqueid#');">Page</a></td>
				<td><a href="javascript:AppReceived('student_app/querys/qr_app_received.cfm?unqid=#uniqueid#&status=#URL.status#');" onClick="return areYouSure(this);">Check</a></td>
			</tr>
		</cfloop>
        
		<tr><td colspan="11">&nbsp;</td></tr>
	</table>
    
	</cfoutput>

<!--- SMG OFFICE - RECEIVED APPLICATIONS - WAITING APPROVAL - STATUS = 8 --->
<cfelseif CLIENT.usertype LTE 4 AND URL.status EQ 8>

	<cfoutput>

	<!--- WAITING TO BE APPROVED - STATUS 8 --->
	<table width="100%" border="0" cellpadding="4" cellspacing="0" class="section">	
		<tr><th colspan="12" bgcolor="e2efc7">#qStudents.recordcount# &nbsp; ONLINE APPLICATION(S) TO BE APPROVED</th></tr>
		<tr>
			<td><a href="#setURL('studentID')#" title="Sort By Student ID"><strong>ID</strong></a></td>
			<td><a href="#setURL('familyLastName')#" title="Sort by Last Name"><strong>Last Name</strong></a></td>
			<td><a href="#setURL('firstName')#" title="Sort by First Name"><strong>First Name</strong></a></td>
			<td><a href="#setURL('sex')#" title="Sort by Gender"><strong>Gender</strong></a></td>
			<td><a href="#setURL('email')#" title="Sorty by Email"><strong>Email</strong></a></td>
			<td><strong>Login</strong></td>
            <td><strong>Future</strong></td>
			<td><a href="#setURL('app_sent_student')#" title="App Submitted"><strong>App Submitted</strong></td>
			<td><a href="#setURL('businessName')#" title="Sort by Business Name"><strong>Intl. Rep.</strong></a></td>
            <td><a href="#setURL('programApplied')#" title="Sort by Program"><strong>Program Applied</strong></a></td>
			<td><strong>Cover Page</strong></td>
		</tr>
        
		<cfloop query="qStudents">
			<tr bgcolor="#iif(qStudents.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#studentid#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#familylastname#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#firstname#</a></td>
				<td><a href="javascript:OpenApp('student_app/index.cfm?curdoc=initial_welcome&unqid=#uniqueid#&id=0');">#sex#</a></td>
				<td>#email#</td>
				<td align="center"><a href="javascript:LoginInfo('student_app/login_information.cfm?unqid=#uniqueid#&status=#URL.status#');"><img src="student_app/pics/info.gif" border="0" alt="Login Information"></a></td>
                <td><a href="student_app/change_future.cfm?studentid=#studentid#&status=#URL.status#" >Change</a></td>
				<td>#DateFormat(app_sent_student, 'mm/dd/yyyy')#</td>
				<td>#businessname#</td>
				<td>#programApplied#</td>
				<td><a href="javascript:OpenApp('student_app/cover_page.cfm?unqid=#uniqueid#');">Page</a></td>
			</tr>
		</cfloop>
        
		<tr><td colspan="11">&nbsp;</td></tr>		
	</table>
    
	</cfoutput>
	
</cfif>

<!--- Include Table Footer --->
<gui:tableFooter />