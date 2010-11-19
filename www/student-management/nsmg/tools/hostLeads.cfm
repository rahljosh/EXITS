<!--- ------------------------------------------------------------------------- ----
	
	File:		hostLeads.cfm
	Author:		Marcus Melo
	Date:		December 11, 2009
	Desc:		ISEUSA.com Host Family Leads

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

    <!--- Sort Feature --->
    <cfparam name="URL.sortBy" default="">
    <cfparam name="URL.sortOrder" default="DESC">

    <cfscript>		
		// Get Host Leads
		qGetHostLeads = APPCFC.HOST.getHostLeads(sortBy=URL.sortBy, sortOrder=URL.sortOrder);
	</cfscript>	
    
</cfsilent>    

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
    imageName="family.gif"
    tableTitle="ISEUSA.COM - Host Family Leads - Total of #qGetHostLeads.recordCount# records"
    tableRightTitle=""
/>

<table width=100% class="section" cellpadding="4" cellspacing="2">
    <tr align="left">
        <th>First Name</th>
        <th>Last Name</th>
        <th>Address</th>
        <th>Address2</th>
        <th>City</th>
        <th>State</th>
        <th>Zip</th>
        <th>Phone</th>
        <th>Email</th>
        <th>Hear About Us</th>
        <th>Rep/Other</th>
        <th>Date Created</th>
    </tr>
    <cfloop query="qGetHostLeads">
        <tr bgcolor="#iif(qGetHostLeads.currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
            <td>#qGetHostLeads.firstName#</td>
            <td>#qGetHostLeads.lastName#</td>
            <td>#qGetHostLeads.address#</td>
            <td>#qGetHostLeads.address2#</td>
            <td>#qGetHostLeads.city#</td>
            <td>#qGetHostLeads.state#</td>
            <td>#qGetHostLeads.zipCode#</td>
            <td>#qGetHostLeads.phone#</td>
            <td>#qGetHostLeads.email#</td>
            <td>#qGetHostLeads.hearAboutUs#</td>
            <td>#qGetHostLeads.hearAboutUsDetail#</td>
            <td>#DateFormat(qGetHostLeads.dateCreated, 'mm/dd/yy')# #TimeFormat(qGetHostLeads.dateCreated, 'hh:mm:ss tt')#</td>
        </tr>
    </cfloop>
</table>

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>