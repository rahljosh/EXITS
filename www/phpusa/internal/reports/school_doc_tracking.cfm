<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Document Tracking Report</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfsilent>

    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.documents" default="">
    <cfparam name="FORM.orderBy" default="">
    
    <!--- Get Programs --->
    <cfquery name="qGetPrograms" datasource="#APPLICATION.DSN#">
        SELECT *
        FROM smg_programs 
        LEFT JOIN smg_program_type ON type = programtypeid
        WHERE programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
    </cfquery>
    
    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        SELECT 
            s.studentid, 
            s.firstname, 
            s.familylastname, 
            s.sex, 
            s.country, 
            s.uniqueid, 
            s.programid, 
            s.dob,
            s.php_grade_student,
            smg_programs.programname,
            u.businessname,
            sc.schoolname,
            php.hostID,
            php.areaRepID,
            php.datecreated, 
            php.dateplaced, 
            php.school_acceptance,
            php.original_school_acceptance,
            php.hf_placement, 
            php.i20received,
            php.hf_application,
            php.transfer_type, 
            php.return_student,
            php.orientationSignOff_student,
            php.doc_letter_rec_date,
            php.doc_rules_rec_date,
            php.doc_photos_rec_date,
            php.doc_school_profile_rec,
            php.doc_conf_host_rec,
            php.orientationSignOff_student,
            php.doc_ref_form_1,
            php.doc_ref_form_2,
            h.php_orientationSignOff,
            IFNULL(alp.name, 'n/a') AS PHPReturnOption
        FROM 
            smg_students s
        
        INNER JOIN
            php_students_in_program php ON php.studentid = s.studentid
        LEFT JOIN
        	smg_hosts h ON h.hostID = php.hostID
        LEFT JOIN 
            smg_programs ON smg_programs.programid = php.programid 
        LEFT JOIN 
            smg_users u on u.userid = s.intrep 
        LEFT JOIN 
            php_schools sc ON sc.schoolid = php.schoolid
      	
        LEFT OUTER JOIN
             applicationlookup alp ON alp.fieldID = php.return_student
                 AND
                    fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="PHPReturnOptions">            
        WHERE
            php.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
        AND
            php.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            php.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
        ORDER BY 
            #FORM.orderby# 
    </cfquery>
    
</cfsilent>


<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>

    <table width="95%" cellpadding=0 cellspacing="0" align="center">
        <tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Document Tracking Report</span></td></tr>
    </table><br/>
    
    <table width="95%" cellpadding=4 cellspacing="0" align="center" frame="box">
        <tr><td align="center">
            Program(s) Included in this Report:<br/>
            <cfloop query="qGetPrograms"><b>#programname# &nbsp; (#ProgramID#)</b><br/></cfloop>
            Total of Students <b>placed</b> in program: #qGetResults.recordcount#
        </td></tr>
    </table><br/>
    
    <table width="95%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##666;">	
        <tr>
            <td><b>Student</b></td>
            <td><b>GRD.</b></td>
            <td><b>DOB</b></td>
            <td><b>Intl. Agent</b></td>
            <td><b>Date Entered</b></td>
            <td><b>School</b></td>
            <td><b>Ret/Trans/Ext</b></td>
            <cfloop list="#FORM.documents#" index="i">
            	<cfif i EQ 'original_school_acceptance'><td><b>Orig. School Accep.</b></td></cfif>
                <cfif i EQ 'school_acceptance'><td><b>School Accep.</b></td></cfif>
                <cfif i EQ 'i20received'><td><b>I-20</b></td></cfif>
                <cfif i EQ 'hf_placement'><td><b>HF Place</b></td></cfif>
                <cfif i EQ 'hf_application'><td><b>HF App</b></td></cfif>
                <cfif i EQ 'doc_letter_rec_date'><td><b>Host Family Letter</b></td></cfif>
                <cfif i EQ 'doc_rules_rec_date'><td><b>Host Family Rules Form</b></td></cfif>
                <cfif i EQ 'doc_photos_rec_date'><td><b>Host Family Photos</b></td></cfif>
                <cfif i EQ 'doc_school_profile_rec'><td><b>School & Community Profile</b></td></cfif>
                <cfif i EQ 'doc_conf_host_rec'><td><b>Confidential HF Visit form</b></td></cfif>
                <cfif i EQ 'orientationSignOff_student'><td><b>Student orientation sign off</b></td></cfif>
                <cfif i EQ 'doc_ref_form_1'><td><b>Reference 1</b></td></cfif>
                <cfif i EQ 'doc_ref_form_2'><td><b>Reference 2</b></td></cfif>
                <cfif i EQ 'php_orientationSignOff'><td><b>HF Orientation Sign-Off </b></td></cfif>
                <cfif i EQ 'hf_cbc'><td><b>HF CBC</b></td></cfif>
                <cfif i EQ 'rep_cbc'><td><b>Representative CBC</b></td></cfif>
                <cfif i EQ 'rep_training'><td><b>Representative Training</b></td></cfif>
                                        
           	</cfloop>
        </tr>
        <cfloop query="qGetResults">
            <tr bgcolor="#iif(qGetResults.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                <td>#qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentid#)</td>
                <td><cfif VAL(qGetResults.php_grade_student)>#qGetResults.php_grade_student#th</cfif></td>
                <td><cfif qGetResults.dob NEQ ''>#DateFormat(qGetResults.dob, 'mm/dd/yyyy')#</cfif></td>			
                <td>#qGetResults.businessname#</td>
                <td><cfif qGetResults.datecreated NEQ ''>#DateFormat(qGetResults.datecreated, 'mm/dd/yyyy')#</cfif></td>
                <td>#qGetResults.schoolname#</td>
                <td><i><font size="-2">#qGetResults.PHPReturnOption#</font></i></td>
                <cfloop list="#FORM.documents#" index="i">
              
                	<cfif i NEQ 'hf_cbc' AND i NEQ 'rep_cbc' AND i NEQ 'rep_training' AND i NEQ 'php_orientationSignOff'>
                    	<td><i><font size="-2"><cfif Evaluate('qGetResults.#i#') NEQ ''>#DateFormat(Evaluate('qGetResults.#i#'), 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>
                   	<cfelseif i EQ 'php_orientationSignOff'>
                    	<td>
                        	<i>
                            	<font size="-2">
									<cfif php_orientationSignOff EQ "">
                                        n/a
                                    <cfelseif DateAdd('yyyy',1,php_orientationSignOff) LT NOW()>
                                        Expired
                                    <cfelse>
                                       #DateFormat(php_orientationSignOff,'mm/dd/yyyy')#
                                    </cfif>
                           		</font>
                          	</i>
                      	</td>
                        
                    <cfelseif i EQ 'hf_cbc'>
                    	<cfscript>
							vIsHostCBCValid = APPLICATION.CFC.Host.isCBCValid(hostID = #VAL(hostID)#);
						</cfscript>
                        <td><i><font size="-2"><cfif vIsHostCBCValid AND VAL(hostID)>Valid<cfelse>n/a</cfif></font></i></td>
                   	<cfelseif i EQ 'rep_cbc'>
                    	<cfscript>
							qIsRepCBCValid = APPLICATION.CFC.User.getCBC(userID=#VAL(areaRepID)#,isNotExpired=true);
						</cfscript>
                        <td><i><font size="-2"><cfif VAL(qIsRepCBCValid.recordCount) AND VAL(areaRepID)>Valid<cfelse>n/a</cfif></font></i></td>
                    <cfelseif i EQ 'rep_training'>
                    	<cfset vTrainingDisplay = "">
                    	<cfloop list="#FORM.programID#" index="j">
                        	<cfscript>
								if(NOT VAL(APPLICATION.CFC.User.getRepTraining(userID=#VAL(areaRepID)#,programID=#j#).approvedTraining)) {
									vTrainingDisplay = "n/a";
								}
							</cfscript>
                        </cfloop>
                        <cfif vTrainingDisplay EQ "">
                        	<cfset vTrainingDisplay = "complete">
                       	</cfif>
                        <td><i><font size="-2">#vTrainingDisplay#</font></i></td>
					</cfif>
                </cfloop>
            </tr>								
        </cfloop>
    </table>
<br /><br />
</cfoutput>

</body>
</html>
