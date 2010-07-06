<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
<cfparam name="Fname" default="Not filled in the request form">
<cfparam name="Lname" default="Not filled in the request form">
<cfparam name="email" default="">
<cfparam name="State" default="Not filled in the request form">
<cfparam name="Dphone" default="Not filled in the request form">
<cfparam name="Nphone" default="Not filled in the request form">
<cfparam name="Comment" default="Not filled in the request form">
<cfparam name="country" default="Not filled in the request form">

<cfif url.request is 'student'>
<cfset desc = 'The following student requested information on being an exchange student'>
<cfelseif url.request is 'agent'>
<cfset desc= 'The following person requested information on becoming a Area Representative'>
<cfelseif url.request is 'host'>
<cfset desc='The following family requested information on hosting a student'>
<cfelse>
<cfset desc='Info submitted with no student/host/agent specifincation'>
</cfif>

 
<cfif url.request is 'student'>
<cfmail to='wayne@iseusa.com' cc='josh@pokytrails.com' from='ise@iseusa.com' subject='Request for Info'>
#desc# from the ISE web site on #dateformat(Now())#.

First Name: #form.fname#
Last Name: #form.lname#
E-Mail Address: #form.email#
Country: #form.country#
Day Phone: #form.dphone#
Evening Phone: #form.nphone#

Additional Comments: #form.comment#

--
</cfmail>
<Cfelse>
<cfmail to='wayne@iseusa.com' cc='josh@pokytrails.com' from='ise@iseusa.com' subject='Request for Info'>
#desc# from the ISE web site on #dateformat(Now())#.


First Name: #form.fname#
Last Name: #form.lname#
E-Mail Address: #form.email#
Address: #form.address#
City: #form.city#
State: #form.state#
Zip: #form.zip#
Day Phone: #form.dphone#
Evening Phone: #form.nphone#

Additional Comments: #form.comment#

--
</cfmail>
</cfif>
<cf_header>
<div class="page-title">Request Submitted&nbsp;</div>
<br>
The following information was submitted to ISE:
<cfoutput>
<table width=90% align="center">
	<tr>
		<td>
First Name: #form.fname#<br>
Last Name: #form.lname#<br>
E-Mail Address: #form.email#<br>
<cfif url.request is 'student'>
Country: #form.country#<br>
<cfelse>
Address: #form.address#<br>
City: #form.city#<br>
State: #form.state#<br>
</cfif>
Day Phone: #form.dphone#<Br>
Evening Phone: #form.nphone#<br><br>

Additional Comments: #form.comment#
		</td>
	</tr>
</table>
</cfoutput>
<br>
You will be contacted shortly.
<cf_footer>