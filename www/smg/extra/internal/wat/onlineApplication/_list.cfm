<!--- ------------------------------------------------------------------------- ----
	
	File:		_list.cfc
	Author:		Marcus Melo
	Date:		August 27, 2010
	Desc:		Online Applications List

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	
	
    <!--- Param URL Variables --->
    <cfparam name="URL.statusID" default="0">

    <cfscript>	
		// Get Current Status
		qGetStatus = APPLICATION.CFC.onlineApp.getApplicationStatusByID(statusID=URL.statusID);
		
		if ( VAL(CLIENT.usertype) LTE 4 ) {
			// Get List
			qGetCandidates = APPLICATION.CFC.candidate.getApplicationListbyStatusID(applicationStatusID=URL.statusID);
		} else { 
			// Get List
			qGetCandidates = APPLICATION.CFC.candidate.getApplicationListbyStatusID(
				applicationStatusID=URL.statusID,
				intRep=CLIENT.userID
			);
		}
	</cfscript>

</cfsilent>

<cfoutput>

<div class="divPageBox">
	  
    <div class="pageTitle title1">
    	#qGetStatus.name# Online Application List 
    	
    	<span class="style1" style="float:right; padding-right:5px; font-weight:normal;">
        	#qGetCandidates.recordcount# candidate(s) found
        </span>
    </div>
        
	<br />
    
    <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
        <tr bgcolor="##4F8EA4">
            <td width="5%" class="style2" align="left">ID</td>
            <td width="13%" class="style2" align="left">Last Name</td>
            <th width="12" class="style2" align="left">First Name</th>
            <th width="5%" class="style2" align="left">Gender</th>
            <th width="20%" class="style2" align="left">Email</th>
            <th width="10%" class="style2" align="left">Submitted</th>		
            <cfif VAL(CLIENT.userType) LTE 4>
            	<th width="20%" class="style2" align="left">Intl. Rep.</th>
            <cfelse>
            	<th width="20%" class="style2" align="left">Created By</th>
			</cfif>  
            <th width="15%" class="style2" align="left">Actions</th>              
        </tr>
        
		<cfif NOT qGetCandidates.recordCount>
            <tr bgcolor="##e9ecf1">
                <td class="style5" colspan="8">There are no records.</td>
            </tr>
        </cfif>
        
        <cfloop query="qGetCandidates">
            <tr bgcolor="###iif(qGetCandidates.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                <td><a href="" class="style4">#qGetCandidates.candidateID#</a></td>
                <td><a href="" class="style4">#qGetCandidates.lastName#</a></td>
                <td><a href="" class="style4">#qGetCandidates.firstName#</a></td>
                <td class="style5"><cfif qGetCandidates.sex EQ 'm'>Male<cfelse>Female</cfif></td>
                <td class="style5">#qGetCandidates.email#</td>
                <td class="style5">#DateFormat(qGetCandidates.dateCreated, 'mm/dd/yyyy')#</td>		
				<cfif VAL(CLIENT.userType) LTE 4>
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
                <td class="style5">
                	<a href="" class="style4">[Login]</a>
                    &nbsp;
                    <a href="" class="style4">[Delete]</a>
                </td>
            </tr>
        </cfloop>
	</table>
    
    <br /><br />
            
</div>

</cfoutput>