<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requestTimeOut="9999">

	<!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">

	<!--- Param Form Variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intrep" default="0">
    <cfparam name="FORM.flightOption" default="">
    <cfparam name="FORM.send_email" default="0">
    <cfparam name="FORM.copy_user" default="0">
    
	<!--- Get Program --->
	<cfquery name="qGetProgram" datasource="MYSQL">
		SELECT DISTINCT 
        	p.programID, 
            p.programname 
		FROM 	
        	smg_programs p
		WHERE 
        	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
	</cfquery>

	<cfquery name="qGetCurrentUser" datasource="MySql">
		SELECT 
        	userID,
            email, 
            firstname, 
            lastname
		FROM 
        	smg_users
		WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
	</cfquery>
	
	<!--- Get Students  --->
	<cfquery name="qGetStudentList" datasource="MYSQL">
		SELECT	
            s.studentid, 
            s.firstname, 
            s.familylastname, 
            s.sex, 
            s.dateplaced, 
            s.dob,
            s.intRep,
            c.countryName,
            h.familylastname as hostfamily,
            p.programname,
            u.businessName
        FROM 
        	smg_students s
		INNER JOIN 
        	smg_users u ON s.intrep = u.userid
		INNER JOIN 
        	smg_programs p ON s.programID = p.programID AND p.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		LEFT JOIN 
        	smg_countrylist c ON s.countryresident = c.countryid

        <!--- Flight Option --->
        <cfswitch expression="#FORM.flightOption#">

            <cfcase value="receivedPreAYPArrival">
            	INNER JOIN	
                	smg_flight_info flight ON flight.studentID = s.studentID 
                    AND	
                        flight.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="preAypArrival">
					AND 
                    	flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	
					AND
                    	flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
            </cfcase>
        	
            <cfcase value="receivedArrival">
            	INNER JOIN	
                	smg_flight_info flight ON flight.studentID = s.studentID 
                    AND	
                        flight.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
					AND 
                    	flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	 
					AND
                    	flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
            </cfcase>

        	<cfcase value="receivedDeparture">
            	INNER JOIN	
                	smg_flight_info flight ON flight.studentID = s.studentID 
                    AND	
                        flight.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
					AND 
                    	flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	
					AND
                    	flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
            </cfcase>
			
		</cfswitch>        
        
        WHERE  
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">        
        AND 
            s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
		
        <cfif ListFind("missingPreAypArrival,receivedPreAypArrival",FORM.flightOption)>
        	AND
            	s.aypEnglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        </cfif>
        
		<cfif CLIENT.companyID EQ 5>
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        <cfelse>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
		
		<cfif VAL(FORM.intrep)>
            AND 
            	s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
        </cfif>
        
		<cfif form.place_date1 is not '' and form.place_date2 is not ''>
        	AND 
            	dateplaced 
            BETWEEN 
            	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(form.place_Date1)#">
	        AND
            	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(form.place_Date2)#">
        </cfif>

        <!--- Flight Option --->
        <cfswitch expression="#FORM.flightOption#">

        	<cfcase value="missingPreAypArrival">
                    AND NOT EXISTS	
                    (
                    	SELECT 
                        	flight.studentID
                        FROM
                        	smg_flight_info flight
                        WHERE
							flight.studentID = s.studentID	
                		AND
                        	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="preAypArrival">
                        AND 
                            flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	 
                        AND
                            flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
                	)
            </cfcase>

        	<cfcase value="missingArrival">
                    AND NOT EXISTS	
                    (
                    	SELECT 
                        	flight.studentID
                        FROM
                        	smg_flight_info flight
                        WHERE
							flight.studentID = s.studentID	
                		AND
                        	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
                        AND 
                            flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	
                        AND
                            flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
                	)
            </cfcase>

        	<cfcase value="missingDeparture">
                    AND NOT EXISTS	
                    (
                    	SELECT 
                        	flight.studentID
                        FROM
                        	smg_flight_info flight
                        WHERE
							flight.studentID = s.studentID	
						AND
                			flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
                        AND 
                            flight.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">	
                        AND
                            flight.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">	                                               
                	)
            </cfcase>
           
		</cfswitch>        
        
        GROUP BY
        	s.studentID
        
        ORDER BY 
        	u.businessname, 
            s.firstname, 
            s.familylastname
	</cfquery>  

</cfsilent>

<link rel="stylesheet" href="reports.css" type="text/css">	
    
<cfoutput>
	
    <!--- Report Header --->
	<table width="95%" cellpadding="6" cellspacing="0" align="center">
        <tr>
            <td align="center"><span class="application_section_header">#CLIENT.companyshort# -  Students per International Rep.</span></td>
        </tr>        
	</table>
    
    <br>
    
    <cfsavecontent variable="programHeader">
        <table width="95%" cellpadding="6" cellspacing="0" align="center" frame="box">
            <tr>
                <td align="center">
                    Program(s) Included in this Report:<br>
                    <cfloop query="qGetProgram">
                        <b>#programname# &nbsp; (###programID#)</b><br>
                    </cfloop>
                </td>
            </tr>
        </table>
        
        <br>
        
        <table width="95%" cellpadding="6" cellspacing="0" align="center" frame="box">	
            <tr>
                <th width="75%">International Representative</th> 
                <th width="25%">Total</th>
            </tr>
        </table>
        
        <br>
	</cfsavecontent>
    
    <!--- Display Program Header --->
    #programHeader#
    
</cfoutput>

<cfoutput query="qGetStudentList" group="intRep">
	
	<cfset groupCount = 0>
	    
	<cfsavecontent variable="studentList">
        <table width="95%" cellpadding="6" cellspacing="0" align="center" frame="below">
            <tr>
            	<td width="6%" align="center"><b>ID</b></td>
                <td width="20%"><b>Student</b></td>
                <td width="8%" align="center"><b>Sex</b></td>
                <td width="8%"><b>DOB</b></td>
                <td width="12%"><b>Country</b></td>
                <td width="12%"><b>Family</b></td>
                <td width="10%" align="center"><b>Program</b></td>
				<!--- Flight Option --->                    
                <cfif ListFind("receivedPreAYPArrival,missingPreAypArrival", FORM.flightOption)>
                    <td width="12%" align="center"><b>Pre-AYP Arrival Information</b></td>                            
				<cfelseif ListFind("receivedArrival,missingArrival", FORM.flightOption)>
                    <td width="12%" align="center"><b>Arrival Information</b></td>                            
                <cfelseif ListFind("receivedDeparture,missingDeparture", FORM.flightOption)>
                    <td width="12%" align="center"><b>Departure Information</b></td>                           
                </cfif>
                <td width="12%" align="center"><b>Placement Date</b></td>
            </tr>
			<!--- Loop over query --->    
            <cfoutput>  
            	<cfset groupCount = groupCount + 1>
                <tr bgcolor="#iif(groupCount MOD 2 ,DE("ededed") ,DE("white") )#">
                    <td align="center">###studentid#</td>
                    <td>#firstname# #familylastname#</td>
                    <td align="center">#sex#</td>
                    <td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
                    <td>#countryname#</td>
                    <td>#hostfamily#</td>
                    <td align="center">#programname#</td>
					<!--- Flight Option --->                    
					<cfif ListFind("receivedPreAYPArrival,receivedArrival,receivedDeparture", FORM.flightOption)>
                        <td align="center">Received</td>                            
                    <cfelseif ListFind("missingPreAypArrival,missingArrival,missingDeparture", FORM.flightOption)>
                        <td align="center"><font color="FF0000"><b>Missing</b></font></td>                            
                    </cfif>
                    <td align="center">#DateFormat(dateplaced, 'mm/dd/yyyy')#</td>
                </tr>
            </cfoutput>
        </table>
        
        <br>
    </cfsavecontent>

    <cfsavecontent variable="intlRepHeader">
        <table width="95%" cellpadding="6" cellspacing="0" align="center" frame="box">	
            <tr>
                <th width="75%">#businessname#</th>
                <td width="25%" align="center">#groupCount#</td>
            </tr>
        </table>
	</cfsavecontent>    
	
    <!--- Display Intl. Rep. Header --->
    #intlRepHeader#
    
    <!--- Display Student List --->
    #studentList#

	<!--- SEND EMAIL --->
	<cfif VAL(FORM.send_email)>

        <!--- Used in the <cfinclude template="email_intl_header.cfm"> --->
        <cfquery name="GetIntlReps" datasource="MySql">
            SELECT 
                userid,
                businessname, 
                email, 
                email2, 
                firstname, 
                lastname
            FROM 
                smg_users
            WHERE 
                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentList.intRep#">
        </cfquery>
		
		<cfif VAL(FORM.copy_user)>
			<cfset BCCAddress = qGetCurrentUser.email>			
		<cfelse>
			<cfset BCCAddress = GetIntlReps.email>
		</cfif>
        
        <!--- Check if we have a valid email address --->
        <cfif IsValid("email", GetIntlReps.email) AND isValid("email", BCCAddress)>
        
            <cfmail to="#GetIntlReps.email#"
                bcc="#BCCAddress#"
                SUBJECT="#CLIENT.companyshort# - Placement & Flight Information"
                FROM="""#CLIENT.companyshort# Support"" <#CLIENT.support_email#>"
                TYPE="HTML">
                <html>
                <head>
                    <style type="text/css">
                        table.nav_bar { font-size: 10px; background-color: ffffff; border: 1px solid 000000; }
                        .style3 {font-size: 13px}
                        .application_section_header{
							border-bottom: 1px dashed Gray;
							text-transform: uppercase;
							letter-spacing: 5px;
							width:100%;
							text-align:center;
							background;
							background: DCDCDC;
							font-size: small;
                        }
                    </style>
                </head>
                <body>
                
                    <cfinclude template="email_intl_header.cfm">
                    
                    <p>&nbsp; &nbsp; &nbsp; Dear #GetIntlReps.firstName# #GetIntlReps.lastName# &nbsp; - &nbsp; #GetIntlReps.businessname#,</p>
                    <p>&nbsp; &nbsp; &nbsp; Please find below a list of placed students. If you have not received a placement yet, please let me know ASAP.</p>
                    <cfif LEN(FORM.flightOption)>
                        <p>&nbsp; &nbsp; &nbsp; <b>Please also send all flight information that may be shown on the report below. You can submit Flight Information thru EXITS.</b></p>
                    </cfif>
                    <p>&nbsp; &nbsp; &nbsp; Also remember that you can log on to EXITS yourself and check all placement information at your convenience. 
                    	Please visit <a href="#CLIENT.site_url#">#CLIENT.site_url#</a> to login.
                    </p>
                    
                    <!--- Display Program Header --->
                    <!--- #programHeader# --->
        
                    <!--- Display Intl. Rep. Header --->
                    #intlRepHeader#
                    
                    <!--- Display Student List --->
                    #studentList#
                
                </body>
                </html>
            </cfmail>
            
            <!--- Display Message On Screen --->
            <p align="center" style="color:##3333CC;">
                Report emailed to #GetIntlReps.email# on #dateformat(now(), 'mm/dd/yyyy')# at #timeformat(now(), 'hh:mm:ss tt')#
            </p>
        
        <cfelse>
        
            <!--- Display Message On Screen --->
            <p align="center" style="color:##F00;">
                Report could not be emailed:
                <cfif NOT IsValid("email", GetIntlReps.email)>
	                Intl. Rep. email address is not valid: #GetIntlReps.email#
                <cfelseif NOT isValid("email", BCCAddress)>
                	User email addres is not valid: #BCCAddress#
                </cfif>
            </p>

        </cfif>
        
		<hr width="80%" align="center">
        
        <br>

    </cfif>	
	
</cfoutput>