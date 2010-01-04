<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param URL Variables --->
	<cfparam name="URL.programID" default="0">

	<cfinclude template="../querys/get_company_short.cfm">

    <cfquery name="get_students" datasource="mysql">
        SELECT
        	c.candidateid, 
            c.firstname, 
            c.lastname, 
            c.dob, 
            c.citizen_country, 
            c.ds2019, 
            c.companyid, 
            c.hostcompanyid, 
            smg_countrylist.countryname, 
            extra_hostcompany.name, 
            c.home_address cadress, 
            extra_hostcompany.address, 
            smg_countrylist.countryname, 
            c.wat_participation, 
            extra_hostcompany.address as hostcompany_address, 
            extra_hostcompany.city as hostcompany_city, 
            extra_hostcompany.state, 
            extra_hostcompany.zip as hostcompany_zip, 
            smg_states.state as hostcompany_state, c.status
        FROM 
        	extra_candidates c
        INNER JOIN 
        	smg_programs ON smg_programs.programid = c.programid
        INNER JOIN 
        	smg_countrylist ON smg_countrylist.countryid = c.citizen_country
        LEFT JOIN 
        	extra_hostcompany ON extra_hostcompany.hostcompanyid = c.hostcompanyid
        LEFT JOIN 
        	smg_states ON smg_states.id = extra_hostcompany.state
        WHERE
        	c.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND 
        	c.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
        AND 
        	c.ds2019 != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND 
        	c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(url.program)#">
        ORDER BY 
        	c.ds2019
	</cfquery>

    <cfquery name="qGetProgram" datasource="MySQL">
        SELECT 
        	programID,
            programName,
            extra_sponsor
        FROM 
        	smg_programs
        WHERE
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(url.program)#">
    </cfquery>

	<cfscript>
		if ( LEN(qGetProgram.extra_sponsor) ) {
			// Set Sponsor
			setSponsor = qGetProgram.extra_sponsor;
		} else {
			// Default Sponsor
			setSponsor = CSB;	
		}
	</cfscript>

</cfsilent>


<cfdocument format="#url.format#" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
<style type="text/css">
	<!--
	.head1 { 
		font-family: Arial, Helvetica, sans-serif;
		font-size: 1; /* font-size 20; */
		padding:5 ;
		font-weight:300;	}
	.head2 { 
		font-family: Arial, Helvetica, sans-serif;
		font-size: 20;
		padding:5 ;
		font-weight:300;	}
	.head3 { 
		font-family: Arial, Helvetica, sans-serif;
		font-size: 16;
		padding:5 ;
		}
	.thin-border-bottom { border-bottom: 1px solid #000000; }
	.thin-border{ border: 1px solid #000000;}
	-->
</style>

<cfoutput>

    <table width=100% align="center" border=0 bgcolor="FFFFFF">
        <tr>
            <td valign="top">
                <img src="../../../../#APPLICATION[setSponsor].logo#" />
            </td>	
            <td align="center" valign="top"> 
                #APPLICATION[setSponsor].name# Summer Work Travel Program / #APPLICATION[setSponsor].programNumber# <br />
                Placement Report
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <p> Season #qGetProgram.programName# </p>
                
                <p> Total Number of Participants: #get_students.recordcount# </p> 
            </td>	
        </tr>		
    </table> <br />
					
    <table width=100% cellpadding="4" cellspacing=0>
        <tr bgcolor="##CCCCCC">
            <Th align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Student name</font></Th>
            <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Date of Birth</font></th>
            <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Citizenship</font></th>
            <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >DS2019</font></th>
            <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >No. Part. </font></th>
            <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Company</font></th>
            <th align="left" ><font size="1" face="Verdana, Arial, Helvetica, sans-serif" >Address </font></th>
        </tr>
        <cfloop query="get_students">
            <tr <cfif get_students.currentrow mod 2>bgcolor="##E4E4E4"</cfif> >
                <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#firstname# #lastname# (#candidateid#)</font></td>
                <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#DateFormat(dob, 'mm/dd/yyyy')#</font></td>
                <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#countryname#</font></td>
                <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#ds2019#</font></td>
                <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><cfif #wat_participation# eq ''>0<cfelse>#wat_participation#</cfif></font></td>
                <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">#name#</font></td>
                <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><cfif hostcompany_address NEQ ''>#hostcompany_address#, #hostcompany_city#, #hostcompany_state# - #hostcompany_zip# </cfif></font></td>															
            </tr>
        </cfloop>
    </table>
    
    <img src="../../pics/black_pixel.gif" width="100%" height="2">
    
    <Br><br>
    
    <font size=-1>Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</font>
</cfoutput>
</cfdocument>