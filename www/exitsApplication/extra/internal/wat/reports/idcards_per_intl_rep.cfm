<!--- Kill extra output --->
<cfsilent>
	
    <cfparam name="URL.uniqueID" default="">
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.verification_received" default="">

	<!--- set loop variables --->                    	
	<cfset col = 0> 
    <cfset pagebreak = 0>

    <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#"> 
        SELECT DISTINCT 
        	c.candidateid, 
            c.lastname, 
            c.firstname, 
            c.ds2019,
            u.businessname,
            p.programname, 
            p.programID, 
            p.extra_sponsor,
            comp.companyname, 
            comp.address AS c_address, 
            comp.city AS c_city, 
            comp.state AS c_state, 
            comp.zip AS c_zip, 
            comp.toll_free, 
            c.hostcompanyid,
            h.name as hostcompanyname, 
            h.address as hostaddress, 
            h.city as hostcity,             
            h.zip as hostzip,
            h.supervisor,
            h.phone,
            s.state as hoststate            
        FROM 
        	extra_candidates c 
        INNER JOIN 
        	smg_users u ON c.intrep = u.userid
        INNER JOIN 
        	smg_programs p ON c.programID = p.programID
        INNER JOIN 
        	smg_companies comp ON c.companyid = comp.companyid
        INNER 
        	JOIN extra_hostcompany h ON c.hostcompanyid = h.hostcompanyid
        INNER 
        	JOIN smg_states s ON s.id = h.state
      	<cfif LEN(URL.uniqueID)>
        	WHERE c.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.uniqueID#">
      	<cfelse>
       		WHERE c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
			AND c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        	AND c.verification_received =  <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verification_received#">  
        	AND c.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
			<cfif VAL(FORM.intrep)>
                AND c.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
            </cfif>
     	</cfif>      
        GROUP BY 
        	c.candidateid        
        ORDER BY 
        	u.businessname, 
            c.lastname, 
            c.firstname 
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>ID Cards List</title>
</head>

<body>

<cfif (NOT VAL(FORM.programID) OR NOT LEN(FORM.verification_received)) AND NOT LEN(URL.uniqueID)>
	Please select at least one program and/or DS 2019 verification received date.
	<cfabort>
</cfif>

<!--- Generate Avery Standard 5371 id cars for our students. --->

<!---  margin:'0.3in' '0.3in' '0.46in' '0.3in'; --->
<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.3in 0.3in 0.46in;
	}
	div.Section1 {		
		page:Section1;
	}
	td.label {
		width:252.0pt;
		height:144.0pt;
	}
	p {
		margin-top:0in;
		margin-right:5.3pt;
		margin-bottom:0in;
		margin-left:5.3pt;
		mso-pagination:widow-orphan;
		font-size:10.0pt;
		font-family:"Arial";
	}
	.style1 {font-size: 6pt} <!--- company address --->
	.style2 {font-size: 7pt} <!--- host + rep info ---->
	.style3 {font-size: 8pt} <!--- student's name ---->
	.style4 {font-size: 10pt} <!--- company name ---->
	.style5 {font-size: 5pt} 
</style>
			
<!--- The table consists has two columns, two labels. To identify where to place each, we need to maintain a column counter. --->

<cfoutput>

<div class="Section1">
					
    <cfloop query="qGetCandidates">
		
		<cfscript>
            if ( qGetCandidates.extra_sponsor EQ 'INTO' ) {
                // Set Sponsor
                setSponsor = qGetCandidates.extra_sponsor;
            } else {
                // Default Sponsor
                setSponsor = 'WAT';	
            }
			
			vPhoneNumber = Replace(qGetCandidates.phone, "(", "");
			vPhoneNumber = Replace(vPhoneNumber, ")", "-");                                                                                    
    	</cfscript>    
	        
		<cfif NOT VAL(pagebreak)>				
			<!--- Start a table for our labels --->
            <table align="center" width="670" border="0" cellspacing="2" cellpadding="0">	
        </cfif>
        
        <!--- If this is the first column, then start a new row --->
        <cfif col EQ "0">
            <tr>
        </cfif>				
        
		<!--- Output the label --->			
        <td class="label" height="144" valign="top">
    
            <!--- HEADER --->
            <table border="0" width="100%">
                <tr> 
                    <td align="center">
                    	<cfif LEN(URL.uniqueID)>
                        	<img src="../../../#APPLICATION.CSB.WAT.smallLogo#" border="0">
                        <cfelse>
                        	<img src="../../../#APPLICATION.CSB[setSponsor].smallLogo#" border="0">
                        </cfif>
                    </td>
                    <td align="center" width="100%"> 
                        <p class="style5">&nbsp;</p>
                        <p class="style4"><b>#APPLICATION.CSB[setSponsor].programName#</b>
                        <p class="style1">#c_address#</p>
                        <p class="style1">#c_city#, #c_state# &nbsp; #c_zip#</p>
                        <p class="style1">#APPLICATION.CSB[setSponsor].phoneIDCard#</p>
                        <p class="style5">&nbsp;</p>
                       
                    </td>
                </tr>
            </table>
            <table border="0" width="100%">
            	<tr>
                	<Td>
                     <p class="style3">Student: <b>#Firstname# #lastname# (###candidateid#)</b></p>
                    </Td>
                </tr>
            </table>
            <!--- BODY --->
            <table border="0" width="100%">
                <tr>
                    <td>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="50%" align="left" valign="top">
                                    <p class="style2">Host Company: #hostcompanyname#</p>
                                    <p class="style2">Primary Contact: #supervisor#</p>															
                                    <p class="style2">Phone Number: 1-#vPhoneNumber#</p>
                                    <p class="style2">Address: #hostaddress#</p>	
                                    <p class="style2">#hostcity#, #hoststate# #hostzip#</p>						
                                    <p class="style2">&nbsp;</p>	
                                </td>
                                <td width="50%" align="right" valign="top">
                                    <!---
                                    <p class="style2">Head Office Contact: Anca</p>
                                    <p class="style2">#APPLICATION.CSB[setSponsor].phoneIDCard#</p><br />
									--->
                                    <p class="style2">Emergency Phone Number:</p>
                                    <p class="style2">#APPLICATION.CSB[setSponsor].phoneIDCard#</p>
                                    <p class="style2">&nbsp;</p>
                                    <p class="style2">US Department of State:</p>
                                    <p class="style2">1-866-283-9090</p>
                                    <p class="style2">&nbsp;</p>	
                                    <p class="style2">Medical Plan - Policy LF003933</p>															
                                    <p class="style2">1-800-314-3938</p>
                                </td>
                            </tr>
                        </table>
                    </td>	
                </tr>
            </table>
        
        </td>
            
        <cfset col = col + 1>	
        					
        <!---If it's column 2, then end the	row and reset the column number.--->
        <cfif col EQ 2>
        	</tr>
        	<cfset col = 0>	
    	</cfif>
    
    	<cfset pagebreak = pagebreak + 1>
    
    	<cfif pagebreak EQ 10> <!--- close table and add a page break --->
            </table>
			<cfset pagebreak = 0>
    		<div style="page-break-before:always;"></div>					
    	</cfif>	
    
    </cfloop>
    
    <!---If we didn't end on column 2, then we haveto output blank labels --->
    <cfif col EQ 1>
            <td class="label"  height="144">
                <p>&nbsp;</p>
            </td>
        </tr>		
    </cfif>
    
    </table>
        
</div>

</cfoutput>

</body>
</html>
