<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.17/themes/base/jquery-ui.css" type="text/css" media="all" />
	
	<script src="http://jqueryui.com/jquery-1.7.1.js"></script>
	<script src="http://jqueryui.com/ui/jquery.ui.core.js"></script>
	<script src="http://jqueryui.com/ui/jquery.ui.widget.js"></script>
	<script src="http://jqueryui.com/ui/jquery.ui.button.js"></script>
	<script src="http://jqueryui.com/ui/jquery.ui.position.js"></script>
	<script src="http://jqueryui.com/ui/jquery.ui.autocomplete.js"></script>
<style>
	.ui-button { margin-left: -1px; }
	.ui-button-icon-only .ui-button-text { padding: 0.0em; } 
	.ui-autocomplete-input { margin: 0; padding: 0em 0 0em 0em; }
	.textbold {
	}
	.ui-widget { font-family: Arial, Helvetica, sans-serif/*{ffDefault}*/; font-size: 13px/*{fsDefault}*/; }
	.ui-widget .ui-widget { font-size: 12px; }

    </style>
	<script>
	(function( $ ) {
		$.widget( "ui.combobox", {
			_create: function() {
				var self = this,
					select = this.element.hide(),
					selected = select.children( ":selected" ),
					value = selected.val() ? selected.text() : "";
				var input = this.input = $( "<input>" )
					.insertAfter( select )
					.val( value )
					.autocomplete({
						delay: 0,
						minLength: 0,
						source: function( request, response ) {
							var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
							response( select.children( "option" ).map(function() {
								var text = $( this ).text();
								if ( this.value && ( !request.term || matcher.test(text) ) )
									return {
										label: text.replace(
											new RegExp(
												"(?![^&;]+;)(?!<[^<>]*)(" +
												$.ui.autocomplete.escapeRegex(request.term) +
												")(?![^<>]*>)(?![^&;]+;)", "gi"
											), "<strong>$1</strong>" ),
										value: text,
										option: this
									};
							}) );
						},
						select: function( event, ui ) {
							ui.item.option.selected = true;
							self._trigger( "selected", event, {
								item: ui.item.option
							});
						},
						change: function( event, ui ) {
							if ( !ui.item ) {
								var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( $(this).val() ) + "$", "i" ),
									valid = false;
								select.children( "option" ).each(function() {
									if ( $( this ).text().match( matcher ) ) {
										this.selected = valid = true;
										return false;
									}
								});
								if ( !valid ) {
									// remove invalid value, as it didn't match anything
									$( this ).val( "" );
									select.val( "" );
									input.data( "autocomplete" ).term = "";
									return false;
								}
							}
						}
					})
					.addClass( "ui-widget ui-widget-content ui-corner-left" );

				input.data( "autocomplete" )._renderItem = function( ul, item ) {
					return $( "<li></li>" )
						.data( "item.autocomplete", item )
						.append( "<a>" + item.label + "</a>" )
						.appendTo( ul );
				};

				this.button = $( "<button type='button'>&nbsp;</button>" )
					.attr( "tabIndex", -1 )
					.attr( "title", "Show All Items" )
					.insertAfter( input )
					.button({
						icons: {
							primary: "ui-icon-triangle-1-s"
						},
						text: false
					})
					.removeClass( "ui-corner-all" )
					.addClass( "ui-corner-right ui-button-icon" )
					.click(function() {
						// close if already visible
						if ( input.autocomplete( "widget" ).is( ":visible" ) ) {
							input.autocomplete( "close" );
							return;
						}

						// work around a bug (likely same cause as #5265)
						$( this ).blur();

						// pass empty string as value to search for, displaying all results
						input.autocomplete( "search", "" );
						input.focus();
					});
			},

			destroy: function() {
				this.input.remove();
				this.button.remove();
				this.element.show();
				$.Widget.prototype.destroy.call( this );
			}
		});
	})( jQuery );

	$(function() {
		$( "#combobox" ).combobox();
		$( "#toggle" ).click(function() {
			$( "#combobox" ).toggle();
		});
	});
	</script>
<cfif isDefined('form.process')>
    <cfquery name="insert_community_info" datasource="MySQL">
    update smg_hosts
        set population="#form.population#",
            nearbigCity="#form.near_City#",
            near_City_Dist="#form.near_City_Dist#",
            near_pop="#form.near_pop#",
            neighborhood="#form.neighborhood#",
            community="#form.community#",
            terrain1="#form.terrain1#",
            terrain2="#form.terrain2#",
            
            wintertemp="#form.wintertemp#",
            summertemp="#form.summertemp#",
            special_cloths="#form.special_cloths#",
            point_interest="#form.point_interest#",
            local_air_code="#form.local_Air_code#",
            major_air_code="#form.major_air_code#",
            snowy_winter = <cfif isDefined('form.snowy_winter')>1<cfelse>0</cfif>,
            rainy_winter = <cfif isDefined('form.rainy_winter')>1<cfelse>0</cfif>,
            hot_summer = <cfif isDefined('form.hot_summer')>1<cfelse>0</cfif>,
            mild_summer = <cfif isDefined('form.mild_summer')>1<cfelse>0</cfif>,
            high_hummidity = <cfif isDefined('form.high_hummidity')>1<cfelse>0</cfif>,
            dry_air = <cfif isDefined('form.dry_air')>1<cfelse>0</cfif>
            
      where hostid=#client.hostid#
           
           

            
    </cfquery>
    <cfif isDefined('form.terrain3')>
    <cfquery name="terrain3" datasource="MySQL">
    update smg_hosts
        set 
        terrain3 = "#form.terrain3#",
        terrain3_desc = "#form.other_desc#"
    where hostid=#client.hostid#
    </cfquery>
    </cfif>
	<cflocation url="index.cfm?page=schoolInfo">
</cfif>

<cfquery name="local" datasource="MySQL">
	select city,state,zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>
<cfform action="index.cfm?page=communityProfile" method="post">
<cfquery name="family_info" datasource="MySQL">
select *
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfoutput>
<input type="hidden" name="process" />
<table width=100%>
	<tr>
    	<Td>
<h2>Community Information for #local.city# #local.state#, #local.zip#</h2>
		</Td>
        <td align="right">
        <em><a href="http://en.wikipedia.org/wiki/#local.city#,_#local.state#" target="_blank">Wikipedia for #local.city#</a></em>
        </td> 
 </tr>

 <table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr  bgcolor="##deeaf3">
        <td class="label">Population:</td><td class="form_text"><cfinput type="text" name="population" size=20 value="#family_info.population#"></span>
     </tr>
     <tr>	
        <td class="label">Local Airport Code:</td><td class="form_text">
        
        
        
        <cfinput type="text" name="local_air_code" size=3 value="#family_info.local_air_code#"></span>
      </tr>
      <tr  bgcolor="##deeaf3">	 
        <td class="label">Nearest Major City:</td><td class="form_text"><cfinput type="text" name="near_city" size=20 value="#family_info.nearbigcity#"></span>
     </tr>
     <tr>
        <td class="label">Major City Popluation:</td><td class="form_text"><cfinput type="text" name="near_pop" size=20 value="#family_info.near_pop#"></span>
     </tr>
     <tr bgcolor="##deeaf3">
        <td class="label">Major Airport Code:</td><td class="form_text"><cfinput type="text" name="major_air_code" size=3 value="#family_info.major_air_code#"></span>
     </tr>
     <tr  >
        <td class="label">Distance:</td><td class="form_text"> <cfinput name="near_city_dist" size=20 type="text" value="#family_info.near_City_dist#"> miles</span>
     </tr>

		</table>
<h2>Neighborhood & Terrain</h2>

<table width=100% cellspacing=0 cellpadding=2 class="border">
	<Tr  bgcolor="##deeaf3">
        <td class="label">
You would describe your neighborhood as:
		</td>
    </Tr>
    <tr bgcolor="##deeaf3">
    	<Td>
<cfif #family_info.neighborhood# is 'upper income'><cfinput type="radio" name="neighborhood" message="Please indicate the type of neighborhood you live in." required="yes" value="upper income"><cfelse> <cfinput type="radio" name="neighborhood" value="upper income" required="yes" message="Please indicate the type of neighborhood you live in."></cfif>Upper Income
<cfif #family_info.neighborhood# is 'white collar'><cfinput type="radio" name="neighborhood" value="white collar" checked> <cfelse><cfinput type="radio" name="neighborhood" value="white collar"></cfif>White Collar
<cfif #family_info.neighborhood# is 'blue collar'><cfinput type="radio" name="neighborhood" value="blue collar" checked> <cfelse><cfinput type="radio" name="neighborhood" value="blue collar"></cfif>Blue Collar
<cfif #family_info.neighborhood# is 'tradesman'><cfinput type="radio" name="neighborhood" value="tradesman" checked><cfelse><cfinput type="radio" name="neighborhood" value="tradesman"></cfif>Tradesman<br><br>
		</Td>
    </tr>
    <Tr >
    	<td class="label">
Would you describe the community as:</td>
	</Tr>
    <Tr >
    	<td>
<cfif #family_info.community# is 'Urban'><cfinput type="radio" name="community" message="Please indicate the type of community you live in." required="yes" value="Urban" checked><cfelse><cfinput type="radio" name="community" value="Urban"  message="Please indicate the type of community you live in." required="yes"> </cfif>Urban
<cfif #family_info.community# is 'suburban'><cfinput type="radio" name="community" value="suburban" checked><cfelse><cfinput type="radio" name="community" value="suburban"></cfif>Suburban
<cfif #family_info.community# is 'small'><cfinput type="radio" name="community" value="small" checked><cfelse><cfinput type="radio" name="community" value="small"></cfif>Small Town
<cfif #family_info.community# is 'rural'><cfinput type="radio" name="community" value="rural" checked><cfelse><cfinput type="radio" name="community" value="rural"></cfif>Rural
		</td>
	</Tr>
    <tr bgcolor="##deeaf3">
    	<td class="label">
 The terrain of your community is (please select one from each row):
 		</td>
    </tr>
    <tr bgcolor="##deeaf3">
    	<td>
             <table border=0>
                <tr>
                    <Td><cfif #family_info.terrain1# is 'flat'><cfinput type="radio" message="Please indicate the type of terrain around your community." required="yes" name="terrain1" value="flat" checked><cfelse><cfinput type="radio" name="terrain1" value="flat" message="Please indicate the type of terrain around your community." required="yes"></cfif>Flat</td>
                    <td><cfif #family_info.terrain1# is 'hilly'> <cfinput type="radio" name="terrain1" value="hilly" checked><cfelse><cfinput type="radio" name="terrain1" value="hilly"></cfif>Hilly</td> <td colspan=2></td>
                    </tr>
                    <tr>
                    

                    <td><cfif #family_info.terrain2# is 'trees'> <cfinput type="radio" name="terrain2" value="trees" checked><cfelse><cfinput type="radio" name="terrain2" value="trees"></cfif>Trees</td><td><cfif #family_info.terrain2# is 'notrees'><cfinput type="radio" name="terrain2" value="notrees" checked><cfelse><cfinput type="radio" name="terrain2" value="notrees"></cfif>No Trees</td><td colspan=2></td>
                </tr>
                <tr>
                    <td><cfif #family_info.terrain3# is 'ocean'><cfinput type="radio" name="terrain3" value="ocean" checked><cfelse><cfinput type="radio" name="terrain3" value="ocean"></cfif>Ocean</td>
                    <td><cfif #family_info.terrain3# is 'lakeside'> <cfinput type="radio" name="terrain3" value="lakeside" checked><cfelse> <cfinput type="radio" name="terrain3" value="lakeside"></cfif>Lakeside</td>
                    <td><cfif #family_info.terrain3# is 'riverside'><cfinput type="radio" name="terrain3" value="riverside" checked><cfelse><cfinput type="radio" name="terrain3" value="riverside"></cfif>Riverside </td>
                    <td><cfif #family_info.terrain3# is 'other'> <cfinput type="radio" name="terrain3" value="other" checked>Other <cfinput type="text" name="other_desc" size=10 value="#family_info.other_Desc#"><cfelse><cfinput type="radio" name="terrain3" value="other">Other <cfinput type="text" name="other_desc" size=10></cfif></td>
                </tr>
            </table>
   </td>
  </tr>
 </table>
<h2>Climate</h2>
 <table  width=100% cellspacing=0 cellpadding=2 class="border">
 	<tr bgcolor="##deeaf3">
		
<td class="label" colspan=2>Avg temp in winter: </td><td class="form_text" colspan=4><cfinput type="text" size="3" name="wintertemp" value=#family_info.wintertemp#><sup>o</sup>F</span>
</tr><tr>
 <td class="label" colspan=2>Avg temp in summer:</td><td class="form_text" colspan=4> <cfinput type="text" size="3" name="summertemp" value=#family_info.summertemp#><sup>o</sup>F</span>
</tr>
<tr>
	<Td colspan=6  bgcolor="##deeaf3">How would you describe your seasons?</Td>
<Tr bgcolor="##deeaf3">
	<Td><input type="checkbox" name="snowy_winter" <Cfif family_info.snowy_winter eq 1>checked </cfif> />Cold, snowy winters </Td>
    <Td><input type="checkbox"  name="rainy_winter" <Cfif family_info.rainy_winter eq 1>checked </cfif>/>Mild, rainy winters</Td>
    <Td><input type="checkbox" name="hot_summer" <Cfif family_info.hot_summer eq 1>checked </cfif>  />Hot Summers</Td>
    <Td><input type="checkbox"  name="mild_summer" <Cfif family_info.mild_summer eq 1>checked </cfif>/>Mild Summers</Td>
    <td><input type="checkbox" name="high_hummidity" <Cfif family_info.high_hummidity eq 1>checked </cfif> />High Humidity</td>
    <td><input type="checkbox" name="dry_air" <Cfif family_info.dry_air eq 1>checked </cfif> />Dry air</td>
</table>
<h2>Misc. Info</h2>
 <table  width=100% cellspacing=0 cellpadding=2 class="border">
 	<tr bgcolor="##deeaf3">
		
<td class="label" colspan=2>
Indicate particular clothes, sports equipment, etc. that your student should consider bringing:</td>
	</tr>
    <tr bgcolor="##deeaf3">
    	<td>
<textarea cols="50" rows="4" name="special_cloths" wrap="VIRTUAL"><cfoutput>#family_info.special_cloths#</cfoutput></textarea></td>	
	</tr>
    <tr>
    	<td>
Describe the points of interest and available activities/opportunities for teenagers in your surrounding area:</td>
	</tr>
    <tr>
    	<Td>
        
<textarea cols="50" rows="4" name="point_interest" wrap="VIRTUAL"><cfoutput>#family_info.point_interest#</cfoutput></textarea><br>
		</Td>
    </tr>
 </table>
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right">
      
        <input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
</cfoutput>
</cfform>