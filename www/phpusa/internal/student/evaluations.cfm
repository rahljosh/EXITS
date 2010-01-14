<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../phpusa.css" rel="stylesheet" type="text/css">
<Title>Evaluation / Grades</title>

<script language="JavaScript"> 
<!--// 
var currentTime = new Date()
var month = currentTime.getMonth() + 1
var day = currentTime.getDate()
var year = currentTime.getFullYear()
if (day < 10) 
	day = "0"+day;
if (month < 10) 
	month = "0"+month;

function CheckDates(ckname, frname) {
	if (document.form.elements[ckname].checked) {
		document.form.elements[frname].value = (month + "/" + day + "/" + year);
		}
	else { 
		document.form.elements[frname].value = '';  
	}
}	
//-->
</script>

<style type="text/css">
<!--
/* region table */
table.dash { font-size: 12px; border: 1px solid #202020; }
tr.dash {  font-size: 12px; border-bottom: dashed #201D3E; }
td.dash {  font-size: 12px; border-bottom: 1px dashed #201D3E;}
-->
</style>
</head>

<table align="center" width="100%" cellpadding=0 cellspacing=0  border=0 bgcolor="#e9ecf1"> 
<tr><td width="100%">&nbsp;</td></tr>
<tr><td>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">
<!----
<cftry>
--->
<cfoutput>

<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
	<tr bgcolor="##C2D1EF"><td align="center"><b>E V A L U A T I O N S &nbsp; / &nbsp; G R A D E S</b></td></tr>
	<tr><th><h5>Student: #get_student_unqid.firstname# #get_student_unqid.familylastname# (##)</h5></th></tr>
	<tr>
		<td>
			<cfform name="form" action="qr_evaluations.cfm" method="post">
				<cfinput type="hidden" name="assignedid" value="#get_student_unqid.assignedid#">
				<cfinput type="hidden" name="uniqueid" value="#get_student_unqid.uniqueid#">
				<table border=0 width="540" align="center">
					<tr>
						<td rowspan="13" valign="top" width="5"><span class="get_attention"><b>></b></span></td>
						<td class="dash" width="240"><b>Evaluations</b></td>
						<td rowspan="13" valign="top" width="10"></td>
						<td rowspan="13" valign="top" width="5"><span class="get_attention"><b>></b></span></td>
						<td class="dash" width="240"><b>Grades</b></td>
					</tr>
					<tr>
						<td>
							<Cfif get_student_unqid.doc_evaluation9 EQ ''>
								<cfinput type="checkbox" name="doc_evaluation9_box" onClick="CheckDates('doc_evaluation9_box', 'doc_evaluation9')">
							<cfelse>
								<cfinput type="checkbox" name="doc_evaluation9_box" onClick="CheckDates('doc_evaluation9_box', 'doc_evaluation9')" checked="yes">		
							</cfif>						
							Oct. Evaluation  &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_evaluation1" size=8 value="#DateFormat(get_student_unqid.doc_evaluation9, 'mm/dd/yyyy')#">						</td>
						<td>
							<Cfif get_student_unqid.doc_grade1 EQ ''>
								<cfinput type="checkbox" name="doc_grade1_box" onClick="CheckDates('doc_grade1_box', 'doc_grade1')">
							<cfelse>
								<cfinput type="checkbox" name="doc_grade1_box" onClick="CheckDates('doc_grade1_box', 'doc_grade1')" checked="yes">
								#get_student_unqid.studentid#		
							</cfif>						
					  Grade 1 &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_grade1" size=8 value="#DateFormat(get_student_unqid.doc_grade1, 'mm/dd/yyyy')#">						</td>
					</tr>
					<tr>
						<td>
							<Cfif get_student_unqid.doc_evaluation12 EQ ''>
								<cfinput type="checkbox" name="doc_evaluation12_box" onClick="CheckDates('doc_evaluation12_box', 'doc_evaluation2')">
							<cfelse>
								<cfinput type="checkbox" name="doc_evaluation12_box" onClick="CheckDates('doc_evaluation12_box', 'doc_evaluation2')" checked="yes">		
							</cfif>						
							Dec. Evaluation  &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_evaluation12" size=8 value="#DateFormat(get_student_unqid.doc_evaluation12, 'mm/dd/yyyy')#">						</td>
						<td>
							<Cfif get_student_unqid.doc_grade2 EQ ''>
								<cfinput type="checkbox" name="doc_grade2_box" onClick="CheckDates('doc_grade2_box', 'doc_grade2')">
							<cfelse>
								<cfinput type="checkbox" name="doc_grade2_box" onClick="CheckDates('doc_grade2_box', 'doc_grade2')" checked="yes">		
							</cfif>						
							Grade 2 &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_grade2" size=8 value="#DateFormat(get_student_unqid.doc_grade2, 'mm/dd/yyyy')#">						</td>
					</tr>	
					<tr>
						<td>
							<Cfif get_student_unqid.doc_evaluation2 EQ ''>
								<cfinput type="checkbox" name="doc_evaluation2_box" onClick="CheckDates('doc_evaluation2_box', 'doc_evaluation2')">
							<cfelse>
								<cfinput type="checkbox" name="doc_evaluation2_box" onClick="CheckDates('doc_evaluation2_box', 'doc_evaluation2')" checked="yes">		
							</cfif>						
							Feb. Evaluation &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_evaluation3" size=8 value="#DateFormat(get_student_unqid.doc_evaluation2, 'mm/dd/yyyy')#">						</td>
						<td>
							<Cfif get_student_unqid.doc_grade3 EQ ''>
								<cfinput type="checkbox" name="doc_grade3_box" onClick="CheckDates('doc_grade3_box', 'doc_grade3')">
							<cfelse>
								<cfinput type="checkbox" name="doc_grade3_box" onClick="CheckDates('doc_grade3_box', 'doc_grade3')" checked="yes">		
							</cfif>						
							Grade 3 &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_grade3" size=8 value="#DateFormat(get_student_unqid.doc_grade3, 'mm/dd/yyyy')#">						</td>
					</tr>	
					<tr>
						<td>
							<Cfif get_student_unqid.doc_evaluation4 EQ ''>
								<cfinput type="checkbox" name="doc_evaluation4_box" onClick="CheckDates('doc_evaluation4_box', 'doc_evaluation4')">
							<cfelse>
								<cfinput type="checkbox" name="doc_evaluation4_box" onClick="CheckDates('doc_evaluation4_box', 'doc_evaluation4')" checked="yes">		
							</cfif>						
							Apr. Evaluation &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_evaluation4" size=8 value="#DateFormat(get_student_unqid.doc_evaluation4, 'mm/dd/yyyy')#">						</td>
						<td>
							<Cfif get_student_unqid.doc_grade4 EQ ''>
								<cfinput type="checkbox" name="doc_grade4_box" onClick="CheckDates('doc_grade4_box', 'doc_grade4')">
							<cfelse>
								<cfinput type="checkbox" name="doc_grade4_box" onClick="CheckDates('doc_grade4_box', 'doc_grade4')" checked="yes">		
							</cfif>						
							Grade 4 &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_grade4" size=8 value="#DateFormat(get_student_unqid.doc_grade4, 'mm/dd/yyyy')#">						</td>
					</tr>	
					<tr>
						<td>
							<Cfif get_student_unqid.doc_evaluation6 EQ ''>
								<cfinput type="checkbox" name="doc_evaluation6_box" onClick="CheckDates('doc_evaluation6_box', 'doc_evaluation6')">
							<cfelse>
								<cfinput type="checkbox" name="doc_evaluation6_box" onClick="CheckDates('doc_evaluation6_box', 'doc_evaluation6')" checked="yes">		
							</cfif>						
							June Evaluation  &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_evaluation6" size=8 value="#DateFormat(get_student_unqid.doc_evaluation6, 'mm/dd/yyyy')#">						</td>
							<td>
							<Cfif get_student_unqid.doc_grade5 EQ ''>
								<cfinput type="checkbox" name="doc_grade5_box" onClick="CheckDates('doc_grade5_box', 'doc_grade5')">
							<cfelse>
								<cfinput type="checkbox" name="doc_grade5_box" onClick="CheckDates('doc_grade5_box', 'doc_grade5')" checked="yes">		
							</cfif>						
							Grade 5 &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_grade5" size=8 value="#DateFormat(get_student_unqid.doc_grade5, 'mm/dd/yyyy')#">
							</td>
  </tr>	
  <tr>
						<td>												
							</td>
						<td>
							<Cfif get_student_unqid.doc_grade6 EQ ''>
								<cfinput type="checkbox" name="doc_grade6_box" onClick="CheckDates('doc_grade6_box', 'doc_grade6')">
							<cfelse>
								<cfinput type="checkbox" name="doc_grade6_box" onClick="CheckDates('doc_grade6_box', 'doc_grade6')" checked="yes">		
							</cfif>						
							Grade 6 &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_grade6" size=8 value="#DateFormat(get_student_unqid.doc_grade6, 'mm/dd/yyyy')#">
					  </td>
					</tr>
					<tr>
						<td>
							</td>
						<td>
							<Cfif get_student_unqid.doc_grade7 EQ ''>
								<cfinput type="checkbox" name="doc_grade7_box" onClick="CheckDates('doc_grade7_box', 'doc_grade7')">
							<cfelse>
								<cfinput type="checkbox" name="doc_grade7_box" onClick="CheckDates('doc_grade7_box', 'doc_grade7')" checked="yes">		
							</cfif>						
							Grade 7 &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_grade7" size=8 value="#DateFormat(get_student_unqid.doc_grade7, 'mm/dd/yyyy')#">				</td>
					</tr>	
					<tr>
						<td>
							</td>
						<td>
							<Cfif get_student_unqid.doc_grade8 EQ ''>
								<cfinput type="checkbox" name="doc_grade8_box" onClick="CheckDates('doc_grade8_box', 'doc_grade8')">
							<cfelse>
								<cfinput type="checkbox" name="doc_grade8_box" onClick="CheckDates('doc_grade8_box', 'doc_grade8')" checked="yes">		
							</cfif>						
							Grade 8 &nbsp; &nbsp; Date: &nbsp; <cfinput type="text" name="doc_grade8" size=8 value="#DateFormat(get_student_unqid.doc_grade8, 'mm/dd/yyyy')#">					</td>
					</tr>	
				</table>
				<br>
				<table width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td align="center" valign="top">
							<cfinput type="image" name="submit" src="../pics/update.gif" border=0>
							&nbsp;&nbsp;
							<cfinput type="image" name="close" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
						</td>
					</tr>
				</table>			
			</cfform>
		</td>
	</tr>
</table><br>

</cfoutput>
	
</td></tr>
</table>
<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
---->
</body>
</html>