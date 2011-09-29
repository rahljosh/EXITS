<link href="tours/trips.css" rel="stylesheet" type="text/css" />
<Cfif isDefined('form.resendEmail')>
<Cfquery name="tripDetails" datasource="mysql">
select *
from smg_tours
where tour_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.tour_id#"> 
</cfquery>
    <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/temp/permissionForm_#url.studentid#.pdf" overwrite="yes">
			<style type="text/css">
            <!--
        	<cfinclude template="../smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
            <cfinclude template="tripPermission.cfm">
        </cfdocument>
                 <cfdocument format="PDF" filename="C:/websites/student-management/nsmg/uploadedfiles/temp/paymentForm_#url.studentid#.pdf" overwrite="yes">
			<style type="text/css">
            <!--
        	<cfinclude template="../smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
            <cfinclude template="paymentForm.cfm">
        </cfdocument>
    <!----Email to Student---->    
    <cfsavecontent variable="stuEmailMessage">
        <cfoutput>			
        ****This email was resent per your request.***** 
    
    
          <p>Please return the MPD Payment Form and Permission Form by:<br />
            <ul>
            <li>email: info@mpdtoursamerica.com
            <li>fax:   +1 718 439 8565  
            <li>mail:  9101 Shore Road, ##203 - Brooklyn, NY 11209 </p>
        <p>Please visit ISE's website for additional questions. http://www.iseusa.com/trips/questions.cfm</p>
        <p>If you have any questions that are not answerd please don't hesitate to contact us at info@mpdtoursamerica.com. </p>
        <p>See you soon!</p>
        <p>MPD Tour America, Inc.<br />
        9101 Shore Road ##203- Brooklyn, NY 11209<Br />
        Email: Info@Mpdtoursamerica.com<br />
        TOLL FREE: 1-800-983-7780<br />
        Fax: 1-(718)-439-8565</p>
	    </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="cfc.email" method="send_mail">
        
        	<cfinvokeargument name="email_to" value="#form.resendEmail#"> 
		<!----
            <cfinvokeargument name="email_to" value="josh@pokytrails.com">  
			---->
            <cfinvokeargument name="email_cc" value="trips@iseusa.com">     
            <cfinvokeargument name="email_from" value="""Trip Support"" <trips@iseusa.com>">
            <cfinvokeargument name="email_subject" value="Your Trip Details">
            <cfinvokeargument name="email_message" value="#stuEmailMessage#">
            <cfinvokeargument name="email_file" value="C:/websites/student-management/nsmg/uploadedfiles/tours/#tripDetails.packetfile#">
            <cfinvokeargument name="email_file3" value="C:/websites/student-management/nsmg/uploadedfiles/temp/permissionForm_#url.studentid#.pdf">
            <cfinvokeargument name="email_file2" value="C:/websites/student-management/nsmg/uploadedfiles/temp/paymentForm_#url.studentid#.pdf">
            
      </cfinvoke>	
</Cfif>
<cfif isDefined('form.updateTrip')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set tripid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.newTour#">
    where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.updateTrip#">
    </cfquery>
</cfif>
<Cfif isDefined('form.delete')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set active = 0
    where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.delete#">
    </Cfquery>
    <Cflocation url="index.cfm?curdoc=tours/mpdtours">
</Cfif>
<Cfif isDefined('form.siblingRecord')>
	<cfquery datasource="#application.dsn#">
    update student_tours_siblings
    set paid = #CreateODBCDate(now())#
    where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.siblingRecord#">
    </Cfquery>
</Cfif>
<Cfif isDefined('form.siblingRemove')>
	<cfquery datasource="#application.dsn#">
    update student_tours_siblings
    set paid = null
    where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.siblingRemove#">
    </Cfquery>
</Cfif>
<Cfif isDefined('form.removeHold')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set hold = 0
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
    </Cfquery>
</Cfif>
<Cfif isDefined('FORM.recordPaid')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set paid = #now()#
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
    </Cfquery>
</Cfif>
<Cfif isDefined('FORM.recordNotPaid')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set paid = null
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
    </Cfquery>
</Cfif>
<Cfif isDefined('FORM.permissionReceived')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set permissionForm = #now()#
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
    </Cfquery>
</Cfif>
<Cfif isDefined('FORM.permissionNOTReceived')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set permissionForm = null
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
    </Cfquery>
</Cfif>
<Cfif isDefined('FORM.flightInfo')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set flightInfo = #now()#
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
    </Cfquery>
</Cfif>
<Cfif isDefined('FORM.noFlightInfo')>
	<cfquery datasource="#application.dsn#">
    update student_tours
    set flightINfo = null
    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
    </Cfquery>
</Cfif>
<cfquery name="tourInfo" datasource="#application.dsn#">
select t.id, s.studentid, s.firstname, s.familylastname, h.local_air_code, s.dob,s.sex, h.major_air_code, s.email as studentEmail, td.tour_name, td.tour_id, t.tripid, t.med, t.flightinfo, t.date, t.paid, t.permissionForm, t.stuNationality, t.id, t.person1, t.person2, t.person3, t.nationality, t.hold, t.holdReason, h.familylastname as hostLast, h.phone as hostPhone, h.email as hostEmail, h.city as hostCity, h.state as hostState
from student_tours t
left join smg_students s on s.studentid = t. studentid
left join smg_tours td on td.tour_id = t.tripId
left join smg_hosts h on h.hostid = s.hostid
where t.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
</cfquery>

<!----Get Siblings on tours---->
<cfquery name="sibs" datasource="#application.dsn#">
select sibs.siblingid, sibs.id, shc.name, shc.lastname, shc.birthdate, shc.sex, sibs.paid
from student_tours_siblings sibs
left join smg_host_children shc on shc.childid = sibs.siblingid
where fk_Studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
and tripid = <cfqueryparam cfsqltype="cf_sql_integer" value="#tourInfo.tripid#">
</cfquery>
<!----Get available Tours so tours can be changed if needed---->
<cfquery name="availTours" datasource="#application.dsn#">
select tour_id, tour_name
from smg_tours

</cfquery>


<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor="##ffffff">
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=30 background="pics/header_background.gif"><img src="pics/plane.png"></td>
        <td background="pics/header_background.gif"><h2>Student Details</h2> </td>
        <td background="pics/header_background.gif" align="right"></td>
    	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
        <tr>
            <td rowspan=5><img src="http://ise.exitsapplication.com/nsmg/uploadedfiles/web-students/#tourInfo.studentid#.jpg" height=150/><Br />
            <span class="greyText"><strong>DOB</strong></span> <span class="bigLabel">#DateFormat(tourInfo.dob, 'mm/dd/yyyy')#</span><Br />
            <span class="greyText"><strong>Sex</strong></span> <span class="bigLabel">#tourInfo.sex#</span>
            </td>
            <Td><span class="greyText">Name</span><br /><span class="bigLabel"> #tourInfo.firstname# #tourInfo.familylastname#</span></Td>
           <td rowspan=5 valign="top">
            	  <table cellpadding=4 cellspacing=0 border=0>
            	<Tr>
                    <td valign="top"><span class="greyText">Host Family </span><br /><span class="bigLabel"> #tourInfo.hostLast#
                    </td>
                </Tr>
                <Tr>
                    <td valign="top"><span class="greyText">Host Phone</span><br /><span class="bigLabel"> #tourInfo.hostPhone#</td>
                </Tr>
                
               <Tr>
                    <td valign="top"><span class="greyText">Host Email</span><br /><span class="bigLabel"> #tourInfo.hostEmail#</td>
                </Tr>
                <Tr>
                    <td valign="top"><span class="greyText">Host City & State</span><br /><span class="bigLabel"> #tourInfo.hostCity# #tourInfo.hostState#</td>
                </Tr>
            </table>
                	
               
            </td>
           <td rowspan=5 valign="top">
            <table cellpadding=4 cellspacing=0 border=0>
            	<Tr>
                    <td valign="top"><span class="greyText">#tourInfo.firstname# Nationality </span><br /><span class="bigLabel"> #tourInfo.stunationality#
                    </td>
                </Tr>
                <Tr>
                    <td valign="top"><span class="greyText">Roomate Nationality</span><br /><span class="bigLabel"> #tourInfo.nationality#</td>
                </Tr>
                
                <Tr>
                    <td valign="top"><span class="greyText">Roommate Requests</span><br /><span class="bigLabel">
                    <Cfif tourInfo.person1 is '' AND tourInfo.person2 is '' AND tourInfo.person3 is ''>
                    None
                    <cfelse>
                      <Cfif tourInfo.person1 is not ''>#tourInfo.person1#<br /></Cfif> 
                      <Cfif tourInfo.person2 is not ''>#tourInfo.person2#<br /></Cfif> 
                      <Cfif tourInfo.person3 is not ''>#tourInfo.person3#<br /></Cfif> 
                    </Cfif>
                    </td>
                </Tr>
            </table>
           <br><span class="greyText">Medical / Allergy Info</span><br /><span class="bigLabel"> #tourInfo.med#</span>
           
           </td>
        </tr>
    
        <tr>
            <Td valign="top"><span class="greyText">Tour</span><br /><span class="bigLabel">
            <form action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#" method="post">
            <input type="hidden" name="updateTrip" value="#tourInfo.id#"/>
            <select name="newTour">
            <Cfloop query="availTours">
            <option value="#tour_id#" <Cfif tourInfo.tripid eq #tour_id#>selected</cfif>>#tour_name#</option>
            </Cfloop>
            </select>
            
            <input type=submit value="Update Trip" />
            <cfif isDefined('form.updateTrip')>
            <br /><font color="##009900">Trip Updated</font>
            </cfif>
            </form>
           </td>
            
            </td>
        </tr>
        <tr>
            <Td valign="top"><span class="greyText">Registered</span><br /><span class="bigLabel">#DateFormat(tourInfo.date)#</span></td>
        </tr>
        <tr>
            <Td valign="top"><span class="greyText">Email</span><br /><span class="bigLabel">#tourInfo.studentEmail#</span></td>
        </tr>
		<tr>
            <Td valign="top"><span class="greyText">Prefered Airport / Alt. Airport</span><br /><span class="bigLabel">
            <cfif tourInfo.local_air_code is ''>none<cfelse>#tourInfo.local_air_code#</cfif> / <cfif tourInfo.major_air_code is ''>none<cfelse>#tourInfo.major_air_code#</cfif> </span></td>
        </tr>
    </table>
   
	<table border=0 cellpadding=4 cellspacing=0 class="section"  width=100%>
    	<Tr>
        	<td colspan=10> <hr width=75% align="center"></td>
        </Tr>
        <tr>
            <td>
            
            <table align="Center" width=50%>
            <Tr>
            	<Td><h2>Hold</h2></Td><td><h2>Payment</h2></td><Td><h2>Permission</h2></Td><Td><h2>Flights</h2></Td>
        	</tr>
            <Tr>
            	<Td>#dateFormat(tourInfo.hold, 'mm/dd/yyyy')#</Td>
                <td>#dateFormat(tourInfo.paid, 'mm/dd/yyyy')#</td>
                <td>#dateFormat(tourInfo.permissionForm, 'mm/dd/yyyy')#</td>
                <td>#dateFormat(tourInfo.flightInfo, 'mm/dd/yyyy')#</td>
            </Tr>
            <tr>
            <td>
                 
                 <Cfif tourInfo.hold neq 1>
                  <cfif client.usertype lte 4>
                   		<form method="post" action="index.cfm?curdoc=tours/hold&studentid=#url.studentid#&tour=#tourinfo.id#">
                   </cfif>
                      	<input name="" type="image" src="pics/buttons/putHold_25.png" />
                    	<input type="hidden" name="putHold" value="#url.studentid#" />
                     <cfif client.usertype lte 4>
                  		</form>
                   	</cfif>    
                    <cfelse>
                   
                    <cfif client.usertype lte 4>
                   		<form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                   </cfif>
                    	 <input type=image src="pics/buttons/removeHold_29.png" >
                         <input type="hidden" name="removeHold" value="#url.studentid#" />
                    <cfif client.usertype lte 4>
                  		</form>
                   	</cfif>
                    </Cfif>
                     
                    
                 </td>
                <Td>
                    <Cfif tourInfo.paid is ''>
                        <form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                       	 	<input type="hidden" name="recordPaid"> 
                         	<input type=image src="pics/buttons/Notreceived_21.png" >
                        </form>
                    <cfelse>
             
                        <form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                        	<input type="hidden" name="recordNOTPaid">
                         	<input type=image src="pics/buttons/received_17.png">
                        </form>
                     </Cfif>
                 </Td>
                 <td>
                 <Cfif tourInfo.permissionForm is ''>
                        <form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                        	<input type="hidden" name="permissionReceived">
                         	<input type=image src="pics/buttons/Notreceived_21.png" >
                        </form>
                    <cfelse>
                     
                        <form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                        	<input type="hidden" name="permissionNOTReceived">
                        	<input type=image src="pics/buttons/received_17.png" >
                        </form>
                     </Cfif>
                 </td>
                  <td>
                 <Cfif tourInfo.flightInfo is ''>
                        <form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                        	<input type="hidden" name="flightInfo">
                         	<input type=image src="pics/buttons/notbooked_35.png" >
                        </form>
                    <cfelse>
                     
                        <form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                        	<input type="hidden" name="noFlightInfo">
                        	<input type=image src="pics/buttons/booked_32.png" >
                        </form>
                     </Cfif>
                 </td>
                  
            </tr>
            <cfif tourInfo.hold eq 1>
            <tr>
            	<td><h2>Hold Reason</h2></td>
            </tr>
            <Tr>
            	<Td colspan=3>#tourInfo.holdReason#</Td>
            </Tr>
            </cfif>
            </table>
            <br /><Br />
            
        <cfif sibs.recordcount gt 0>
     	 <table align="Center" width=50%>
        	<tr>
            	<th colspan=4><h2>Siblings Going Along</h2></th>
            </tr>
            <tr>
            	<Td><u>Name</u></Td>
                <td><u>Age</u></td>
                <Td><u>Sex</u></Td>
                <td><u>Paid</u></td>
    		</tr>
             <Cfloop query="sibs">
                <tr>
                    <td>#name# #lastname#</td>
                    <Td>#DateDiff('yyyy', '#birthdate#', '#now()#')#</Td>
                    <Td>#sex#</Td>
                    <Td>#DateFormat(paid, 'mm/dd/yyyy')#</Td>
                    <Td>
					<cfif paid is ''>
                    	<form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                        	<input type=hidden name="siblingRecord" value="#sibs.id#" />
                            <input type="submit" value="Record Payment" />
                        </form>
                        
                    <cfelse>
                    
                    	
                    <form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                        	<input type=hidden name="siblingRemove" value="#sibs.id#" />
                            <input type="submit" value="Remove Payment" />
                        </form>
                    </cfif>
                    </Td>
                </tr>	
             </Cfloop>
           
            </table>
            </cfif>
            <Cfif client.usertype lte 4> 
                <br /><Br />
                <div align="center">
                <form method="post" action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#">
                <input type=hidden name="Delete" value="#tourInfo.id#" /> 
                <input type=hidden name="tripid" value="#tourInfo.tripid#">
               <input type="image" src="pics/delete.gif" />
                </form>
                </div>
            </Cfif>
           </td>
          </tr>
          <Tr>
             	<td colspan=4 align="Center">
                   Resend Forms to 
                <form action="index.cfm?curdoc=tours/profile&studentid=#url.studentid#" method="post">
                <input type="hidden" name="tour_id" value="#tourInfo.tour_id#">
                <input type="text" name="resendEmail" value="#tourInfo.studentEmail#"/> <input type="submit" value="Resend" />
                </form>
                </td>
             </Tr>
     </table>
  
     
     
</cfoutput>
<cfinclude template="../table_footer.cfm">