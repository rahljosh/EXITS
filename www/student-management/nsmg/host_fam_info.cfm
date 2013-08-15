<!--- ------------------------------------------------------------------------- ----
	
	File:		host_fam_info.cfm
	Author:		Marcus Melo
	Date:		December 10, 2009
	Desc:		Not updated.

	Updated:  	

----- ------------------------------------------------------------------------- --->
<link rel="stylesheet" href="linked/css/buttons.css" type="text/css">
<link rel="stylesheet" href="linked/css/statusIcons.css" type="text/css" />
<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<cfajaxproxy cfc="extensions.components.cbc" jsclassname="CBC">

    <!--- Param URL Variables --->
    <cfparam name="url.hostID" default="">
    
    <!--- CHECK RIGHTS --->
	<cfinclude template="check_rights_host.cfm">
	
	<cfscript>
		//users allowed to resent email app
		allowedUsers = "13538,7729,13185,7858,7203,14488,16975,6200,13731,17919,17427,12313,18602";
		allowedRegions = "1474,1389,1020,1435,1463,1093,22,1403";
		//Random Password for account, if needed
		strPassword = APPLICATION.CFC.UDF.randomPassword(length=8);
		
        // Get Host Mother CBC
        qGetCBCMother = APPLICATION.CFC.CBC.getCBCHostByID(
            hostID=hostID, 
            cbcType='mother'
        );
        
        // Gets Host Father CBC
        qGetCBCFather = APPLICATION.CFC.CBC.getCBCHostByID(
            hostID=hostID, 
            cbcType='father'
        );
        
        // Get Family Member CBC
        qGetHostMembers = APPLICATION.CFC.CBC.getCBCHostByID(
            hostID=hostID,
            cbcType='member',
			sortBy='familyID'
        );
		
		qGetHostEligibility = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
			applicationID=7,
			foreignTable='smg_hosts',
			foreignID=hostID
		);
		
		qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=URL.hostID);	
    </cfscript>


	<!--- delete other family member. --->
    <cfif isDefined("url.delete_child")>
        
        <cfquery datasource="#application.dsn#">
            UPDATE 
                smg_host_children
            SET
                isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            WHERE 
                childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.delete_child#">
        </cfquery>
        
    </cfif>

    <cfquery name="user_compliance" datasource="#application.dsn#">
        SELECT userid, compliance
        FROM smg_users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
    
    <cfquery name="family_info" datasource="#application.dsn#">
        SELECT *
        FROM smg_hosts
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(url.hostID)#">
    </cfquery>
    <cfscript>
		qGetAreaRep = APPLICATION.CFC.USER.getUsers(
			userID = family_info.areaRepID
		);
	</cfscript>
    
     <cfquery name="host_children" datasource="#application.dsn#">
        SELECT *
        FROM smg_host_children
        WHERE 
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(family_info.hostID)#">
        AND
        	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        ORDER BY birthdate
    </cfquery>
    
    <!---number kids at home---->
    <cfquery name="kidsAtHome" dbtype="query">
        select count(childid)
        from host_children
        where liveathome = 'yes'
    </cfquery>
    
    <!----- Students being Hosted----->
    <cfquery name="hosting_students" datasource="#application.dsn#">
        SELECT studentid, familylastname, firstname, p.programname, c.countryname
        FROM smg_students
        INNER JOIN smg_programs p ON smg_students.programid = p.programid
        LEFT JOIN smg_countrylist c ON smg_students.countryresident = c.countryid
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(family_info.hostID)#">
        AND smg_students.active = 1
        ORDER BY familylastname
    </cfquery>
    
    <!--- Students previous hosted --->
    <cfquery name="hosted_students" datasource="#application.dsn#">
        SELECT DISTINCT h.studentid, familylastname, firstname, p.programname, c.countryname
        FROM smg_students
        INNER JOIN smg_hosthistory h ON smg_students.studentid = h.studentid
        INNER JOIN smg_programs p ON smg_students.programid = p.programid
        LEFT JOIN smg_countrylist c ON smg_students.countryresident = c.countryid
        WHERE h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(family_info.hostID)#">
        ORDER BY familylastname
    </cfquery>
    
    <!--- REGION --->
    <cfquery name="get_region" datasource="#application.dsn#">
        SELECT regionid, regionname

        FROM smg_regions
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(family_info.regionid)#">
    </cfquery>
    
    <!--- SCHOOL ---->
    <cfquery name="get_school" datasource="#application.dsn#">
        SELECT schoolid, schoolname, address, city, state, begins, ends
        FROM smg_schools
        WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(family_info.schoolid)#">
    </cfquery>
    
	<!--- CROSS DATA - check if was submitted under a user --->
    <cfquery name="qCheckCBCMother" datasource="#application.dsn#">
        SELECT DISTINCT u.userid, u.ssn, firstname, lastname, cbc.cbcid, cbc.requestid, date_authorized, date_sent, date_expired, smg_seasons.season,cbc.batchid, cbc.cbcid
        FROM smg_users u
        INNER JOIN smg_users_cbc cbc ON cbc.userid = u.userid
        LEFT JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
        WHERE u.ssn != ''
        AND cbc.familyid = '0'
        AND ((u.ssn = '#family_info.motherssn#' AND u.ssn != '') OR (u.firstname = '#family_info.motherfirstname#' AND u.lastname = '#family_info.familylastname#' <cfif family_info.motherdob NEQ ''>AND u.dob = '#DateFormat(family_info.motherdob,'yyyy/mm/dd')#'</cfif>))
    </cfquery>
    
    <cfquery name="qCheckCBCFather" datasource="#application.dsn#">
        SELECT DISTINCT u.userid, u.ssn, u.firstname, u.lastname, cbc.cbcid, cbc.requestid, date_authorized, date_sent, date_expired, batchid,
            smg_seasons.season, cbc.cbcid
        FROM smg_users u
        INNER JOIN smg_users_cbc cbc ON cbc.userid = u.userid
        LEFT JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
        WHERE u.ssn != ''
        AND cbc.familyid = '0'
        AND ((u.ssn = '#family_info.fatherssn#' AND u.ssn != '') OR (u.firstname = '#family_info.fatherfirstname#' AND u.lastname = '#family_info.familylastname#' <cfif family_info.fatherdob NEQ ''>AND u.dob = '#DateFormat(family_info.fatherdob,'yyyy/mm/dd')#'</cfif>))
    </cfquery>

</cfsilent>

<!--- Check if decided to host was clicked because the email should also be sent out in this case. --->
<cfset goingToHost = 0>
<cfif isDefined('decideToHost')>
	<cfif FORM.decideToHost EQ 0>
    	<cfset goingToHost = 0>
    <cfelse>
    	<cfset goingToHost = 1>
    </cfif>
</cfif>

<!--- Send email to host family and update application, check for password first. --->
<cfif isDefined('sendAppEmail') OR goingToHost EQ 1>

    <cfquery datasource="#APPLICATION.DSN#">
    	UPDATE smg_hosts
      	SET
        	dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
        	<cfif isDefined('sendAppEmail')>
            	<cfif FORM.sendAppEmail EQ "Convert to eHost">
        			,areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
              	</cfif>
           	</cfif>
			<cfif NOT VAL(family_info.hostAppStatus)>
                ,hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="9">
                ,applicationSent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            </cfif>
            <cfif family_info.password is ''>
              	,password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">
            </cfif>
  		WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(family_info.hostID)#">
	</cfquery>
    <cfquery name="qGetUpdatedPassword" datasource="#APPLICATION.DSN#">
        SELECT password, email
        FROM smg_hosts
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(family_info.hostID)#">
    </cfquery>
    
       <cfscript>
			// Data Validation
			
			// Email Address
            if ( NOT LEN(TRIM(qGetUpdatedPassword.email)) ) {
                SESSION.formErrors.Add("Please provide an email address.");
            }	
			
			// Valid Email Address
            if ( LEN(TRIM(qGetUpdatedPassword.email)) AND NOT isValid("email", TRIM(qGetUpdatedPassword.email)) ) {
                SESSION.formErrors.Add("The email address you have entered does not appear to be valid.");
            }	
		</cfscript>	
        
    <cfif NOT SESSION.formErrors.length()>
 	<cfscript>
		APPLICATION.CFC.HOST.sendWelcomeLetter(
			email=#family_info.email#,
			password=#qGetUpdatedPassword.password#,
			fatherFirstName=#family_info.fatherFirstName#,
			motherFirstName=#family_info.motherFirstName#);
	</cfscript>
    </cfif>
    <!--- Only reload the page if it does not need to change the host family's active status --->
    <cfif NOT isDefined('decideToHost')>
    	<cflocation url="?#CGI.QUERY_STRING#"/>
    </cfif>                  
</cfif>

<cfif isDefined('decideToHost')>
	<cfquery datasource="#APPLICATION.DSN#">
    	UPDATE smg_hosts
        SET dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
      		isHosting = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.decideToHost)#">
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#family_info.hostID#">
    </cfquery>
    <cflocation url="?#CGI.QUERY_STRING#"/>
</cfif>


<cfif not isNumeric(url.hostID)>
	a numeric hostID is required.
	<cfabort>
</cfif>

<!--- client.hostID should be phased out, but still need it for other pages not updated yet. --->
<cfif isDefined('url.hostID')>
	<cfset client.hostID = url.hostID>
</cfif>

<script type="text/javascript">
	function getCBCFromUser(hostID, cbcid, memberType) {
		var cbc = new CBC();
		cbc.transferUserToHostCBC(hostID, cbcid, memberType);
		window.location.reload();
	}
	
	function showEligibilityNotes() {
		var qualified = $("#notQualified").is(':checked');
		if (qualified) {
			$("#qualifiedNotesTr").html("<td style='vertical-align:top;'>Explanation: <textArea name='qualifiedNotes' id='qualifiedNotes' style='width:70%;' /></td>");
		} else {
			$("#qualifiedNotesTr").html("");
		}
	}
	
	function confirmDelete() {
		if (confirm('You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue.')) {
			window.location.href='?curdoc=querys/delete_host&hostID=<cfoutput>#family_info.hostID#</cfoutput>'
		}	
	}
</script>

<style type="text/css">
div.scroll {
	height: 155px;
	width:auto;
	overflow:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	left:auto;
}
div.scroll2 {
	height: 100px;
	width:auto;
	overflow:auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
	left:auto;
}
.alert{
	width:auto;
	height:55px;
	border:#666;
	background-color:#FF9797;
	text-align:center;
	-moz-border-radius: 15px;
	border-radius: 15px;
	vertical-align:center;

}
</style>

<cfif family_info.recordcount EQ 0>
	The host family ID you are looking for, <cfoutput>#url.hostID#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the host family record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view this host family
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

 
<cfoutput>

<!----check if single placement family assign a value of 1 to each family memmber, if sum of total family members over 1, no worries.  Other wise, display warning---->
<Cfset father=0>
<cfset mother=0>
<Cfif family_info.fatherfirstname is not ''>
	<cfset father = 1>
</Cfif>
<Cfif family_info.motherfirstname is not ''>
	<cfset mother = 1>
</Cfif>
<cfset totalfam = mother + father + kidsAtHome.recordcount>


	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
        
	<cfif totalfam eq 1>
        <div class="alert">
        <h1>Single Person Placement - additional screening will be required. </h1>
        <em>Starting with Aug 2011 Students - Single Person Placement Authorization Form and 2 additional references</em> </div>
        <br />
    </cfif>
        

<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
    	<!--- LEFT SIDE --->
    	<td width="60%" align="left" valign="top">
        
        	<!--- HOST FAMILY INFORMATION --->
            <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
                <tr valign="middle" height="24">
                	<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
                    <td height="24" width="26" background="pics/header_background.gif"><img src="pics/family.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Host Family Information</h2></td>
                    <td background="pics/header_background.gif" style="text-align:right">
                    	<cfif VAL(family_info.hostAppStatus)>
                            <span class="buttonBlue smallerButton" onclick="window.location.href='?curdoc=hostApplication/toDoList&hostID=#family_info.hostID#'">
                                Open eHost Application
                            </span>
                        	&nbsp;
                       	</cfif>
                        <span class="buttonBlue smallerButton" onclick="window.location.href='?curdoc=forms/host_fam_form&hostID=#family_info.hostID#'">
                        	Edit
                      	</span>
                        &nbsp;
                        <span class="buttonBlue smallerButton" onclick="confirmDelete();">
                        	Delete
                        </span>
                    </td>
                    <td height="24" width="17" background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
            <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                <tr><td>Family Name:</td><td>#family_info.familylastname#</td><td>ID:</td><td>#family_info.hostID#</td></tr>
                <tr><td>Address:</td><td>#family_info.address#<br />#family_info.address2#</td></tr>
                <tr><td>City:</td><td>#family_info.city#</td></tr>
                <tr><td>State:</td><td>#family_info.state#</td><td>ZIP:</td><td>#family_info.zip#</td></tr>
                <tr><td>Phone:</td><td>#family_info.phone#</td></tr>
                <tr>
                    <td>Email:</td>
                    <td>
                        <a href="mailto:#family_info.email#">#family_info.email#</a>
                        <cfif VAL(family_info.hostAppStatus)>
                            <br /><span class="required">*eHost - Online Application</span>
                        </cfif>                
                    </td>
                	<td>Password:</td>
                    <td>
						<cfif family_info.password is not ''>
                        	#family_info.password#
                     	<cfelse>
                        	No Password on File
                       	</cfif>
                 	</td>
                </tr>
                <tr><th colspan="2" align="left">Father's Information</th></tr>
                <tr><td>Name:</td><td>#family_info.fatherfirstname# #family_info.fatherlastname#</td><td>Age:</td><td><cfif family_info.fatherdob NEQ ''>#dateDiff('yyyy', family_info.fatherdob, now())#</cfif></td></tr>
                <tr><td>Occupation:</td><td><cfif family_info.fatherworktype is ''>n/a<cfelse>#family_info.fatherworktype#</cfif></td><td>Cell Phone:</td><td>#family_info.father_cell#</td></tr>
                <tr><th colspan="2" align="left">Mother's Information</th></tr>
                <tr><td>Name:</td><td>#family_info.motherfirstname# #family_info.motherlastname#</td><td>Age:</td><td><cfif family_info.motherdob NEQ ''>#dateDiff('yyyy', family_info.motherdob, now())#</cfif></td></tr>
                <tr><td>Occupation:</td><td><cfif family_info.motherworktype is ''>n/a<cfelse>#family_info.motherworktype#</cfif></td><td>Cell Phone:</td><td>#family_info.mother_cell#</td></tr>
            </table>
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
            </table>
            
            <br/>
            
            <table width="100%">
            	<tr>
                	<!--- COMMUNITY INFORMATION --->
                	<td width="50%">
                        <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                            <tr valign=middle height=24>
                                <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                                <td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
                                <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Community Information</h2></td>
                                <td background="pics/header_background.gif" width=16>
                                	<span class="buttonBlue smallerButton" onclick="window.location.href='?curdoc=forms/host_fam_pis_7&hostID=#family_info.hostID#'">Edit</span>
                           		</td>
                                <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                          	</tr>
                        </table>
                        <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                            <tr>
                            	<td>Region:</td><td colspan="3"><cfif get_region.regionname is ''>not assigned<cfelse>#get_region.regionname#</cfif></td>
                          	</tr>
                            <tr>
                            	<td>Community:</td><td colspan="3"><cfif family_info.community is ''>n/a<cfelse>#family_info.community#</cfif></td>
                          	</tr>
                            <tr>
                            	<td>Closest City:</td><td><cfif family_info.nearbigcity is ''>n/a<cfelse>#family_info.nearbigcity#</cfif></td><td>Distance:</td><td>#family_info.near_City_dist# miles</td>
                         	</tr>
                            <tr>
                            	<td>Airport Code:</td><td colspan="3"><cfif family_info.major_air_code is ''>n/a<cfelse>#family_info.major_air_code#</cfif></td>
                          	</tr>
                            <tr>
                            	<td>Airport City:</td>
                                <td colspan="3">
									<cfif family_info.airport_city is '' and family_info.airport_state is ''>n/a<cfelse>#family_info.airport_city# / #family_info.airport_state#</cfif>
                              	</td>
                          	</tr>
                            <tr>
                                <td valign="top">Interests: </td>
                                <td colspan="3">
                                    <cfif len(#family_info.pert_info#) gt '100'>#Left(family_info.pert_info,92)# <a href="?curdoc=forms/host_fam_pis_7">more...</a><cfelse>#family_info.pert_info#</cfif>
                                </td>
                          	</tr>
                        </table>				
                        <table width=100% cellpadding=0 cellspacing=0 border=0>
                            <tr valign="bottom">
                            	<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
                                <td width=100% background="pics/header_background_footer.gif"></td>
                                <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
                          	</tr>
                        </table>
                    </td>
                    <!--- SCHOOL INFORMATION --->
                    <td width="50%">
                        <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                            <tr valign=middle height=24>
                                <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
                                <td background="pics/header_background.gif"><h2>School Information</h2></td>
                                <td background="pics/header_background.gif" width=16>
                                	<span class="buttonBlue smallerButton" onclick="window.location.href='?curdoc=forms/host_fam_pis_5&hostID=#family_info.hostID#'">Edit</span> 
								</td>
                                <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                         	</tr>
                        </table>
                        <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                            <tr><td>School:</td><td><cfif get_school.recordcount is '0'>there is no school assigned<cfelse>#get_school.schoolname#</cfif></td></tr>
                            <tr><td>Address:</td><td><cfif get_school.address is ''>n/a<cfelse>#get_school.address#</cfif></td></tr>
                            <tr><td>City:</td><td><cfif get_school.city is ''>n/a<cfelse>#get_school.city#</cfif></td></tr>
                            <tr><td>State:</td><td><cfif get_school.state is ''>n/a<cfelse>#get_school.state#</cfif></td></tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr><td>&nbsp;</td></tr>
                        </table>				
                        <table width=100% cellpadding=0 cellspacing=0 border=0>
                            <tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
                        </table>
                    </td>
                </tr>
            </table>
            
            <br/>
            
            <!--- CBC --->
            <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/notes.gif"></td>
                    <td background="pics/header_background.gif"><h2>Criminal Background Check</td>
                    <cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'>
                        <td background="pics/header_background.gif" width=16>
                        	<span class="buttonBlue smallerButton" onclick="window.location.href='?curdoc=cbc/hosts_cbc&hostID=#family_info.hostID#'">Edit</span>
                		</td>
                    </cfif>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
            <table width=100% cellpadding=4 cellspacing=0 border=0 class="section">
                <tr bgcolor="e2efc7">
                    <td valign="top"><b>Name</b></td>
                    <td align="center" valign="top"><b>Season</b></td>		
                    <td align="center" valign="top"><b>Date Submitted</b> <br><font size="-2">mm/dd/yyyy</font></td>
                    <td align="center" valign="top"><b>Expiration Date</b> <br><font size="-2">mm/dd/yyyy</font></td>		
                    <td align="center" valign="top"><b>View</b></td>
                    <td align="left" valign="top"><b>Status</b></td>
                     <cfif client.usertype lte 4> <td align="left" valign="top" colspan="2"><b>Notes</b></td></cfif>
                    <cfif client.usertype lte 4 and client.companyid eq 10><td align="center" valign="top"><b>Delete</b></td></cfif>
                </tr>				
                <cfif qGetCBCMother.recordcount EQ '0' AND qCheckCBCMother.recordcount EQ '0' AND qGetCBCFather.recordcount EQ '0' AND qCheckCBCFather.recordcount EQ '0'>
                    <tr><td align="center" colspan="5">No CBC has been submitted.</td></tr>
                <cfelse>
                    <tr><td colspan="6"><strong>Host Mother:</strong></td></tr>
                    <cfloop query="qGetCBCMother">
                    <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                        <td style="padding-left:20px;">#family_info.motherfirstname# #family_info.motherlastname#</td>
                        <td align="center">#season#</td>
                        <td align="center"><cfif isDate(date_sent)>#DateFormat(date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                        <td align="center"><cfif isDate(date_expired)>#DateFormat(date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                        <td align="center">
                            <cfif NOT LEN(requestid)>
                                processing
                            <cfelseif flagcbc EQ 1 AND client.usertype LTE 4>
                                    <a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCMother.hostID#&CBCFamID=#qGetCBCMother.CBCFamID#&file=batch_#qGetCBCMother.batchid#_host_mother_#qGetCBCMother.hostID#_rec.xml" target="_blank">On Hold Contact Your PM</a>
                            <cfelse>
                        		<cfif client.usertype lte 4>
                                    <a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCMother.hostID#&CBCFamID=#qGetCBCMother.CBCFamID#&file=batch_#qGetCBCMother.batchid#_host_mother_#qGetCBCMother.hostID#_rec.xml" target="_blank">#requestid#</a>
                                <cfelse>
                                    #requestid#
                              	</cfif>
                            </cfif>
                        </td>
                        <td align="left">
                        	<cfif LEN(requestid)>
								<cfscript>
                                    APPLICATION.CFC.CBC.getCBCResultStatus(cbcID=cbcFamID,cbcType="host");
                                </cfscript>
                         	</cfif>
                        </td>
                        <cfif client.usertype lte 4><td align="left" valign="top" colspan="2"><cfif isDefined('notes')>#notes#</cfif></td></cfif>
                        <cfif client.usertype lte 4 and client.companyid eq 10>
                            <td align="center" valign="top"><a href="delete_cbc.cfm?type=host&id=#requestid#&userid=#url.hostid#"><img src="pics/deletex.gif" border=0/></a></td>
                        </cfif>
                    </tr>
                    </cfloop>
                    
                    <cfif qCheckCBCMother.recordCount>
                        <tr>
                            <td colspan="3" style="padding-left:20px;">
                                Submitted for User #qCheckCBCMother.firstname# #qCheckCBCMother.lastname# (###qCheckCBCMother.userid#).
                            </td>
                        </tr>                
                    </cfif>
                    
                    <cfloop query="qCheckCBCMother">
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td>&nbsp;</td>
                            <td align="center">#season#</td>
                            <td align="center"><cfif isDate(date_sent)>#DateFormat(date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                            <td align="center"><cfif isDate(date_expired)>#DateFormat(date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                            <td align="center">
                                <cfif NOT LEN(requestid)>
                                    processing
                                <cfelse>
                                    #requestid#
                              </cfif>
                            </td>
                            <cfif client.usertype lte 4 and client.companyid eq 10>
                                <td align="center" valign="top"><a href="delete_cbc.cfm?type=host&id=#requestid#&userid=#url.hostid#"><img src="pics/deletex.gif" border=0/></a></td>
                            </cfif>
                             <td>
                                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                    <input type="button" onclick="getCBCFromUser(#family_info.hostID#, #cbcid#,'mother')" value="Transfer CBC" style="font-size:10px" />
                                </cfif>
                            </td>
                            <td align="left">
                            </td>
                        </tr>
                    </cfloop>
                    
                    <tr bgcolor="e2efc7"><td colspan="7"><strong>Host Father:</strong></td></tr>
                    <cfloop query="qGetCBCFather">
                    <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                        <td style="padding-left:20px;">#family_info.fatherfirstname# #family_info.fatherlastname#</td>
                        <td align="center">#season#</td>
                        <td align="center"><cfif isDate(date_sent)>#DateFormat(date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                        <td align="center"><cfif isDate(date_expired)>#DateFormat(date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                        <td align="center">
                            <cfif NOT LEN(requestid)>
                                processing
                            <cfelseif flagcbc EQ 1 AND client.usertype LTE 4>
                                
                                <a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCFather.hostID#&CBCFamID=#CBCFamID#&file=batch_#qGetCBCFather.batchid#_host_father_#qGetCBCFather.hostID#_rec.xml" target="_blank">On Hold Contact Your PM</a>
                            <cfelse>		
                                <cfif client.usertype lte 4>
                                    <a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCFather.hostID#&CBCFamID=#CBCFamID#&file=batch_#qGetCBCFather.batchid#_host_father_#qGetCBCFather.hostID#_rec.xml" target="_blank">#requestid#</a>
                                <cfelse>
                                    #requestid#
                              </cfif>
                            </cfif>
                        </td>
                        <td align="left">
                        	<cfif LEN(requestid)>
								<cfscript>
                                    APPLICATION.CFC.CBC.getCBCResultStatus(cbcID=cbcFamID,cbcType="host");
                                </cfscript>
                         	</cfif>
                        </td>
                        <cfif client.usertype lte 4><td align="left" valign="top"><cfif isDefined('notes')>#notes#</cfif></td></cfif>
                        <cfif client.usertype lte 4 and client.companyid eq 10>
                            <td align="center" valign="top"><a href="delete_cbc.cfm?type=host&id=#requestid#&userid=#url.hostid#"><img src="pics/deletex.gif" border=0/></td>
                        </cfif>
                    </tr>
                    </cfloop>
    
                    <cfif qCheckCBCFather.recordCount>
                        <tr>
                            <td colspan="3" style="padding-left:20px;">
                                Submitted for User #qCheckCBCFather.firstname# #qCheckCBCFather.lastname# (###qCheckCBCFather.userid#).
                            </td>
                        </tr>                
                    </cfif>
                    
                    <cfloop query="qCheckCBCFather">
                        <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                            <td>&nbsp;</td>
                            <td align="center">#season#</td>
                            <td align="center"><cfif isDate(date_sent)>#DateFormat(date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                            <td align="center"><cfif isDate(date_expired)>#DateFormat(date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                            <td align="center">
                                <cfif NOT LEN(requestid)>
                                    processing
                                <cfelse>
                                    #requestid#
                              </cfif>
                            </td>
                            <td align="left">
                            </td>
                            <cfif client.usertype lte 4 and client.companyid eq 10>
                                <td align="center" valign="top"><a href="delete_cbc.cfm?type=host&id=#requestid#&userid=#url.hostid#"><img src="pics/deletex.gif" border=0/></td>
                            </cfif>
                            <td>
                                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                    <input type="button" onclick="getCBCFromUser(#family_info.hostID#, #cbcid#, 'father')" value="Transfer CBC" style="font-size:10px" />
                                </cfif>
                            </td>
                        </tr>
                    </cfloop>				
                </cfif>
                
                <tr bgcolor="e2efc7"><td colspan="7"><strong>Other Family Members</strong></td></tr>
                <cfif qGetHostMembers.recordcount EQ '0'>
                    <tr><td align="center" colspan="6">No CBC has been submitted.</td></tr>
                <cfelse>
                    <cfloop query="qGetHostMembers">
                    
                    <cfscript>
                        // Get Member Details
                        qGetMemberDetail = APPCFC.HOST.getHostMemberByID(childID=qGetHostMembers.familyID, getAllMembers=1);
                    </cfscript>
                    
                    <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
                        <td style="padding-left:20px;">#qGetMemberDetail.name# #qGetMemberDetail.lastName#</td>
                        <td align="center">#season#</td>
                        <td align="center"><cfif isDate(date_sent)>#DateFormat(date_sent, 'mm/dd/yyyy')#<cfelse>processing</cfif></td>
                        <td align="center"><cfif isDate(date_expired)>#DateFormat(date_expired, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
                        <td align="center">
                            <cfif NOT LEN(requestid)>
                                processing
                            <cfelse>
                                <cfif client.usertype lte 4><a href="cbc/view_host_cbc.cfm?hostID=#qGetHostMembers.hostID#&CBCFamID=#qGetHostMembers.CBCFamID#&file=batch_#qGetHostMembers.batchid#_hostm_#qGetMemberDetail.name#_#qGetHostMembers.hostID#_rec.xml" target="_blank">#requestid#</a></cfif>
                            </cfif>
                        </td>
                        <td align="left">
                        	<cfif LEN(requestid)>
								<cfscript>
                                    APPLICATION.CFC.CBC.getCBCResultStatus(cbcID=cbcFamID,cbcType="host");
                                </cfscript>
                         	</cfif>
                        </td>
                        <cfif client.usertype lte 4><td align="left" valign="top"><cfif isDefined('notes')>#notes#</cfif></td></cfif>
                        <cfif client.usertype lte 4 and client.companyid eq 10><td align="center" valign="top"><a href="delete_cbc.cfm?type=host&id=#requestid#&userid=#url.hostid#"><img src="pics/deletex.gif" border=0/></td></cfif>
                    </tr>
                    </cfloop>
                </cfif>
            </table>
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign=bottom >
                    <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
                    <td width=100% background="pics/header_background_footer.gif"></td>
                    <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
                </tr>
            </table>
            
      	</td>
        
        <td>&nbsp;&nbsp;</td>
        
        <!--- RIGHT SIDE --->
        <td width="40%" align="right" valign="top">
        	<!--- OTHER FAMILY MEMBERS --->
            <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Other Family Members</h2></td>
                    <td background="pics/header_background.gif" width=16>
                    	<span class="buttonBlue smallerButton" onclick="window.location.href='index.cfm?curdoc=forms/host_fam_mem_form&hostID=#family_info.hostID#'">Add</span>
              		</td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
            	</tr>
            </table>
            <div class="scroll">
            <table width=100% align="left" border=0 cellpadding=2 cellspacing=0>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><u>Name</u></td>
                    <td><u>Sex</u></td>
                    <td><u>Age</u></td>
                    <td><u>Relation</u></td>
                    <td><u>At Home</u></td>
                </tr>	
                <cfloop query="host_children">
                    <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                        <td><a href="index.cfm?curdoc=host_fam_info&delete_child=#childid#&hostID=#family_info.hostID#" onClick="return confirm('Are you sure you want to delete this Family Member?')"><img src="pics/deletex.gif" border="0" alt="Delete"></a></td>
                        <td><a href="index.cfm?curdoc=forms/host_fam_mem_form&childid=#childid#"><img src="pics/edit.png" border="0" alt="Edit"></a></td>
                        <td>#name#</td>
                        <td>#sex#</td>
                        <td><cfif birthdate NEQ ''>#DateDiff('yyyy', birthdate, now())#</cfif></td>
                        <td>#membertype#</td>
                        <td>#liveathome#</td>
                    </tr>
                </cfloop>
            </table>
            </div>
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
            </table>
            
            <br/>
            
            <!--- HOST ELIGIBILITY --->
            <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Host Eligibility</h2></td>
                    <td background="pics/header_background.gif" width=16>
                        <cfif APPLICATION.CFC.USER.isOfficeUser()>
                        	<span class="buttonBlue smallerButton" onclick="window.location.href='index.cfm?curdoc=forms/host_fam_eligibility_form&hostID=#family_info.hostID#'">Edit</span>
                        </cfif>
                    </td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
            <table width="100%" align="left" cellpadding=8 class="section">
                <cfif family_info.isNotQualifiedToHost EQ 0>
                    <tr>
                        <td>
                            <input type="checkbox" disabled="disabled" /> Not Qualified
                        </td>
                        <td>
                            <cfif CLIENT.usertype LTE 7>
                                <cfif VAL(family_info.isHosting)>
                                    <form 
                                        method="post" 
                                        action="index.cfm?curdoc=host_fam_info&hostid=#url.hostid#" 
                                        style="display:inline;" 
                                        onsubmit="return confirm('Are you sure this family does not want to host this year?')">
                                        <input type="hidden" name="decideToHost" value="0"/>
                                        <input type="submit" value="Decided Not To Host"  alt="Decided Not To Host" border="0" class="buttonRed" />
                                    </form>
                                    <cfif VAL(family_info.hostAppStatus)>
                                        <form method="post" action="index.cfm?curdoc=host_fam_info&hostid=#url.hostid#" style="display:inline;">
                                            <input name="sendAppEmail" type="submit" value="Resend Login Info"  alt="Resend Login Info" border="0" class="buttonGreen" />
                                        </form>
                                    <cfelse>
                                        <form method="post" action="index.cfm?curdoc=host_fam_info&hostid=#url.hostid#" style="display:inline;">
                                            <input name="sendAppEmail" type="submit" value="Convert to eHost"  alt="Convert to eHost" border="0" class="buttonYellow" />
                                        </form>
                                    </cfif>
                                <cfelse>
                                    <form method="post" action="index.cfm?curdoc=host_fam_info&hostid=#url.hostid#" style="display:inline;">
                                        <input type="hidden" name="decideToHost" value="1"/>
                                        <input type="submit" value="Decided To Host"  alt="Decided To Host" border="0" class="buttonYellow" />
                                    </form>
                                </cfif>
                            </cfif>
                        </td>
                </tr>
                <cfelse>
                    <tr>
                        <td>
                            <input type="checkbox" checked="checked" disabled="disabled" /> <span style="color:red;"><b>Not Qualified</b></span>
                        </td>
                        
                    </tr>
                    <tr>
                        <td width="30%">
                            <u>Entered By</u>
                        </td>
                        <td width="20%">
                            <u>Date</u>
                        </td>
                        <td width="50%">
                            <u>Explanation</u>
                        </td>
                    </tr>
                    <cfloop query="qGetHostEligibility">
                        <tr>
                            <td>
                                #qGetHostEligibility.enteredBy#
                            </td>
                            <td>
                                #DateFormat(dateupdated,'mm/dd/yyyy')#
                            </td>
                            <td>
                                #comments#
                            </td>
                        </tr>
                    </cfloop>
                </cfif>
               
                <tr id="qualifiedNotesTr">
                </tr>
            </table>
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign="bottom">
                    <td width=9 valign="top" height=12>
                        <img src="pics/footer_leftcap.gif" >
                    </td>
                    <td width=100% background="pics/header_background_footer.gif">
                    </td>
                    <td width=9 valign="top">
                        <img src="pics/footer_rightcap.gif">
                    </td>
                </tr>
            </table>
            
            <br/>
            
            <!--- AREA REPRESENTATIVE --->
            <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Area Representative</h2></td>
                    <td background="pics/header_background.gif" width=16>
                        <cfif CLIENT.userType LTE 7>
                        	<span class="buttonBlue smallerButton" onclick="window.location.href='index.cfm?curdoc=forms/setHostAreaRepForm&hostID=#family_info.hostID#'">Edit</span>
                        </cfif>
                    </td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
                </tr>
            </table>
            <table width="100%" align="left" cellpadding=8 class="section">
                <tr>
                    <td>#qGetAreaRep.firstName# #qGetAreaRep.lastName# (###qGetAreaRep.userID#)</td>
                </tr>
            </table>
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign="bottom">
                    <td width=9 valign="top" height=12>
                        <img src="pics/footer_leftcap.gif" >
                    </td>
                    <td width=100% background="pics/header_background_footer.gif">
                    </td>
                    <td width=9 valign="top">
                        <img src="pics/footer_rightcap.gif">
                    </td>
                </tr>
            </table>
            
            <br/>
            
            <!--- STUDENTS --->
            <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td><td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
                    <td background="pics/header_background.gif"><h2>Students</h2></td><td align="right" background="pics/header_background.gif"><font size="-1">[ Hosting / Hosted ]</font></td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
            </table>
            <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                <tr><td width="10%"><u>ID</u></td>
                    <td width="50%"><u>Name</u></td>
                    <td width="20%"><u>Country</u></td>
                    <td width="20%"><u>Program</u></td></tr>
            </table>
            <div class="scroll2">
            <table width=100% align="left" border=0 cellpadding=1 cellspacing=0>
                <cfif hosting_students.recordcount is '0'>
                    <tr><td colspan="4" align="center">no current students are assigned to this host family</td></tr>
                <cfelse>			
                    <tr><td colspan="4" bgcolor="e2efc7"><u>Current Students</u></td></tr>
                    <cfloop query="hosting_students">
                        <tr bgcolor="e2efc7"><td width="10%"><a href="?curdoc=student_info&studentid=#studentid#">#studentid#</a></td>
                            <td width="50%"><a href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</a></td>
                            <td width="20%">#countryname#</td>
                            <td width="20%">#programname#</td></tr>
                    </cfloop>
                </cfif>	
                <cfif hosted_students.recordcount is '0'>
                    <tr><td colspan="4" align="center">no previous students were assigned to this host family</td></tr>
                <cfelse>			
                    <tr><td colspan="4"><u>Students Hosted</u></td></tr>
                    <cfloop query="hosted_students">
                        <tr><td width="10%"><a href="?curdoc=student_info&studentid=#studentid#">#studentid#</a></td>
                            <td width="50%"><a href="?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</a></td>
                            <td width="20%">#countryname#</td>
                            <td width="20%">#programname#</td></tr>
                    </cfloop>
                </cfif>
            </table>
            </div>		
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
            </table>
            
            <br/>
            
            <!--- OTHER INFORMATION --->
            <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                <tr valign=middle height=24>
                    <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
                    <td background="pics/header_background.gif"><h2>Other Information</h2></td>
                    <td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
            </table>
            <table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
                <tr><td><a href="index.cfm?curdoc=forms/host_fam_pis_3&hostID=#family_info.hostID#">Room, Smoking, Pets, Church</a></td></tr>
                <tr bgcolor="ffffe6"><td><a class="nav_bar" href="index.cfm?curdoc=forms/host_fam_pis_4&hostID=#family_info.hostID#">Family Interests</a></td></tr>
                <tr><td><a class="nav_bar" href="index.cfm?curdoc=forms/double_placement&hostID=#family_info.hostID#">Rep Info</a></td></tr>
            </table>				
            <table width=100% cellpadding=0 cellspacing=0 border=0>
                <tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td><td width=100% background="pics/header_background_footer.gif"></td><td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
            </table>
        </td>
  	</tr>
</table>

</cfoutput>