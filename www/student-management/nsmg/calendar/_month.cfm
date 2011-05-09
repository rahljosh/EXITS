
<!--- Kill extra output. --->
<cfsilent>

	<!--- Param the URL attributes. --->
	<cftry>
		<cfparam
			name="REQUEST.Attributes.date"
			type="numeric"
			default="#REQUEST.DefaultDate#"
			/>
			
		<cfcatch>
			<cfset REQUEST.Attributes.date = REQUEST.DefaultDate />
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfparam
			name="URL.month"
			type="numeric"
			default="#Month( REQUEST.Attributes.date )#"
			/>
			
		<cfcatch>
			<cfset URL.month = Month( REQUEST.Attributes.date ) />
		</cfcatch>
	</cftry>
	
	
	<cftry>
		<cfparam
			name="URL.year"
			type="numeric"
			default="#Year( REQUEST.Attributes.date )#"
			/>
			
		<cfcatch>
			<cfset URL.year = Year( REQUEST.Attributes.date ) />
		</cfcatch>
	</cftry>

	
	<!---
		Based on the month and year, let's get the first 
		day of this month. In case the year or month are not
		valid, put this in a try / catch.
	--->
	<cftry>
		<cfset dtThisMonth = CreateDate( 
			URL.year, 
			URL.month, 
			1 
			) />
		
		<cfcatch>
		
			<!--- 
				If there was an error, just default the month 
				view to be the current month.
			--->
			<cfset dtThisMonth = CreateDate(
				Year( Now() ),
				Month( Now() ),
				1
				) />
				
		</cfcatch>
	</cftry>
	
	
	<!--- Get the next and previous months. --->
	<cfset dtPrevMonth = DateAdd( "m", -1, dtThisMonth ) />
	<cfset dtNextMonth = DateAdd( "m", 1, dtThisMonth ) />
	
	
	<!--- Get the last day of the month. --->
	<cfset dtLastDayOfMonth = (dtNextMonth - 1) />
	
	<!--- 
		Now that we have the first day of the month, let's get
		the first day of the calendar month - this is the first
		graphical day of the calendar page, which may be in the
		previous month (date-wise).
	--->
	<cfset dtFirstDay = (
		dtThisMonth - 
		DayOfWeek( dtThisMonth ) + 
		1
		) />
		
	<!--- 
		Get the last day of the calendar month. This is the last
		graphical day of the calendar page, which may be in the 
		next month (date-wise).
	--->
	<cfset dtLastDay = (
		dtLastDayOfMonth + 
		7 - 
		DayOfWeek( dtLastDayOfMonth )
		) />
		
	
	<!--- Get the events for this time span. --->
	<cfset objEvents = GetEvents(
		dtFirstDay,
		dtLastDay
		) />
		
		
	<!--- 
		Check to see if this month contains the default date. 
		If not, then set the default date to be this month.
	--->
	<cfif (
		(Year( dtThisMonth ) NEQ Year( REQUEST.DefaultDate )) OR
		(Month( dtThisMonth ) NEQ Month( REQUEST.DefaultDate ))				
		)>
	
		<!--- This we be used when building the navigation. --->
		<cfset REQUEST.DefaultDate = Fix( dtThisMonth ) />
		
	</cfif>
	
</cfsilent>

<cfinclude template="./includes/_header.cfm">

<cfoutput>
		
	<h2>
		#DateFormat( dtThisMonth, "mmmm yyyy" )# WebEx Calendar
	</h2>

	<p id="calendarcontrols">
		&laquo;
		<a href="#REQUEST.URLPath#&action=month&date=#Fix( dtPrevMonth )#">#DateFormat( dtPrevMonth, "mmmm yyyy" )#</a> &nbsp;|&nbsp;
		<a href="#REQUEST.URLPath#&action=month&date=#Fix( dtNextMonth )#">#DateFormat( dtNextMonth, "mmmm yyyy" )#</a>
		&raquo;
	</p>
	
	<form id="calendarform" action="index.cfm" method="get">

    	<input type="hidden" name="curdoc" value="#REQUEST.Curdoc#" />

		<input type="hidden" name="action" value="month" />
	
		<select name="month">
			<cfloop 
				index="intMonth" 
				from="1" 
				to="12"
				step="1">
				
				<option value="#intMonth#"
					<cfif (Month( dtThisMonth ) EQ intMonth)>selected="true"</cfif>
					>#MonthAsString( intMonth )#</option>
					
			</cfloop>
		</select>
		
		<select name="year">
			<cfloop 
				index="intYear" 
				from="#(Year( dtThisMonth ) - 5)#" 
				to="#(Year( dtThisMonth ) + 5)#"
				step="1">
				
				<option value="#intYear#"
					<cfif (Year( dtThisMonth ) EQ intYear)>selected="true"</cfif>
					>#intYear#</option>
					
			</cfloop>		
		</select>
		
		<input type="submit" value="Go" />
		
	</form>
	
	<table id="calendar" width="100%" cellspacing="1" cellpadding="0" border="0">
	<colgroup>
		<col />
		<col width="10%" />
		<col width="16%" />
		<col width="16%" />
		<col width="16%" />
		<col width="16%" />
		<col width="16%" />
		<col width="10%" />
	</colgroup>
	<tr class="header">
		<td>
			<br />
		</td>
		<td>
			Sunday
		</td>
		<td>
			Monday
		</td>
		<td>
			Tuesday
		</td>
		<td>
			Wednesday
		</td>
		<td>
			Thursday
		</td>
		<td>
			Friday
		</td>
		<td>
			Saturday
		</td>
	</tr>
	
	<!--- Loop over all the days. --->
	<cfloop 
		index="dtDay"
		from="#dtFirstDay#"
		to="#dtLastDay#"
		step="1">
	
		<!--- 
			If we are on the first day of the week, then 
			start the current table fow.
		--->
		<cfif ((DayOfWeek( dtDay ) MOD 7) EQ 1)>
			<tr class="days">
				<td class="header">
					<a href="#REQUEST.URLPath#&action=week&date=#dtDay#">&raquo;</a>
				</td>
		</cfif>
		
		<td 
			<cfif (
				(Month( dtDay ) NEQ Month( dtThisMonth )) OR
				(Year( dtDay ) NEQ Year( dtThisMonth ))
				)>
				class="other"
			<cfelseif (dtDay EQ Fix( Now() ))>
				class="today"
			</cfif>
			>
			
            <a 
                <!--- Only Gary Lubrat or Global Administrator are allowed to input events --->
                <cfif ListFind(REQUEST.AllowedIDs, CLIENT.userID) OR CLIENT.userType EQ 1>
                    href="#REQUEST.URLPath#&action=edit&viewas=#dtDay#" 
                </cfif>
                title="#DateFormat( dtDay, "mmmm d, yyyy" )#" 
                class="daynumber<cfif (Day( dtDay ) EQ 1)>full</cfif>"
                ><cfif (Day( dtDay ) EQ 1)>#MonthAsString( Month( dtDay ) )#&nbsp;</cfif>#Day( dtDay )#</a>
            							
			<!--- 
				Since query of queries are expensive, we 
				only want to get events on days that we 
				KNOW have events. Check to see if there 
				are any events on this day. 
			--->
			<cfif StructKeyExists( objEvents.Index, dtDay )>
				
				<!--- Query for events for the day. --->
				<cfquery name="qEventSub" dbtype="query">
					SELECT
						id,
						name,
						time_started,
						time_ended,
                        is_all_day,
						color,
                        webEx_url
					FROM
						objEvents.Events
					WHERE
						day_index = <cfqueryparam value="#dtDay#" cfsqltype="CF_SQL_INTEGER" />
					ORDER BY
						time_started ASC
				</cfquery>
			
				<!--- Loop over events. --->
				<cfloop query="qEventSub">

					<!--- Only Gary Lubrat or Global Administrator are allowed to input events --->
                    <cfif ListFind(REQUEST.AllowedIDs, CLIENT.userID) OR CLIENT.userType EQ 1>
                        
                        <a 
                            href="#REQUEST.URLPath#&action=edit&id=#qEventSub.id#&viewas=#dtDay#"
                            <cfif Len( qEventSub.color )>
                                style="border-left: 3px solid ###qEventSub.color# ; padding-left: 3px ;"
                            </cfif>
                            class="event">
                            
                            <cfif qEventSub.is_all_day>
                                <strong>All Day Event</strong><br />
                            <cfelse>
                                <strong>#TimeFormat( qEventSub.time_started, "h:mm TT" )# - #TimeFormat( qEventSub.time_ended, "h:mm TT" )#</strong><br />
                            </cfif>
                            
                            #qEventSub.name#<br />
						
                        </a>
                        
					<cfelse>
                    
                        <a   
                            <cfif Len( qEventSub.webEx_url )>
	                            href="#qEventSub.webEx_url#"
                            </cfif>
                            title="Click to Register"
                            target="_blank"
							<cfif Len( qEventSub.color )>
                                style="border-left: 3px solid ###qEventSub.color# ; padding-left: 3px ;"
                            </cfif>
                            class="event">
                            
                            <cfif qEventSub.is_all_day>
                                <strong>All Day Event</strong><br />
                            <cfelse>
                                <strong>#TimeFormat( qEventSub.time_started, "h:mm TT" )# - #TimeFormat( qEventSub.time_ended, "h:mm TT" )#</strong><br />
                            </cfif>
                            
                            #qEventSub.name#  <br /> <cfif Len( qEventSub.webEx_url )> <strong> Click to Register </strong> <br /> </cfif>

                        </a>
                    
                    </cfif>
                    
                    <br />
                    
				</cfloop>
			</cfif>
		</td>				
		
		<!--- 
			If we are on the last day, then close the 
			current table row. 
		--->
		<cfif NOT (DayOfWeek( dtDay ) MOD 7)>
			</td>
		</cfif>
		
	</cfloop>
    
	<tr class="footer">
		<td colspan="8">
			<br />
		</td>
	</tr>
	</table>

    <!--- Insert Scheduled Sessions --->
    #scheduledSessions#
    
</cfoutput>

<cfinclude template="./includes/_footer.cfm" />
