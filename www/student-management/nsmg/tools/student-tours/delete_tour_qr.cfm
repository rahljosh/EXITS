<cfquery name="delete_tour" datasource="MySQL">
	DELETE 
	  FROM smg_tours
	 WHERE tour_id = '#url.tour_id#'
</cfquery>

<cflocation url="?curdoc=tools/student-tours/index" addtoken="no">
