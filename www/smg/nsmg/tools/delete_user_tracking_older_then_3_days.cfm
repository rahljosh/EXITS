<cfquery name="delete_tracking_info" datasource="MySQL">
delete from smg_user_tracking 
where time_viewed < #DateAdd('d','-3','#now()#')#
</cfquery>
