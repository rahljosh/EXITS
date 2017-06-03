<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
  
	
    <cfsetting requesttimeout="9999">
    <Cfset defaultStartDate = '#DatePart('m',now())#/1/#DatePart('yyyy',now())#'>
    <cfset d=DaysInMonth(defaultStartDate)>
    <cfset defaultEndDate  = '#DatePart('m',now())#/#d#/#DatePart('yyyy',now())#'>

	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.programID" default=0;	
		param name="FORM.studentStatus" default="All";
		param name="FORM.outputType" default="excel";

		// Set Report Title To Keep Consistency
		vReportTitle = "Office Management - Host Lead Statistics";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>	

    
</cfsilent>



<cfparam name="initialPer" default="">
<cfparam name="interestPer" default="">
<cfparam name="commitedPer" default="">
<cfparam name="tinitialPer" default="">
<cfparam name="tinterestPer" default="">
<cfparam name="tcommitedPer" default="">
<cfparam name="form.Submitted" default="">

<!----Previous Defaults---->
<cfparam name="previousTotalNumberOfInitialLeads" default="">
<cfparam name="previousTotalnumberOfinterestedLeads" default="">
<cfparam name="previoustotalNotInterested" default="">
<cfparam name="previoustotalAddInfo" default="">
<cfparam name="previoustotalCallBack" default="">
<cfparam name="previousTotalnumberOfCommittedLeads" default="">
<cfparam name="previoustotalFuture" default="">
<cfparam name="previoustotalNotQualified" default="">
<!----Current Defaults---->
<cfparam name="TotalNumberOfInitialLeads" default="">
<cfparam name="TotalnumberOfinterestedLeads" default="">
<cfparam name="totalNotInterested" default="">
<cfparam name="totalAddInfo" default="">
<cfparam name="totalCallBack" default="">
<cfparam name="TotalnumberOfCommittedLeads" default="">
<cfparam name="totalFuture" default="">
<cfparam name="totalNotQualified" default="">

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=officeHostLeads" name="officeHostLeads" id="officeHostLeads" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Time Frame&dagger;: <span class="required"></span></td>
                    <td>
                       From: <input type="text" name="fromDate" id="placedDateFrom" value="#defaultStartDate#" size="7" maxlength="10" class="datePicker">
                       &nbsp;&nbsp;
                To: <input type="datefield" name="toDate" size=15 value="#defaultEndDate#" size="7" maxlength="10" class="datePicker">
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Region&Dagger;: <span class="required"></span></td>
                    <td>
                        <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                           
                            <cfloop query="qGetRegionList">
                            	<option value="#qGetRegionList.regionID#" selected>
                                	<cfif CLIENT.companyID EQ 5>#qGetRegionList.companyShort# -</cfif>
                                    #qGetRegionList.regionname#
                                </option>
                            </cfloop>
                        </select>
                    </td>		
                </tr>
                <!---
                <tr class="on">
                    <td class="subTitleRightNoBorder">Student Status: <span class="required">*</span></td>
                    <td>
                        <select name="studentStatus" id="studentStatus" class="xLargeField" required>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                            <option value="Canceled">Canceled</option>
                            <option value="All" selected="selected">All</option>
                        </select>
                    </td>		
                </tr>
				---->
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputType" class="xLargeField">
							<option value="onScreen">On Screen</option>
                            
                        </select>
                    </td>		
                </tr>
                 <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required</td>
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">&dagger; Defaults to Current Month</td>
                </tr><tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">&Dagger; Defaults to All Regions</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>This report generates the statistics on host leads for a specified time frame and region (optional).</td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"> </th>
                </tr>
            </table>
        </form>            

	</cfoutput>

<cfelse>    

<cfset daysDiff = #DateDiff('d','#form.fromDate#','#form.toDate#')#>
<cfset prevFromDate = #DateAdd('d','-#daysDiff#','#form.fromDate#')#>
<cfset prevToDate = #DateAdd('d','-#daysDiff#','#form.toDate#')#>


<cfset futFromDate = #DateAdd('d','#daysDiff#','#form.fromDate#')#>
<cfset futToDate = #DateAdd('d','#daysDiff#','#form.toDate#')#>

<!----Previous Time Frame---->
<cfquery name="prevLeads" datasource="#application.dsn#">
select *
from smg_host_lead
where dateCreated between 
<cfqueryparam cfsqltype="cf_sql_date" value="#prevFromDate#">
 AND <cfqueryparam cfsqltype="cf_sql_date" value="#prevToDate#"> 
and (
<cfloop list="#form.regionid#" index="i">
	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
    <cfif listLast(form.regionid) neq #i#> or </cfif>
    </cfloop>
)
</cfquery>
<!----Current Time Frame---->
<cfquery name="leads" datasource="#application.dsn#">
select *
from smg_host_lead
where dateCreated between 
<cfqueryparam cfsqltype="cf_sql_date" value="#form.FromDate#">
 AND <cfqueryparam cfsqltype="cf_sql_date" value="#form.ToDate#"> 
and (
<cfloop list="#form.regionid#" index="i">
	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
    <cfif listLast(form.regionid) neq #i#> or </cfif>
    </cfloop>
)
</cfquery>
<!----
<!----Future Time Frame---->
<cfquery name="futLeads" datasource="#application.dsn#">
select *
from smg_host_lead
where dateCreated between 
<cfqueryparam cfsqltype="cf_sql_date" value="#form.fromDate#">
 AND <cfqueryparam cfsqltype="cf_sql_date" value="#form.toDate#"> 

</cfquery>
---->
<!----Previous Time Frame---->

<!----Totals---->
<cfquery dbtype="query" datasource="prevLeads" name="prevTotalnumberOfInitialLeads">
select count(statusID) as initial 
from prevLeads
where statusid = 1
</cfquery>


<cfquery dbtype="query" datasource="prevLeads" name="prevTotalnumberOfinterestedLeads">
select count(statusID) as interested
from prevLeads
where statusid = 2
</cfquery>


<cfquery dbtype="query" datasource="prevLeads" name="prevtotalNotInterested">
select count(statusID) as notInterested
from prevLeads
where statusid = 3
</cfquery>


<cfquery dbtype="query" datasource="prevLeads" name="prevtotalAddInfo">
select count(statusID) as totalAddInfo
from prevLeads
where statusid = 4
</cfquery>


<cfquery dbtype="query" datasource="prevLeads" name="prevtotalCallBack">
select count(statusID) as totalCallBack
from prevLeads
where statusid = 6
</cfquery>



<cfquery dbtype="query" datasource="prevLeads" name="prevTotalnumberOfCommittedLeads">
select count(statusID) as committed
from prevLeads
where statusid = 8
</cfquery>


<cfquery dbtype="query" datasource="prevLeads" name="prevtotalFuture">
select count(statusID) as totalFuture 
from prevLeads
where statusid = 9
</cfquery>


<cfquery dbtype="query" datasource="prevLeads" name="prevtotalNotQualified">
select count(statusID) as totalNotQualified
from prevLeads
where statusid = 10
</cfquery>



<Cfif prevTotalnumberOfCommittedLeads.committed is ''>
	<Cfset prevtotalComLeads = 0>
  <cfelse>
  	<Cfset prevtotalComLeads = #prevTotalnumberOfCommittedLeads.committed#>
</cfif>
<Cfif prevTotalnumberOfInitialLeads.initial is ''>
	<Cfset prevtotalInitial = 0>
  <cfelse>
  	<Cfset prevtotalInitial = #prevTotalnumberOfInitialLeads.initial#>
</cfif>

<Cfif prevTotalnumberOfinterestedLeads.interested is ''>
	<Cfset prevtotalInterested = 0>
  <cfelse>
  	<Cfset prevtotalInterested = #prevTotalnumberOfinterestedLeads.interested#>
</cfif>

<Cfif prevTotalnumberOfCommittedLeads.committed is ''>
	<Cfset prevtotalComLeads = 0>
  <cfelse>
  	<Cfset prevtotalComLeads = #prevTotalnumberOfCommittedLeads.committed#>
</cfif>

<Cfif prevtotalFuture.totalFuture is ''>
	<Cfset prevtotalFutureCount = 0>
  <cfelse>
  	<Cfset prevtotalFutureCount = #prevtotalFuture.totalFuture#>
</cfif>

<Cfif prevtotalCallBack.totalCallBack is ''>
	<Cfset prevtotalCallBackCount = 0>
  <cfelse>
  	<Cfset prevtotalCallBackCount = #prevtotalCallBack.totalCallBack#>
</cfif>

<Cfif prevtotalAddInfo.totalAddInfo is ''>
	<Cfset prevtotalAddInfoCount = 0>
  <cfelse>
  	<Cfset prevtotalAddInfoCount = #prevtotalAddInfo.totalAddInfo#>
</cfif>

<Cfif prevtotalNotQualified.totalNotQualified is ''>
	<Cfset prevtotalNotQualifiedCount = 0>
  <cfelse>
  	<Cfset prevtotalNotQualifiedCount = #prevtotalNotQualified.totalNotQualified#>
</cfif>

<Cfif prevtotalNotInterested.notInterested is ''>
	<Cfset prevtotalnotInterestedCount = 0>
  <cfelse>
  	<Cfset prevtotalnotInterestedCount = #prevtotalNotInterested.notInterested#>
</cfif>



<Cfset prevtotalLeads = #prevtotalInitial# + #prevtotalnotInterestedCount# + 
#prevtotalComLeads# + #prevtotalFutureCount# + #prevtotalCallBackcount# + #prevtotalAddInfoCount# + #prevtotalNotQualifiedCount#>


<Cfset prevtotalLeadPer = #prevtotalLeads# / #prevleads.recordcount#>

<cfquery dbtype="query" datasource="prevleads" name="regions">
	select distinct regionID
    from leads 
</cfquery>

<cfset prevsentToRm = #prevleads.recordcount# - #prevtotalnotInterestedCount# - #prevtotalNotQualifiedCount#>
<Cfset prevnotQualNotInt =  #prevtotalnotInterestedCount# + #prevtotalNotQualifiedCount#>




<!----Current Time Frame---->
<!----Totals---->
<cfquery dbtype="query" datasource="leads" name="TotalnumberOfInitialLeads">
select count(statusID) as initial 
from leads
where statusid = 1
</cfquery>


<cfquery dbtype="query" datasource="leads" name="TotalnumberOfinterestedLeads">
select count(statusID) as interested
from leads
where statusid = 2
</cfquery>


<cfquery dbtype="query" datasource="leads" name="totalNotInterested">
select count(statusID) as notInterested
from leads
where statusid = 3
</cfquery>


<cfquery dbtype="query" datasource="leads" name="totalAddInfo">
select count(statusID) as totalAddInfo
from leads
where statusid = 4
</cfquery>


<cfquery dbtype="query" datasource="leads" name="totalCallBack">
select count(statusID) as totalCallBack
from leads
where statusid = 6
</cfquery>


<cfquery dbtype="query" datasource="leads" name="TotalnumberOfCommittedLeads">
select count(statusID) as committed
from leads
where statusid = 8
</cfquery>


<cfquery dbtype="query" datasource="leads" name="totalFuture">
select count(statusID) as totalFuture 
from leads
where statusid = 9
</cfquery>


<cfquery dbtype="query" datasource="leads" name="totalNotQualified">
select count(statusID) as totalNotQualified
from leads
where statusid = 10
</cfquery>



<Cfif TotalnumberOfInitialLeads.initial is ''>
	<Cfset totalInitial = 0>
  <cfelse>
  	<Cfset totalInitial = #TotalnumberOfInitialLeads.initial#>
</cfif>

<Cfif TotalnumberOfinterestedLeads.interested is ''>
	<Cfset totalInterested = 0>
  <cfelse>
  	<Cfset totalInterested = #TotalnumberOfinterestedLeads.interested#>
</cfif>

<Cfif TotalnumberOfCommittedLeads.committed is ''>
	<Cfset totalComLeads = 0>
  <cfelse>
  	<Cfset totalComLeads = #TotalnumberOfCommittedLeads.committed#>
</cfif>

<Cfif totalFuture.totalFuture is ''>
	<Cfset totalFutureCount = 0>
  <cfelse>
  	<Cfset totalFutureCount = #totalFuture.totalFuture#>
</cfif>

<Cfif totalCallBack.totalCallBack is ''>
	<Cfset totalCallBackCount = 0>
  <cfelse>
  	<Cfset totalCallBackCount = #totalCallBack.totalCallBack#>
</cfif>

<Cfif totalAddInfo.totalAddInfo is ''>
	<Cfset totalAddInfoCount = 0>
  <cfelse>
  	<Cfset totalAddInfoCount = #totalAddInfo.totalAddInfo#>
</cfif>

<Cfif totalNotQualified.totalNotQualified is ''>
	<Cfset totalNotQualifiedCount = 0>
  <cfelse>
  	<Cfset totalNotQualifiedCount = #totalNotQualified.totalNotQualified#>
</cfif>

<Cfif totalNotInterested.notInterested is ''>
	<Cfset totalnotInterestedCount = 0>
  <cfelse>
  	<Cfset totalnotInterestedCount = #totalNotInterested.notInterested#>
</cfif>


<cfif TotalnumberOfInitialLeads.initial is not ''>
	<cfset tinitialPer = #TotalnumberOfInitialLeads.initial#/#leads.recordcount# >
</cfif>
<cfif TotalnumberOfinterestedLeads.interested is not ''>
	<cfset tinterestPer = #TotalnumberOfinterestedLeads.interested#/#leads.recordcount# >
</cfif>
<cfif TotalnumberOfCommittedLeads.committed is not ''>
	<cfset tcommitedPer = #TotalnumberOfCommittedLeads.committed#/#leads.recordcount# >
</cfif>

<cfif totalFuture.totalFuture is not ''>
	<cfset ttotalFuture = #totalFuture.totalFuture#/#leads.recordcount# >
</cfif>
<cfif totalCallBack.totalCallBack is not ''>
	<cfset ttotalCallBack = #totalCallBack.totalCallBack#/#leads.recordcount# >
</cfif>
<cfif totalAddInfo.totalAddInfo is not ''>
	<cfset ttotalAddInfo = #totalAddInfo.totalAddInfo#/#leads.recordcount# >
</cfif>
<cfif totalNotQualified.totalNotQualified is not ''>
	<cfset ttotalNotQualiifed = #totalNotQualified.totalNotQualified#/#leads.recordcount# >
</cfif>
<Cfif TotalnumberOfCommittedLeads.committed is ''>
	<Cfset totalComLeads = 0><cfelse><Cfset totalComLeads = #TotalnumberOfCommittedLeads.committed#>
</cfif>


<Cfset totalLeads = 
#totalInitial# + 
#totalInterested# + 
#totalComLeads# + 
#totalFutureCount# + 
#totalCallBackCount# + 
#totalAddInfoCount# + 
#totalNotQualifiedCount#>
<cfif totalLeads eq 0>
	<cfset totalLeadPer = 0>
<Cfelse>
	<Cfset totalLeadPer = #totalLeads# / #leads.recordcount#>
</cfif>
<cfquery dbtype="query" datasource="futleads" name="regions">
	select distinct regionID
    from leads 
</cfquery>

<cfset sentToRm = #leads.recordcount# - #totalnotInterestedCount# - #totalNotQualifiedCount#>
<Cfset notQualNotInt =   #totalnotInterestedCount# + #totalNotQualifiedCount#>

<!----Previous Time Frame---->
<!----
<!----Future Time Frame---->
<!----Totals---->
<cfquery dbtype="query" datasource="futLeads" name="futTotalnumberOfInitialLeads">
select count(statusID) as initial 
from futLeads
where statusid = 1
</cfquery>
<cfquery dbtype="query" datasource="futLeads" name="futTotalnumberOfinterestedLeads">
select count(statusID) as interested
from futLeads
where statusid = 2
</cfquery>
<cfquery dbtype="query" datasource="futLeads" name="futtotalNotInterested">
select count(statusID) as notInterested
from futLeads
where statusid = 3
</cfquery>
<cfquery dbtype="query" datasource="futLeads" name="futtotalAddInfo">
select count(statusID) as totalAddInfo
from futLeads
where statusid = 4
</cfquery>
<cfquery dbtype="query" datasource="futLeads" name="futtotalCallBack">
select count(statusID) as totalCallBack
from futLeads
where statusid = 6
</cfquery>
<cfquery dbtype="query" datasource="futLeads" name="futTotalnumberOfCommittedLeads">
select count(statusID) as committed
from futLeads
where statusid = 8
</cfquery>
<cfquery dbtype="query" datasource="futLeads" name="futtotalFuture">
select count(statusID) as totalFuture 
from futLeads
where statusid = 9
</cfquery>
<cfquery dbtype="query" datasource="futLeads" name="futtotalNotQualified">
select count(statusID) as totalNotQualified
from futLeads
where statusid = 10
</cfquery>

<cfif futTotalnumberOfInitialLeads.initial is not ''>
	<cfset futtinitialPer = #futTotalnumberOfInitialLeads.initial#/#futleads.recordcount# >
</cfif>
<cfif futTotalnumberOfinterestedLeads.interested is not ''>
	<cfset futtinterestPer = #futTotalnumberOfinterestedLeads.interested#/#futleads.recordcount# >
</cfif>
<cfif futTotalnumberOfCommittedLeads.committed is not ''>
	<cfset futtcommitedPer = #futTotalnumberOfCommittedLeads.committed#/#futleads.recordcount# >
</cfif>

<cfif prevtotalFuture.totalFuture is not ''>
	<cfset futttotalFuture = #futtotalFuture.totalFuture#/#futleads.recordcount# >
</cfif>
<cfif futtotalCallBack.totalCallBack is not ''>
	<cfset futttotalCallBack = #futtotalCallBack.totalCallBack#/#futleads.recordcount# >
</cfif>
<cfif futtotalAddInfo.totalAddInfo is not ''>
	<cfset futttotalAddInfo = #futtotalAddInfo.totalAddInfo#/#futleads.recordcount# >
</cfif>
<cfif prevtotalNotQualified.totalNotQualified is not ''>
	<cfset futttotalNotQualiifed = #futtotalNotQualified.totalNotQualified#/#futleads.recordcount# >
</cfif>

<Cfif futTotalnumberOfCommittedLeads.committed is ''>
	<Cfset futtotalComLeads = 0>
  <cfelse>
  	<Cfset futtotalComLeads = #futTotalnumberOfCommittedLeads.committed#>
</cfif>

<Cfset futtotalLeads = #futTotalnumberOfInitialLeads.initial# + #futTotalnumberOfinterestedLeads.interested# + #futtotalComLeads# + #futtotalFuture.totalFuture# + #futtotalCallBack.totalCallBack# + #futtotalAddInfo.totalAddInfo# + #futtotalNotQualified.totalNotQualified#>

<Cfset futtotalLeadPer = #futtotalLeads# / #futleads.recordcount#>

<cfset futsentToRm = #futleads.recordcount# - #futtotalNotInterested.notInterested# - #futtotalNotQualified.totalNotQualified#>
<Cfset futnotQualNotInt =  #futtotalNotInterested.notInterested# + #futtotalNotQualified.totalNotQualified#>

---->

<Cfoutput>
<link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css">
 <div class="rdholder" style="width:100%;float:left;"> 
        <div class="rdtop"> 
        <span class="rdtitle">Overall Stats</span> 
        
      	
                            
                  
        
        </div> <!-- end top --> 
     <div class="rdbox">
      <table align="center" width=90%> 
        	<tr>
            	<th>Previous Time Frame<br>#DateFormat(prevFromDate, 'mm/dd/yyyy')# - #DateFormat(prevToDate, 'mm/dd/yyyy')# <br>Total Leads: #prevleads.recordcount#</th>
                <th>Current Time Frame<br>#DateFormat(form.fromDate, 'mm/dd/yyyy')# - #DateFormat(form.toDate,'mm/dd/yyyy')#<br> Total Leads: #leads.recordcount#</th>
                <!----<Th>Next Time Frame<br>#DateFormat(futFromDate, 'mm/dd/yyyy')# - #DateFormat(futToDate,'mm/dd/yyyy')#<br>Total Leads: #futleads.recordcount#</Th>---->
        	</tr>
              <td valign="top" align="center">
            Sent to RM: #prevsentToRm#" value="#val(prevsentToRm)#<br />
            Commited: #prevtotalComLeads#" value="#val(prevtotalComLeads)#<Br />
            Not Qual or Int: #notQualNotInt#" value="#val(notQualNotInt)#
                <cfchart
                     format="png" chartheight="180"
                     scalefrom="0"
                     scaleto="#prevleads.recordcount#" 
                     pieslicestyle="solid">
               
                             
                             <cfchartseries 
                                type="pie"
                                colorlist = "66bed0fc,66eae8e8,661b99da"
                                dataLabelStyle="value"
                                
                                paintStyle="raise"
                                
                                seriesColor="##bed0fc" 
                                seriesLabel="Leads this Month">
                          
                             
                             
                             
                  
                    <cfchartdata item="Sent to RM: #prevsentToRm#" value="#prevsentToRm#">
                    <cfchartdata item="Commited: #prevtotalComLeads#" value="#valprevtotalComLeads#">
                    <cfchartdata item="Not Qual or Int: #prevnotQualNotInt#" value="#prevnotQualNotInt#">
                </cfchartseries>
            </cfchart>

                </td>
                 <td valign="top" align="center">
                
                <cfchart
                     format="png" chartheight="240"
                     scalefrom="0"
                     scaleto="#leads.recordcount#"
                     pieslicestyle="sliced" xoffset="-.75" yoffset="-.2" show3d="yes">
                <cfchartseries
                             type="pie"
                             serieslabel="Leads this Month"
                             seriescolor="blue">
                   
                    <cfchartdata item="Sent to RM: #sentToRm#" value="#sentToRm#">
                    <cfchartdata item="Commited: #totalComLeads#" value="#totalComLeads#">
                     <cfchartdata item="Not Qual/int: #notQualNotInt#" value="#notQualNotInt#">
                </cfchartseries>
            </cfchart>

                </td>
                <!----
                   <td valign="top" align="center">
                   
                <cfchart
                     format="png" chartheight="180"
                     scalefrom="0"
                     scaleto="#futleads.recordcount#"
                     pieslicestyle="solid">
                <cfchartseries
                             type="pie"
                             serieslabel="Leads this Month"
                             seriescolor="##00FF33CC">
                    
                    <cfchartdata item="Sent to RM: #futsentToRm#" value="#futsentToRm#">
                    <cfchartdata item="Commited: #futtotalComLeads#" value="#futtotalComLeads#">
                    <cfchartdata item="Not Qual/int: #futnotQualNotInt#" value="#futnotQualNotInt#">
                    
                </cfchartseries>
            </cfchart>

                </td>
				---->
             </tr>
           </table>

	</div>
    	<div class="rdbottom"></div> <!-- end bottom --> 
</div>


 <div class="rdholder" style="width:100%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Current Time Frame Break Down</span> 
              
				
            	</div> <!-- end top --> 
             <div class="rdbox">
<table width=100% cellpadding=4 cellspacing=0>
	<Tr>
    	<th align="left">Region</th>
        <th align="left">Total ## of Leads</th>
        <!----<th align="left">Send to Manager</th>---->
        <th align="left">Interested</th>
        <th align="left">Interested in Future</th>
        <th align="left">Committed to Host</th>
        <th align="left">Need Call Back</th>
        <th align="left">Additional Info</th>
        <th align="left">Not Qualified</th>
        <th align="left"><h3>Total</h3></th>
    </Tr>
<cfloop query="regions">
<cfquery name="regionName" datasource="#application.dsn#">
select regionname
from smg_regions
where regionid = #regionid#
</cfquery>
<cfquery dbtype="query" datasource="leads" name="numberOfLeads">
select count(statusID) as leads 
from leads
where regionid = #regionid#
</cfquery>
<!---Sent to Manager---->
<cfquery dbtype="query" datasource="leads" name="numberOfInitialLeads">
select count(statusID) as initial 
from leads
where statusid = 1
and regionid = #regionid#
</cfquery>
<!----INterested---->
<cfquery dbtype="query" datasource="leads" name="numberOfinterestedLeads">
select count(statusID) as interested
from leads
where statusid = 2
and regionid = #regionid#
</cfquery>
<!----NEed additional Info---->
<cfquery dbtype="query" datasource="leads" name="additionalInfo">
select count(statusID) as additionalInfo
from leads
where statusid = 4
and regionid = #regionid#
</cfquery>
<!----call back---->
<cfquery dbtype="query" datasource="leads" name="callBack">
select count(statusID) as callback
from leads
where statusid = 6
and regionid = #regionid#
</cfquery>
<!----Commited to Hosting---->
<cfquery dbtype="query" datasource="leads" name="numberOfCommittedLeads">
select count(statusID) as committed
from leads
where statusid = 8
and regionid = #regionid#
</cfquery>
<!----Interested in Future---->
<cfquery dbtype="query" datasource="leads" name="future">
select count(statusID) as future
from leads
where statusid = 9
and regionid = #regionid#
</cfquery>
<!----Not Qualified---->
<cfquery dbtype="query" datasource="leads" name="notQualified">
select count(statusID) as notQualified
from leads
where statusid = 10
and regionid = #regionid#
</cfquery>
<!----
<cfset totalRegionDisplay = #notQualified.notQualified# + 
#future.future# + #numberOfCommittedLeads.committed# + #callBack.callBack# + #additionalInfo.additionalInfo# + #numberOfinterestedLeads.interested# + #numberOfInitialLeads.initial#>
<cfset totalRegPer = 0 <!----#totalRegionDisplay# / #numberOfLeads.recordcount#---->>
---->

<!---Percentages---->
<cfif numberOfInitialLeads.initial is not ''>
	<cfset initialPer = #numberOfInitialLeads.initial#/#numberofLeads.leads# >
</cfif>
<cfif numberOfinterestedLeads.interested is not ''>
	<cfset interestPer = #numberOfinterestedLeads.interested#/#numberofLeads.leads# >
</cfif>
<cfif numberOfCommittedLeads.committed is not ''>
	<cfset commitedPer = #numberOfCommittedLeads.committed#/#numberofLeads.leads# >
</cfif>

<cfif future.future is not ''>
	<cfset futurePer = #future.future#/#numberofLeads.leads# >
</cfif>
<cfif callback.callback is not ''>
	<cfset callBackPer = #callback.callback#/#numberofLeads.leads# >
</cfif>
<cfif additionalInfo.additionalInfo is not ''>
	<cfset additionalInfoPer = #additionalInfo.additionalInfo#/#numberofLeads.leads# >
</cfif>

<cfif notQualified.notQualified is not ''>
	<cfset notQualifiedPer = #notQualified.notQualified#/#numberofLeads.leads# >
</cfif>
	<tr <cfif currentrow mod 2>bgcolor=##efefef</cfif>>
    	<td><Cfif regionName.regionname is ''>No Region Assigned<cfelse>#regionName.regionname#</Cfif></td>
        <td class="results"><Cfif numberOfLeads.leads is ''>-<cfelse> #numberOfLeads.leads# </Cfif></td>
        <!----<td class="results"><Cfif numberOfInitialLeads.initial is ''>-<cfelse> #numberOfInitialLeads.initial# <span class="per">(#Round(initialPer * 100)#%)</span> </Cfif></td>---->
        <td class="results"><Cfif numberOfinterestedLeads.interested is ''>-<cfelse> #numberOfinterestedLeads.interested# <span class="per">(#Round(interestPer * 100)#%)</span></Cfif> </td>
        <td class="results"><Cfif future.future is ''>-<cfelse> #future.future# <span class="per">(#Round(futurePer * 100)#%)</span></Cfif> </td>
        <td class="results"><Cfif numberOfCommittedLeads.committed is ''>-<cfelse> #numberOfCommittedLeads.committed# <span class="per">(#Round(commitedPer * 100)#%)</span> </Cfif></td>
        <td class="results"><Cfif callBack.callBack is ''>-<cfelse> #callBack.callBack# <span class="per">(#Round(callBackPer * 100)#%)</span> </Cfif></td>
         <td class="results"><Cfif additionalInfo.additionalInfo is ''>-<cfelse> #additionalInfo.additionalInfo# <span class="per">(#Round(additionalInfoPer * 100)#%)</span></Cfif></td>
         <td class="results"><Cfif notQualified.notQualified is ''>-<cfelse> #notQualified.notQualified# <span class="per">(#Round(notQualifiedPer * 100)#%)</span></Cfif></td>
         <td class="results"><!----<cfif totalRegionDisplay is ''>-<cfelse>#totalRegionDisplay# <span class="per">(#Round(totalRegPer * 100)#%)</span></cfif>----></td>
    </tr>
</cfloop>

	<tr>
    	<Td><h3>Total</h3></Td>
        <td><h3>#leads.recordcount#</h3></td>
        <!----<td><h3>#TotalnumberOfInitialLeads.initial# <span class="per">
         
        	<cfif TotalnumberOfInitialLeads.initial gt 0>(#Round(tinitialPer * 100)#%)</cfif></span></h3></td>---->
        <td><h3>#TotalnumberOfinterestedLeads.interested# <span class="per">
        	<cfif TotalnumberOfinterestedLeads.interested gt 0> (#Round(tinterestPer * 100)#%)</cfif></h3></span></td>
        <td><h3>#totalfuture.totalfuture# <span class="per">
        	<cfif totalfuture.totalfuture gt 0> (#Round(ttotalFuture * 100)#%)</cfif></span></h3> </td>
        <td><h3>#TotalnumberOfCommittedLeads.committed# <span class="per">
			<cfif totalnumberofcommittedLeads.committed is not ''>(#Round(tcommitedPer * 100)#%)<cfelse>--</cfif></span></h3></td>
        <td><h3>#totalCallBack.totalCallBack# <span class="per">
        	<cfif totalCallBack.totalCallBack gt 0>(#Round(ttotalCallBack * 100)#%)</cfif></span></h3></td>
        <td><h3>#totalAddInfo.totalAddInfo# <span class="per">
        	<cfif totalAddInfo.totalAddInfo gt 0> (#Round(ttotalAddInfo * 100)#%)</cfif></span></h3></td>
        <td><h3>#totalNotQualified.totalNotQualified# <span class="per">
        	<cfif totalNotQualified.totalNotQualified gt 0> (#Round(ttotalNotQualiifed * 100)#%)</cfif></span></h3></td>
        <td><h3>#totalLeads# <span class="per">
        	<cfif totalLeads gt 0> (#Round(totalLeadPer * 100)#%)</cfif></span></h3></td>
    </tr>

</table>
    </div>
        <div class="rdbottom"></div> <!-- end bottom --> 
    </div>

</Cfoutput>
</cfif>

