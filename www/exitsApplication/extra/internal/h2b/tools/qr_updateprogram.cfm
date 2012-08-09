<cfquery name="qr_updateprogram" datasource="MySql">
    UPDATE smg_programs
    SET programname = '#form.programname#',
    type = '#form.type#',

<cfif form.startdate is ''>  
startdate = null,
<cfelse>
startdate = #CreateODBCDate(form.startdate)#,
</cfif>

<cfif form.enddate is ''>  
enddate = null
<cfelse>
enddate = #CreateODBCDate(form.enddate)#
</cfif>


	WHERE programid = #url.programid#
</cfquery>
<cflocation url="?curdoc=tools/programs">