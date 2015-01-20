  <cfquery name="usersWithDate" datasource="#application.dsn#">
   select *
    from smg_users_paperwork
    where seasonID = 9
    
    and fk_companyid < 5
    and ar_info_sheet != ''
    and userid = 278
   </cfquery>
   
<cfloop query="usersWithDate">
   	<cfset url.userid = #usersWithDate.userid#>
   		<cfif DirectoryExists('C:/websites/student-management/nsmg/uploadedfiles/users/#url.userid#/')>
         <cfelse>
            <cfdirectory action = "create" directory = "C:/websites/student-management/nsmg/uploadedfiles/users/#url.userid#/" >
        </cfif>
           <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/users/#url.userid#/AreaRepInfo.pdf" overwrite="yes">
 
                  
                    	<cfinclude template="areaRepInfoSheet.cfm">
                    
                    
                    <br /><Br />
                    <Cfoutput>
                    Electronically Signed<Br />
                    #userinfo.firstname# #userinfo.lastname# <br />
                    #DateFormat(ar_info_sheet, 'mmm d, yyyy')#<Br />
                   
                    </Cfoutput>
                </cfdocument>
 </cfloop>