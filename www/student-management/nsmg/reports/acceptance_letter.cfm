<cfif isdefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Student Info --->
<cfinclude template="../querys/get_student_info.cfm">

<!-----Company Information----->
<Cfquery name="companyshort" datasource="MySQL">
select *
from smg_companies
where companyid = #get_student_info.companyid#
</Cfquery>

<!-----Intl. Agent----->
<cfquery name="int_Agent" datasource="MySQL">
SELECT companyid, businessname, fax, email
FROM smg_users 
WHERE userid = #get_student_info.intrep#
</cfquery>

<!-----Program Name----->
<cfquery name="program_name" datasource="MySQL">
select programname, programtype
from smg_programs
INNER JOIN smg_program_type
ON type = programtypeid
where programid = #get_Student_info.programid#
</cfquery>

<style type="text/css">
<!--
.style1 {font-size: 13px}
-->
</style>
<cfoutput>

<!--- PAGE HEADER --->
<table width=650 align="center" border=0 bgcolor="FFFFFF"> 
	<tr>
	<td  valign="top" width=90>
		TO:<br>
		FAX:<br>
		E-MAIL:<br><br><br><br>
		Today's Date:<br>
	</td>
	<td  valign="top">
		<cfif len(#int_agent.businessname#) gt  40>#Left(int_agent.businessname,40)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		#int_agent.fax#<br>
		<a href="mailto:#int_agent.email#">#int_agent.email#</a><br>
		<form action="email_acceptance_letter.cfm?studentid=#get_student_info.studentid#" method="post"
		onsubmit="return confirm ('Are you sure? This Acceptance Letter will be sent to the International Representative')">
		<input type="image" src="../pics/sendemail.gif" value="send email"></form><br><br>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>
	</td>
	<td><img src="../pics/logos/#get_student_info.companyid#.gif"  alt="" border="0" align="right"></td>
	<td valign="top" align="right"> 
	<div align="right">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td></tr>
</table><br>
<br>
<table  width=650 align="center" border=0 bgcolor="FFFFFF">
	<hr width=80% align="center">
</table><br>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" >
	<tr>
	<td>
    <div align="justify"><span class="application_section_header"><font size=+1><b><u>RECEIPT AND ACCEPTANCE NOTIFICATION</u></b></font></span><br>
    <br><br>
	  The application for the following student(s) has been received. Not only is this a
	  notification of acceptance but it is also, in some cases, a notice that additional
	  information is needed in order to adhere to United States Department of State regulations
	  and to ensure that the student will be easily placed. Please send the requested information
	  <b>in English </b>as soon as possible. It is extremely important!!! If a student has been rejected you will be
	  notified with a separate letter. (If a student has scheduled dates written in for upcoming 
	  immunizations, please make sure that he/she obtains proof in writing from their doctor that
	  the immunizations have been completed and the date).
     <br><br>
	 </div></td></tr>
</table>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
	<td><p><b>Program:</b> #program_name.programname# &nbsp; - &nbsp; #program_name.programtype#<p></td>
	<tr><td colspan=3><hr width=100% align="center"></td></tr>
	<tr><td valign="top" width=280><span class="acceptance_letter_header">
Student's Name</span><br><br>
<span class="style1">#get_Student_info.firstname# #get_Student_info.familylastname# (#get_Student_info.studentid#)</span>
	</td>
	<td valign="top" width=370><span class="acceptance_letter_header">
Missing Documents</span><br><br>
<span class="style1">#get_Student_info.other_missing_docs#</span>
	</td></tr>
	<td colspan=3><hr width=100% align="center"></td><br>
    
    <!--- Display Message if student is assigned to Brian - Approved region --->
    <cfif get_student_info.regionAssigned EQ 1462>
    	<tr>
        	<td colspan="3">
            	We thank you for submitting your application early but we have not begun assigning applications to regions for your program yet. 
                Therefore, you will find that this application has been assigned to the approved region for the time being.
            </td>
		</tr>                        
    </cfif>
</table>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
	<tr><td>
	<br>Thanks,<br><br>
	#companyshort.admission_person#<br> 
	Student Admissions Department
	</td></tr>
</cfoutput>

<!--- http://smg.pokytrails.com/reports/acceptance_letter.cfm?studentid=470 --->