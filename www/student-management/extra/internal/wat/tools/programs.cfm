<cfscript>
	// Get Program List
	qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
</cfscript>

<cfoutput>
    <table width=95% cellpadding="0" cellspacing="0" border="0" align="center" height="25" bgcolor="##E4E4E4">
        <tr bgcolor="E4E4E4">
            <td width="85%" class="title1"> Program Maintenence</td>
            <td width="15%">#qGetProgramList.recordCount# Programs Listed</td>
        </tr>
    </table><br />

    <table width=95% border="0" align="center" cellpadding=4 cellspacing="0" class="section">
        <tr bgcolor="##4F8EA4" style="color:##FFFFFF; font-weight:bold;">
            <td><span class="style2">ID</span></td>
            <td><span class="style2">Status</span></td>
            <td><span class="style2">Program Name</span></td>
            <td><span class="style2">Type</span></td>
            <td><span class="style2">Start Date</span></td>
            <td><span class="style2">End Date</span></td>
            <td><span class="style2">Company</span></td>
            <td><span class="style2">Sponsor</span></td>		  
        </tr>
        <cfloop query="qGetProgramList">
            <tr bgcolor="#iif(qGetProgramList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                <td><span class="style5">#qGetProgramList.programid#</span></td>
                <td>
                    <cfif qGetProgramList.hold EQ 1>
                        <span class="style5"><font color="##3300CC">hold</font></span>
					<cfelseif now() GT qGetProgramList.enddate>
                        <span class="style5"><font color="red">expired</font></span>
                    <cfelse>
                        <span class="style5"><font color="green">active</font> </span>
                    </cfif>
                </td>
                <td><span class="style5"><a href="?curdoc=tools/program_info&programID=#programid#">#qGetProgramList.programname#</a></span></td>
                <td>
					<cfif qGetProgramList.programtype is ''>
                        <span class="style5"><font color="red">None Assigned</font></span>
                    <cfelse>
                        <span class="style5">#qGetProgramList.programtype#</span>
                    </cfif>
                </td>
                <td><span class="style5">#DateFormat(qGetProgramList.startdate, 'mm-dd-yyyy')#</span></td>
                <td><span class="style5">#DateFormat(qGetProgramList.enddate, 'mm-dd-yyyy')#</span></td>
                <td><span class="style5">#qGetProgramList.companyname#</span></td>
                <td><span class="style5">#qGetProgramList.extra_sponsor#</span></td>
            </tr>
        </cfloop>
        <tr>
            <td colspan="8" align="center"><a href="index.cfm?curdoc=tools/program_info" class="style5"><img src="../pics/add-program.gif" alt="Add Program"></a></td>
        </tr>
    </table>

</cfoutput>
