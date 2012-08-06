<cfsetting requesttimeout="300">

<!--- FROM PHP - AXIS --->
<cfif IsDefined('URL.user')>
	<cfset CLIENT.usertype = '#URL.user#'>
</cfif>

<cfif IsDefined('url.unqid')>
	<cfquery name="qGetStudentInfoPrint" datasource="MySql">
		SELECT
			s.firstname,
			s.familylastname,
			s.studentid,
			s.intrep,
			s.app_indicated_program,
			u.businessname,
			u.master_accountid
		FROM
			smg_students s
		INNER JOIN
			smg_users u ON u.userid = s.intrep
		WHERE
			s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	</cfquery>	
	<cfset CLIENT.studentid = '#qGetStudentInfoPrint.studentid#'>
<cfelse>
	<cfquery name="qGetStudentInfoPrint" datasource="MySql">
		SELECT
			s.firstname,
			s.familylastname,
			s.studentid,
			s.intrep,
			s.uniqueid,
			s.app_indicated_program,
			u.businessname,
			u.master_accountid
		FROM
			smg_students s
		INNER JOIN
			smg_users u ON u.userid = s.intrep
		WHERE
			studentid = <cfqueryparam value="#VAL(client.studentid)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset url.unqid = '#qGetStudentInfoPrint.uniqueid#'>
</cfif>

<cfif cgi.http_host is 'jan.case-usa.org' or cgi.http_host is 'www.case-usa.org'>
	<cfset client.org_code = 10>
	<cfset bgcolor ='ffffff'>
<cfelse>
	<cfset client.org_code = 5>
	<cfset bgcolor ='B5D66E'>
</cfif>
<cfquery name="org_info" datasource="mysql">
	SELECT
		*
	FROM
		smg_companies
	WHERE
		companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.org_code)#">
</cfquery>

<!----Check Allergy---->
<cfquery name="check_allergy" datasource="#application.dsn#">
	SELECT
		has_an_allergy
	FROM
		smg_student_app_health
	WHERE
		studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">
</cfquery>
<!-----Check Additional Medical---->
<cfquery name="additional_info" datasource="#application.dsn#">
	SELECT
		*
	FROM
		smg_student_app_health_explanations
	WHERE
		studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">
</cfquery>

<!--- This is to set the correct directory for displaying images in the included files --->
<cfset relative = "">

<!--- SECTION 1 --->
<cfsavecontent variable="pages1To4">
	<tr>
        <td valign="top">				
            <cfinclude template="section1/page1print.cfm">
            <div style="page-break-after:always;"></div>
        </td>
    </tr>
    <tr>
        <td valign="top">				
            <cfinclude template="section1/page2print.cfm">
            <div style="page-break-after:always;"></div>
        </td>
    </tr>
    <tr>
        <td valign="top">				
            <cfinclude template="section1/page3print.cfm">
            <div style="page-break-after:always;"></div>
        </td>
    </tr>
    <tr>
        <td valign="top">				
            <cfinclude template="section1/page4print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfsavecontent variable="page5">
    <tr>
        <td valign="top">		
            <cfinclude template="section1/page5print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfsavecontent variable="page6">
	<tr>
        <td valign="top">				
            <cfinclude template="section1/page6print.cfm">
        </td>
    </tr>
</cfsavecontent>

<!--- SECTION 2 --->

<cfsavecontent variable="page7">
	<tr>
        <td valign="top">				
            <cfinclude template="section2/page7print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfsavecontent variable="page8">
	<tr>
        <td valign="top">				
            <cfinclude template="section2/page8print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfsavecontent variable="page9">
	<tr>
        <td valign="top">				
            <cfinclude template="section2/page9print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfsavecontent variable="page10">
	<tr>
        <td valign="top">				
            <cfinclude template="section2/page10print.cfm">
        </td>
    </tr>
</cfsavecontent>

<!--- SECTION 3 --->

<cfsavecontent variable="page11">
	<tr>
        <td valign="top">				
            <cfinclude template="section3/page11print.cfm">
        </td>
    </tr>
  	<cfif additional_info.recordcount gt 0>
    	<tr>
      		<td valign="top">
            	<cfinclude template="section3/additional_info_print.cfm">	
         	</td>
     	</tr>
	</cfif>
</cfsavecontent>

<cfsavecontent variable="page12">
	<tr>
        <td valign="top">				
            <cfinclude template="section3/page12print.cfm">
        </td>
    </tr>
  	<cfif additional_info.recordcount gt 0>
    	<tr>
      		<td valign="top">
            	<cfinclude template="section3/allergy_info_request_print.cfm">	
         	</td>
     	</tr>
	</cfif>
</cfsavecontent>

<cfsavecontent variable="page13">
	<tr>
        <td valign="top">				
            <cfinclude template="section3/page13print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfsavecontent variable="page14">
	<tr>
		<td valign="top">
        	<cfinclude template="section3/page14print.cfm">
        </td>
  	</tr>
</cfsavecontent>

<!--- SECTION 4 --->

<cfsavecontent variable="page15">
	<tr>
		<td valign="top">
        	<cfinclude template="section4/page15print.cfm">
        </td>
  	</tr>
</cfsavecontent>

<cfsavecontent variable="page16">
	<tr>
		<td valign="top">
        	<cfinclude template="section4/page16print.cfm">
        </td>
  	</tr>
</cfsavecontent>

<cfsavecontent variable="page17">
	<tr>
		<td valign="top">
        	<cfinclude template="section4/page17print.cfm">
        </td>
  	</tr>
</cfsavecontent>

<cfsavecontent variable="page18">
	<tr>
		<td valign="top">
        	<cfinclude template="section4/page18print.cfm">
        </td>
  	</tr>
</cfsavecontent>

<cfsavecontent variable="page19">
	<tr>
    	<td valign="top">
        	<cfinclude template="section4/page19print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfsavecontent variable="page2x">
	<tr>
    	<td valign="top">
        	<cfinclude template="section4/page20print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfsavecontent variable="page3x">
	<tr>
    	<td valign="top">
        	<cfinclude template="section4/page21print.cfm">
        </td>
    </tr>
</cfsavecontent>

<cfoutput>

	<!--- PUT THE SECTIONS TOGETHER WITH THE UPLOADED PDF's --->
    
    <!--- This is the list of PDF's to merge --->
    <cfset sourceList = "#ExpandPath('../uploadedFiles/temp/')#ISE_Application#CLIENT.studentID#.pdf">
    
    <!--- Pages 1 to 4 --->
    <cfdocument format="pdf"  filename="#ExpandPath('../uploadedFiles/temp/')#ISE_Application#CLIENT.studentID#.pdf" overwrite="yes">
        <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
            #pages1To4#
        </table>
    </cfdocument>
    
    <!--- Page 5 (display only the PDF if there is one) --->
    <cfif FileExists(ExpandPath('../uploadedfiles/letters/students/#CLIENT.studentID#.pdf'))>
    	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/letters/students/')##CLIENT.studentID#.pdf">
  	<cfelse>
    	<cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page5#CLIENT.studentID#.pdf" overwrite="yes">
            <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
                #page5#
            </table>
        </cfdocument>
        <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page5#CLIENT.studentID#.pdf">
    </cfif>
    
    <!--- Page 6 (display only the PDF if there is one) --->
    <cfif FileExists(ExpandPath('../uploadedfiles/letters/parents/#CLIENT.studentID#.pdf'))>
    	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/letters/parents/')##CLIENT.studentID#.pdf">
    <cfelse>
    	<cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page6#CLIENT.studentID#.pdf" overwrite="yes">
            <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
                #page6#
            </table>
        </cfdocument>
        <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page6#CLIENT.studentID#.pdf">
    </cfif>
    
    <!--- Pages 7 to 9 (Loop through these and add uploaded PDF's if they exist) --->
    <cfloop from="7" to="9" index="i">
    	<cfset page = Evaluate('page' & #i#)>
        <cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page#i##CLIENT.studentID#.pdf" overwrite="yes">
            <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
                #page#
            </table>
        </cfdocument>
        <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page#i##CLIENT.studentID#.pdf">
        <cfif FileExists(ExpandPath('../uploadedfiles/online_app/page0#i#/#CLIENT.studentID#.pdf'))>
        	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/online_app/')#page0#i#/#CLIENT.studentID#.pdf">
        </cfif>
    </cfloop>
    
    <!--- Page 10 --->
    <cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page10#CLIENT.studentID#.pdf" overwrite="yes">
        <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
            #page10#
        </table>
    </cfdocument>
    <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#\page10#CLIENT.studentID#.pdf">
    <cfif FileExists(ExpandPath('../uploadedfiles/online_app/page10/#CLIENT.studentID#.pdf'))>
    	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/online_app/')#page10/#CLIENT.studentID#.pdf">
    </cfif>
    
    <!--- Page 11 --->
    <cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page11#CLIENT.studentID#.pdf" overwrite="yes">
        <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
            #page11#
        </table>
    </cfdocument>
    <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page11#CLIENT.studentID#.pdf">
    
    <!--- Pages 12 and 13 (Loop through these and add uploaded PDF's if they exist) --->
    <cfloop from="12" to="13" index="i">
    	<cfset page = Evaluate('page' & #i#)>
        <cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page#i##CLIENT.studentID#.pdf" overwrite="yes">
            <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
                #page#
            </table>
        </cfdocument>
        <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page#i##CLIENT.studentID#.pdf">
        <cfif FileExists(ExpandPath('../uploadedfiles/online_app/page#i#/#CLIENT.studentID#.pdf'))>
        	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/online_app/')#page#i#/#CLIENT.studentID#.pdf">
        </cfif>
    </cfloop>
    
    <!--- Pages 14 to 17 (Loop through these and display only the PDF if it exists) --->
    <cfloop from="14" to="17" index="i">
    	<cfset page = Evaluate('page' & #i#)>
        <cfif FileExists(ExpandPath('../uploadedfiles/online_app/page#i#/#CLIENT.studentID#.pdf'))>
        	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/online_app/')#page#i#/#CLIENT.studentID#.pdf">
        <cfelse>
        	<cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page#i##CLIENT.studentID#.pdf" overwrite="yes">
                <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
                    #page#
                </table>
            </cfdocument>
            <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page#i##CLIENT.studentID#.pdf">
        </cfif>
    </cfloop>
    
    <!--- Page 18 (Do not display for ESI or Canada Application) --->
 	<cfif CLIENT.companyID NEQ 14 AND NOT ListFind("14,15,16", get_student_info.app_indicated_program)>
        <cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page18#CLIENT.studentID#.pdf" overwrite="yes">
            <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
                #page18#
            </table>
        </cfdocument>
        <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page18#CLIENT.studentID#.pdf">
        <cfif FileExists(ExpandPath('../uploadedfiles/online_app/page18/#CLIENT.studentID#.pdf'))>
        	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/online_app/')#page18/#CLIENT.studentID#.pdf">
        </cfif>
   	</cfif>
    
    <!--- Page 19 --->
  	<cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page19#CLIENT.studentID#.pdf" overwrite="yes">
        <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
            #page19#
        </table>
    </cfdocument>
    <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page19#CLIENT.studentID#.pdf">
    <cfif FileExists(ExpandPath('../uploadedfiles/online_app/page19/#CLIENT.studentID#.pdf'))>
    	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/online_app/')#page19/#CLIENT.studentID#.pdf">
    </cfif>
    
    <!--- Page 20 (HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 STUDENTS / ESI does not need 20) --->
 	<cfif 
		IsDefined('client.usertype') 
		AND client.usertype NEQ 10 
		AND qGetStudentInfoPrint.master_accountid NEQ 10115 
		AND qGetStudentInfoPrint.intrep NEQ 10115 
		AND qGetStudentInfoPrint.intrep NEQ 8318
		AND CLIENT.companyID NEQ 14>
        <cfif FileExists(ExpandPath('../uploadedfiles/online_app/page20/#CLIENT.studentID#.pdf'))>
        	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/online_app/')#page20/#CLIENT.studentID#.pdf">
        <cfelse>
        	<cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page20#CLIENT.studentID#.pdf" overwrite="yes">
                <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
                    #page2x#
                </table>
            </cfdocument>
            <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page20#CLIENT.studentID#.pdf">
        </cfif>
 	</cfif>
    
    <!--- Page 21 (HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 STUDENTS) --->
	<cfif 
		IsDefined('client.usertype') 
		AND client.usertype NEQ 10 
		AND qGetStudentInfoPrint.master_accountid NEQ 10115 
		AND qGetStudentInfoPrint.intrep NEQ 10115 
		AND qGetStudentInfoPrint.intrep NEQ 8318>
        <cfif FileExists(ExpandPath('../uploadedfiles/online_app/page21/#CLIENT.studentID#.pdf'))>
        	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/online_app/')#page21/#CLIENT.studentID#.pdf">
        <cfelse>
			<cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page21#CLIENT.studentID#.pdf" overwrite="yes">
                <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0"> 
                    #page3x#
                </table>
            </cfdocument>
            <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page21#CLIENT.studentID#.pdf">
		</cfif>
  	</cfif>
    
    <!--- Page 22 --->
    <cfset currentDirectory = "#ExpandPath('../uploadedfiles')#/virtualfolder/#qGetStudentInfoPrint.studentid#/page22">
	<cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">
    <cfloop query="mydirectory">
		<cfif ListFind("jpg,peg,gif,tif,iff,png", LCase(Right(name, 3)))>
        	<cfdocument format="pdf" filename="#ExpandPath('../uploadedFiles/temp/')#page22#CLIENT.studentID#.pdf" overwrite="yes">
                <table align="center" width="100%" cellpadding="0" cellspacing="0"  border="0">
                    <tr>
                        <td>
                            <img src="../uploadedfiles/virtualfolder/#qGetStudentInfoPrint.studentid#/page22/#name#" width="660" height="820">
                        </td>
                    </tr>
                </table>
          	</cfdocument>
            <cfset sourceList = sourceList & ",#ExpandPath('../uploadedFiles/temp/')#page22#CLIENT.studentID#.pdf">
       	<cfelseif ListFind("pdf", LCase(Right(name, 3)))>
        	<cfset sourceList = sourceList & ",#ExpandPath('../uploadedfiles/virtualfolder/')##qGetStudentInfoPrint.studentid#/page22/#name#">
        </cfif>
    </cfloop>
    
    <!--- Merge the PDF files --->
    <cfpdf action="merge" source="#sourceList#" destination="#ExpandPath('../uploadedFiles/temp/')#ISE_Application#CLIENT.studentID#.pdf" overwrite="yes">	
        
    <cfheader name="Content-Disposition" value="attachment; filename='#ExpandPath('../uploadedFiles/temp/')#ISE_Application#CLIENT.studentID#.pdf'">
    <cfcontent type="application/pdf" file="#ExpandPath('../uploadedFiles/temp/')#ISE_Application#CLIENT.studentID#.pdf">

</cfoutput>