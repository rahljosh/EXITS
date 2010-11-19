<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param Form Variables --->
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.isUsCitizen" default="0">
    <cfparam name="FORM.insurance_typeID" default="0">
    <cfparam name="FORM.id1" default="0">
    <cfparam name="FORM.id2" default="0">

	<!--- set loop variables --->                    	
    <cfset startTable = 1>

    <cfquery name="qGetStudents" datasource="MySql"> 
        SELECT 	
            s.studentID, 
            s.familyLastName, 
            s.firstname, 
            s.dob,
            u.businessname,
            p.programname, 
            p.programid
        FROM 
            smg_students s 
        INNER JOIN 
            smg_users u ON s.intrep = u.userid
        INNER JOIN
        	smg_insurance_type type ON type.insuTypeID = u.insurance_typeID 
            AND 
                type.insuTypeID > <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
			AND
            	type.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        INNER JOIN 
            smg_programs p ON s.programid = p.programid
        WHERE 
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">

		<cfif CLIENT.companyID EQ 5>
           AND 
              s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.listISE#" list="yes"> )
        <cfelse>
           AND 
              s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
        </cfif>

        <cfif LEN(FORM.programID)>
        	AND
            	s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
        </cfif>
        
        <cfif VAL(FORM.intrep)>
            AND 
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
        </cfif>

        <cfif VAL(FORM.insurance_typeid)>
            AND 
                u.insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.insurance_typeid#">
        </cfif>

		<cfif VAL(FORM.isUsCitizen)>
        	AND 
            	(
                	s.countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="232"> 
                OR 
                	s.countrycitizen = <cfqueryparam cfsqltype="cf_sql_integer" value="232"> 
                OR 
                	countrybirth = <cfqueryparam cfsqltype="cf_sql_integer" value="232">
                )
        </cfif>

		<cfif VAL(FORM.id1) AND VAL(FORM.id2)>
        	AND 
            	s.studentid
            BETWEEN 
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.id1#">
            AND 
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.id2#">
        </cfif>
    
        ORDER BY 
            u.businessname, 
            s.firstname,
            s.familyLastName,
            s.studentID      
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance Cards List</title>

<!--- Generate Avery Standard 5371 id cars for our students. --->

<!--- Browser Margin: top 0.3 / bottom 0.3 / left 0.5 / right 0.5 --->
<style>
	body {
		padding:0;
		margin:0;
	}
	
	.tableHolder {		
		width:7in; /* 17.7cm */		
		/* height:10in; /* 25cm */
		padding:0;
		margin:0;	
		/* border: 1px thin black; */
	}

	.tableCell {
		height:2in; /* 5.0cm */
		width:3.5in; /* 8.9cm */
		padding:0;
		margin:0;
	}

	.informationDiv {
		padding-top:0.3in; /*  0.8cm */
		padding-left:0.2in; /* 0.5cm */
		width:2.5in; /* 6.4cm */ 
		overflow:hidden;
	}

	/* Student Name, DOB and Dates */
	.textStyle {
		font-size: 8pt;
		line-height:0.3in; /* 0.8cm */
		display: block;
		overflow:hidden;
	}
	
	.pageBreak {
		padding:0;
		margin:0;
		page-break-after:always;
	}
</style>

</head>

<body>

<!--- The table consists has two columns, two labels. To identify where to place each, we need to maintain a column counter. --->

<cfoutput query="qGetStudents">
    
    <cfif VAL(startTable)>				
        <!--- Start a table for our labels --->            
        <table class="tableHolder" cellspacing="0" cellpadding="0">	            
        <cfset startTable = 0>
    </cfif>
    
    <!--- If this is the first column, then start a new row --->
    <cfif qGetStudents.currentRow MOD 2 EQ 1>
        <tr>
    </cfif>				
    
        <!--- Output the label --->			
        <td class="tableCell" valign="top">
    
            <!--- BODY --->
            <div class="informationDiv">
            
                <span class="textStyle">#qGetStudents.familyLastName#, #qGetStudents.firstname# (###qGetStudents.studentID#)</span>
                
                <span class="textStyle">#DateFormat(qGetStudents.dob, 'mm/dd/yyyy')#</span>
                
                <span class="textStyle">#qGetStudents.programName#</span>
                
            </div>   
                 
        </td>
        
    <!---If it's column 2, then end the	row --->
    <cfif qGetStudents.currentRow MOD 2 EQ 0>
        </tr>
    </cfif>

    <!--- close table every 10 columsn and add a page break --->
    <cfif qGetStudents.currentRow MOD 10 EQ 0> 

        <cfset startTable = 1>
        </table>            
        <!--- <div class="pageBreak"></div>--->
    </cfif>	

</cfoutput>

<!---If we didn't end on column 2, then we have to output blank label --->
<cfif qGetStudents.recordCount MOD 2 EQ 1>
            <td class="tableCell">
                <span class="textStyle">&nbsp;</span>
            </td>
        </tr>
    </table>		
<cfelseif VAL(qGetStudents.recordCount MOD 10)>
    </table>
</cfif>
    

</body>
</html>