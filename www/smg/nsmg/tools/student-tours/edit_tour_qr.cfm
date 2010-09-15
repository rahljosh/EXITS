<Cfdump var="#form#">
<Cfdump var="#cffile#">
<cffile action="upload" destination="#AppPath.tours#" filefield="form.packet" nameconflict="overwrite">
<cfquery name="edit_tour" datasource="MySQL">
	UPDATE smg_tours
	   SET tour_name = '#form.tour_name#', tour_date = '#form.tour_date#', tour_price = '#form.tour_price#', tour_description = '#form.tour_description#',
	       tour_flights = '#form.tour_flights#', tour_flightdetails = '#form.tour_flightDetails#', tour_payment = '#form.tour_payment#', 
           tour_include = '#form.tour_include#', packetFile = '#cffile.serverfile#',
		   tour_notinclude = '#form.tour_notinclude#', tour_cancelfee = '#form.tour_cancelfee#', tour_status = '#form.tour_status#'
	 WHERE tour_id = '#url.tour_id#'
</cfquery>

<cflocation url="?curdoc=tools/student-tours/index" addtoken="no">
