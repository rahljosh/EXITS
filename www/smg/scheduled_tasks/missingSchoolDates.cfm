
<cfquery datasource="mysql" name="active_seasons">
select seasonid, season
from smg_seasons
where active=1 and seasonid = 7
</cfquery>

<cfloop query="active_seasons">
    <cfquery name="schools_wo_dates" datasource="mysql">
    SELECT  smg_schools.schoolid, smg_schools.schoolname, 
    smg_students.regionassigned, smg_students.firstname, smg_students.familylastname, smg_students.studentid, smg_students.arearepid, smg_students.companyid, smg_users.firstname as rep_first, smg_users.lastname as rep_last, smg_users.email as rep_email, smg_students.regionassigned, user_access_rights.userid as rm, u2.firstname as rm_first, u2.lastname as rm_last, u2.email as rm_email, smg_programs.programname
    FROM smg_schools
    LEFT JOIN smg_students on smg_students.schoolid = smg_schools.schoolid
    LEFT JOIN smg_users on smg_users.userid = smg_students.arearepid
    LEFT JOIN user_access_rights on user_access_rights.regionid = smg_students.regionassigned
    LEFT JOIN smg_users u2 on u2.userid = user_access_rights.userid
	LEFT JOIN smg_programs on smg_programs.programid = smg_students.programid
    WHERE smg_schools.schoolid NOT IN (
    SELECT smg_school_dates.schoolid
    FROM smg_school_dates where seasonid = #seasonid# ) and smg_students.active = 1 and smg_students.companyid <> 6 and user_access_rights.usertype = 5 and smg_programs.seasonid = #seasonid#
    order by companyid, rm, arearepid
    </cfquery>
<Cfdump var="#schools_wo_dates#">

	<!----Facilitators Email---->
   	<Cfloop list="1,2,3,4,5,10" index="i">
    <cfset client.companyid = #i#>
    <cfquery name="facilitators_email" dbtype="query">
    select *
    from schools_wo_dates
    where companyid = #i#
    </cfquery>
    <cfif facilitators_email.recordcount neq 0>
    
    <cfquery name="company_info" datasource="mysql">
    select *
    from smg_companies
    where companyid = #i#
    </cfquery>
    <Cfset application.site_url = #company_info.url_ref#>
    <cfset client.companyname = #company_info.companyname#>
	<cfset client.site_url = #company_info.url#>
	<cfoutput>    


   <cfsavecontent variable="email_message">
 
   #company_info.team_id#-<br /><br />
    The following schools have students assigned to them for the #season# season but there are still no dates recorded for the #season# season for this school. Please note that the students are listed for refrence, but dates only need to be added to the school once.
    This information has also been sent to the Regional Manager and Area Rep for each student.<br /><br />
    
    <table cellpadding=4 cellspacing=0>
        <Tr bgcolor="##666666">
           <td><font color="white">School</td> <Td><font color="white">Student</Td><td><font color="white">Regional Manager</td><td><font color="white">Area Rep</td>
        </Tr>
            <cfloop query="facilitators_email">
                <tr <cfif facilitators_email.currentrow mod 2>bgcolor="##CCCCCC"</cfif>>
                    <td>#schoolname# (#schoolid#)</td>
                    <td>#firstname# #familylastname#</td>
                    <td>#rm_first# #rm_last#</td>
                    <td>#rep_first# #rep_last#</td>
                </tr>
            </cfloop>
    </table>
    <br /><br />
    <font size=-1>
This information is accurate as of <strong>#DateFormat(now(),'mmm d, yyyy')# at #TimeFormat(now(),'h:m tt')#</strong>.<br />

You will recieve this email daily through Aug 1st until all school dates have been added. <br />
This information is also available on initial welcome page when you login under Current Items.
</font>   
 </cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value=" #company_info.pm_email#">
                <cfinvokeargument name="email_subject" value="#season# Schools Missing Dates">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="Daily Reports <#company_info.support_email#>">
            </cfinvoke>
    <!----End of Email---->
 

   
   
    
    </cfoutput>     
</cfif>
	<!----End of Facilitators Email---->
    
    </cfloop>
    

	<!----Regional Managers Email---->
    <Cfquery name="regional_managers" dbtype="query">
    select distinct rm 
    from schools_wo_dates
    </cfquery>
    
    <Cfloop query="regional_managers">
      <cfquery name="rm_email_list" dbtype="query">
        select *
        from schools_wo_dates
        where rm = #rm#
        </Cfquery>
         
    <cfif rm_email_list.recordcount neq 0>
		<cfset client.companyid = #rm_email_list.companyid#>
        <cfquery name="company_info" datasource="mysql">
        select *
        from smg_companies
        where companyid = #rm_email_list.companyid#
        </cfquery>
        <Cfset application.site_url = #company_info.url_ref#>
        <cfset client.companyname = #company_info.companyname#>
        <cfset client.site_url = #company_info.url#>
	<cfoutput>    
  

   <cfsavecontent variable="email_message">
<br>

   #rm_email_list.rm_first# #rm_email_list.rm_last#-<br /><br />
    The following schools have students assigned to them for the <strong>#active_seasons.season#</strong> season but there are still no dates recorded for the <strong>#active_seasons.season#</strong> season for this school. Please note that the students are listed for refrence, but dates only need to be added to the school once.
    This information has also been sent to the Facilitator and Area Rep for each student.<br /><br />
    
    <table cellpadding=4 cellspacing=0>
        <Tr bgcolor="##666666">
           <td><font color="white">School</td> <Td><font color="white">Student</Td><td><font color="white">Facilitator</td><td><font color="white">Area Rep</td>
        </Tr>
            <cfloop query="rm_email_list">
                <tr <cfif rm_email_list.currentrow mod 2>bgcolor="##CCCCCC"</cfif>>
                    <td>#schoolname# (#schoolid#)</td>
                    <td>#firstname# #familylastname#</td>
                    <td>#company_info.team_id#</td>
                    <td>#rep_first# #rep_last#</td>
                </tr>
            </cfloop>
    </table>
    <br /><br />
    <font size=-1>
This information is accurate as of <strong>#DateFormat(now(),'mmm d, yyyy')# at #TimeFormat(now(),'h:m tt')#</strong>.<br />

You will recieve this email daily through Aug 1st until all school dates have been added. <br />
This information is also available on initial welcome page when you login under Current Items.
</font> 

   </cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#rm_email_list.rm_email#">
                <cfinvokeargument name="email_subject" value="#active_seasons.season# Schools Missing Dates">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="Daily Reports <#company_info.support_email#>">
            </cfinvoke>
			
    <!----End of Email---->

   

    
    </cfoutput>     
</cfif>
	</cfloop>
    

<!----End of Regional Managers Email---->

	<!----Area Rep Email---->
    <Cfquery name="area_reps" dbtype="query">
    select distinct arearepid
    from schools_wo_dates
    </cfquery>
    
    <Cfloop query="area_reps">
      <cfquery name="ar_email" dbtype="query">
        select *
        from schools_wo_dates
        where arearepid = #arearepid# and arearepid > 0 
        </Cfquery>
         
    <cfif ar_email.recordcount neq 0>
		<cfset client.companyid = #ar_email.companyid#>
        <cfquery name="company_info" datasource="mysql">
        select *
        from smg_companies
        where companyid = #ar_email.companyid#
        </cfquery>
        <Cfset application.site_url = #company_info.url_ref#>
        <cfset client.companyname = #company_info.companyname#>
        <cfset client.site_url = #company_info.url#>
	<cfoutput>  
   

   <cfsavecontent variable="email_message">

   #ar_email.rm_first# #ar_email.rm_last#-<br /><br />
    The following schools have students assigned to them for the <strong>#active_seasons.season#</strong> season but there are still no dates recorded for the <strong>#active_seasons.season#</strong> season for this school. Please note that the students are listed for refrence, but dates only need to be added to the school once.
    This information has also been sent to the Facilitator and Regional Manager for each student.<br /><br />
    
    <table cellpadding=4 cellspacing=0>
        <Tr bgcolor="##666666">
           <td><font color="white">School</td> <Td><font color="white">Student</Td><td><font color="white">Facilitator</td><td><font color="white">Regional Manager</td>
        </Tr>
            <cfloop query="ar_email">
                <tr <cfif ar_email.currentrow mod 2>bgcolor="##CCCCCC"</cfif>>
                    <td>#schoolname# (#schoolid#)</td>
                    <td>#firstname# #familylastname#</td>
                    <td>#company_info.team_id#</td>
                    <td>#rm_first# #rm_last#</td>
                </tr>
            </cfloop>
    </table>
    <br /><br />
    <font size=-1>
This information is accurate as of <strong>#DateFormat(now(),'mmm d, yyyy')# at #TimeFormat(now(),'h:m tt')#</strong>.<br />

You will recieve this email daily through Aug 1st until all school dates have been added. <br />
This information is also available on initial welcome page when you login under Current Items.
</font> 

   </cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#ar_email.rep_email#">
                <cfinvokeargument name="email_subject" value="#active_seasons.season# Schools Missing Dates">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="Daily Reports <#company_info.support_email#>">
            </cfinvoke>
			
    <!----End of Email---->
   


    
    </cfoutput>     
</cfif>
</cfloop>
<!----End of Area Rep Email---->

 <!----End Active Seasons loop---->
  </cfloop>


  
  
  
  
  
  
  
  



