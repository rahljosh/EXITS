
<cfset companycolor='0054A0'> 

<Cfquery name="company_info" datasource="#application.dsn#">
    select fax, toll_free, phone, company_color, companyName
    from smg_companies
    where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
</Cfquery>
 
<style type="text/css">
<!--
table,tr,td					{font-family:Arial, Helvetica, sans-serif;}
.smlink         		{font-size: 10px;}
.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #ffffff;}
.sideborders				{ border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6; background: #ffffff;}
.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionSubHead			{font-size:11px;font-weight:bold;}
.thin-border{ border: 4px solid ##000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
-->
</style>

<cfoutput>
<div class="thin-border">
<table width="600px" background="#APPLICATION.PATH.PHP.phpusa#pics/email_textured_background.png">
    <tr>
        <td>
            <img src="#APPLICATION.site_url#/images/#ATTRIBUTES.companyID#_short_profile_header.jpg" />
        </td>
    </tr>
     <tr>	
     	<td colspan="2"><img src="#APPLICATION.PATH.PHP.phpusa#pics/#client.companyid#_px.png" height=12 width=100%></td>
	</tr>
</table>                                                            

<Table width="600px">
	<Tr>
    	<td>
</cfoutput>