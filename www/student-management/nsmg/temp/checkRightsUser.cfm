<cfparam name="form.userid" default="">
<cfparam name="form.seasonid" default="">

<cfquery name="seasons" datasource="mysql">
select seasonid, season
from smg_seasons
where active = 1
</cfquery>
<form method="post" action="checkRightsUser.cfm">
UserID: <input type="text" name="userid"><br>
SeasonID: 
<cfoutput>
<select name="seasonid">
    <cfloop query="seasons">
          <option value="#seasonid#">#season#</option>
    </cfloop>
</select>
</cfoutput>
<input type="submit" value="submit">
</form>

<cfif val(form.userid) AND val(form.seasonid)>
	 <cfscript>	
            // Get Student by uniqueID
            allpaperworkCompleted = APPCFC.UDF.allpaperworkCompleted(userid=16678,seasonid=9);
     </cfscript>
     
     <cfdump var="#allpaperworkCompleted#">
 
 </cfif>
