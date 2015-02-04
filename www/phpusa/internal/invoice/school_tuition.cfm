<cfparam name="FORM.submitted" default="0">

<!--- Update submitted form --->
<cfif VAL(FORM.submitted)>
    <cfloop from="1" to="#FORM.count#" index="x">
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE php_schools
            SET 
                tuition_year = <cfif Evaluate("FORM." & x & "_tuition_year") EQ ''>NULL<cfelse>'#Evaluate("FORM." & x & "_tuition_year")#'</cfif>,
                tuition_semester = <cfif Evaluate("FORM." & x & "_tuition_semester") EQ ''>NULL<cfelse>'#Evaluate("FORM." & x & "_tuition_semester")#'</cfif>,	
                boarding_school = '#Evaluate("FORM." & x & "_boarding_school")#'
            WHERE schoolid = '#Evaluate("FORM." & x & "_schoolid")#'
            LIMIT 1
        </cfquery>
    </cfloop>

	<script type="text/javascript">
        alert("You have successfully updated this page. Thank You.");
        location.replace("?curdoc=invoice/school_tuition");
    </script>
</cfif>

<cfquery name="qGetSchools" datasource="#APPLICATION.DSN#">
	SELECT schoolid, schoolname, city, tuition_semester, tuition_year, boarding_school,
		smg_states.statename
	FROM php_schools
	LEFT JOIN smg_states ON smg_states.id = php_schools.state 
	ORDER BY schoolname
</cfquery>

<cfoutput>

	<br /><br />

	<form action="?curdoc=invoice/school_tuition" method="post" enctype="multipart/form-data">
		<input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="count" value="#qGetSchools.recordcount#" />

        <table width="90%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
            <tr><th colspan="2"> DMD SPONSORED PRIVATE HIGH SCHOOL PROGRAM </th></tr>
            <tr>
                <td width="100%" valign="top">
                    <table border="0" cellpadding="5" cellspacing="0" width="90%" align="center">
                        <tr bgcolor="##C2D1EF">
                            <td><b>School Name</b></td>
                            <td><b>Year Price</b></td>
                            <td><b>Sem. Price</b></td>
                            <td><b>Location</b></td>
                            <td><b>Day/Board</b></td>
                        </tr>
                        <cfloop query="qGetSchools">
                            <tr  bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                                <td>	
                                    #schoolname#
                                    <input type="hidden" name="#currentrow#_schoolid" value="#schoolid#">
                                </td>
                                <td><input type="text" name="#currentrow#_tuition_year" value="#tuition_year#" size="6"></td>
                                <td><input type="text" name="#currentrow#_tuition_semester" value="#tuition_semester#" size="6"></td>
                                <td>#city#, #statename#</td>
                                <td>
                                    <select name="#currentrow#_boarding_school">
                                        <option value="0" <cfif boarding_school EQ 0>selected</cfif> >Day</option>
                                        <option value="1" <cfif boarding_school EQ 1>selected</cfif> >Board</option>
                                        <option value="2" <cfif boarding_school EQ 2>selected</cfif> >Day/Board</option>
                                        <option value="3" <cfif boarding_school EQ 3>selected</cfif>></option>
                                    </select>
                                </td>
                            </tr>
                        </cfloop>
                        <tr bgcolor="##C2D1EF"><th colspan="5"><input type="image" name="next" value=" Update " src="pics/update.gif" align="middle" submitOnce></th></tr>
                    </table>
                </td>
            </tr>
        </table>

	</form>

	<br /><br />

</cfoutput>