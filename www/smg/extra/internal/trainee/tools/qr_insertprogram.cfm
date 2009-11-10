<cfquery name="qr_updateprogram" datasource="MySql">
    INSERT INTO smg_programs (programname, type, startdate, enddate, companyid)
    VALUES (
    '#form.programname#',
    '#form.type#',
    
<cfif form.startdate is ''>  
null,
<cfelse>
#CreateODBCDate(form.startdate)#,
</cfif>
	
	<!--- para checkboxes IsDefined <cfif IsDefined('form.enddate')>--->
<cfif form.enddate is ''>  
null,
<cfelse>
#CreateODBCDate(form.enddate)#,
</cfif>
	    
	#client.companyid#
	);
</cfquery>    
<cflocation url="?curdoc=tools/programs">
    
<!---
<cfif NOT IsDefined('form.startdate')>  
startdate = '',
<cfelse>
startdate = #CreateODBCDate(form.startdate)#,
</cfif>

<cfif NOT IsDefined('form.enddate')>  
enddate = ''
<cfelse>
enddate = #CreateODBCDate(form.enddate)#
</cfif>

#url.programid#,
---->

