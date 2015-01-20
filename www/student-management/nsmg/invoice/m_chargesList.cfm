
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>List of Charges</title>

<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfsetting requesttimeout="9999">

<style type="text/css">

	table.frame 
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFFF;
	padding:2px;
	}
	
	td.right
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	color:#FFFFFF;
	font-weight:bold;
	padding:10px;
	}
	
	td.two
	{
	font:Arial, Helvetica, sans-serif;
	font-style:normal;
	font-size:small;
	padding:4px;
	}
	
	.box
	{
	border-style:solid;
	border-width:thin;
	border-color:#004080;
	border-collapse:collapse;
	background-color:#FFFFFF;
	}
	
	tr.darkBlue
	{
	background-color:#0052A4;
	}

.style1 {color: #FF0000}
</style>

</head>

<cfparam name="FORM.selectPrograms" default="0">
<cfparam name="form.printFormat" default="0">
<cfparam name="student" default="0">
<cfparam name="studentAmount" default="0">
<cfparam name="totalAmount" default="0">

<!--- ALL INTERNATIONAL REPS --->
<cfinclude template="../querys/get_all_intl_rep.cfm">

<cfquery name="getPrograms" datasource="MySQL">
SELECT 
	*
FROM 
	smg_programs
WHERE
	<cfif CLIENT.companyid EQ 14>
    	companyID = 14
    <cfelse>
		companyID IN (1,7,8,9,10,12,13,14)
    </cfif>
AND
	type NOT IN (6,10,14,15,16,17,18,19,20,21)
ORDER BY 
	companyid, 
	startdate DESC
</cfquery>

<body>

<cfif NOT ISDEFINED('form.submitted')>
<div align="center" style="padding-top:10px;">
    <cfform>
        
        <cfinput type="hidden" name="submitted">
    	
        <strong><small>Choose International Agent</small></strong>
        
        </br>

        <select name="intrep" size="1">
            <cfoutput query="get_all_intl_rep">
                <option value="#userid#">#businessname#</option>
            </cfoutput>
        </select>
		
        </br>
        </br>
        </br>
        
        <strong><small>Choose Programs</small></strong>
        
        </br>

        <select name="selectPrograms" multiple="multiple" size="30">
            <option value="All" selected="selected">Select All</option>
            <option value="0">Charges not related to a program</option>
            <cfoutput query="getPrograms">
                <cfswitch expression="#companyid#">
                    <cfcase value="1"><cfset compId = 'ISE'></cfcase>
                    <cfcase value="7"><cfset compId = 'TRAINEE'></cfcase>
                    <cfcase value="8"><cfset compId = 'W&T'></cfcase>
                    <cfcase value="9"><cfset compId = 'H2B'></cfcase>
                    <cfcase value="10"><cfset compId = 'CASE'></cfcase>
                    <cfcase value="13"><cfset comId = 'SMG Canada'></cfcase>
                    <cfcase value="14"><cfset compId = 'ESI'></cfcase>
                </cfswitch>
                <option value="#programid#">#variables.compId# - #getPrograms.programname#</option>
            </cfoutput>
        </select>
        
		</br>
        
        <input type="image" src="../pics/submit.gif" name="submit">
    
    </cfform>

	<cfif NOT ISDEFINED('form.submitted')>
        <cfabort>
    </cfif>

</div>
</cfif>

<cfoutput>
<div align="center"><h4 style="color:##000099">List of Charges as of #DateFormat(now(), 'mm-dd-yyyy')# at #TimeFormat(now(),'h:mm:ss tt')#<br></h2></div>
</cfoutput>

<strong><small>International agent: </small></strong>
<cfquery name="IA" datasource="MySQL">
SELECT
	businessname
FROM
	smg_users
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
</cfquery>

<cfoutput>
	<small>#IA.businessname#</small>
</cfoutput>

<br/>
<br/>

<strong><small>Programs selected:</small></strong><br/>

<cfloop list="#form.selectPrograms#" index="programsSelected">

    <cfif programsSelected IS "All">
    
        <small>All programs were selected</small><br/>
        
        <cfelseif programsSelected EQ 0>
        
            <small>Charges not related to a program</small><br/>
        
            <cfelse>
            
                <cfquery name="getProgramsSelected" datasource="MySQL">
                SELECT *
                FROM smg_programs sp
				WHERE sp.programid = #programsSelected#
                ORDER BY companyid ASC, startdate DESC
                </cfquery>
                
                <cfoutput query="getProgramsSelected">
                
                <cfswitch expression="#getProgramsSelected.companyid#">
                    <cfcase value="1"><cfset compId = 'High School'></cfcase>
                    <cfcase value="7"><cfset compId = 'Trainee'></cfcase>
                    <cfcase value="8"><cfset compId = 'W&T'></cfcase>
                    <cfcase value="9"><cfset compId = 'H2B'></cfcase>
					<cfcase value="10"><cfset compId = 'CASE'></cfcase>
                    <cfcase value="13"><cfset compID = 'SMG Canada'></cfcase>
                    <cfcase value="14"><cfset compId = 'ESI'></cfcase>
                </cfswitch>
                
                <small>#variables.compId# - #getProgramsSelected.programname# (###getProgramsSelected.programid#)</small> <br/>
                
                </cfoutput>
        
    </cfif>
    
</cfloop>

<cfquery name="getCharges" datasource="MySQL">
    SELECT
        sch.stuid, 
        sch.chargeid, 
        sch.companyid, 
        sch.programid,
        'invoice', 
        sch.invoiceid, 
        sch.date,
        
        <!--- high school students table --->
        ss.firstname,
        ss.familylastname,
        CAST(IFNULL(CONCAT( ss.firstname, ' ', ss.familylastname, ' (', ss.studentid, ')'), sch.description) AS CHAR) AS hsInvDescrip,
        <!--- end: high school students table --->
        
        <!--- work programs students table --->
        ec.firstname AS workTravelFirstName,
        ec.lastname AS workTravelLastName,
        CAST(IFNULL(CONCAT( ec.firstname, ' ', ec.lastname, ' (', ec.candidateid, ')'), sch.description) AS CHAR) AS workInvDescrip, 
        <!--- end: work programs students table --->
        
        sch.description, 
        sch.type, 
        sch.amount_due
    FROM
        smg_charges sch
    LEFT JOIN
        smg_students ss ON ss.studentid = sch.stuid
    LEFT JOIN
        extra_candidates ec ON ec.candidateid = sch.stuid
    WHERE
        sch.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
    <cfif selectPrograms IS NOT "All">
        AND
            sch.programid IN (#form.selectPrograms#)
    </cfif>
            
    UNION ALL
    
    SELECT
        sc.stuid, 
        sc.chargeid, 
        sc.companyid,
        sch.programid,
        'credit note', 
        sc.creditid, 
        sc.date,
        
        <!--- high school students table --->
        ss.firstname,
        ss.familylastname,
        CAST(IFNULL(CONCAT( ss.firstname, ' ', ss.familylastname, ' (', ss.studentid, ')'), sc.description) AS CHAR) AS hsInvDescrip,
        <!--- end: high school students table ---> 
        
        <!--- work programs students table --->
        ec.firstname AS workTravelFirstName,
        ec.lastname AS workTravelLastName,
        CAST(IFNULL(CONCAT( ec.firstname, ' ', ec.lastname, ' (', ec.candidateid, ')'), sc.description) AS CHAR) AS workInvDescrip,
        <!--- end: work programs students table --->
        
        sch.description, 
        sch.type, 
        sc.amount*-1
    FROM
        smg_credit sc
    LEFT JOIN
        smg_students ss ON ss.studentid = sc.stuid
    LEFT JOIN
        extra_candidates ec ON ec.candidateid = sc.stuid
    LEFT JOIN
        smg_charges sch ON sch.chargeid = sc.chargeid
    WHERE
        sc.agentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
    <cfif selectPrograms IS NOT "All">
        AND
            sch.programid IN (#form.selectPrograms#)
    </cfif>
</cfquery>

<cfquery name="getStudentID" dbtype="query">
SELECT
	DISTINCT(stuid)
FROM
	getCharges
ORDER BY
	firstname, familylastname
</cfquery>

<cfquery name="totalCharged" dbtype="query">
SELECT SUM(amount_due) AS grandTotal
FROM getCharges
</cfquery>

<cfoutput>

<br/>

<small><strong>Number of students charged:</strong> #getStudentID.recordCount#</small>

<br/>

<small><strong>Total amount charged:</strong> #LsCurrencyFormat(totalCharged.grandTotal)#</small>

<br/>
<br/>

<table class="frame">

    <tr class="darkBlue">
    	<td class="right">
        	<strong><small>Student</small></strong>
        </td>
    	<td class="right" align="center">
        	<strong><small>Program</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Company</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Document Type</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Document Number</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Date</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Charge</small></strong>
        </td>
    	<td class="right">
        	<strong><small>Amount</small></strong>
        </td>
    </tr>
    
    <cfloop query="getStudentID">
    	
        <!--- charges per student --->
    	<cfquery name="studentCharges" dbtype="query">
        SELECT *
        FROM getCharges
        WHERE stuid = #getStudentID.stuid#
        </cfquery>
    
    	<!--- sum charges per student --->
    	<cfquery name="sumStudentCharges" dbtype="query">
        SELECT SUM(amount_due) AS studentAmount
        FROM getCharges
        WHERE stuid = #getStudentID.stuid#
        </cfquery>
        
        <cfloop query="studentCharges">

            <tr>
                <td class="two">
                    <cfif studentCharges.currentRow EQ 1>
                    	<cfswitch expression="#studentCharges.companyid#">
                        	<cfcase value="7,8,9">
                   				<small>#studentCharges.workInvDescrip#</small>
                            </cfcase>
                            <cfdefaultcase>
                            	<small>#studentCharges.hsInvDescrip#</small>
                            </cfdefaultcase>
                        </cfswitch>
                    </cfif>
                </td>
                <td class="two" align="center">
                	<small>#studentCharges.description#</small>
                </td>
                <td class="two" align="center">
                    <cfif studentCharges.companyid EQ 10>
                    	<small>CASE</small>
                    <cfelse>
                    	<small>ISE</small>
                    </cfif>
                </td>
                <td class="two" align="center">
                    <small>#studentCharges.invoice#</small>
                </td>
                <td class="two" align="center">
                    <small>#studentCharges.invoiceid#</small>
                </td>
                <td class="two" align="center">
                    <small>#dateFormat(studentCharges.date,'mm/dd/yyyy')#</small>
                </td>
                <td class="two">
                    <small>#studentCharges.type#</small>
                </td>
                <td class="two" align="center"  <cfif studentCharges.amount_due LT 0> style="color:##FF0000;"</cfif>>
                    <small>#LsCurrencyFormat(studentCharges.amount_due)#</small>
                </td>
            </tr>
            
            </cfloop>
        
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td class="two"><strong><small>Total</small></strong></td>
            <td class="two" align="center">            
                <strong><small>#LsCurrencyFormat(sumStudentCharges.studentAmount)#</small></strong>
            </td>
        </tr>
        
        <tr>
        	<td colspan="8" height="10" style="border-top-style:solid; border-top-width:thin; border-top-color:##000000;"></td>
        </tr>
        
    </cfloop>
    
</table>

</cfoutput>