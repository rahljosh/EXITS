<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Region Status</title>
</head>

<body>
<cfparam name="form.selectedProgram" default="">
<cfscript>
	// Get Programs
	qGetActivePrograms= APPLICATION.CFC.program.getPrograms(isActive=1);
</cfscript>
<cfif isDefined('url.programid')>
	<cfset form.selectedProgram = #url.programid#>
</cfif>

<cfif isDefined('url.regionid')>

	<cfif url.isActive eq 1>
   
        <Cfquery datasource="#application.dsn#">
            insert into regionstateclosure (fk_regionID, fk_programid, fk_companyid)
                                values(#url.regionid#, #url.programid#, <cfif client.companyid lte 5 OR client.companyid eq 12>1<cfelse>10</cfif>)
        </cfquery>
    
    <Cfelse>
        <Cfquery datasource="#application.dsn#">
    	delete from regionstateclosure where fk_regionid = #url.regionid# and fk_programid = #url.programid#
		</cfquery>
    </cfif>
</cfif>
<!----If no program is selected, user needs to specify which program---->
	<cfif NOT VAL(form.selectedProgram)>
    
    
    
    <h1>Available Region Guarantees</h1>
    <em>Region guarantees differ between programs.  The status of any given region can change with out notice and availability of a regional gurantee is not ensured until your application is succesfully submitted</em>.  
    <Br /><br />
    <div align="center">
    Please select a program to view availability.
    <table>
        <Tr>
            <Td>
    <Cfoutput>
    <form method="post" action="regionStatus.cfm">
    <select name="selectedProgram" >
        <cfloop query="qGetActivePrograms">
            <option value="#programid#">#programname#</option>
        </cfloop>
    </option>
    </select>		
            </td>
            <Td>
            <input type="image" src="../pics/buttons/Next.png" />
            </Td>
          </tr>
       </table>
      </form>
    
    </cfoutput>
    </div>
    <cfabort>
    <Cfelse>

		<cfscript>
            // Get Program
            qCurrentProgram= APPLICATION.CFC.program.getPrograms(
                programID=#form.selectedProgram#
            );
        </cfscript>
</cfif>
<cfquery name="inActiveRegions" datasource="#application.dsn#">
select *
from regionstateclosure
where fk_programid = #qCurrentProgram.programid#
<cfif client.companyid lte 5 OR client.companyid eq 12>
and fk_companyid = 1
<cfelse>
and fk_companyid = #client.companyid#
</cfif>
</cfquery>
<cfquery name="westActive" dbtype="query">
select id
from inActiveRegions
where fk_regionID = 6
<cfif client.companyid lte 5 OR client.companyid eq 12>
and fk_companyid = 1
<cfelse>
and fk_companyid = #client.companyid#
</cfif>
</cfquery>
<cfquery name="centralActive" dbtype="query">
select id
from inActiveRegions
where fk_regionID = 7
<cfif client.companyid lte 5 OR client.companyid eq 12>
and fk_companyid = 1
<cfelse>
and fk_companyid = #client.companyid#
</cfif>
</cfquery>
<cfquery name="southActive" dbtype="query">
select id
from inActiveRegions
where fk_regionID = 8
<cfif client.companyid lte 5 OR client.companyid eq 12>
and fk_companyid = 1
<cfelse>
and fk_companyid = #client.companyid#
</cfif>
</cfquery>
<cfquery name="eastActive" dbtype="query">
select id
from inActiveRegions
where fk_regionID = 9
<cfif client.companyid lte 5 OR client.companyid eq 12>
and fk_companyid = 1
<cfelse>
and fk_companyid = #client.companyid#
</cfif>
</cfquery>
<Cfoutput>
      <table width=670 border=0 cellpadding=4 cellspacing=4 align="center">
                        <tr><td colspan="3" align="Center"><h2>Program: #qCurrentProgram.programname# <BR /> Season: #qCurrentProgram.seasonname#</h2>
                        <br /><a href="regionStatus.cfm">Choose a different program</a>
                        </td></tr>
                        <tr>
                            <td valign="top"><Cfif westActive.recordcount eq 0><img src="../student_app/pics/west.jpg"><cfelse><img src="../student_app/pics/WestFade.jpg"></Cfif></td>
                            <td valign="top"><Cfif centralActive.recordcount eq 0><img src="../student_app/pics/central.jpg"><cfelse><img src="../student_app/pics/centralFade.jpg"></Cfif></td>
                        </tr>
                        <tr>
                        	<td align="center">
                            <cfif client.usertype lte 4>
								<Cfif westActive.recordcount gt 0>
                                	<a href="regionStatus.cfm?regionid=6&isActive=0&programid=#qCurrentProgram.programid#&label=#qCurrentProgram.seasonname#&program=#qCurrentProgram.programname#"><img src="../pics/Available.png" /></a>
                                <cfelse>
                                	<a href="regionStatus.cfm?regionid=6&isActive=1&programid=#qCurrentProgram.programid#&label=#qCurrentProgram.seasonname#&program=#qCurrentProgram.programname#"><img src="../pics/unAvailable.png" />
                                </Cfif>
                             </cfif>
                            </td>
                            <td align="center">
                            <cfif client.usertype lte 4>
								<Cfif centralActive.recordcount gt 0>
                                	<a href="regionStatus.cfm?regionid=7&isActive=0&programid=#qCurrentProgram.programid#&label=#qCurrentProgram.seasonname#&program=#qCurrentProgram.programname#"><img src="../pics/Available.png" />
                                <cfelse>
                                	<a href="regionStatus.cfm?regionid=7&isActive=1&programid=#qCurrentProgram.programid#&label=#qCurrentProgram.seasonname#&program=#qCurrentProgram.programname#"><img src="../pics/unAvailable.png" />
                                </Cfif>
                             </cfif>
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
                            <cfif client.usertype lte 4>
								<Cfif southActive.recordcount gt 0>
                                	<a href="regionStatus.cfm?regionid=8&isActive=0&programid=#qCurrentProgram.programid#&label=#qCurrentProgram.seasonname#&program=#qCurrentProgram.programname#"><img src="../pics/Available.png" />
                                <cfelse>
                                	<a href="regionStatus.cfm?regionid=8&isActive=1&programid=#qCurrentProgram.programid#&label=#qCurrentProgram.seasonname#&program=#qCurrentProgram.programname#"><img src="../pics/unAvailable.png" />
                                </Cfif>
                            </cfif>
                            </td>
                            <td align="center">
                            <cfif client.usertype lte 4>
								<Cfif eastActive.recordcount gt 0>
                                	<a href="regionStatus.cfm?regionid=9&isActive=0&programid=#qCurrentProgram.programid#&label=#qCurrentProgram.seasonname#&program=#qCurrentProgram.programname#"><img src="../pics/Available.png" />
                                <cfelse>
                                	<a href="regionStatus.cfm?regionid=9&isActive=1&programid=#qCurrentProgram.programid#&label=#qCurrentProgram.seasonname#&program=#qCurrentProgram.programname#"><img src="../pics/unAvailable.png" />
                                </Cfif>
                            </cfif>
                            </td>
                        </tr>
                    </table>
 </cfoutput>

</body>
</html>