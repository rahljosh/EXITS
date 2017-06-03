<!--- ------------------------------------------------------------------------- ----
	
	File:		_leadList.cfm
	Author:		James Griffiths
	Date:		July 5, 2012
	Desc:		Host Family Leads List
				
----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfscript>
		param name="FORM.dateFrom" default="";
		param name="FORM.dateTo" default="";
		param name="FORM.adwords" default="";
			
		// Get Report
		qGetHostLeads = APPLICATION.CFC.HOST.getHostLeadsList(
			dateFrom=FORM.dateFrom,
			dateTo=FORM.dateTo,
			isAdWords =FORM.adwords
		);
	</cfscript>

</cfsilent>

<cfoutput>
	
    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
    
    	<tr>
        	<th align="center" colspan="2">Host Lead List</th>
        </tr>
        
        <tr>
        	<th align="left">
            	<cfif isDate(FORM.dateFrom)>Submitted From: #DateFormat(FORM.dateFrom, 'mm/dd/yyyy')#<br /></cfif>
                <cfif isDate(FORM.dateTo)>Submitted To: #DateFormat(FORM.dateTo, 'mm/dd/yyyy')#<br /></cfif>
            </th>
            <th align="right">#qGetHostLeads.recordCount# Hosts</th>
        </tr>
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">     
            <tr>
                <td class="subTitleLeft" width="50%">Family Name</td>
                <td class="subTitleCenter" width="30%">Submitted On</td>
                <td class="subTitleCenter" width="20%">Google AdWords</td>
            </tr>
        
            <cfloop query="qGetHostLeads">
                <tr class="#iif(currentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>
                        <a href="hostLeads/index.cfm?action=detail&id=#ID#&key=#hashID#" class="jQueryModal">
                            #firstName# #lastName# (###ID#)
                        </a>
                    </td>
                    <td align="center">#DateFormat(dateUpdated, 'mm/dd/yyyy')#</td>
                    <td align="center">#YesNoFormat(isAdWords)#</td>
                </tr>
            </cfloop>
            
      	</table>
        
    </table>
    
</cfoutput>