<!--- ------------------------------------------------------------------------- ----
	
	File:		_list.cfc
	Author:		Marcus Melo
	Date:		August 27, 2010
	Desc:		Online Applications List

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param URL Variables --->
    <cfparam name="URL.statusID" default="0">
	<cfparam name="URL.uniqueID" default="0">

    <cfscript>	
		// Get Current Status
		qGetStatus = APPLICATION.CFC.onlineApp.getApplicationStatusByID(statusID=URL.statusID);

		// Set Candidate Record as Deleted
		if ( LEN(URL.uniqueID) ) {
			// Get Candidate Info
			qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=URL.uniqueID);
			
			if ( qGetCandidateInfo.recordCount) {
				// Set Candidate as Deleted
				isDeleted = APPLICATION.CFC.candidate.deleteCandidate(candidateID=qGetCandidateInfo.candidateID);
		
				// Set Page Message
				SESSION.pageMessages.Add("Candidate " & qGetCandidateInfo.firstName & " " & qGetCandidateInfo.lastName & " successfully deleted");
			} else {
				SESSION.formErrors.Add("Candidate could not be deleted");
			}

			// Reload page with updated information
			location("index.cfm?curdoc=onlineApplication/index&action=#URL.action#&statusID=#URL.statusID#", "no");
			
		}
		
		if ( ListFind("1,2,3,4", VAL(CLIENT.usertype)) ) {
			// Get List
			qGetCandidates = APPLICATION.CFC.CANDIDATE.getApplicationListbyStatusID(applicationStatusID=URL.statusID);
		} else { 
			// Get List
			qGetCandidates = APPLICATION.CFC.CANDIDATE.getApplicationListbyStatusID(
				applicationStatusID=URL.statusID,
				intRep=CLIENT.userID
			);
		}
	</cfscript>

</cfsilent>

<script type="text/javascript">
	$(document).ready(function() {
		
		// --- START OF VERICATION RECEIVED --- //
		var confirmReceived = function() {
			// Are you sure you would like to check DS-2019 verification for student #" + studentID + " as received?
			if (confirm(" Are you sure you would like to delete this application? \n If you change your mind in the future, please contact suppport to reactivate this account.")){
				return true; 
			} else {
				return false; 
			}
		}	
	
		// Pop Up Application 
		$('.popUpOnlineApplication').popupWindow({ 
			height:600, 
			width:1100,
			centerBrowser:1,
			scrollbars:1,
			resizable:1,
			windowName:'onlineApplication'
		}); 
		
		// Pop Up Application 
		$('.popUpDisplayLogin').popupWindow({ 
			height:250, 
			width:600,
			centerBrowser:1,
			scrollbars:0,
			resizable:1,
			windowName:'loginInformation'
		}); 
		
	});
</script>

<cfoutput>

<div class="divPageBox">
	  
    <div class="pageTitle title1">
    	#qGetStatus.name# Online Application List 
    	
    	<span class="style1" style="float:right; padding-right:5px; font-weight:normal;">
        	#qGetCandidates.recordcount# candidate(s) found
        </span>
    </div>
        
	<br />

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
    
    <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
        <tr bgcolor="##4F8EA4">
            <td width="5%" class="style2" align="left">ID</td>
            <td width="12%" class="style2" align="left">Last Name</td>
            <th width="12" class="style2" align="left">First Name</th>
            <th width="5%" class="style2" align="left">Gender</th>
            <th width="16%" class="style2" align="left">Email</th>
            <th width="10%" class="style2" align="left">Submitted</th>	
            
            <cfif ListFind("1,2,3,4", VAL(CLIENT.userType))>
            	<th width="18%" class="style2" align="left">Intl. Rep.</th>
            <cfelse>
            	<th width="18%" class="style2" align="left">Created By</th>
			</cfif>  
            <th width="10%" class="style2" align="left">Program Option</th>		
            <th width="12%" class="style2" align="left">Requested Placement</th>              
        </tr>
        
		<cfif NOT qGetCandidates.recordCount>
            <tr bgcolor="##e9ecf1">
                <td class="style5" colspan="8">There are no records.</td>
            </tr>
        </cfif>
        
        <cfloop query="qGetCandidates">
        <cfquery name = "rP" datasource="#APPLICATION.DSN.Source#">
        	SELECT answer
            FROM applicationanswer
            WHERE fieldkey = 'requestedPlacement'
            AND foreignid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidates.candidateid#">
            
        </cfquery>
        
        
            <tr bgcolor="###iif(qGetCandidates.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                <td><a href="onlineApplication/index.cfm?action=initial&uniqueID=#qGetCandidates.uniqueID#" class="style4 popUpOnlineApplication">#qGetCandidates.candidateID#</a></td>
                <td><a href="onlineApplication/index.cfm?action=initial&uniqueID=#qGetCandidates.uniqueID#" class="style4 popUpOnlineApplication">#qGetCandidates.lastName#</a></td>
                <td><a href="onlineApplication/index.cfm?action=initial&uniqueID=#qGetCandidates.uniqueID#" class="style4 popUpOnlineApplication">#qGetCandidates.firstName#</a></td>
                <td class="style5"><cfif qGetCandidates.sex EQ 'm'>Male<cfelse>Female</cfif></td>
                <td class="style5">#qGetCandidates.email#</td>
                <td class="style5">#DateFormat(qGetCandidates.dateCreated, 'mm/dd/yyyy')#</td>	
                	
				<cfif ListFind("1,2,3,4", VAL(CLIENT.userType))>
                    <td class="style5">#qGetCandidates.businessName#</td>
                <cfelse>
                    <td class="style5">
                    	<cfif LEN(qGetCandidates.branchName)>
                        	#qGetCandidates.branchName#
                        <cfelse>
                        	Main Office
                        </cfif>
                    </td>
                </cfif>                
                <td class="style5">#qGetCandidates.wat_placement#</td>
                <td class="style5">
                 <cfif len(rP.answer)>#rP.answer#</cfif>
                   <!--- <a href="onlineApplication/index.cfm?action=displayLogin&uniqueID=#qGetCandidates.uniqueID#" class="style4 popUpDisplayLogin">[View Login]</a>
					
                    <!--- Do not allow Agents to [delete] applications once submitted --->                    
                    <cfif qGetCandidates.applicationStatusID LT 7 OR ( ListFind("7,8,9,10,11", qGetCandidates.applicationStatusID) AND ListFind("1,2,3,4", CLIENT.userType) )> 
                        &nbsp;
                        <a href="index.cfm?curdoc=onlineApplication/index&action=#URL.action#&statusID=#URL.statusID#&uniqueID=#qGetCandidates.uniqueID#" onclick="return confirmReceived();" class="style4">[Delete]</a>
                	</cfif>
					---->
                </td>
            </tr>
        </cfloop>
      
	</table>
    
    <br /><br />
            
</div>

</cfoutput>
