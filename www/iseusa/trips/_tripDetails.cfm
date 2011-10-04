<!--- ------------------------------------------------------------------------- ----
	
	File:		_tripDetail.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Trip Detail Page
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

</cfsilent>

<style type="text/css">
<!--
	.whtMiddleTrips {		
		margin: 0px;
		height: auto;
		min-height: 1100px;
		text-align: justify;
		padding:5px 0px 0px 0px;
		background-repeat: repeat-y;
		background-image: url(../images/whtBoxMiddle.png);
	}
-->
</style>

<cfoutput>

    <div class="whtMiddleTrips">    

        <div class="tripsTours">

			<!--- Include Trip Header --->
            <cfinclude template="_tripHeader.cfm">
            			
            <table width="665px" border="0" align="center" cellpadding="2" cellspacing="0">                                          
                <tr>
                    <td>
                        
                        <form action="#CGI.SCRIPT_NAME#?action=lookUpAccount" method="post">
                            <input type="hidden" name="tourID" value="#qGetTourDetails.tour_id#" />
                        
                            <table width="101%" border="0" align="center" cellpadding="5" cellspacing="0" class="bBackground">
                                <tr>
                                    <td width="28%" height="62" align="center">
                                        <span class="TitlesLG">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)#</span><br />
                                
                                        <span class="SubTitle">#LSCurrencyFormat(APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_price), 'local')#</span>
                                    </td>
                                    <td width="48%">
                                        <span class="SubTitleLG">#qGetTourDetails.tour_date#</span><br />
                                        <span class="SubTitle">#qGetTourDetails.tour_length#</span>
                                    </td>
                                    <td width="24%">
                                        <cfif qGetTourDetails.tour_status EQ 'Full'>
                                            <font color='FF0000' size='2' style="font-weight:bold; text-align:center;">No More Seats Available!!</font>
                                        <cfelseif qGetTourDetails.tour_status EQ 'Cancelled'>
                                            <font color='FF0000' size='2'><b><center>Cancelled!!</center></b></font>
                                        <cfelse> 
                                        	<input type="image" name="submit" src="images/reserve_class.png" alt="Reserve Spot" />
                                        </cfif>
                                    </td>
                                </tr>
                            </table><br />
                        
                        </form>
                        
                        <span class="RegularText">
                            #APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_description)#
                        </span><br /><br />
                        
                        <span class="SubTitle">
                            <img src="https://ise.exitsapplication.com/nsmg/uploadedfiles/student-tours/#qGetTourDetails.tour_img2#.jpg" width="215" hspace="10" border="0" align="left" class="image-left"> 
                            Flights:
                        </span><br />
                        
                        <span class="RegularText">
                            #APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_flights)#
                            <br /><br /><br />
                        
                            <span class="SubTitle">Payment:</span>
                            #APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_payment)#
                            <br /><br /><br />
                            
                            <span class="SubTitle">Tour Cancellation Fees and Penalties:</span>
                            #APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_cancelfee)#
                            <br /><br />
                        </span>
                        
                        <table width="85%" border="0" align="center" cellpadding="5" cellspacing="1" bgcolor="##000066">
                            <tr>
                                <td width="50%"><div align="center"><span class="SubTitle style1 style2">Included:</span></div></td>
                                <td width="50%"><div align="center"><span class="SubTitle style1 style2"><span class="style2"><u>NOT</u> Included:</span></span></div></td>
                            </tr>
                            <tr>
                                <td width="50%" valign="top" bgcolor="##FFFFFD">
                                    <span class="RegularText">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_include)#</span>
                                </td>
                                <td width="50%" valign="top" bgcolor="##FFFFFD">
                                    <span class="RegularText">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_notinclude)#</span>
                                </td>
                            </tr>
                        </table><br />
                        
                        <span class="RegularText">
                            <center>
                                <strong>For further information regarding tours and flights:</strong><br />
                                Call Toll Free: 1-800-983-7780 from 9:00am to 8:00pm Eastern Standard Time
                            </center>
                        </span>
                        
                    </td>
                </tr>
            </table>

			<!--- Include Trip Footer --->
            <cfinclude template="_tripFooter.cfm">

        </div> <!-- tripsTours -->

    </div><!-- end whtMiddleTrips -->
        
</cfoutput>    