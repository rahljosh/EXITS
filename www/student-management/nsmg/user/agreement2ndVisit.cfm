<!--- ------------------------------------------------------------------------- ----
	
	File:		agreement2ndVisit.cfm
	Author:		Marcus Melo
	Date:		July 31, 2012
	Desc:		Agreement 2nd Visit Contract
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output ---> 
<cfsilent>

	<cfscript>
		// Get Company Information
		qGetCompanyInfo = APPLICATION.CFC.COMPANY.getCompanyByID(companyID=CLIENT.companyID);
	</cfscript>

</cfsilent>

<style type="text/css">
	ol.letters { list-style-type: lower-alpha }
</style>

<cfoutput>

<div align="center">
    #qGetCompanyInfo.companyname#<br />
    AYP #qGetSeason.years# SERVICES AGREEMENT
</div> <br />

<p>
	This SERVICES AGREEMENT is entered into the date below (the "Effective Date") by and between <strong>#qGetCompanyInfo.companyname# (#qGetCompanyInfo.companyshort_nocolor#)</strong> a not-for-profit 
    corporation located at #qGetCompanyInfo.address#, #qGetCompanyInfo.city#, #qGetCompanyInfo.state# #qGetCompanyInfo.zip# and
    <strong><u>#qGetUser.firstname# #qGetUser.lastname#</u></strong>, an individual residing at
    <strong><u>#qGetUser.address# #qGetUser.address2# #qGetUser.city#, #qGetUser.state#, #qGetUser.zip#</u></strong> (the "Second Visit Area Representative").
</p> 

<p>
	WHEREAS, #qGetCompanyInfo.companyshort_nocolor# assists international foreign exchange students who wish to study in the United States with the 
	process of coming to and staying in the U.S., including placing the students with U.S. host families;
</p>

<p>
	WHEREAS, to further its objectives, #qGetCompanyInfo.companyshort_nocolor# desires to engage the services of the Second Visit Area 
    Representative to screen and review the host families home within the first or second month following the 
    student's placement in the home as required by the U.S. State Department; and 
</p>

<p>
	WHEREAS, #qGetCompanyInfo.companyshort_nocolor# wishes to engage the Second Visit Area Representative as an independent contractor, but not an employee, 
    agent, legal representative, partner or joint venture of #qGetCompanyInfo.companyshort_nocolor#, and the Second VIsit Area Representative wishes to be so 
    engaged pursuant to the terms and conditions of this Agreement. The Term of this Agreement shall commence on the Effective Date and shall cease on  
    #DateFormat(qGetSeason.paperworkEndDate, 'mmmm d, yyyy')#, unless otherwise agreed in writing 
    between the parties or unless earlier terminated. 
</p>

<p>
	<strong>Services</strong><br />
	In connection with the conduct of #qGetCompanyInfo.companyshort_nocolor#'s activities, the Second Visit Area Representative will perform the following services: 
	screen and review placements in homes of high quality families for #qGetCompanyInfo.companyshort_nocolor#-sponsored students for AYP #qGetSeason.years#. <br /><br />
    
	The Second Visit Area Representative acknowledges that the performance of the Services is subject to the regulations and 
	guidelines of the U.S. State Department ("State Department"), All Services shall be performed to the highest 
	professional standard and shall be performed to #qGetCompanyInfo.companyshort_nocolor#'s reasonable satisfaction in accordance with State 	
	Department regulations. Failure to adhere to these standards may result in termination of this Agreement. 
</p>

<p>
	<strong>Schedule of Payment</strong><br />
	Upon completion of the Host Family site visit and completion of the #qGetCompanyInfo.companyshort_nocolor# confidential second visit form, a 
	payment of $50 will be sent to the Second Visit Area Representative once paperwork is received and processed in 
	the NY office. Payment form must be received within 30 days of visit.
</p>

</cfoutput>