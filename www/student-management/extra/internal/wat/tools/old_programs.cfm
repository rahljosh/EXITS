<style type="text/css">

body,td,th {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style1 {font-size: 10px}

</style>
<cfquery name="programstools" datasource="MySql">
	SELECT programid, programname, type, smg_program_type.programtype, startdate, enddate, insurance_startdate, insurance_enddate, smg_programs.companyid, smg_companies.companyname, programfee, smg_programs.active, smg_programs.hold
	FROM smg_programs
    INNER JOIN smg_companies ON smg_companies.companyid = smg_programs.companyid
    LEFT JOIN smg_program_type ON smg_program_type.programtypeid = smg_programs.type
    WHERE smg_programs.companyid = #client.companyid#
</cfquery>


<form method=post action="?curdoc=tools/new_program">

<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
	  <td width="85%" class="title1"> Program Maintenence</td>
		<td width="15%" class="title1"><!---<cfoutput>#programstools.active# </cfoutput>----></td>
	</tr>
</table><br />


<table width=95% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
  <tr>
		<td bgcolor="4F8EA4"><strong><font color="#FFFFFF">Status
        </div>        
        </strong></td>
		<td bgcolor="4F8EA4"><strong><font color="#FFFFFF">Program Name
        </div>
		</strong></td>
		<td bgcolor="4F8EA4"><strong><font color="#FFFFFF">Type
        </div>
		</strong></td>
		<td bgcolor="4F8EA4"><font color="#FFFFFF"><strong>Start Date
        </div>
		</strong></td>
		<td bgcolor="4F8EA4"><font color="#FFFFFF"><strong>End Date
        </div>
		</strong></td>
		<td bgcolor="4F8EA4"><strong><font color="#FFFFFF">Company
        </div>
		</strong></td>
	
	  <!--- <td><b>Fee's</b></td> --->
	</tr>
	<cfoutput query="programstools">
	<tr bgcolor="#iif(programstools.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#"> <!---  --->
		<Td>
		  
		    <cfif #enddate# lt #now()#>
		      <font color="red">expired
		      <cfelseif hold is 1>
		      <font color="##3300CC">hold
		      <cfelseif #enddate# gt #now()#>
		      <font color="green">active
	        </cfif>
	    </div></Td>
		<td><a href="?curdoc=tools/change_programs&programid=#programid#">#programname# </a></div></td>
		<td>
		  
		    <cfif programtype is ''>
		      <font face="Verdana, Arial, Helvetica, sans-serif" color="red">None Assigned
		      <cfelse>
		      #programtype# 
	        </cfif>
        </div></td>
		<td>
		  </span>
	   #DateFormat(startdate, 'mm-dd-yyyy')#</div></td>
		<td>
		  </span>
	   #DateFormat(enddate, 'mm-dd-yyyy')#</div></td>
		<td>
		  </span>
	   #companyname#</div></td>
		
		<!--- <td>#programfee# *</td> --->
	</tr>
	</cfoutput>
	<Tr>
		<td colspan=8 align="center"><a href="index.cfm?curdoc=tools/new_program" class="style1"><input name="Submit" type="image" src="../pics/add-program.gif" alt="Add Program" border=0></a></td>
	</Tr>
	<tr><td colspan=8></span></td>
	</tr>
</table>
</form>