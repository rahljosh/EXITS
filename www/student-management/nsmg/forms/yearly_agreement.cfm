	<Cfset season = 8>
	<!---_Check Agreement---->
    <Cfquery name="checkAgreement" datasource="#application.dsn#">
    select ar_cbc_auth_form, ar_agreement
    from smg_users_paperwork
    where userid = #client.userid#
    and seasonid = #season#
    </cfquery>
    <!----Check Refrences---->
    <Cfquery name="checkReferences" datasource="#application.dsn#">
    select *
    from smg_user_references
    where referencefor = #client.userid#
    </cfquery>
    <!----Check Employmenthistory---->
    <Cfquery name="employHistory" datasource="#application.dsn#">
    select *
    from smg_users_employment_history
    where fk_userid = #client.userid#
    </cfquery>  
    <Cfquery name="prevExperience" datasource="#application.dsn#">
    select prevOrgAffiliation, prevAffiliationName
    from smg_users
    where userid = #client.userid#
    </cfquery>
     <Cfif employHistory.recordcount gte 2 AND (prevExperience.prevOrgAffiliation eq 0 OR (prevExperience.prevOrgAffiliation eq 1 and prevExperience.prevAffiliationName is not ''))>
     	<Cfset previousExperience = 1>
     <cfelse>
     	<Cfset previousExperience = 0>
     </Cfif> 
     <Cfif checkAgreement.ar_cbc_auth_form is not '' AND checkAgreement.ar_agreement is not '' AND checkReferences.recordcount eq 4 and CLIENT.agreement_needed eq 1 and previousExperience eq 1 >
        <cfset temp = DeleteClientVariable("agreement_needed")>
     	<cflocation url="index.cfm?curdoc=initial_welcome">
     </Cfif>
  
    <style type="text/css">
    .outline {
	padding: 5px;
	border: thin solid #666;
	width: 500px;
	margin-left: 30px;
}
    .yellowbox {
	background-color: #FFC;
	width: 480px;
	margin-left: 30px;
	padding-top: 20px;
	padding-right: 20px;
	padding-bottom: 10px;
	padding-left: 20px;
}
    </style>
    
    
<div class="yellowbox">
<p>The information below needs to be updated for the new season.  Access to <strong>EXITS</strong> is disabled until these agreements have been signed, and information submited.</p>
<p><strong>ALL FOUR SECTIONS ARE REQUIRED</strong></p></div><br />
<cfoutput>
<div class="outline">
<table width="100%" align="center"  cellspacing=5 cellpadding=4>
	<tr bgcolor="##666" cellspacing=0 cellpadding=4>
    	<td width="350"><h2><font color="##FFFFFF">&nbsp;&nbsp;Item</font></h2></td><Td width="100" align="center"><h2><font color="##FFFFFF">Status</font></h2></Td>
    </tr>
	<Tr>
	  	<Td><h2>Services Agreement</h2></Td>
        <td align="center" >
			<cfif checkAgreement.ar_agreement is ''>
        		<a href="javascript:openPopUp('forms/displayRepAgreement.cfm?curdoc=displayRepAgreement', 640, 800);"><img src="../pics/infoNeeded.png" width="120" height="30" border="0" /></a>
            <cfelse>
             <img src="../pics/noInfo.png" width="120" height="30" border="0" />
          </cfif> 
        </td>
    </tr>    
    <Tr>
	  	<Td><h2>CBC Authorization</h2></Td>
        <td align="center">
        	<cfif checkAgreement.ar_cbc_auth_form is ''>
            	<a href="javascript:openPopUp('forms/cbcAuthorization.cfm?curdoc=cbcAuthorization', 640, 800);"><img src="../../images/infoNeeded.png" width="120" height="30" border="0" /></a>
            <cfelse>
            	 <img src="../../images/noInfo.png" width="120" height="30" border="0" />
          </cfif>
        </td>
    </tr>  
    <Tr>
	  	<Td><h2>Employment History</h2></Td>
        <td align="center">
        	<cfif previousExperience eq 0>
            	<a href="javascript:openPopUp('forms/employmentHistory.cfm?curdoc=employmentHistory', 640, 800);"><img src="../../images/infoNeeded.png" width="120" height="30" border="0" /></a>
            <cfelse>
            	 <img src="../../images/noInfo.png" width="120" height="30" border="0" />
          </cfif>
        </td>
    </tr> 
    <Tr >
	  	 <Td><h2>References</h2></Td><td align="left" <cfif checkReferences.recordcount lt 2></cfif>>
          	<cfif checkReferences.recordcount lt 4>
          		<a href="javascript:openPopUp('forms/repRefs.cfm?curdoc=repRefs', 640, 800);">Additional Ref's Needed </a>
         	<cfelse>
           	  <img src="../../images/noInfo.png" width="120" height="30" border="0" />
            </cfif>
         </td>
    </Tr>
</table>
</div>
</cfoutput>