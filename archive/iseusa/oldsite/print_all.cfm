<cfoutput>
<!----<META HTTP-EQUIV="Refresh" CONTENT="3; url=confirm_print.cfm?view=#url.view#">---->
	<title>Placement Report</title>
<style type="text/css" media="print">
	.page-break {page-break-after: always}
</style>


</cfoutput>
	
	<SCRIPT Language="Javascript">
	
	
	
	function printit(){  
	
	if (window.print) {
	
	    window.print() ;  
	
	} else {
	
	    var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
	
	document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
	
	    WebBrowser1.ExecWB(6, 2);//Use a 1 vs. a 2 for a prompting dialog box    WebBrowser1.outerHTML = "";  
	
	}
	
	}
	
	</script>
	
	<!----
	
	<SCRIPT Language="Javascript">  
	
	var NS = (navigator.appName == "Netscape");
	
	var VERSION = parseInt(navigator.appVersion);
	
	if (VERSION > 3) {
	
	    document.write('<form><input type=button value="Print Report" name="Print" onClick="printit()"></form>');        
	
	}
	
	</script>
	
	
	<body onload="printit()">
---->

<cfif #url.view# is 'placement_Reports'>


	<cfquery name="all_info_super_user" datasource="reports">

		SELECT      doc_tracking.*, placement_information_sheet.*

		FROM         doc_tracking, placement_information_sheet 

		WHERE      (placement_information_sheet.tracking_id = doc_tracking.tracking_id) and (doc_tracking.archived = 'no') and (doc_tracking.current_Status='ny')
		
		order by placement_information_Sheet.facilitator_email
	</cfquery>



<cfoutput query="all_info_super_user">

<div class="page-break">

<TABLE border=0 width=100%>

	<TR>

		<TD width=70><img src="pics/ise_logo.jpg" width="70" height="63" alt="" border="0" align="left"></td>

		<TD>

			<TABLE border=2 bgcolor="Silver" bordercolor="black" align="left" width=500>

				<TR>

					<TD><DIV CLASS="form_header" align="center"><font size=+3>Placement Information Sheet</div></div></td>

				</TR>

			</table>

		</TD>

	</TR> 

</TABLE>  





<table border=0 width=800>  
	<tr>
		<td colspan=3>Facilitator: #facilitator_email#</td>
	</tr>
	<tr> 
		
		<td colspan=3>Student: <b>#stu_id# - #stu_name#</b><input type="hidden" name="stu_name" value=#stu_name#> Placement Date: <b>#Left(placement_Date,10)#</b>

		</td>

	</tr>

	<tr>

		<td colspan=3>Regional Director: <b>#regional_director_first# #regional_director_last#</b></td>

	</tr>

		<tr>

		<td colspan=3>Regional Advisor: <b>#regional_advisor_first# #regional_advisor_last#</b></td>

	</tr>

	<tr>

		<td colspan=3>Placement Rep: <b>#place_by#</b></tf>

	<tr>

		<TD colspan=2>Supervising Representative: <b>#area_rep_first_name# #area_rep_last_name#</b></td>

	</tr>

	<tr>  

		<TD colspan=2>Address: <b>#sup_address#</b></td>

	</tr>

	<tr>

		<TD>City: <b>#sup_add_city#</b> State: <b>#sup_add_state#</b> Zip: <b>#sup_zip#</b></td>

	</TR>

	<tr>

		<td colspan=2>Phone: <b>#rep_phone#</b></td>

	</tr>

</table>



<TABLE width = 80% ><TR><TD>

<div class="bu">Host Family Information</div>

<table align="right" width=100%> 

	<tr>

		<td rowspan=29 width=30></td>

		<td><b>#family_name#</b></td>

	</tr>

	<tr>

		<td><b>#fam_add_street#</b></td>

	</tr>

	<tr>

		<TD><b>#fam_add_city# #fam_add_State# #fam_add_zip#</b></td>

	</TR>

	<tr>

		<td>Phone: <b>#host_phone#</b> Email: <b>#host_email#</b></td>

	</tr>

	<tr>

		<td>Father's Date of Birth: <b>#father_dob#</b> Mother's Date of Birth: <b>#mother_dob#</b> </td>

	</tr>

	<tr>

		<td>Father's Occupation: <b>#fathers_occ#</b> Mother's Occupation: <b>#mothers_occ#</b>

	</tr>

	<CFIF child1_name IS "">

	<tr>

		<td></td>

	</TR>

	<CFELSE>	

	<tr>

		<td>Children</td>

	</tr>

	<tr>

		<TD><div class="first_name"><b>#child1_name#</b> DOB: <b>#child1_dob#</b> Sex: : <b>#sex1# </b>At home?<b> #home1#</b></td>

	</tr>

	</CFIF>

	<CFIF child2_name IS "">

	<tr>

		<td></td>

	</TR>

	<CFELSE>	

	<tr>

		<TD><div class="first_name"><b>#child2_name#</b>DOB: <b>#child2_dob#</b> Sex: : <b>#sex2# </b>At home?<b> #home2#</b></td>

	</tr>

	</cfif>

		<CFIF child3_name IS "">

	<tr>

		<td></td>

	</TR>

	<CFELSE>	

	<tr>

		<TD><div class="first_name"><b>#child3_name#</b>DOB: <b>#child3_dob#</b> Sex: : <b>#sex3# </b>At home?<b> #home3#</b></td>

	</tr>

	</cfif>

	<CFIF child4_name IS "">

	<tr>

		<td></td>

	</TR>

	<CFELSE>	

	<tr>

		<TD><div class="first_name"><b>#child4_name#</b>DOB: <b>#child4_dob#</b> Sex: : <b>#sex4# </b>At home?<b> #home4#</b></td>

	</tr>

	</cfif>

		<CFIF child5_name IS "">

	<tr>

		<td></td>

	</TR>

	<CFELSE>	

	<tr>

		<TD><div class="first_name"><b>#child5_name#</b>DOB: <b>#child5_dob#</b> Sex: : <b>#sex5# </b>At home?<b> #home5#</b></td>

	</tr>

	</cfif>

	<CFIF child1_name is "" and child2_name is "" and child3_name is "" and child4_name is "" and child5_name is "">

	<tr>

		<td>Family has no children</td>

	</tr>

	</cfif>

	<cfif room_share is "">

	<tr>

		<td>The student will not be sharing a room.</td>

	<tr>

	<cfelse>

	</tr>

		<td>The student will be sharing a room with <b>#room_share#</b>

	</tr>

	</cfif>

	<tr>

		<td>Does the family attend church?<b>#church#</b> To what extent?<b>#extent_church#</b></td>

	</tr>

	<tr>

		<td>Students choice to attend? <b>#choice#</b> Will family transport to Students church?<b>#trans_church#</b></td>

	</tr>

	<tr>

		<td>Will they accept a smoker?<b>#smoker#</b> If so...any special conditions?<b>#smoke_conditions#</b></td>

	</tr>

	<CFIF animal is "">

	<TR>

		<TD></TD>

	</TR>

	<CFELSE>

	<tr>

		<td><DIV class="bu">Pets/Animals</td>

	</tr>

	<tr>	

		<td><b>#animal#  #indoor#</b></td>

	</tr>

	</CFIF>

	<TR>

		<TD><u>INTERESTS AND ACTIVITIES OF FAMILY</u></TD>

	</TR>

	<TR>

		<TD><b>#family_int#</b></TD>

	</TR>

</TABLE>



		</td>

	</tr>

</table>







<TABLE width = 80% ><TR><TD>

<div class="bu">School</div>

<table align="right" width=100%> 

	<tr>

		<td rowspan=13 width=30></td>	

		<td><b>#school_name#</b></td>

	</tr>

	<tr>

		<TD>

	<tr>

		<td><b>#school_add#</b></td>

	</tr>

	<tr>

		<TD><b>#school_add_city# #school_add_state# #school_zip#</b></td>

	</TR>	

	<tr>

		<td>Phone: <b>#sch_pho#</b> &nbsp;Fax: <b>#sch_fax#</b> </td>

	</tr>
		<td>Email: <b>#sch_email#</b>
	<tr>

		<td>Contact Name, Title: <b>#school_contact#</b> </td>

	</tr>

	<tr>

		<td>Date of Enrollment/Orientation: <b>#enroll#</b> </td>

	</TR>

	<tr>

		<td>DATE SCHOOL BEGINS: <b>#school_start#</b> DATE SCHOOL ENDS: <b>#school_end# </b>

	</TR>

	<Tr>

		<td>Costs student is responsible for: <b>#costs#</b></td>

	</tr>

	<tr>

		<td>Distance from school: <b>#distance_school#</b>  Transported to school by: <b>#trans#</b></td>

	</tr>

</table>

		</td>

	</tr>

<table>





<TABLE width = 80% ><TR><TD>

<div class="bu">Community</div>

<table align="right" width=100%> 

	<tr>

		<td rowspan=4 width=30></td>

		<td><div class="bu">Community</td>

	</tr>

	<tr>

		<td>Type: <b>#comm_type#</b></td>

	</tr>

	<tr>

		<td>Closest City<b>#closest_city# </b> How Far? <b>#distance#</b>miles</td>

	</tr>

	<tr>

		<td>ARRIVAL AIRPORT <b>#arrival_airport# </b>Airport Code: <b>#air_code#</b> LOCATION <b>#arrival_location#</b></td>

	</tr>

</table>



<!---outside table--->

		</td>

	</tr>

	<tr>

		<td>

<!---outside table--->



<TABLE align="left"> 

	<TR>

		

		<TD colspan=2><div class="bu">OTHER PERTINENT INFORMATION</div></td>

	</tr>

	<tr>

		<td width=30></td><td><b>#pert_info#</b></td>

	</tr>

</table>



<!---End of Outside table--->

		</td>	

	</tr>

</table>
</div>
</cfoutput>
<cfelse>

	<cfquery name="all_info" datasource="reports">

		SELECT      doc_tracking.*, test_progress_reports.*

		FROM         doc_tracking, test_progress_Reports 

		WHERE      (test_progress_reports.tracking_id = doc_tracking.tracking_id) and (doc_tracking.archived = 'no') and (doc_tracking.current_Status='ny')
		
		order by test_progress_reports.facilitator_email
	</cfquery>
	
	<cfoutput query=all_info>

<div class="page-break">
			<table cellspacing="2" cellpadding="2" border=0 width=100% align="center">
			<tr>
			    <td rowspan="3" align="left"><img src="http://www.iseusa.com/internet/images/logo_ise.gif" width="70" height="77" alt="" border="0"></td>
			    <td><i>Monthly Contact with the Student is Required.</i></td>
			</tr>
			<tr>
			    <td colspan=2>
					<FONT SIZE=+3>Student Progress Report for #month#</Font>
				</td>
			</TR>
			<TR>
				<TD colsapn=2><FONT SIZE=+1>Student Name: #stu_first_name# #Stu_last#</td><TD><FONT SIZE=+1>Student Number: #stu_id#</td>
			</TR>
			</table>
			<hr>
			<TABLE width=90% align="center">
				<tr>
					<TD>Area Representative: #session.intra_fname# #session.intra_lname# <font size=-2>#session.email#</font></td> 
					<TD>Regional Advisor: #Regional_Advisor_First# #REgional_Advisor_Last# <font size=-2>#regional_advisor_email#</font></TD>
					<td>Regional Director: #Regional_Director_first# #Regional_Director_last# <font size=-2>#regional_director_email#</font> </td>
					</TR>
				<TR>
					
					<td >Host Family:  <CFIF father_name is ''>&nbsp;<cfelse>#father_name# </cfif><cfif father_name is not '' AND mother_name is not ''> & <cfelse>&nbsp;</cfif> <CFIF mother_name is ''>&nbsp;<cfelse> #mother_name# #host_last#</cfif></td>
					<TD>International Agent: #int_bus#</td>
					<td></td>
				</tr>
			</TABLE>
			<!----<TABLE width=100% align="center">
				<TR>
					<td style="font_smaller">
			This report will be shared with the International Representative, your Students Natural parents, and ISE's Regional and Main Offices.  
			<B>Reports are due in the Regional Office by the 10th of the month.</b> (supervision through October 10th is due BY OCTOBER 10th).  
			Payments will be released only after these reports are filed.  <b>ANY REPORT RECEIVED MORE THEN 30 DAYS LATE IN ARRIVING WILL NOT BE 
			ACCEPTED FOR PAYMENT.</B></FONT><BR><br>
					</TD>
				</tr>
			</TABLE>---->
			<!---<table frame="border" border=5 bordercolor="black" width=100% align="center">
				<TR>
					<TD COLSPAN=6>Written reports are only required on the following months. (October written report of the students' progress from arrival through Oct. is due in the office by Oct 10, etc).<br>REPORTS ARE REQUIRED ONLY THE FOLLOWING MONTHS.</TD>
				</TR>
				<TR>
					<TD>Check the month you are reporting</td>
					<td>OCTOBER <cfinput type="Radio" name="month" value="October" align="RIGHT"><br>Arrival - Oct. 10<br>OCTOBER Paymnet</td>
					<td>DECEMBER <cfinput type="Radio" name="month" value="December" align="RIGHT"><br>Oct. 10 - Dec. 10<br>DECEMBER Payment</td>
					<td>FEBRUARY <cfinput type="Radio" name="month" value="February" align="RIGHT"><br>Dec. 10 - Feb. 10<br>FEBRUARY Payment</TD>
					<td>APRIL <cfinput type="Radio" name="month" value="April" align="RIGHT"><BR>Feb. 10 -0 Apr. 10<br>MAY Payment</td>
					<TD>JUNE <cfinput type="Radio" name="month" value="June" align="RIGHT"><br>Apr. 10 - END<br>JUNE FINAL Payment</td> 
				</TR>
			</TABLE> ---->
			<TABLE border=1 bordercolor="black" align="center" width=100% class="font_print">
				<TR>
					<TD>
					
					<table border=0>
						<!---<TR>
							<TD colspan=2>Dates/Methods of Student Contact for this period:<br><div align="center">(IP=In Person .... BT=By Telephone)<br><hr color="black" width=100%><td>
						</TR>--->
						<TR align="Center">
							<TD>Date: <b> #stu_date_one# </td>
							<td>Method: <b>#stu_method_one#
						</tr>
						<TR align="Center">
							<TD>Date: <b>#stu_date_two#</td>
							<td>Method: <b>#stu_method_two#</td>
						</tr>
						<TR align="Center">
							<TD>Date: <b>#stu_date_three#</td>
							<td>Method: <b>#stu_method_three#</td>
						</tr>
					</TABLE>
							
					</TD>
					<TD>
					
						<TABLE>
							<!---<TR>
								<TD colspan=2>Dates/Methods of Host Family Contact for this period:<br><div align="center">(IP=In Person .... BT=By Telephone)<br><hr color="black" width=100%><td>
							</TR>--->
							<TR align="Center">
								<TD>Date:<b> #host_date_one#</td>
								<td>Method: <b>#host_method_one#</td>
							</tr>
							<TR align="Center">
								<TD>Date: <b>#host_date_two#</td>
								<td>Method: <b>#host_method_two#
							</tr>
							<TR align="Center">
								<TD>Date: <b>#host_date_three#</td>
								<td>Method: <b>#host_method_three#</td>
							</tr>
						</TABLE>
						
					</TD>
					<TD>
					
						<TABLE>
							<!---<TR>
								<TD colspan=2>Dates/Methods of School Contact for this period:<br><div align="center">(IP=In Person .... BT=By Telephone)<br><hr color="black" width=100%><td>
							</tr>--->
							<TR align="Center">
								<TD>Date: <b>#school_date_one#</td>
								<td>Method:<b> #school_method_one#</td>
							</tr>
							<TR align="Center">
								<TD>Date: <b>#school_date_two#</td>
								<td>Method: <b>#school_method_two#</td>
							</tr>
							<TR align="Center">
								<TD>Date: <b>#school_date_three#</td>
								<td>Method: <b>#school_method_three#</td>
							</tr>
						</TABLE>
						
					</TD>
				</TR>
			</TABLE>
			<br>
			<!---<TABLE width=100% align="center">
				<TR>
					<TD>
			<DIV ALIGN="center">ANSWER THE FOLLOWING QUESTIONS BASED ON COMMUNICATION WITH THE STUDENT, HOST FAMILY, AND/OR SCHOOL STAFF DURRING THIS PERIOD.
			EACH ANSWER SHOULD BE GIVEN A NUMERICAL RATING BY THE PERSON INDUCATED BASED ON THE FOLLOWING SCALE:<BR>
			<FONT SIZE=+1>1-2-3-4-5-6-7-8-9-10</font><BR>
			<FONT SIZE=-1>(ONE = <I><U>DOES NOT APPLY</U></I> ... TEN = <I><U>FULLY APPLIES</U></I> TO THE STUDENTS' PROGRAM.)<BR>
			ANY CONCERNS SHOULD BE NOTED IN THE SPACE PROVIDED.</font></div><BR>
					</TD>
				</TR>
			</TABLE>--->
			<table width="95%" cellspacing="2" cellpadding="2" border="0" align="centerft">
			<tr>
			    <td></td>
			    <td><div align="center"><U>STUDENT</U></td>
			    <td><div align="center"><U>HOST FAMILY</U></td>
			    <td><div align="center"><U>SCHOOL</U></td>
			</tr>
			<tr>
			    <td><DIV STYLE="print">#stu_first_name# seems to be enjoying his/her role as an exchange student.</td>
			    <td><DIV ALIGN="center">#stu_role#
			</td>
			   	<td><DIV ALIGN="center">#host_role#
			</td>
			    <td><DIV ALIGN="center">#school_role#
			</td>
			</tr>
			<tr>
			    <td>#stu_first_name# has adjusted satisfactorily in school with studies and rules.</td>
			    <td><DIV ALIGN="center">#stu_adjust#
			</td>
			    <td><DIV ALIGN="center">#host_adjust#
			</td>
			    <td><DIV ALIGN="center">#school_adjust#
			</td>
			</tr>
			<tr>
			    <td>#stu_first_name#s' English is more fluent.</td>
			    <td><DIV ALIGN="center">#stu_english#
			</td>
			    <td><DIV ALIGN="center">#host_english#
			</td>
			    <td><DIV ALIGN="center">#school_english#
			</td>
			</tr>
			<tr>
			    <td>#stu_first_name# is involved in extracurricular activities.</td>
			    <td><DIV ALIGN="center">#stu_extra#
			</td>
			    <td><DIV ALIGN="center">#host_extra#
			</td>
			    <td><DIV ALIGN="center">#school_extra#
			</td>
			</tr>
			<tr>
			    <td>#stu_first_name# has attempted to make AMERICAN friends. </td>
			    <td><DIV ALIGN="center">#stu_american#
			</td>
			    <td><DIV ALIGN="center">#host_american#
			</td>
			    <td><DIV ALIGN="center">#school_american#
			</td>
			</tr>
			<tr>
			    <td>#stu_first_name# has integrated/adjusted to the Host Family.</td>
			    <td><DIV ALIGN="center">#stu_integrat#
			</td>
			    <td><DIV ALIGN="center">#host_integrat#
			</td>
			    <td><DIV ALIGN="center">#school_integrat#
			</td>
			</tr>
			<tr>
			    <td>#stu_first_name# communicates well with all members of the Host Family.</td>
			    <td><DIV ALIGN="center">#stu_comm#
			</td>
			    <td><DIV ALIGN="center">#host_comm#
			</td>
			    <td><DIV ALIGN="center">#school_comm#
			</td>
			</tr>
			<tr>
			    <td></td>
			    <td><DIV ALIGN="center"><U>AREA REP</U></td>
			    <td><DIV ALIGN="center"><U>HOST FAMILY</U></td>
			    <td><DIV ALIGN="center"><U>SCHOOL</U></td>
			</tr>
			<tr>
			    <td>#stu_first_name# comes to you for assistance and guidance.</td>
			    <td><DIV ALIGN="center">#rep_guide#
			</td>
			    <td><DIV ALIGN="center">#host_guide#
			</td>
			    <td><DIV ALIGN="center">#school_guide#
			</td>
			</tr>
			</table>
			 <br>
			 <br>
			 <TABLE width=100% align="center">
			 	<TR>
					<TD><DIV ALIGN="left">
			 Additional Concerns/Comments:<br><br>
			#message#
					</TD>
				</TR>
			</TABLE>
			
</cfoutput>
</cfif>
</body>
</html>
