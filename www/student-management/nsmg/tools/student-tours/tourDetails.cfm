<!--- ------------------------------------------------------------------------- ----
	
	File:		tourDetails.cfm
	Author:		Marcus Melo
	Date:		October 13, 2011
	Desc:		

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param Form Variables --->   
    <cfparam name="URL.tour_ID" default="0">
	
    <!--- Param Form Variables --->   
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.tour_ID" default="0">
    <cfparam name="FORM.tour_name" default="">
    <cfparam name="FORM.tour_date" default="">
    <cfparam name="FORM.tour_price" default="">
    <cfparam name="FORM.totalSpots" default="">
    <cfparam name="FORM.spotLimit" default="">
    <cfparam name="FORM.extraMaleSpot" default="0">
    <cfparam name="FORM.extraFemaleSpot" default="0">
    <cfparam name="FORM.tour_status" default="1">
    <cfparam name="FORM.packetFile" default="">
    <cfparam name="FORM.tour_flights" default="">
    <cfparam name="FORM.tour_description" default="">
    <cfparam name="FORM.tour_flightdetails" default="">
    <cfparam name="FORM.tour_payment" default="">
    <cfparam name="FORM.tour_include" default="">
    <cfparam name="FORM.tour_notinclude" default="">
    <cfparam name="FORM.tour_cancelfee" default="">

    <cfscript>
		if ( VAL(URL.tour_ID) ) {
			FORM.tour_ID = URL.tour_ID;
		}
	</cfscript>

    <cfquery name="qGetTripDetails" datasource="#APPLICATION.DSN#">
        SELECT 
            *
        FROM 
            smg_tours
        WHERE 
            tour_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tour_ID)#">
    </cfquery>

	<!--- Get Total Registrations --->
    <cfquery name="qGetTotalRegistered" datasource="#application.dsn#">
        SELECT 
            tour_ID,
            tour_name,
            totalSpots,
            SUM(total) AS total,
            SUM(totalMale) AS totalMale,
            SUM(totalFemale) AS totalFemale
        FROM
        (
        
            SELECT 
                t.tour_ID,
                t.tour_name,
                t.totalSpots,
                COUNT(st.studentID) AS total,
                COUNT(sMale.sex) AS totalMale,
                COUNT(sFemale.sex) AS totalFemale
            FROM 
                smg_tours t
            LEFT OUTER JOIN
                student_tours st ON st.tripID = t.tour_ID
                    AND
                        st.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    AND
                        st.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            LEFT OUTER JOIN	
                smg_students sMale ON sMale.studentID = st.studentID
                    AND
                        sMale.sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="male">
            LEFT OUTER JOIN	
                smg_students sFemale ON sFemale.studentID = st.studentID
                    AND
                        sFemale.sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="female">
            WHERE
                t.tour_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.tour_ID#">
                
            UNION
    
            SELECT 
                t.tour_ID,
                t.tour_name,
                t.totalSpots,
                COUNT(sts.siblingID) AS total,
                COUNT(hMale.sex) AS totalMale,
                COUNT(hFemale.sex) AS totalFemale
            FROM 
                smg_tours t
            INNER JOIN	
                student_tours_siblings sts ON sts.tripID = t.tour_ID
                    AND
                        sts.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            LEFT OUTER JOIN
                smg_host_children hMale ON hMale.childID = sts.siblingID
                    AND
                        hMale.sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="male">
                    AND
                        hMale.childID IN ( SELECT siblingID FROM student_tours_siblings WHERE paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes"> )
            LEFT OUTER JOIN
                smg_host_children hFemale ON hMale.childID = sts.siblingID
                    AND
                        hFemale.sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="female">
                    AND
                        hFemale.childID IN ( SELECT siblingID FROM student_tours_siblings WHERE paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes"> )
            WHERE
                t.tour_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.tour_ID#">
        
        ) AS deviredTable
        
        GROUP BY
        	tour_ID
        
        ORDER BY
        	tour_name
    </cfquery>

	<!--- FORM Submitted --->    
    <cfif FORM.submitted>
    
		<!--- Upload File --->
		<cfif LEN(FORM.packetFile)>
            
            <cffile action="upload" destination="#APPLICATION.PATH.tours#" filefield="FORM.packetFile" nameconflict="overwrite">
            
        </cfif>
        
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE 
            	smg_tours
            SET 
            	tour_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_name#">, 
                tour_date = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_date#">, 
                tour_price = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_price#">, 
                totalSpots = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.totalSpots)#">,
                spotLimit = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.spotLimit)#">, 
                extraMaleSpot = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.extraMaleSpot)#">,
                extraFemaleSpot = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.extraFemaleSpot)#">, 
                tour_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_description#">,
                tour_flights = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_flights#">, 
                tour_flightdetails = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_flightDetails#">, 
                tour_payment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_payment#">, 
                tour_include = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_include#">,
				<cfif LEN(FORM.packetFile)>
                	packetFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFFILE.serverfile#">,
                </cfif>
                tour_notinclude = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_notinclude#">, 
                tour_cancelfee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_cancelfee#">, 
                tour_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tour_status#">
             WHERE 
             	tour_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.tour_ID)#">
        </cfquery>    
        
        <cfscript>
			// Set Page Message
			SESSION.pageMessages.Add("Form successfully submitted.");
			
			Location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");
		</cfscript>
    
    <cfelse>
    
    	<cfscript>
			// DEFAULT FORM VARIABLES
			FORM.tour_name = qGetTripDetails.tour_name;
			FORM.tour_date = qGetTripDetails.tour_date;
			FORM.tour_price = qGetTripDetails.tour_price;
			FORM.totalSpots = qGetTripDetails.totalSpots;
			FORM.spotLimit = qGetTripDetails.spotLimit;
			FORM.extraMaleSpot = qGetTripDetails.extraMaleSpot;
			FORM.extraFemaleSpot = qGetTripDetails.extraFemaleSpot;
			FORM.tour_status = qGetTripDetails.tour_status;
			FORM.packetFile = qGetTripDetails.packetFile;
			FORM.tour_flights = qGetTripDetails.tour_flights;
			FORM.tour_description = qGetTripDetails.tour_description;
			FORM.tour_flightdetails = qGetTripDetails.tour_flightdetails;
			FORM.tour_payment = qGetTripDetails.tour_payment;
			FORM.tour_include = qGetTripDetails.tour_include;
			FORM.tour_notinclude = qGetTripDetails.tour_notinclude;
			FORM.tour_cancelfee = qGetTripDetails.tour_cancelfee;
		</cfscript>
    
    </cfif>
    
</cfsilent>    


<cfoutput>
    
	<!--- Table Header --->    
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="Student's Tours - Edit Tour"
    />

	<cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" enctype="multipart/form-data" preloader="no">
    	<input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="tour_ID" value="#FORM.tour_ID#" />

		<!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />

        <table width="100%" align="center" cellpadding="3" cellspacing="2" bgcolor="##ffffe6" class="section">
            <tr>
                <td width="25%" valign="top" align="right"><b>Name:</b></div></td>
                <td width="45%" valign="top"><cfinput type="text" value="#FORM.tour_name#" name="tour_name" class="xLargeField" required="yes" message="Please enter a Tour Name"></td>
                <td width="30%" valign="top" rowspan="14">
                	
                    <!--- Availability Information --->
                    <table border="0" cellpadding="4" cellspacing="0" width="100%" align="center" style="border:1px solid ##3b5998;">
                        <tr style="background-color:##3b5998; color:##FFF; font-weight:bold;">
                            <td align="center">Total Registrations</td>
                            <td align="center">Male</td>
                            <td align="center">Female</td>
                            <td align="center">Available Seats</td>
                        </tr>
                        <tr bgcolor="##ffffe6">
                            <td align="center" style="border-right:1px solid ##3b5998;">#qGetTotalRegistered.total#</td>
                            <td align="center" style="border-right:1px solid ##3b5998;">#qGetTotalRegistered.totalMale#</td>
                            <td align="center" style="border-right:1px solid ##3b5998;">#qGetTotalRegistered.totalFemale#</td>
                            <td align="center">#qGetTotalRegistered.totalSpots - qGetTotalRegistered.total#</td>
                        </tr>
                    </table>   
                
                </td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Date:</b></div></td>
                <td valign="top"><cfinput type="text" name="tour_date" value="#FORM.tour_date#" class="xLargeField" required="yes" message="Please enter a Tour Date"></td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Price:</b></div></td>
                <td valign="top">
                	<cfinput type="text" name="tour_price" message="Enter only numbers for the price.  Do not inlcude $" validate="integer" required="yes" value="#FORM.tour_price#" class="smallField"> 
            		DO NOT PUT $
                </td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Total of Seats:</b></div></td>
                <td valign="top"><input type="text" name="totalSpots" value="#FORM.totalSpots#" class="smallField"></td>          
            </tr>
            <tr>
                <td valign="top" align="right"><b>Set Seat Limit:</b></div></td>
                <td valign="top">
                	<input type="text" name="spotLimit" value="#FORM.spotLimit#" class="smallField"> 
                    Automatically blocks trip registrations when this limit is reached
                </td>          
            </tr>
            
            <tr>
                <td valign="top" align="right"><b>Extra Males Allowed:</b></div></td>
                <td valign="top">
                	<select name="extraMaleSpot" class="smallField">
                    	<cfloop from="0" to="5" index="i">
                        	<option value="#i#" <cfif FORM.extraMaleSpot EQ i> selected="selected" </cfif> >#i#</option>
                    	</cfloop>
                    </select>
                    Number of males allowed to register after limit has been reached
                </td>          
            </tr>
            <tr>
                <td valign="top" align="right"><b>Extra Females Allowed:</b></div></td>
                <td valign="top">
                	<select name="extraFemaleSpot" class="smallField">
                    	<cfloop from="0" to="5" index="i">
                        	<option value="#i#" <cfif FORM.extraFemaleSpot EQ i> selected="selected" </cfif> >#i#</option>
                    	</cfloop>
                    </select>
                    Number of females allowed to register after limit has been reached
                </td>          
            </tr>

            <tr>
                <td align="right"><b>Status:</b></td>
                <td>
                	<cfselect name="tour_status">
                        <option value="Active" <cfif FORM.tour_status EQ 'Active'>selected="selected"</cfif>>Active</option>
                        <option value="Inactive"<cfif FORM.tour_status EQ 'Inactive'>selected="selected"</cfif>>Inactive</option>
                        <option value="Cancelled"<cfif FORM.tour_status EQ 'Cancelled'>selected="selected"</cfif>>Cancelled</option>
                        <option value="Full"<cfif FORM.tour_status EQ 'Full'>selected="selected"</cfif>>Full</option>
                        <!---
                        <option value="Male Full"<cfif FORM.tour_status EQ 'Male Full'>selected="selected"</cfif>>Male Full</option>
                        <option value="Female Full"<cfif FORM.tour_status EQ 'Female Full'>selected="selected"</cfif>>Female Full</option>
						--->
                	</cfselect>
				</td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Welcome Packet:</b></div></td>
                <td valign="top">
                	<cfinput type="file" name="packetFile" class="xLargeField"> <br />
                    Current File:  <cfif NOT LEN(FORM.packetfile)><a href="uploadedfiles/tours/#FORM.packetfile#">#FORM.packetfile#</A><cfelse>None</cfif>
                </td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Flight Arrival Details: (for travel agent use)</b> <br />Please airport and  arrival/departure time window at final destination.</div></td>
                <td valign="top"><textarea name="tour_flightdetails" cols="70" rows="7">#FORM.tour_flightdetails#</textarea></td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Description:</b></td>
                <td valign="top"><textarea name="tour_description" cols="70" rows="7">#FORM.tour_description#</textarea></td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Flights:</b></td>
                <td valign="top"><textarea name="tour_flights" cols="70" rows="7">#FORM.tour_flights#</textarea></td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Payment:</b></td>
                <td valign="top"><textarea name="tour_payment" cols="70" rows="7">#FORM.tour_payment#</textarea></td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Include:</b></td>
                <td valign="top"><textarea name="tour_include" cols="70" rows="7">#FORM.tour_include#</textarea></td>
            </tr>
            <tr>
                <td valign="top" align="right"><b><u>NOT</u> Include:</b></td>
                <td valign="top"><textarea name="tour_notinclude" cols="70" rows="7">#FORM.tour_notinclude#</textarea></td>
            </tr>
            <tr>
                <td valign="top" align="right"><b>Cancelation Fee:</b></td>
                <td valign="top"><textarea name="tour_cancelfee" cols="70" rows="7">#FORM.tour_cancelfee#</textarea></td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2" align="center"><cfinput name="Submit" type="image" src="pics/update.gif" border="0"></td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
        </table>
	</cfform>

	<!--- Table Footer --->    
    <gui:tableFooter />

</cfoutput>