<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param Variables --->
	<cfparam name="FORM.submitted" default="0">
   	<cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.status" default="1">
    
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
        	c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
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
                ec.ds2019,
                ec.ds2019_startdate,
                ec.ds2019_enddate,
                eh.name AS hostCompanyName,             
                u.userID, 
                u.businessname,
                esf.fieldStudy AS categoryName,
                esSub.subField AS subCategoryName
            FROM 
              	extra_candidates ec
            LEFT OUTER JOIN 
              	extra_hostcompany eh ON eh.hostcompanyid = ec.hostcompanyid
            LEFT OUTER JOIN
            	extra_sevis_fieldstudy esf ON esf.fieldStudyID = ec.fieldStudyID
            LEFT OUTER JOIN
            	extra_sevis_sub_fieldstudy esSub ON esSub.subFieldID = ec.subFieldID
            INNER JOIN 
              	smg_users u ON u.userID = ec.intrep
            WHERE 
                ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
            AND 
            	ec.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
			
            <cfif FORM.status EQ 'Cancelled'>
                AND 
                	ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Cancelled">
            <cfelseif FORM.status EQ 0>
                AND 
                	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            <cfelseif FORM.status EQ 1>
                AND 
                	ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            </cfif>
            
        	ORDER BY
            	ec.lastName
        </cfquery>
	
    </cfif>
            
</cfsilent>

<cfoutput>

	<form name="reportForm" action="index.cfm?#CGI.QUERY_STRING#" method="post">
	<input type="hidden" name="submitted" value="1" />

    <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center" height="25">
        <tr bgcolor="##E4E4E4">
            <td class="title1">&nbsp; &nbsp; Candidates by Intl. Rep. Report</td>
        </tr>
    </table><br />
    
    <table width="95%" cellpadding="4" cellspacing="2" border="0" align="center">
        <tr>
            <td class="style1" width="130px">Intl. Rep.:</td>
			<td class="style1">
                <select name="userID" id="userID" class="xLargeField">
                    <cfloop query="qGetIntlRepList">
                    	<option value="#qGetIntlRepList.userID#" <cfif qGetIntlRepList.userID EQ FORM.userID> selected="selected" </cfif> > #qGetIntlRepList.businessName# </option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td class="style1">Candidate Status:</td>
            <td class="style1">
                <select name="status" id="status" class="xLargeField">
					<option value="" <cfif NOT LEN(FORM.status)> selected="selected" </cfif> > All</option>
                    <option value="1" <cfif VAL(FORM.status)> selected="selected" </cfif> >Active</option>
                    <option value="0" <cfif FORM.status EQ 0> selected="selected" </cfif> >Inactive</option>
                    <option value="Cancelled" <cfif FORM.status EQ "Cancelled"> selected="selected" </cfif> >Cancelled</option>
                </select>
            </td>
        </tr>   
        <tr>
            <td class="style1">&nbsp;</td>
            <td class="style1">
            	<input type="image" src="../pics/view.gif" name="submit" value=" Submit " />
            </td>
        </tr>        
    </table>
    
	</form>
  
  	<cfif FORM.submitted>

        <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center">
            <tr>
                <td class="style1">
                    Total No of Students: #qGetCandidates.recordcount# 
                </td>
            </tr>
        </table><br />
  		
        <table border="0" cellpadding="4" cellspacing="0" class="section" align="center" width="95%">
            <tr>
                <td bgcolor="##4F8EA4"><span class="style2">First Name</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Last Name</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Sex</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">DS-2019</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Category</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Sub Category</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Host Company Name</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Program Start Date</span></td>
                <td bgcolor="##4F8EA4"><span class="style2">Program End Date</span></td>
            </tr>
            
            <cfloop query="qGetCandidates">
                <tr>
                    <td class="style1">#qGetCandidates.firstname#</td>
                    <td class="style1">#qGetCandidates.lastname#</td>
                    <td class="style1">#qGetCandidates.sex#</td>
                    <td class="style1">#qGetCandidates.ds2019#</td>
                    <td class="style1">#qGetCandidates.categoryName#</td>
                    <td class="style1">#qGetCandidates.subCategoryName#</td>
                    <td class="style1">#qGetCandidates.hostCompanyName#</td>
                    <td class="style1">#DateFormat(qGetCandidates.ds2019_startdate, 'mm/dd/yyyy')#</td>
                    <td class="style1">#DateFormat(qGetCandidates.ds2019_enddate, 'mm/dd/yyyy')#</td>
                </tr>
            </cfloop>
            
        </table>        
        
    </cfif>
    
</cfoutput>
