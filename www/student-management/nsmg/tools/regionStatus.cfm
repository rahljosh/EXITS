<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Region Status</title>
</head>

<body>
<cfif isDefined('url.regionid')>

	<cfif url.isActive eq 1>
   
        <Cfquery datasource="#application.dsn#">
            insert into regionStateClosure (fk_regionID, fk_programid)
                                values(#url.regionid#, #url.programid#)
        </cfquery>
    
    <Cfelse>
        <Cfquery datasource="#application.dsn#">
    	delete from regionStateClosure where fk_regionid = #url.regionid# and fk_programid = #url.programid#
		</cfquery>
    </cfif>
</cfif>

<cfquery name="inActiveRegions" datasource="#application.dsn#">
select *
from regionStateClosure
where fk_programid = #url.programid#
</cfquery>
<cfquery name="westActive" dbtype="query">
select id
from inActiveRegions
where fk_regionID = 6
</cfquery>
<cfquery name="centralActive" dbtype="query">
select id
from inActiveRegions
where fk_regionID = 7
</cfquery>
<cfquery name="southActive" dbtype="query">
select id
from inActiveRegions
where fk_regionID = 8
</cfquery>
<cfquery name="eastActive" dbtype="query">
select id
from inActiveRegions
where fk_regionID = 9
</cfquery>
<Cfoutput>
      <table width=670 border=0 cellpadding=4 cellspacing=4 align="center">
                        <tr><td colspan="3" align="Center"><h2>Program: #url.program# <BR /> Season: #url.label#</h2></td></tr>
                        <tr>
                            <td valign="top"><Cfif westActive.recordcount eq 0><img src="../student_app/pics/west.jpg"><cfelse><img src="../student_app/pics/WestFade.jpg"></Cfif></td>
                            <td valign="top"><Cfif centralActive.recordcount eq 0><img src="../student_app/pics/central.jpg"><cfelse><img src="../student_app/pics/centralFade.jpg"></Cfif></td>
                        </tr>
                        <tr>
                        	<td align="center">
								<Cfif westActive.recordcount gt 0>
                                	<a href="regionStatus.cfm?regionid=6&isActive=0&programid=#url.programid#&label=#url.label#&program=#url.program#"><img src="../pics/Available.png" /></a>
                                <cfelse>
                                	<a href="regionStatus.cfm?regionid=6&isActive=1&programid=#url.programid#&label=#url.label#&program=#url.program#"><img src="../pics/unAvailable.png" />
                                </Cfif>
                            </td>
                            <td align="center">
								<Cfif centralActive.recordcount gt 0>
                                	<a href="regionStatus.cfm?regionid=7&isActive=0&programid=#url.programid#&label=#url.label#&program=#url.program#"><img src="../pics/Available.png" />
                                <cfelse>
                                	<a href="regionStatus.cfm?regionid=7&isActive=1&programid=#url.programid#&label=#url.label#&program=#url.program#"><img src="../pics/unAvailable.png" />
                                </Cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan=2 align="center"><hr width=80% /></td>
                        </tr>
                        <tr>
                            <td valign="top"><Cfif southActive.recordcount eq 0><img src="../student_app/pics/south.jpg"><cfelse><img src="../student_app/pics/southFade.jpg"></Cfif></td>
                            <td valign="top"><Cfif eastActive.recordcount eq 0><img src="../student_app/pics/east.jpg"><cfelse><img src="../student_app/pics/eastFade.jpg"></Cfif></td>
                           
                        </tr>
                        <tr>
                        	<td align="center">
								<Cfif southActive.recordcount gt 0>
                                	<a href="regionStatus.cfm?regionid=8&isActive=0&programid=#url.programid#&label=#url.label#&program=#url.program#"><img src="../pics/Available.png" />
                                <cfelse>
                                	<a href="regionStatus.cfm?regionid=8&isActive=1&programid=#url.programid#&label=#url.label#&program=#url.program#"><img src="../pics/unAvailable.png" />
                                </Cfif>
                            </td>
                            <td align="center">
								<Cfif eastActive.recordcount gt 0>
                                	<a href="regionStatus.cfm?regionid=9&isActive=0&programid=#url.programid#&label=#url.label#&program=#url.program#"><img src="../pics/Available.png" />
                                <cfelse>
                                	<a href="regionStatus.cfm?regionid=9&isActive=1&programid=#url.programid#&label=#url.label#&program=#url.program#"><img src="../pics/unAvailable.png" />
                                </Cfif>
                            </td>
                        </tr>
                    </table>
 </cfoutput>

</body>
</html>