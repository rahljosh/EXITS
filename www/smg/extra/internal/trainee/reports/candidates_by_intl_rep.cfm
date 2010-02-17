<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Variables --->
	<cfparam name="FORM.submitted" default="0">
   	<cfparam name="FORM.userID" default="0">
    
    <cfquery name="qGetProgram" datasource="MySql">
        SELECT 
        	c.companyid, 
            c.companyname, 
            c.companyshort
        FROM 
        	smg_companies c
        INNER JOIN 
        	extra_candidates ec ON ec.companyid = c.companyid
        WHERE 
        	c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfquery>

    <cfquery name="qGetIntlRepList" datasource="MySql">
        SELECT 
            businessname, 
            userID
        FROM 
            smg_users
        WHERE
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        ORDER BY
            businessName            
    </cfquery>

	<cfif FORM.submitted>

        <cfquery name="qGetCandidates" datasource="MySql">
            SELECT 
                ec.firstname, 
                ec.lastname, 
                ec.sex, 
                ec.ds2019_startdate,
                ec.ds2019_enddate,
                eh.name AS hostCompanyName,             
                u.userID, 
                u.businessname
            FROM 
              	extra_candidates ec
            LEFT OUTER JOIN 
              	extra_hostcompany eh ON eh.hostcompanyid = ec.hostcompanyid
            INNER JOIN 
              	smg_users u ON u.userID = ec.intrep
            WHERE 
                ec.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND  
                ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            AND 
            	ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
        	ORDER BY
            	ec.lastName
        </cfquery>
	
    </cfif>
            
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>All Students Enroolled in the Program</title>
<script language="JavaScript"> 
	<!-- Begin
	function submitForm(form){
		//var URL = document.reportForm.agent.options[document.reportForm.agent.selectedIndex].value;
		//window.location.href = URL;
		document.reportForm.submit();
	}
	// End -->
</script>
</head>
<body style="font-size:12px; font-family:Verdana, Geneva, sans-serif;">

<cfoutput>

	<form name="reportForm" action="index.cfm?#CGI.QUERY_STRING#" method="post">
	<input type="hidden" name="submitted" value="1" />

    <table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25">
        <tr bgcolor="##E4E4E4">
            <td class="title1">&nbsp; &nbsp; Active Candidates by Intl. Rep. Report</td>
        </tr>
    </table>
    <br />
    
    <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" class="style1">
            	 Intl. Rep. 
                <select name="userID" onChange="javascript:submitForm();">
                    <cfloop query="qGetIntlRepList">
                    	<option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.userID> selected="selected" </cfif> > #qGetIntlRepList.businessName# </option>
                    </cfloop>
                </select>
        	</td>
        </tr>
    </table>
    <br />
    
	</form>
  
  	<cfif FORM.submitted>

        <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center">
            <tr valign="middle" height="24">
                <td valign="middle" class="style1">
                    Total No of Students: #qGetCandidates.recordcount# 
                </td>
            </tr>
        </table>
        <br />
  		
        <table border="0" cellpadding="4" cellspacing="0" class="section" align="center" width="95%">
            <tr>
                <td bgcolor="##4F8EA4"><span class="style2">First Name</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Last Name</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Sex </span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Host Company Name</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Program Start Date</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Program End Date</span></td>
            </tr>
            <tr>
                <td class="style1">#qGetCandidates.firstname#</td>
                <td class="style1">#qGetCandidates.lastname#</td>
                <td class="style1">#qGetCandidates.sex#</td>
                <td class="style1">#qGetCandidates.hostCompanyName#</td>
                <td class="style1">#DateFormat(qGetCandidates.ds2019_startdate, 'mm/dd/yyyy')#</td>
                <td class="style1">#DateFormat(qGetCandidates.ds2019_enddate, 'mm/dd/yyyy')#</td>
            </tr>
        </table>
        <br />
        
    </cfif>
    
</cfoutput>

</body>
</html>
