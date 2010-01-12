<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="99999">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.print" default="">
	<cfparam name="FORM.program" default="">
	<cfparam name="FORM.companyID" default="0">

    <!--- Param Variables --->
    <cfparam name="intoPlacement" default="0">
    <cfparam name="selfPlacement" default="0">
    <cfparam name="grandTotal" default="0">

    <cfquery name="get_program" datasource="MySql">
        SELECT 
        	programname, 
            programid
        FROM 
        	smg_programs 
        WHERE 
        	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyID#">
    </cfquery>

    <cfquery name="get_host_company" datasource="MySql">
        SELECT 
        	extra_hostcompany.hostcompanyID, 
            extra_hostcompany.name, 
            extra_hostcompany.phone, 
            extra_hostcompany.supervisor, 
            extra_hostcompany.city, 
            extra_hostcompany.state, 
            extra_hostcompany.business_typeid, 
            extra_typebusiness.business_type as typebusiness, 
            smg_states.state as s
        FROM 
        	extra_hostcompany
        LEFT JOIN 
        	smg_states ON smg_states.id = extra_hostcompany.state
        LEFT JOIN 
        	extra_typebusiness ON extra_typebusiness.business_typeid = extra_hostcompany.business_typeid
        WHERE 
        	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyID#">
        AND 
        	extra_hostcompany.name != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        ORDER BY 
        	name
    </cfquery>

</cfsilent>

<script language="JavaScript" type="text/javascript"> 
	<!-- Begin
	function formHandler2(form){
	var URL = document.formagent.agent.options[document.formagent.agent.selectedIndex].value;
	window.location.href = URL;
	}
	// End -->
</script>

<cfoutput>

<form action="index.cfm?curdoc=reports/students_hired_per_company_wt" method="post">
    <input type="hidden" name="submitted" value="1" />

    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>&nbsp;Students hired per company</td>
        </tr>
        <tr valign="middle" height="24">
            <td valign="middle" colspan=2>&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right" valign="middle" class="style1"><b>Host Company: </b></td>
            <td valign="middle">  
                <select name="companyID" class="style1">
                    <option value="ALL">---  All Host Companies  ---</option>
                    <cfloop query="get_host_company">
                    <option value="#hostcompanyID#" <cfif IsDefined('FORM.companyID')><cfif get_host_company.hostcompanyID eq #FORM.companyID#> selected</cfif></cfif>> #get_host_company.name# </option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Program: </b></td><td>
                <select name="program" class="style1">
                    <option></option>
                    <cfloop query="get_program">
                    <option value="#programid#" <cfif get_program.programid eq FORM.program> selected </cfif> >#programname#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right" class="style1"><b>Format: </b></td>
            <td class="style1"> 
                <input type="radio" class="style1" name="print" value=0 checked>  Onscreen (View Only) 
                <input type="radio" name="print" value=1> Print (PDF)
                <input type="radio" name="print" value=2> Excel (XLS)
            </td>            
        </tr>
        <tr>
            <td colspan=2 align="center"><br />
                <input type="submit" value="Generate Report" class="style1" /><br />
                <br />
            </td>
        </tr>
    </table>

</form>

</cfoutput>

<br /><br />

<!-----Display Reports---->
<cfif VAL(FORM.submitted)>

	<cfif NOT LEN(FORM.companyID)>
        <table width=99% cellpadding="4" cellspacing=0 align="center">
            <tr>
                <td align="center" colspan=10> 
                    <span class="style1">Please select report criteria and click on generate report. </span><br />
                </td>
            </tr>                
        </table>
        
        <cfabort>
    </cfif>                    
    
	<cfif FORM.print eq 1>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/qHiredStudents_per_company_wt_flashpaper&program=#FORM.program#&companyID=#FORM.companyID#&format=PDF">
	
	<cfelseif FORM.print eq 2>
		<span class="style1"><center><b>Results are being generated...</b></center></span><br /><br /><br />
		<meta http-equiv="refresh" content="1;url=index.cfm?curdoc=reports/qHiredStudents_per_company_wt_excel&program=#FORM.program#&companyID=#FORM.companyID#">
	<cfelse>
	
        <!--- Get All Host Companies Current Hosting Students --->
        <cfquery name="qGetHostCompany" datasource="MySQL">
            SELECT 
                company.hostCompanyID,
                company.name,
                c.candidateID,
                c.firstname,             
                c.lastname, 
                c.sex, 
                c.dob,                
                c.email, 
                c.ssn, 
                c.ds2019,
                c.startdate, 
                c.enddate, 
                c.wat_placement, 
                c.status,
                u.businessname,
                country.countryname
            FROM 
            	extra_hostcompany company    
            INNER JOIN
                extra_candidates c ON company.hostcompanyID = c.hostcompanyID
            INNER JOIN
                smg_programs p on p.programid = c.programid
            INNER JOIN
                smg_users u on u.userid = c.intrep
            LEFT JOIN 
                smg_countrylist country ON country.countryid = c.home_country
            WHERE 
                c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyID#">
            AND 
                c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.program#">
            AND 
                c.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
       		ORDER BY
            	company.name
		</cfquery>

        <cfoutput query="qGetHostCompany" group="hostCompanyID">
        
            <cfquery name="qHiredStudents" dbtype="query">
                SELECT 
                    candidateID,
                    firstname,             
                    lastname, 
                    sex, 
                    dob,                
                    email, 
                    ssn, 
                    ds2019,
                    startdate, 
                    enddate, 
                    wat_placement, 
                    businessname,
                    countryname
                FROM 
                    qGetHostCompany 
                WHERE 
                    hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompany.hostcompanyID#">
                AND 
                    wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
            </cfquery> 
            
            <cfquery name="qSelfCandidate" dbtype="query">
                SELECT 
                    candidateID,
                    firstname,             
                    lastname, 
                    sex, 
                    dob,                
                    email, 
                    ssn, 
                    ds2019,
                    startdate, 
                    enddate, 
                    wat_placement, 
                    businessname,
                    countryname
                FROM 
                	qGetHostCompany
                WHERE 
                	hostcompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostCompany.hostcompanyID#"> 
                AND 
                	wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
            </cfquery>
            
            <cfset totalPerAgent = qHiredStudents.recordCount + qSelfCandidate.recordCount>
            <cfset intoPlacement = intoPlacement + qHiredStudents.recordCount>
            <cfset selfPlacement = selfPlacement + qSelfCandidate.recordCount>
            <cfset grandTotal = grandTotal + totalPerAgent>
        
            <table width=99% cellpadding="4" cellspacing=0 align="center"> 
                <tr>
                    <td colspan="12">
                        <small><strong>#qGetHostCompany.name# - Total Candidates: #totalPerAgent#</strong> (#qHiredStudents.recordCount# CSB; #qSelfCandidate.recordCount# Self)</small>
                    </td>
                </tr>
                <tr>
                    <td align="left" bgcolor="4F8EA4" class="style2">ID</Td>
                    <td align="left" bgcolor="4F8EA4" class="style2">Last Name</Td>
                    <td align="left" bgcolor="4F8EA4" class="style2">First Name</Td>
                    <td align="left" bgcolor="4F8EA4" class="style2">Sex</td>
                    <td align="left" bgcolor="4F8EA4" class="style2">DOB</Td>
                    <td align="left" bgcolor="4F8EA4" class="style2">Country</td>
                    <td align="left" bgcolor="4F8EA4" class="style2">Email</td>
                    <td align="left" bgcolor="4F8EA4" class="style2">SSN</Td>
                    <td align="left" bgcolor="4F8EA4" class="style2">Start Date</td>
                    <td align="left" bgcolor="4F8EA4" class="style2">End Date</td>
                    <td align="left" bgcolor="4F8EA4" class="style2">International Agent</td>
                    <td align="left" bgcolor="4F8EA4" class="style2">Option</td>
                </tr>
            	
                <cfloop query="qHiredStudents">
                    <tr <cfif qHiredStudents.currentRow mod 2>bgcolor="##E4E4E4"</cfif> >
                        <td><span class="style1">#candidateID#</span></td>
                        <td><span class="style1">#lastname#</span></td>
                        <td><span class="style1">#firstname# </span></td>
                        <td><span class="style1">#sex#</span></td>
                        <td><span class="style1">#dateformat (dob, 'mm/dd/yyyy')#</span></td>
                        <td><span class="style1">#countryname#</span></td>
                        <td><span class="style1">#email#</span></td>
                        <td><span class="style1">#ssn#</span></td>
                        <cfif LEN(ds2019)>
                            <td><span class="style1">#dateformat (startdate, 'mm/dd/yyyy')#</span></td>
                            <td><span class="style1">#dateformat (enddate, 'mm/dd/yyyy')# </span></td>
                        <cfelse>
                            <td colspan=2 align="center"><span class="style1">Awaiting DS-2019</span></td>
                        </cfif>
                        <td><span class="style1">#businessname#</span></td>
                        <td><span class="style1">#wat_placement#</span></td>
                    </tr>
                </cfloop>

                <cfloop query="qSelfCandidate">
                    <tr <cfif qSelfCandidate.currentRow mod 2>bgcolor="##E4E4E4"</cfif> >
                        <td><span class="style1">#candidateID#</span></td>
                        <td><span class="style1">#lastname#</span></td>
                        <td><span class="style1">#firstname# </span></td>
                        <td><span class="style1">#sex#</span></td>
                        <td><span class="style1">#dateformat (dob, 'mm/dd/yyyy')#</span></td>
                        <td><span class="style1">#countryname#</span></td>
                        <td><span class="style1">#email#</span></td>
                        <td><span class="style1">#ssn#</span></td>
                        <cfif LEN(ds2019)>
                            <td><span class="style1">#dateformat (startdate, 'mm/dd/yyyy')#</span></td>
                            <td><span class="style1">#dateformat (enddate, 'mm/dd/yyyy')# </span></td>
                        <Cfelse>
                            <td colspan=2 align="center"><span class="style1">Awaiting DS-2019</span></td>
                        </cfif>
                        <td><span class="style1">#businessname#</span></td>
                        <td><span class="style1">#wat_placement#</span></td>
                    </tr>
                </cfloop>

            </table>
            <br />
            
        </cfoutput> <!--- Group by --->

		<cfoutput>
		
            <div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #intoPlacement#</div>	
            <div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #selfPlacement#</div>
            <div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>
            <div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #grandTotal#</div>
            <div class="style1"><strong>&nbsp; &nbsp; ----------------------------------</strong></div>		  
		
        </cfoutput>
                    	     
    </cfif>
   
<cfelse>
	<span class="style1">
    	<center>
        	Print results will replace the menu options and take a bit longer to generate.<br /> 
            Onscreen will allow you to change criteria with out clicking your back button.
        </center>
    </span>
</cfif>