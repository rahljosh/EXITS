
<!--- ------------------------------------------------------------------------- ----
	
	File:		host_fam_info.cfm
	Author:		Marcus Melo
	Date:		December 10, 2009
	Desc:		Not updated.

	Updated:  	

----- ------------------------------------------------------------------------- --->
<link rel="stylesheet" href="linked/css/colorbox2.css" />
<!--- Kill extra output --->
<cfsilent>
	
	<cfajaxproxy cfc="extensions.components.cbc" jsclassname="CBC">

    <!--- Param URL Variables --->
    <cfparam name="url.hostID" default="">
    
    <!--- CHECK RIGHTS --->
	<cfinclude template="check_rights_host.cfm">
	
	<cfscript>
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
        SELECT schoolid, schoolname, address, city, state, begins, ends, zip, url, begins, semesterends, semesterbegins, ends, enrollment, principal, phone
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
    <cfinclude template="hostApplication/appStatus.cfm">

<cfset barLength = Round((#appNotComplete# / 300) * 100)>
<cfif barLength gte 99><cfset barLength = 99></cfif>

    <!----Get documents---->
    
    <cfquery name="qDocuments" datasource="#application.dsn#">
    select *
    from smg_documents
    where hostid = #url.hostid#
    </cfquery>

</cfsilent>
<script>

        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
                onClosed:function(){ location.reload(false); } });

            
        });

    </script>

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
<cfset totalfam = #mother# + #father# + #kidsAtHome.recordcount#>

<cfif totalfam eq 1>

<h1>Single Person Placement - additional screening will be required. </h1>
<em>Starting with Aug 2011 Students - Single Person Placement Authorization Form and 2 additional references</em> </div>
<br />
</cfif>

<!--- INFORMATION - Not currently Userd For Hot Info.  Area for generic information at top of page that spans all columns --->
<!----
			<div class="rdholder"> 
				<div class="rdtop"> 
                <span class="rdtitle">Please Note</span> 
            </div> <!-- end top --> 
             <div class="rdbox">
	</div>
             <div class="rdbottom"></div> <!-- end bottom --> 
            
             </div>
			 ---->
<!----Left column for alignment purposes---->
<div class="rdholder" style="width:100%;float:left;"> 
<div style="width:49%;float:left;display:block;">
			<!----Personal Information---->
		   
           
 			<!--- ------------------------------------------------------------------------- ---->
            <!---Host Family Information---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Host Family Information</span> 
                 <cfif CLIENT.usertype LTE 5>
                 <a href="" onClick="return confirm('You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue.')"><img src="pics/deletex.gif" border="0" ></a>
                
                </cfif>
                <a href="?curdoc=forms/host_fam_form&hostID=#family_info.hostID#"><img src="pics/buttons/pencilBlue23x29.png" class="floatRight" border=0/></a>
            	</div> <!-- end top --> 
             <div class="rdbox">



	<!--- BODY OF A TABLE --->
	<table width="100%" border=0 cellpadding=4 cellspacing=0>
		<tr><h2>#family_info.familylastname# - (#family_info.hostID#)</h2></td></tr>
        <tr>
        	<Td valign="top">#family_info.address#<br />
        <Cfif family_info.address2 is not ''>#family_info.address2#<br /></Cfif>
       <a href="http://en.wikipedia.org/wiki/#family_info.city#,_#family_info.state#" class="iframe">#family_info.city# #family_info.state#</a>, #family_info.zip# <br /><br />
         #family_info.phone#<br /><br>
        <a href="mailto:#family_info.email#">#family_info.email#</a><br />
        Password: #family_info.password#
        </Td>
        
		<td valign="top">Father: #family_info.fatherfirstname# #family_info.fatherlastname# (<cfif family_info.fatherdob NEQ ''>#dateDiff('yyyy', family_info.fatherdob, now())#</cfif>)<br />Occupation: #family_info.fatherworktype#<br />Cell: <cfif family_info.father_cell is ''>Not on File<cfelse>#family_info.father_cell#</cfif><br /><br />Mother: #family_info.motherfirstname# #family_info.motherlastname# (<cfif family_info.motherdob NEQ ''>#dateDiff('yyyy', family_info.motherdob, now())#</cfif>)<br />
        Occupation: #family_info.motherworktype#<Br />Cell: <cfif family_info.mother_cell is ''>Not on File<cfelse>#family_info.mother_cell#</cfif></td>
        </tr>
       <tr>
       	
        <td valign="top">
       
        </td>
		</tr>
	</table>	
	   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END host Information---->
            <!--- ------------------------------------------------------------------------- ---->
    	
            


   		
    	

	

	<br /><br />
   		<!--- ------------------------------------------------------------------------- ---->
            <!---School Information ---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">School Information</span> 
                 <a href="?curdoc=forms/host_fam_pis_5&hostID=#family_info.hostID#"><img src="pics/buttons/pencilBlue23x29.png" class="floatRight" border=0/></a>
            	</div> <!-- end top --> 
             <div class="rdbox">
    
	
		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0 >
			<tr><td><cfif get_school.recordcount is '0'>there is no school assigned<cfelse><strong>#get_school.schoolname#</strong></cfif><br />
            #get_school.address#<br />
            #get_school.principal#<br />
            #get_school.phone#<br />
            #get_school.city# #get_school.state#, #get_school.zip#<br />
            <cfif left(get_school.url, 4) is not 'http'><cfset schoolURL = 'http://#get_school.url#'><Cfelse><cfset schoolURL = '#get_school.url#'></cfif>
            <cfif get_school.url is ''><a href="http://www.google.com/search?q=#get_school.schoolname#+#get_school.city#+#get_school.state#">Google Seach School, no URL on file.<cfelse><a href="#schoolURL#" class='iframe'>#schoolURL#</a></cfif>
            
            </td>
            <td>
            <Table>
            	<tr>
                	<Td>Year Starts </Td><td><cfif get_school.begins is ''>n/a<cfelse>#DateFormat(get_school.begins, 'mm/dd/yyyy')#</cfif></td>
                </tr>
                <tr>
                	<Td>1<sup>st</sup> Sem. Ends</Td><td> <cfif get_school.begins is ''>n/a<cfelse>#DateFormat(get_school.semesterends, 'mm/dd/yyyy')#</cfif> </td>
                <tr>
                	<Td>2<sup>nd</sup> Sem. Starts </Td><td> <cfif get_school.begins is ''>n/a<cfelse>#DateFormat(get_school.semesterbegins, 'mm/dd/yyyy')#</cfif></td>
                <tr>
                	<Td>Year Ends</Td><Td> <cfif get_school.ends is ''>n/a<cfelse>#DateFormat(get_school.ends, 'mm/dd/yyyy')#</cfif></Td>
                </tr>
              </table>
            </td>
            </tr>
            <tr>
                	<Td>
			
			<!----
			<tr><td>Start Date:</td><td><cfif get_school.begins is ''>n/a<cfelse>#DateFormat(get_school.begins, 'mm/dd/yyyy')#</cfif></td></tr>
			<tr><td>End Date:</td><td><cfif get_school.ends is ''>n/a<cfelse>#DateFormat(get_school.ends, 'mm/dd/yyyy')#</cfif></td></tr>			
			---->
			<tr><td>&nbsp;</td></tr>
		</table>				
		<!--- BOTTOM OF A TABLE --- SCHOOL  --->
   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END Shool info---->
            <!--- ------------------------------------------------------------------------- ---->
         
   <br /><br />
   		<!--- ------------------------------------------------------------------------- ---->
            <!---Student Information ---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Students</span> 
                <font size="-1">[ Hosting / Hosted ]</font>
            	</div> <!-- end top --> 
             <div class="rdbox">         
            

		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0 >
			<tr bgcolor='0b5886'><td width="10%"><font color="##FFFFFF"><strong>ID</strong></td>
				<td width="50%"><font color="##FFFFFF"><strong>Name</strong></td>
				<td width="20%"><font color="##FFFFFF"><strong>Country</strong></td>
				<td width="20%"><font color="##FFFFFF"><strong>Program</strong></td></tr>
		</table>
		
		<table width=100% align="left" border=0 cellpadding=1 cellspacing=0>
        <tr><td colspan="4" bgcolor="d6e8f3"><strong>Current Students</strong></td></tr>
			<cfif hosting_students.recordcount is '0'>
				<tr><td colspan="4" align="center">There are currently not students assigned to this family.</td></tr>
			<cfelse>			
				
				<cfloop query="hosting_students">
					<tr <cfif currentrow mod 2>bgcolor="efefef"</cfif>><td width="10%"><a href="">#studentid#</a></td>
						<td width="50%"><a href="">#firstname# #familylastname#</a></td>
						<td width="20%">#countryname#</td>
						<td width="20%">#programname#</td></tr>
				</cfloop>
			</cfif>	
            <tr>
            	<td>&nbsp;</td>
            </tr>
            <tr><td colspan="4" bgcolor='d6e8f3'><strong>Students Hosted</strong></td></tr>
			<cfif hosted_students.recordcount is '0'>
				<tr><td colspan="4" align="center">This family has never hosted a student. </td></tr>
			<cfelse>			
				
				<cfloop query="hosted_students">
					<tr <cfif currentrow mod 2>bgcolor="efefef"</cfif>><td width="10%"><a href="">#studentid#</a></td>
						<td width="50%"><a href="">#firstname# #familylastname#</a></td>
						<td width="20%">#countryname#</td>
						<td width="20%">#programname#</td></tr>
				</cfloop>
			</cfif>
		</table>
        
	 <div style="display: block; height: 8px; width: 100%;"></div>
     <font color="white">></font>
	   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END Student info---->
            <!--- ------------------------------------------------------------------------- ---->
        	
            
   <br /><br />
   		<!--- ------------------------------------------------------------------------- ---->
            <!---CBC Information ---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Criminal Background Check</span> 
                <cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'>
                	<a href="?curdoc=cbc/hosts_cbc&hostID=#family_info.hostID#"><img src="pics/buttons/pencilBlue23x29.png" class="floatRight" border=0/></a>
                </cfif>
            	</div> <!-- end top --> 
             <div class="rdbox">  

	
			<!--- BODY OF TABLE --->
		<table width=100% cellpadding=4 cellspacing=0 border=0>
			<tr bgcolor="e2efc7">
				<td valign="top"><b>Name</b></td>
				<td align="center" valign="top"><b>Season</b></td>		
				<td align="center" valign="top"><b>Date Submitted</b> <br><font size="-2">mm/dd/yyyy</font></td>
                <td align="center" valign="top"><b>Expiration Date</b> <br><font size="-2">mm/dd/yyyy</font></td>		
				<td align="center" valign="top"><b>View</b></td>
                 <cfif client.usertype lte 4> <td align="left" valign="top" colspan="2"><b>Notes</b></td></cfif>
                <cfif client.usertype lte 4 and client.companyid eq 10><td align="center" valign="top"><b>Delete</b></td></cfif>
			</tr>				
			<cfif qGetCBCMother.recordcount EQ '0' AND qCheckCBCMother.recordcount EQ '0' AND qGetCBCFather.recordcount EQ '0' AND qCheckCBCFather.recordcount EQ '0'>
				<tr><td align="center" colspan="5">No CBC has been submitted.</td></tr>
			<cfelse>
				<tr><td colspan="6"><strong>Host Mother:</strong></td></tr>
				<cfloop query="qGetCBCMother">
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("efefef") )#"> 
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
                    <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("efefef") )#"> 
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
					</tr>
				</cfloop>
                
				<tr bgcolor="e2efc7"><td colspan="6"><strong>Host Father:</strong></td></tr>
				<cfloop query="qGetCBCFather">
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("efefef") )#"> 
					<td style="padding-left:20px;">#family_info.fatherfirstname# #family_info.fatherlastname#</td>
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
                        		<a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCFather.hostID#&CBCFamID=#CBCFamID#&file=batch_#qGetCBCFather.batchid#_host_father_#qGetCBCFather.hostID#_rec.xml" target="_blank">#requestid#</a>
                        	<cfelse>
                            	#requestid#
                          </cfif>
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
                    <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("efefef") )#"> 
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
            
			<tr bgcolor="e2efc7"><td colspan="6"><strong>Other Family Members</strong></td></tr>
			<cfif qGetHostMembers.recordcount EQ '0'>
				<tr><td align="center" colspan="6">No CBC has been submitted.</td></tr>
			<cfelse>
                <cfloop query="qGetHostMembers">
                
                <cfscript>
					// Get Member Details
					qGetMemberDetail = APPCFC.HOST.getHostMemberByID(childID=qGetHostMembers.familyID, getAllMembers=1);
				</cfscript>
                
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("efefef") )#"> 
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
                    <cfif client.usertype lte 4><td align="left" valign="top"><cfif isDefined('notes')>#notes#</cfif></td></cfif>
                    <cfif client.usertype lte 4 and client.companyid eq 10><td align="center" valign="top"><a href="delete_cbc.cfm?type=host&id=#requestid#&userid=#url.hostid#"><img src="pics/deletex.gif" border=0/></td></cfif>
                </tr>
                </cfloop>
			</cfif>
		</table>
	   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END CBC info---->
            <!--- ------------------------------------------------------------------------- ---->
        	
   
  </div>
   
    <!--- ------------------------------------------------------------------------- ---->
	<!---- Right Column---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
    <!--- ------------------------------------------------------------------------- ---->
   
    
  <div style="width:49%;float:right;display:block;">
       <!--- ------------------------------------------------------------------------- ---->
            <!---Other Family Information---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:right;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Family Members</span> 
                 <cfif CLIENT.usertype LTE 5>
                 
                
                 </cfif>
                 <a href="index.cfm?curdoc=forms/host_fam_mem_form&hostID=#family_info.hostID#"><img src="pics/buttons/new23x23.png" width="23" border=0 class="floatRight" /></a>
            	</div> <!-- end top --> 
             <div class="rdbox">
	
	<!--- BODY OF TABLE --->
	<table width='100%' align="left" border="0" cellpadding="2" cellspacing="0">
			
		<cfloop query="host_children">
			<tr bgcolor="#iif(currentRow MOD 2 ,DE('efefef') ,DE('white') )#">
                <td><a href="index.cfm?curdoc=host_fam_info&delete_child=#childid#&hostID=#family_info.hostID#" onClick="return confirm('Are you sure you want to delete this Family Member?')"><img src="pics/deletex.gif" border="0" alt="Delete"></a></td>
                <td><a href="index.cfm?curdoc=forms/host_fam_mem_form&childid=#childid#"><img src="pics/buttons/pencilBlue23x29.png" border="0" alt="Edit"></a></td>
            	<td>#name#</td>
				<td>#sex#</td>
				<td><cfif birthdate NEQ ''>#DateDiff('yyyy', birthdate, now())#</cfif></td>
				<td>#membertype#</td>
				<td><cfif liveathome is 'yes'>at home<cfelse>not at home</cfif></td>
            </tr>
		</cfloop>
	</table>
<div style="display: block; height: 8px;width: 100%;"></div>
<font color="white">></font>
	   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END other fam Information---->
            <!--- ------------------------------------------------------------------------- ---->
  
  <br /><br />
  
  <div class="rdholder" style="width:100%;float:right;" > 
				<div class="rdtop"> 
  <span class="rdtitle">Host Eligibility</span> 
			<cfif APPLICATION.CFC.USER.isOfficeUser()>
                 <a href="index.cfm?curdoc=forms/host_fam_eligibility_form&hostID=#family_info.hostID#" class="floatRight">Edit</a>
            </cfif>
        </div> <!-- end top --> 
         <div class="rdbox">    
   <table width="100%" align="left" cellpadding=8 >
		<cfif family_info.isNotQualifiedToHost EQ 0>
            <tr>
                <td>
                    <input type="checkbox" disabled="disabled" /> Not Qualified
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
  
  
   <div class="clearfix"></div>
	   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
  
  
   		<!--- ------------------------------------------------------------------------- ---->
            <!---Online App ---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Online Application</span> 
                 
            	</div> <!-- end top --> 
             <div class="rdbox">
	
	<!--- BODY OF TABLE --->
	<table width=100% align="left" border=0 cellpadding=2 cellspacing=0>
		<tr>
            <td><u>Status</u></td>
			
			<td><u>Application</u></td>
			
        </tr>	
		
			<tr>
                <td>
					 <cfif family_info.hostAppStatus EQ 8>Filling Out</cfif>
                     <cfif family_info.hostAppStatus EQ 7>Waiting on Area Representative</cfif>
                     <cfif family_info.hostAppStatus EQ 6>Waiting on Regional Advisor</cfif>
                     <cfif family_info.hostAppStatus EQ 5>Waiting on Regional Manager</cfif>
                     <cfif family_info.hostAppStatus EQ 4>Waiting on Program Manager</cfif>
                     <cfif family_info.hostAppStatus LTE 3>Approved</cfif>
                 </td>
				
                  <td><a href="" target="_blank">View App</a></td>
            </tr>
		
	</table>
   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END online app---->
            <!--- ------------------------------------------------------------------------- ---->
	
  
   <br /><br />
   		<!--- ------------------------------------------------------------------------- ---->
            <!---Documents ---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Documents</span> 
                 
            	</div> <!-- end top --> 
             <div class="rdbox">
	<!--- BODY OF TABLE --->
	<table width=100% align="left" border=0 cellpadding=2 cellspacing=0>
		<tr>
            
        	<td><u>Name</u></td>
			<td><u>Type</u></td>
			<td><u>Description</u></td>
			
        </tr>	
		<cfloop query="qDocuments">
			<tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
               
            	<td><a href="uploadedfiles/#filePath##fileName#" target="_blank">#fileName#</a></td>
				<td>#type#</td>
				<td>#shortDesc#</td>
				
            </tr>
		</cfloop>
	</table>
	
	   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END documents---->
            <!--- ------------------------------------------------------------------------- ---->
            

   
   <br /><br />
   
   		<!--- ------------------------------------------------------------------------- ---->
            <!---Community Information ---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Community Information</span> 
               
                 <a href="?curdoc=forms/host_fam_pis_7&hostID=#family_info.hostID#"><img src="pics/buttons/pencilBlue23x29.png" class="floatRight" border=0/></a>
            	</div> <!-- end top --> 
             <div class="rdbox">

		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0>
			<tr><td>Region:</td><td colspan="3"><cfif get_region.regionname is ''>not assigned<cfelse>#get_region.regionname#</cfif></td></tr>
			<tr><td>Community:</td><td colspan="3"><cfif family_info.community is ''>n/a<cfelse>#family_info.community#</cfif></td></tr>
			<tr><td>Closest City:</td><td><cfif family_info.nearbigcity is ''>n/a<cfelse>#family_info.nearbigcity#</cfif></td><td>Distance:</td><td>#family_info.near_City_dist# miles</td></tr>
			<tr><td>Airport Code:</td><td colspan="3"><cfif family_info.major_air_code is ''>n/a<cfelse>#family_info.major_air_code#</cfif></td></tr>
			<tr><td>Airport City:</td><td colspan="3"><cfif family_info.airport_city is '' and family_info.airport_state is ''>n/a<cfelse>#family_info.airport_city# / #family_info.airport_state#</cfif></td></tr>
			<tr><td valign="top">Interests: </td><td colspan="3"><cfif len(#family_info.pert_info#) gt '100'>#Left(family_info.pert_info,92)# <a href="">more...</a><cfelse>#family_info.pert_info#</cfif></td></tr>
            </table>
	   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END Community Info---->
            <!--- ------------------------------------------------------------------------- ---->
        			 	     
<br /><br />
   		<!--- ------------------------------------------------------------------------- ---->
            <!---Other Information ---->
            <!--- ------------------------------------------------------------------------- ---->

    	<div class="rdholder" style="width:100%;float:left;" > 
				<div class="rdtop"> 
                <span class="rdtitle">Other Information</span> 
               
            	</div> <!-- end top --> 
             <div class="rdbox">  
		<!--- BODY OF TABLE --->
		<table width="100%" border=0 cellpadding=4 cellspacing=0 >
			<tr bgcolor="efefef"><td><a class="iframe" href="index.cfm?curdoc=forms/host_fam_pis_3&hostID=#family_info.hostID#">Room, Smoking, Pets, Church</a></td></tr>
			<tr><td><a class="iframe" href="index.cfm?curdoc=forms/host_fam_pis_4&hostID=#family_info.hostID#">Family Interests</a></td></tr>
			<tr bgcolor="efefef"><td><a class="iframe" href="index.cfm?curdoc=forms/double_placement&hostID=#family_info.hostID#">Rep Info</a></td></tr>
		</table>				
	   </div>
            <div class="rdbottom"></div> <!-- end bottom --> 
            </div>
            <!--- ------------------------------------------------------------------------- ---->
            <!----END OTHER info---->
            <!--- ------------------------------------------------------------------------- ---->
</div>
</cfoutput>
