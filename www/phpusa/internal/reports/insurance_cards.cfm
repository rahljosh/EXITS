<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param Form Variables --->
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.insurance_typeID" default="0">
    <cfparam name="FORM.date1" default="0">
    <cfparam name="FORM.date2" default="0">

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
        	php_students_in_program php
        INNER JOIN 
        	smg_students s ON php.studentid = s.studentid
        INNER JOIN 
        	smg_users u ON s.intrep = u.userid AND u.php_insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.insurance_typeID#">
        INNER JOIN 
            smg_programs p ON php.programid = p.programid
        WHERE 
        	php.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfif isDate(FORM.date1) AND isDate(FORM.date2)>
            AND 
            	php.dateCreated 
                BETWEEN
                	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.date1)#">
            	AND 
            		<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(DateAdd('d', 1, FORM.date2))#">
        </cfif>
        <cfif VAL(FORM.intRep)>
        	AND s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRep#">
		</cfif>
        AND
        	php.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
        GROUP BY 
        	studentid
        ORDER BY 
        	u.businessname, 
            s.familylastname, 
            s.firstname
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
		width:8.3in; /* 21.6 cm */		
		/* height:10in; /* 25cm */
		padding:0;
		margin:0.15in 0.75in 0 0.5in;
		/* border:1px solid #CCCCCC; */
	}

	.tableCell {
		margin:0;
		padding:0;
		height:2.25in; /* 6 cm */
		width:3.5in; /* 8.9cm */	
		/*
		border-top:1px solid #CCCCCC;
		border-left:1px solid #CCCCCC;
		*/
	}

	.informationDiv {
		float:left;
		margin:0;
		height:1in;
		width:3.3in; /* 6.4cm */ 
		overflow:hidden;
		padding:0.72in 0 0 0.1in; /* 2 cm */
	}

	/* Student Name, DOB and Dates */
	.textStyle {
		font-size: 10pt;
		line-height:0.35in; /* 0.8cm */
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
		<!--- Break Page --->
        <div class="pageBreak"></div>
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