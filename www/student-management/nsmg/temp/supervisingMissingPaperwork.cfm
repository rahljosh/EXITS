 <cfquery name="repsSupervising" datasource="#application.dsn#">
 	select  distinct s.arearepid, u.lastname, u.firstname, u.accountCreationVerified, s.companyid
    from smg_students s
    left join smg_users u on u.userid = s.arearepid
    left join smg_programs p on p.programid = s.programid
    left join smg_companies c on c.companyid = s.companyid
    where (s.programid = 318 or s.programid = 320 or s.programid = 330 or s.programid = 331)
	
    order by lastname
 </cfquery>

<table>
	<Tr>
    	<th></th><th>Rep ID</th><th>First Name</th><th>Last Name</th><Th>Area Rep Paperwork</Th><th>Fully Enabled?</th>
        <th>AR Info Sheet</th><th>AR Agree</th><th>CBC Auth</th><th>CBC Approved</th><th>Num Refs</th><Th>Num. Approv</Th><th>Num w/ Answers</th><Th>AR Ref 1</Th><th>AR Ref 2</th><th>Region</th>
    <tr>
<cfoutput>
<cfset updateDateLive = ''>
    <cfloop query="repsSupervising">
   	 	<cfquery name="regioninfo" datasource="#application.dsn#">
         select user_access_rights.regionid, regionname
         from user_access_rights
         left join smg_regions on smg_regions.regionid = user_access_rights.regionid
         where userid = #arearepid#
         and default_access = 1
         </cfquery>
        <cfset missingCount = 0>
		<Cfscript>
                //Check if paperwork is complete for season
                get_paperwork = APPLICATION.CFC.udf.allpaperworkCompleted(userid=arearepid,seasonid=9);
            </cfscript>
          
        <cfif get_paperwork.arearepok eq 0 >
      	<Cfif get_paperwork.AR_CBCAUTHREVIEW is '' AND get_paperwork.AR_CBC_AUTH_FORM is not ''>
        	<Cfset updateDateLive = 'ThisWillUpdate'>
        </Cfif>
        <cfquery name="checkCBCRun" datasource="#application.dsn#">
        select *
        from smg_users_cbc
        where userid = #arearepid#
        and seasonid = 9
        </cfquery>
        <Cfquery name="checkRefs" datasource="#application.dsn#">
        select *
        from smg_user_references
        where referencefor = #arearepid#
        </Cfquery>
        
        <Cfquery name="checkRefsAppr" dbtype="query">
        select *
        from checkRefs
       	where approved > 0
        </Cfquery>
        
        <Cfquery name="refAnswers"  datasource="#application.dsn#">
        select *
        from arearepquestionairetracking
       	where areaRepID = #arearepid#
        </Cfquery>
        <!----
        <cfif len(checkCBCRun.requestID) and checkCBCRun.date_approved is ''>
        <cfquery name="ApproveCBC" datasource="#application.dsn#">
        update smg_users_cbc
        set date_approved = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
        where userid = #arearepid#
        and seasonid = 9
        </cfquery>
        </cfif>
		---->
        <tr >
             <th>#currentrow#</th><td>#arearepid#</td><td>#firstname#</td><td>#lastname#</td><td><cfif get_paperwork.arearepok eq 1>Complete<cfelse>Not Complete</cfif></td>
             <td><cfif val(accountCreationVerified)>Yes<cfelse>No</cfif> </td>
              <td><cfif get_paperwork.ar_info_sheet is ''>
			 <!----
              <cfquery name="ApproveInfoSheet" datasource="#application.dsn#">
                update smg_users_paperwork
                set ar_info_sheet = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                where userid = #arearepid#
                and seasonid = 9
                </cfquery>
			  ---->
			  
			  <cfset missingCOunt = #missingCount# + 1></cfif>#DateFormat(get_paperwork.ar_info_sheet, 'mm/dd/yy')#</td>
             <td><cfif get_paperwork.ar_agreement is ''><cfset missingCOunt = #missingCount# + 1></cfif>#DateFormat(get_paperwork.ar_agreement, 'mm/dd/yy')#</td>
             <td><cfif get_paperwork.AR_CBC_AUTH_FORM is ''><cfset missingCOunt = #missingCount# + 1></cfif>#DateFormat(get_paperwork.AR_CBC_AUTH_FORM, 'mm/dd/yy')#</td>
             <td> <cfif checkCBCRun.recordcount neq 0>
			 			<cfif get_paperwork.AR_CBCAUTHREVIEW is ''><cfset missingCOunt = #missingCount# + 1></cfif>#DateFormat(get_paperwork.AR_CBCAUTHREVIEW, 'mm/dd/yy')#
                  <cfelse>
                  
                  		

                      
                  		No CBC Run
                  </cfif>
                  </td>
              
              <td>#checkRefs.recordcount#</td>
              <td>#checkRefsAppr.recordcount#</td>
              <td>#refAnswers.recordcount#
              
              
              </td>
            	<td>
				 
				<cfif get_paperwork.AR_REF_QUEST1 is ''><cfset missingCOunt = #missingCount# + 1></cfif>#DateFormat(get_paperwork.AR_REF_QUEST1, 'mm/dd/yy')#</td>
             <td>
			 
			 <cfif get_paperwork.AR_REF_QUEST2 is ''><cfset missingCOunt = #missingCount# + 1></cfif>#DateFormat(get_paperwork.AR_REF_QUEST2, 'mm/dd/yy')#</td>
             <td>#regioninfo.regionname#</td>
        </Tr>

        </cfif>
      <cfset updateDateLive = ''>
    </cfloop>
</cfoutput>

