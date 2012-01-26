<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Area Representative Agreement</title>
<STYLE type="text/css">
OL.letters { list-style-type: lower-alpha }
</STYLE>
</head>

<body>
<cfquery name="repInfo" datasource="#application.dsn#">
select firstname, lastname, address, address2, city, state, zip
from smg_users
where userid = #client.userid#
</cfquery>
<Cfquery name="companyInfo" datasource="#application.dsn#">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>
<Cfset years = '2011-2012'>
<Cfoutput>
<div align="center">

#companyInfo.companyname#<br />
AYP #years# SERVICES AGREEMENT
</div>



This SERVICES AGREEMENT is entered into the date below (the “Effective Date”) by and between #companyInfo.companyname# (#companyInfo.companyshort_nocolor#) a not-for-profit corporation located at #companyInfo.address#, #companyInfo.city#, #companyInfo.state# #companyInfo.zip# and
<strong><u>#repInfo.firstname# #repInfo.lastname#</u></strong>, an individual residing at
<strong><u>#repInfo.address# #repInfo.address2# #repInfo.city#, #repInfo.state#, #repInfo.zip#</u></strong> (the "Second Visit Area Representative").</p> 



<p>WHEREAS, #companyInfo.companyshort_nocolor# assists international foreign exchange students who wish to study in the United States with the 

process of coming to and staying in the U.S., including placing the students with U.S. host families;</p>

<p>WHEREAS, to further its objectives, #companyInfo.companyshort_nocolor# desires to engage the services of the Second Visit Area 

Representative to screen and review the host families home within the first or second month following the 

student’s placement in the home as required by the U.S. State Department; and </p>

<p>WHEREAS, #companyInfo.companyshort_nocolor# wishes to engage the Second Visit Area Representative as an independent contractor, but not an employee, 

agent, legal representative, partner or joint venture of #companyInfo.companyshort_nocolor#, and the Second VIsit Area Representative wishes to be so 

engaged pursuant to the terms and conditions of this Agreement. The Term of this Agreement shall 

commence on the Effective Date and shall cease on August 31, 2012, unless otherwise agreed in writing 

between the parties or unless earlier terminated. </p>

<strong>Services</strong><br /> 

<p>In connection with the conduct of #companyInfo.companyshort_nocolor#’s activities, the Second Visit Area Representative will perform the following services: 

screen and review placements in homes of high quality families for #companyInfo.companyshort_nocolor#-sponsored students for AYP #years#.

The Second Visit Area Representative acknowledges that the performance of the Services is subject to the regulations and 

guidelines of the U.S. State Department (“State Department”), All Services shall be performed to the highest 

professional standard and shall be performed to #companyInfo.companyshort_nocolor#’s reasonable satisfaction in accordance with State 

Department regulations. Failure to adhere to these standards may result in termination of this Agreement. </p>

<strong>Schedule of Payment </strong><br />

<p>Upon completion of the Host Family site visit and completion of the #companyInfo.companyshort_nocolor# confidential second visit form, a 

payment of $50 will be sent to the Second Visit Area Representative once paperwork is received and processed in 

the NY office. Payment form must be received within 30 days of visit.</p>

</Cfoutput>

</body>
</html>