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
	<title>Page [18] - Private School</title>
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

<cfquery name="private_schools" datasource="#APPLICATION.DSN#">
	SELECT privateschoolid, privateschoolprice, type
	FROM smg_private_schools
</cfquery>

<cfoutput>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [18] - Private School</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page18printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr>
		<td width="110"><em>Student's Name</em></td>
		<td width="560"><br><img src="#path#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br><br>
	
<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td colspan="2"><div align="justify">
		<p>While the majority of students attend local public (tuition-free) high schools, the exchange
		organization does have a selected number of private Catholic, Christian, and non-sectarian high schools available.  Occasionally the teen-agers 
		of a host family will attend a private school and they would like the exchange student living in their home to also 
		attend that school  We also have private schools that specifically request foreign exchange students.  A pre-requisite for all of these private schools is that the 
		exchange students be good students who are able to read, write and speak English at least at an intermediate level.  These are the same
		requirements as a regular J-1 student.  The only additional requirement for the J-1 Private High School program is that the student
		must have parents willing to pay the necessary tuition and fees.  <b>This makes it easier and quicker to place the exchange student.</b></p>
		<p> Tuition costs at these schools generally range
		from $3,000 to $8,000 a year depending on the schools. <b>These fees are in addition to the Program Fees</b> quoted to you by your International Representative.  if you would like your child to be considered for these schools, please indicate your preference below and
		indicate the amount of tuition you are willing to pay.  You have the option to refuse a placement if the costs exceed the original amount 
		requested below.</p>
		<p>Please note:  All J-1 rules apply including the need for communicative English skills.    Some private high schools may also charge additional
		fees for books, uniforms, sports activities, etc.  Again, these costs vary.</p>
</div></td></tr>
</table><br><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr>
		<td>
			<table>
				<tr></tr><td><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td><em>Do not consider my child for J-1 Private Schools</em></td></tr>
			</table>
		</td>
	</tr>
	<tr><td align="center"><br><h2>- OR -</h2><br></td></tr>
	<tr>
		<td>
			<table>
				<tr><td><img src="#path#pics/RadioN.gif" width="13" height="13" border="0"></td>
					<td><em>Consider my child for any school in the following tuition range: (select one)</em></td></tr>
				<tr><td></td><td>Tuition Range: (select one)</td></tr>
					<cfloop query="private_schools">
					<tr><td></td><td>_______ &nbsp; #privateschoolprice#</td></tr>
					</cfloop>
			</table>
		</td>

	</tr>
</table><br><br><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
		<td width="5"></td>
		<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>		
		<td width="40"></td>
		<td width="315"><br><img src="#path#pics/line.gif" width="315" height="1" border="0" align="absmiddle"></td>
	</tr>
	<tr>
		<td>Parent's Signature</td>
		<td></td>
		<td>Date</td>
		<td></td>
		<td>Student's Name (print clearly)</td>
	</tr>
</table><br><br>
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

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>