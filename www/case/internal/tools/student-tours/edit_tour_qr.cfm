<cfquery name="edit_tour" datasource="caseusa">
	UPDATE smg_tours
	   SET tour_name = '#form.tour_name#', tour_date = '#form.tour_date#', tour_price = '#form.tour_price#', tour_description = '#form.tour_description#',
	       tour_flights = '#form.tour_flights#', tour_payment = '#form.tour_payment#', tour_include = '#form.tour_include#', 
		   tour_notinclude = '#form.tour_notinclude#', tour_cancelfee = '#form.tour_cancelfee#', tour_status = '#form.tour_status#'
	 WHERE tour_id = '#url.tour_id#'
</cfquery>

<cflocation url="?curdoc=tools/student-tours/index" addtoken="no">
