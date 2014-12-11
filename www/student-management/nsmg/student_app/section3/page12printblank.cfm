<cftry>

<cfif LEN(URL.curdoc) OR IsDefined('url.path')>
	<cfset path = "">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [12] - Clinical Evaluation</title>
	<style type="text/css">
	<!--
	body {
		margin-left: 0.3in;
		margin-top: 0.3in;
		margin-right: 0.3in;
		margin-bottom: 0.3in;
	}
	-->
	</style>	
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [12] - Clinical Evaluation</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section3/page12printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td align="center" colspan="7"><b>To Be Filled Out by Family Physician</b></td></tr>

	<tr><td colspan="7"><b>MEASUREMENTS AND OTHER FINDINGS</b></td></tr>
	
	<tr><td width="10">&nbsp;</td>
		<td width="80" align="right"><em>Height:</em> </td>
		<td width="130"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <em>inches</em><br><img src="#path#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>
		
		<td width="110" align="right"><em>Weight:</em></td>
		<td width="120"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <em>lbs</em><br><img src="#path#pics/line.gif" width="110" height="1" border="0" align="absmiddle"></td>

		<td width="90" align="right"><em>Build:</em></td>
		<td width="130"><br><img src="#path#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td align="right"><em>Color Hair:</em></td> 
		<td><br><img src="#path#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>

		<td align="right"><em>Color Eyes:</em> </td>
		<td><br><img src="#path#pics/line.gif" width="110" height="1" border="0" align="absmiddle"></td>
		
		<td colspan="2">&nbsp;</td>
	</tr>
</table><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr>
		<td width="48%" valign="top">
			<table border=1 cellpadding=2 cellspacing=0 width="100%">
				<tr><td width="180" align="center"><em>Check each item</em></td>
					<td width="70" align="center"><em>Normal</em></td>
					<td width="70" align="center"><em>Abnormal</em></td></tr>
				<tr><td>&nbsp; Head, Face, Neck, Scalp</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td></tr>
				<tr><td>&nbsp; Nose</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td></tr>
				<tr><td>&nbsp; Sinuses</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Mouth and Throat</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Ears - General (int. & ext.)</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Drums (perforated)</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Eyes</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Ophthalmoscopic</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Pupils</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Ocular Motility</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Lungs and Chest</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Heart</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Vascular System</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Abdomen and Viscera</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
			</table>	
		</td>
		<td width="4%">&nbsp;</td>
		<td width="48%" valign="top" align="left">
			<table border=1 cellpadding=2 cellspacing=0 width="100%">
				<tr><td width="180" align="center"><em>Check each item</em></td>
					<td width="70" align="center"><em>Normal</em></td>
					<td width="70" align="center"><em>Abnormal</em></td></tr>
				<tr><td>&nbsp; Anus and Rectum</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Endocrine System</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; G - U System</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Upper Extremities</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Feet</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Lower Extremities</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Spine, other Musculoskeletal</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Body Marks, Scars, Tatoos</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Skin, Lymphatics</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Neurologic</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Psychiatric</td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
				<tr><td>&nbsp; Pelvic (female only)<br> &nbsp;  &nbsp; check how done <br> &nbsp; &nbsp;
						<img src="#path#pics/RadioN.gif" width="13" height="13" border="0">  vaginal &nbsp;  
						<img src="#path#pics/RadioN.gif" width="13" height="13" border="0">  rectal <br><br></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td align="center"><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
			</table>	
		</td>
	</tr>	
</table><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="7"><b>BLOOD PRESSURE</b></td></tr>
	<tr><td width="10">&nbsp;</td>
		<td width="80" align="right"><em>Sitting:</em></td>
		<td width="130"><br><img src="#path#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>
		
		<td width="110" align="right"><em>Recumbent:</em></td>
		<td width="120" ><br><img src="#path#pics/line.gif" width="110" height="1" border="0" align="absmiddle"></td>
		
		<td width="90" align="right"><em>Standing:</em></td>
		<td width="130"><br><img src="#path#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td></tr>
	
	<tr><td colspan="7">&nbsp;</td></tr>
	
	<tr><td colspan="7"><b>PULSE</b> (arm at heart level)</td></tr>
	<tr><td>&nbsp;</td>
		<td align="right"><em>Sitting: </em></td>
		<td><br><img src="#path#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>
		
		<td align="right"><em>After Exercise:</em></td>
		<td><br><img src="#path#pics/line.gif" width="110" height="1" border="0" align="absmiddle"></td>

		<td align="right"><em>2 Minutes After:</em></td>
		<td><br><img src="#path#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td></tr>

	<tr><td>&nbsp;</td>
		<td align="right"><em>Recumbent: </em> </td>
		<td><br><img src="#path#pics/line.gif" width="120" height="1" border="0" align="absmiddle"></td>
		
		<td align="right"><em>After Standing 3 Minutes: </em></td>
		<td colspan="3"><br><img src="#path#pics/line.gif" width="110" height="1" border="0" align="absmiddle"></td></tr>
</table><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="5"><b>LABORATORY FINDINGS</b></td></tr>
	<tr><td width="40">&nbsp;</td>
		<td width="300"><em>Urinalysis (A.Specific Gravity):</em></td>	
		<td width="170"><em>Albumin: &nbsp;</em> <br><img src="#path#pics/line.gif" width="160" height="1" border="0" align="absmiddle"></td>
		<td width="160"><em>Sugar: &nbsp; </em>  <br><img src="#path#pics/line.gif" width="150" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Serology &nbsp;(Specify Test): &nbsp;</em> <br><img src="#path#pics/line.gif" width="290" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"><em>Blood Type & RH Factor: &nbsp;</em> <br><img src="#path#pics/line.gif" width="320" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Tuberculosis (Clearance must be within 6 months)</em></td>
		<td colspan="2"><em>BCG (TB Vaccine) Date: &nbsp; </em> <br><img src="#path#pics/line.gif" width="320" height="1" border="0" align="absmiddle"></td></tr>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Skin Test Date: &nbsp;</em> <br><img src="#path#pics/line.gif" width="290" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"><em>Result: &nbsp;</em>
						<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Positive
						<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Negative &nbsp;
						<br><img src="#path#pics/line.gif" width="320" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td>&nbsp;</td>
		<td><em>Chest X-Ray Date: &nbsp;</em><br><img src="#path#pics/line.gif" width="290" height="1" border="0" align="absmiddle"></td>
		<td colspan="2"><em>Result: &nbsp;</em>
						<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Positive
						<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Negative &nbsp;
						<br><img src="#path#pics/line.gif" width="320" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td>
		<td colspan="2"><small>(NB! if positive, chest x-ray information mandatory)</small></td></tr>
</table><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
<tr>
    	<td colspan="3">
        	Are you aware of any physical or psychological condition that the student may have that would impact their ability to travel to the United States to participate in a high school exchange program?
        </td>
    </tr>
   <tr><td colspan="3"><input type="checkbox"> No</td></tr>
    <tr><td colspan="3"></td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td colspan="3"><input type="checkbox"> Yes (please explain):</td></tr>
    <tr><td colspan="3"><img src="#path#pics/line.gif" width="540" height="1" border="0" align="absmiddle" style="margin-left:125px;"></td></tr>

	<tr><td width="315"><em>Physician's Name</em></td><td width="40">&nbsp;</td><td width="315"><em>Signature</em></td></tr>
	<tr>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr><td><em>Address</em></td><td width="40">&nbsp;</td><td width="315"><em>Date of Exam</em></td></tr>
	<tr>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr>
		<td colspan="3"><div align="justify">We certify that the information supplied is true and complete to the best or our knowledge. We authorize
		any of the doctors, hospitals, or clinics mentioned above to furnish a complete transcript of medical records for purposes of processing 
		this application.</div>
		</td>
	</tr>
	<tr>
		<td width="315"><em>Signature of Student</em></td>
		<td width="40">&nbsp;</td>
		<td width="315"><em>Date</em></td>
	</tr>
	<tr>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td><em>Signature of Parent</em></td>
		<td>&nbsp;</td>
		<td><em>Date</em></td>
	</tr>	
	<tr>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
		<td>&nbsp;</td>
		<td><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>	
</table><br>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</body>
</html>

</cftry>