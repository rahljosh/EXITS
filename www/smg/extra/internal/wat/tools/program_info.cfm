<!--- ------------------------------------------------------------------------- ----
	
	File:		program.cfm
	Author:		Marcus Melo
	Date:		December, 23 2009
	Desc:		Add/Edits a program

	Updated:  						

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param Variables --->
	<cftry>

		<cfparam name="programID" type="numeric" default="0">

        <cfcatch type="any">
        	<cfset programID = 0>
        </cfcatch>
    
    </cftry>

	<!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.programName" default="">
    <cfparam name="FORM.type" default="0">
    <cfparam name="FORM.startDate" default="">
    <cfparam name="FORM.endDate" default="">
    <cfparam name="FORM.extra_sponsor" default="CSB">

	<cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
	</cfscript>
    
	<!--- Query for Program --->
    <cfquery name="qGetProgram" datasource="MySql">
        SELECT 
        	p.programID, 
            p.programName, 
            p.type, 
            p.extra_sponsor,            
            p.startDate, 
            p.endDate, 
            p.insurance_startDate, 
            p.insurance_endDate, 
            p.companyID, 
            p.programfee, 
            p.active, 
            p.hold,
            t.programtype
        FROM 
        	smg_programs p
        LEFT JOIN 
        	smg_program_type t ON t.programtypeid = p.type
        WHERE 
        	p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">
        AND 
        	p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfquery>
	
    <!--- Query for Program Type --->
    <cfquery name="qProgramType" datasource="MySql">
        SELECT 
        	programTypeID,
            programType             
        FROM 
        	smg_program_type
    </cfquery>

	<!--- FORM has been submitted --->
	<cfif FORM.submitted>

		<cfscript>
            // Data Validation
            
            // ProgramName
            if ( NOT LEN(FORM.programName) ) {
                ArrayAppend(Errors.Messages, "Program Name is required.");			
            }
    
            // Type
            if ( NOT VAL(FORM.type) ) {
                ArrayAppend(Errors.Messages, "Program Type is required.");			
            }
            
            // Sponsor
            if ( NOT LEN(FORM.extra_sponsor) ) {
                ArrayAppend(Errors.Messages, "Sponsor is required.");			
            }
            
            // Start Date
            if ( NOT IsDate(FORM.startDate) ) {
                ArrayAppend(Errors.Messages, "Please enter a valid start date");
                FORM.startDate = '';
            }		
            
            // End Date
            if ( NOT IsDate(FORM.endDate) ) {
                ArrayAppend(Errors.Messages, "Please enter a valid end date");
                FORM.endDate = '';
            }				
        </cfscript>
    
        <!--- There are no errors --->
        <cfif NOT VAL(ArrayLen(Errors.Messages))>
    
            <!--- Insert --->
            <cfif NOT VAL(programID)>
        
                <cfquery name="qr_updateprogram" datasource="MySql">
                    INSERT INTO 
                        smg_programs 
                    (
                        companyid,
                        programname, 
                        type, 
                        extra_sponsor,
                        startdate, 
                        enddate                     
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.programName#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.type#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.extra_sponsor#">,
                        <cfif LEN(FORM.startDate)>  
                            <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.startDate)#">,
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">,                                
                        </cfif>
                        <cfif LEN(FORM.endDate)>  
                            <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.endDate)#">
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">                                
                        </cfif>
                    );
                </cfquery>        
        
                <!--- Locate to programs list --->
                <cflocation url="?curdoc=tools/programs">
        
            <!--- Update --->
            <cfelse>
    
                <cfquery datasource="MySql">
                    UPDATE 
                        smg_programs
                    SET 
                        programName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.programName#">,
                        type = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.type#">,
                        extra_sponsor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.extra_sponsor#">,
                        <cfif LEN(FORM.startDate)>  
                            startDate = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.startDate)#">,
                        <cfelse>
                            startDate = <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">,                                
                        </cfif>
                        <cfif LEN(FORM.endDate)>  
                            endDate = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.endDate)#">
                        <cfelse>
                            endDate = <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">                                
                        </cfif>
                    WHERE 
                        programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">
                </cfquery>
    
                <!--- Locate to programs list --->
                <cflocation url="?curdoc=tools/programs">
                    
            </cfif>
        
        </cfif> <!--- check for errors --->
        
    <cfelse>

        <cfscript>
			if (qGetProgram.recordCount) {
				// Set FORM variables
				FORM.programName = qGetProgram.ProgramName;
				FORM.type = qGetProgram.type;
				FORM.extra_sponsor = qGetProgram.extra_sponsor;
				FORM.startDate = qGetProgram.startDate;
				FORM.endDate = qGetProgram.endDate;
			}
		</cfscript>
    
    </cfif>

</cfsilent>

<!--- Header --->
<table width="95%" cellpadding="0" cellspacing="0" border="0" align="center" height="25" bgcolor="#E4E4E4">
	<tr bgcolor="#E4E4E4">
	  	<td width="85%" class="title1">Program Maintenence</td>
		<td width="15%" class="title1">&nbsp;</td>
	</tr>
</table>

<cfoutput>

<form name="form" id="form" method="post" action="index.cfm?curdoc=tools/program_info"><br>
	<input type="hidden" name="submitted" value="1" />
    <input type="hidden" name="programID" value="#programID#" />

	<!--- Display Errors --->
	<cfif VAL(ArrayLen(Errors.Messages))>
		<table width="95%" align="center" cellpadding="0" cellspacing="0">
        	<tr>
            	<td>
			        <font color="##FF0000">Please review the following items:</font> <br>
	
                    <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                        #Errors.Messages[i]# <br>        	
                    </cfloop>
				</td>
			</tr>
		</table> <br />                      
	</cfif>	
        
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="section">
        <tr>
            <td>
                <table width="100%" border="0" align="center">
                    <tr>
                        <td colspan="5" bgcolor="##4F8EA4">
                        	<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="##FFFFFF"> <b><cfif VAL(programID)>Edit<cfelse>Add</cfif> Program</b></font>
                        </td>
                    </tr>
                    <tr>
                        <td width="23%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Program Name</font></td>
                        <td width="77%"><input type="text" name="programName" value="#FORM.programName#" ></td>
                    </tr>
                    <tr>
                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Type</font></td>
                        <td>
                            <select name="type" id="select">
                                <option value="0"></option>
                                <cfloop query="qProgramType">
                                    <option value="#programtypeid#" <cfif FORM.type EQ qProgramType.programTypeID> selected="selected" </cfif> >#programtype#</option>
                                </cfloop>
                            </select>            
                        </td>
                    </tr>
                    <tr>
                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Sponsor</font></td>
                        <td>
                            <select name="extra_sponsor" id="select">
                                <option value=""></option>
                                <option value="CSB" <cfif FORM.extra_sponsor EQ 'CSB'> selected="selected" </cfif> > CSB </option>
                                <option value="INTO" <cfif FORM.extra_sponsor EQ 'INTO'> selected="selected" </cfif> > INTO </option>
                            </select>            
                        </td>
                    </tr>
                    <tr>
                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Start Date</font></td>
                        <td><input type="text" name="startDate" value="#DateFormat(FORM.startDate, 'mm/dd/yyyy')#" class="date-pick" maxlength="10"> <font size="2" face="Verdana, Arial, Helvetica, sans-serif"> (mm/dd/yyyy</font>)</td>
                    </tr>
                    <tr>
                        <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">End Date</font></td>
                        <td><input type="text" name="endDate" value="#DateFormat(FORM.endDate, 'mm/dd/yyyy')#" class="date-pick" maxlength="10"> <font size="2" face="Verdana, Arial, Helvetica, sans-serif">(mm/dd/yyyy</font>)</td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center"><input type="image" src="../pics/save.gif" name="button" value="Submit" alt="save" /></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
</form>

</cfoutput>