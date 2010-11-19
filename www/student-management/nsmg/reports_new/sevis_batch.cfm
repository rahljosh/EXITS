<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
	<cfif trim(form.programid) EQ ''>
		<cfset errorMsg = "Please select one or more Programs.">
    <cfelse>
    	<cfset form.display = 1>
	</cfif>
	<cfif isDefined("errorMsg")>
        <script language="JavaScript">
            alert('<cfoutput>#errorMsg#</cfoutput>');
        </script>
    </cfif>
</cfif>

<style type="text/css">
<!--
.region {
	font-size: 13px;
	font-weight: bold;
	background-color: #eeeeee;
	line-height: 25px;
}
-->
</style>

<cfparam name="form.display" default="0">
<cfparam name="form.programid" default="">
<cfparam name="form.intrep" default="">

<!--- this table is to prevent 100% width. --->
<table align="center">
  <tr>
    <td>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>SEVIS Batch Report per International Rep.</h2></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=reports_new/sevis_batch" method="post">
<input name="display" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        <td>
            <cfquery name="get_programs" datasource="#application.dsn#">
                SELECT smg_programs.programid, smg_companies.companyshort, smg_programs.programname
                FROM smg_programs
                INNER JOIN smg_companies ON smg_programs.companyid = smg_companies.companyid
                WHERE smg_programs.active = 1
                <cfif client.companyid EQ 5>
                    AND smg_companies.website = 'SMG'
                <cfelse>
                    AND smg_programs.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                </cfif>
                ORDER BY smg_programs.companyid, smg_programs.startdate DESC, smg_programs.programname
            </cfquery>
            Program<br />
            <cfif client.companyid EQ 5>
                <cfselect name="programid" query="get_programs" group="companyshort" value="programid" display="programname" selected="#form.programid#" required="yes" message="Please select one or more Programs." multiple="yes" size="6" />
            <cfelse>
                <cfselect name="programid" query="get_programs" value="programid" display="programname" selected="#form.programid#" required="yes" message="Please select one or more Programs." multiple="yes" size="6" />
            </cfif>
        </td>
        <td>
            <cfquery name="get_intl_rep" datasource="#application.dsn#">
                SELECT DISTINCT smg_students.intrep, smg_users.businessname, smg_users.userid
                FROM smg_students 
                INNER JOIN smg_users ON smg_students.intrep = smg_users.userid 
                <cfif client.companyid NEQ 5>
                    AND smg_students.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                </cfif>
                ORDER BY smg_users.businessname
            </cfquery>
            Intl. Rep.<br />
			<cfselect name="intrep" query="get_intl_rep" value="intrep" display="businessname" selected="#form.intrep#" queryPosition="below">
				<option value="">All</option>
			</cfselect>
        </td>
    </tr>
</table>
</cfform>

<cfif form.display>

    <cfquery name="companyshort" datasource="#application.dsn#">
        select *
        from smg_companies
        where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfquery>
    <cfquery name="get_programs" datasource="#application.dsn#">
        SELECT programid, programname, startdate, enddate
        FROM smg_programs 
        WHERE programid IN (#form.programid#)
    </cfquery>
    
    <cfquery name="getResults" datasource="#application.dsn#">
        SELECT smg_students.studentid, smg_students.firstname, smg_students.familylastname, smg_students.sex,
			smg_students.sevis_batchid, smg_students.sevis_bulkid, smg_students.insurance, smg_students.sevis_fee_paid_date,
        	smg_students.intrep, smg_users.businessname, smg_users.accepts_sevis_fee, smg_users.insurance_policy_type,
        	smg_countrylist.countryname, smg_sevis.datecreated as sevisdate, smg_sevisfee.datecreated as feedate		
        FROM smg_students
        INNER JOIN smg_users ON smg_students.intrep = smg_users.userid
		INNER JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid
        LEFT JOIN smg_sevis ON smg_students.sevis_batchid = smg_sevis.batchid
        LEFT JOIN smg_sevisfee ON smg_students.sevis_bulkid = smg_sevisfee.bulkid
        WHERE smg_students.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND smg_students.active = 1
        AND smg_students.programid IN (#form.programid#)
        <cfif form.intrep NEQ ''>
        	AND smg_students.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#">
        </cfif>
	    <!--- include the intrep because we're grouping by that in the output, just in case two have the same businessname. --->
        ORDER BY smg_users.businessname, smg_students.intrep, smg_students.familylastname, smg_students.firstname
    </cfquery>

    <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
        <tr align="center">
            <td>
            <cfoutput><h1>#companyshort.companyshort# SEVIS Batch Report per International Rep.</h1></cfoutput>
			<cfoutput query="get_programs">
            	<b>Program: #programname# (#programid#)</b><br>
            </cfoutput>
            <cfoutput>Total Students: #numberFormat(getResults.recordCount)#</cfoutput>
            </td>
        </tr>
    </table>

	<cfif getResults.recordCount GT 0>
    
        <table width=100% class="section" cellspacing="0" cellpadding="4">
            <cfoutput query="getResults" group="intrep">
				<cfif currentRow NEQ 1>
                    <tr>
                        <td colspan=3 height="25">&nbsp;</td>
                    </tr>
                </cfif>
                <cfset rep_total = 0>
                <cfoutput>
	                <cfset rep_total = rep_total + 1>
                </cfoutput>
                <tr class="region" align="center">
                    <td colspan=5>International Rep: #businessname#</td>
                    <td colspan=4>Total Students: #numberFormat(rep_total)#</td>
                </tr>
                <tr align="left">
                    <th>ID</th>
                    <th>Student</th>
                    <th>Sex</th>
                    <th>Country</th>
                    <th>Batch ID</th>
                    <th>Batch Date</th>
                    <th>Bulk ID</th>
                    <th>Bulk Date</th>
                    <th>Insured On</th>
                </tr>
                <cfset mycurrentRow = 0>
                <cfoutput>
                    <cfset mycurrentRow = mycurrentRow + 1>
                    <tr bgcolor="#iif(mycurrentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                        <td>#studentid#</td>
                        <td>#firstname# #familylastname#</td>
                        <td>#sex#</td>
                        <td>#countryname#</td>
                        <td><cfif sevis_batchid EQ 0><font color="FF0000">not issued</font><cfelse>#sevis_batchid#</cfif></td>
                        <td><cfif sevisdate is ''><font color="FF0000">not issued</font><cfelse>#dateFormat(sevisdate, 'mm/dd/yyyy')#</cfif></td>
                        <td>
							<cfif accepts_sevis_fee is '0'>
                            	none
                            <cfelse>  
								<cfif sevis_bulkid is 0 and sevis_fee_paid_date is ''>
                                    <font color="FF0000">not issued</font>
                                <cfelse>
                                    #sevis_bulkid#
                                </cfif>  
                            </cfif>
                        </td>
                        <td>
							<cfif accepts_sevis_fee is '0'>
                                none
                            <cfelse>  
                                <cfif sevis_fee_paid_date is ''>
                                    <font color="FF0000">not issued</font>
                                <cfelse>
                                    #DateFormat(sevis_fee_paid_date, 'mm/dd/yyyy')#
                                </cfif>
                            </cfif>
                        </td>
                        <td>
							<cfif insurance_policy_type is 'none'>
                                none
                            <cfelse>
                                <cfif insurance is ''>
                                    <font color="FF0000">not issued</font>
                                <cfelse>
                                    #DateFormat(insurance, 'mm/dd/yyyy')#
                                </cfif>
                            </cfif>
                       </td>
                    </tr>
                </cfoutput>
            </cfoutput>
        </table>
               
	<cfelse>
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <tr>
                <th><br />No records matched your criteria.</th>
            </tr>
        </table>
    </cfif>

</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>
<!--- this table is to prevent 100% width. --->