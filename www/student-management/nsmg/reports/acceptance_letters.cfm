<!--- Get Programs --->
<cfquery name="get_programs" datasource="MySQL">
	SELECT s.programid, p.programname, count(studentid) as total_stu
	FROM smg_students s INNER JOIN smg_programs p
	ON s.programid = p.programid and s.intrep = '#form.intrep#' 
	and (s.dateapplication between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(DateAdd('d', 1, form.date2))#) 
	and s.active = '1' and s.companyid = '#client.companyid#' 
	GROUP BY s.programid
</cfquery>

<!-----Intl. Agent----->
<cfquery name="int_Agent" datasource="MySQL">
	select companyid, businessname, fax, email
	from smg_users 
	where userid = '#form.intrep#'
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<link rel="stylesheet" href="../profile.css" type="text/css">

<style type="text/css">
<!--
.style1 {font-size: 13px}
-->
</style>

<cfoutput>
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td  valign="top" width=90><span id="titleleft">
		TO:<br>
		FAX:<br>
		E-MAIL:<br><br><br><br>	
		Today's Date:<br>
	</td>
	<td  valign="top"><span id="titleleft">
		<cfif len(#int_agent.businessname#) gt  40>#Left(int_agent.businessname,40)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		#int_agent.fax#<br>
		<a href="mailto:#int_agent.email#">#int_agent.email#</a><br>
		<form action="email_acceptance_letters.cfm?intrep=#form.intrep#&date1=#form.date1#&date2=#form.date2#" method="post"
		onsubmit="return confirm ('Are you sure? This Acceptance Letter will be sent to the International Representative')">
		<input type="image" src="../pics/sendemail.gif" value="send email"></form>
		#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>
	</td>
	<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="right"></td>	
	<td valign="top" align="right"> 
		<div align="right"><span id="titleleft">
		#companyshort.companyshort#<br>
		#companyshort.address#<br>
		#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
		<cfif companyshort.phone is ''><cfelse> Phone: #companyshort.phone#<br></cfif>
		<cfif companyshort.toll_free is ''><cfelse> Toll Free: #companyshort.toll_free#<br></cfif>
		<cfif companyshort.fax is ''><cfelse> Fax: #companyshort.fax#<br></cfif></div>
	</td></tr>		
</table><br><br>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" >
	<hr width=80% align="center">
	<tr>
	<td colspan="2">
    <div align="justify"><span class="application_section_header"><font size=+1><b><u>RECEIPT AND ACCEPTANCE NOTIFICATION</u></b></font></span><br><br><br>
	  The application for the following student(s) has been accepted. Not only is this a
	  notification of acceptance but it is also, in some cases, a notice that additional
	  information is needed in order to adhere to United States Department of State regulations
	  and to ensure that the student will be easily placed. Please send the requested information
	  <b>in English </b>as soon as possible. It is extremely important!!! If a student has been denied you will be
	  notified with a separate letter. (If a student has scheduled dates written in for upcoming 
	  immunizations, please make sure that he/she obtains proof in writing from their doctor that
	  the immunizations have been completed and the date). <br><br>
	 </div></td></tr>
</table>

<cfloop query="get_programs">
<table width=650 border=0 align="center" bgcolor="FFFFFF">
	<tr><td><b>Program:</b> #get_programs.programname#</td><td>Total: #get_programs.total_stu#</td></tr> 
	<tr><td colspan=2><hr width=100% align="center"></td></tr>
	<tr>
		<td valign="top" width=250><span class="acceptance_letter_header">Student's Name</span><br><br></td>
		<td valign="top" width=400><span class="acceptance_letter_header">Missing Documents</span></td>
	</tr>
	<!--- Get Students --->
	<cfquery name="get_students" datasource="MySQL">
		SELECT firstname, familylastname, studentid, other_missing_docs, dateapplication, programid, intrep, regionAssigned
		FROM smg_students 
		WHERE intrep = '#form.intrep#' and (dateapplication between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(DateAdd('d', 1, form.date2))#) 
		and active = '1' and companyid = '#client.companyid#' and programid = '#get_programs.programid#'
		ORDER BY studentid
	</cfquery>

    <cfquery name="qGetStudentRegions" dbtype="query">
    	SELECT
        	regionAssigned
        FROM
        	get_students
	</cfquery>        	
    
    <cfset regionList = ValueList(qGetStudentRegions.regionAssigned)>

	<cfloop query="get_students">
	<tr>
		<td><span class="style1">#firstname# #familylastname# (#studentid#)</span></td>
		<td><div align="justify"><span class="style1">#other_missing_docs#</span></div></td>
	</tr>
	<tr><td colspan="2"><hr width=100% align="center"></td></tr>
	</cfloop>

    <!--- Display Message if at least one student is assigned to Brian - Approved region --->
    <cfif ListFind(regionList, 1462)>
    	<tr>
        	<td colspan="2">
            	We thank you for submitting your application early but we have not begun assigning applications to regions for your program yet. 
                Therefore, you will find that this application has been assigned to the approved region for the time being.
            </td>
		</tr>                        
    </cfif>
    
</table>
</cfloop>

<table width=650 border=0 align="center" bgcolor="FFFFFF">
	<tr><td>
	<br>Thanks,<br><br>
	#companyshort.admission_person#<br> 
	Student Admissions Department
	</td></tr>
</cfoutput>
