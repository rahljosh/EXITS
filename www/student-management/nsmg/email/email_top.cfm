<cfswitch expression="#CLIENT.companyID#">
	
    <cfcase value="1,2,3,4,12">
    	<cfset vCompanyColor='0054A0'>
    </cfcase>

    <cfcase value="10">
    	<cfset vCompanyColor='98012E'>
    </cfcase>

    <cfcase value="11">
    	<cfset vCompanyColor='00b3d9'>
    </cfcase>
    <cfcase value="13">
    	<cfset vCompanyColor='900f1c'>
    </cfcase>

    <cfdefaultcase>
    	<cfset vCompanyColor='0054A0'> 
    </cfdefaultcase>

</cfswitch>

<!--- Check if it is an email for MPD --->
<cfparam name="isMPDEmail" default="0">

<style type="text/css">
	<!--
	table,tr,td				{font-family:Arial, Helvetica, sans-serif;}
	.smlink         		{font-size: 10px;}
	.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #ffffff;}
	.sideborders			{border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6; background: #ffffff;}
	.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
	.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
	.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
	.sectionSubHead			{font-size:11px;font-weight:bold;}
	.thin-border			{border: 1px solid ##vCompanyColor#;}
	.thin-border-bottom		{border-bottom: 1px solid ##vCompanyColor#;}
	.wrapper 				{padding: 10px; width: 750px; margin-right: auto; margin-left: auto; border: medium solid #999; font-family: "Trebuchet MS", Arial, Helvetica, sans-serif; font-size: 12px; }
	.wrapper .grey 			{background-color: #EFEFEF; padding: 10px; }
	.id 					{width: 225px; margin-right: auto; margin-left: auto; padding: 0px; }
	-->
</style>

<cfoutput>

<div class="thin-border">
    <table background="#CLIENT.exits_url#/nsmg/pics/email_textured_background.png" width="90%">
        <tr>
        	<cfif NOT VAL(isMPDEmail)>
                <td width="94"><img src="#CLIENT.exits_url#/nsmg/pics/logos/#CLIENT.companyid#_header_logo.png"></td>
                <cfif ListFind("1,2,3,4,5,12", CLIENT.companyID)>
                    <td><strong><font size=+2>INTERNATIONAL <span color="#vCompanyColor#">STUDENT EXCHANGE</span></font></strong></td>
                <cfelse>
                    <td><strong><font size=+2>#CLIENT.companyname#</font></strong></td>
                </cfif>
           	<cfelse>
            	<td width="94"><img src="#CLIENT.exits_url#/nsmg/pics/logos/mpdtours.png"></td>
                <td><strong><font size=+2>MPD Tours</font></strong></td>
            </cfif>
        </tr>	
        <tr>
            <td colspan="2"><img src="#CLIENT.exits_url#/nsmg/pics/logos/#CLIENT.companyID#_px.png" height="12" width="100%"></td>
        </tr>
    </table>
    
    <table width="90%">
        <tr>
            <td>
</cfoutput>