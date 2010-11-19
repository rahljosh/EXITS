<cfif #client.usertype# LT 3>
	
	<cfquery name="countries" datasource="MySql">
	SELECT *
	FROM smg_countrylist
	ORDER BY countryname
	</cfquery>

	<div class="application_section_header">Countries Maintenance</div><br>
	
	<cfif isDefined ('url.message')>
	<cfoutput><div align="center"><span class="get_Attention">#url.message#</span></div><br></cfoutput>
	</cfif>
	
	<cfform method=post action="?curdoc=querys/update_countries">
	<cfoutput>
	<input type="hidden" name="count" value=#countries.recordcount#>
	<table div align="center" cellpadding= 4 cellspacing=0 width="95%">
		<tr bgcolor="00003C">
			<td width="36%"><font color="white">Country</font></td>
			<td width="17%" align="center"><font color="white">Caremed Code</font></td>
			<td width="17%" align="center"><font color="white">SEVIS Code</font></td>
			<td width="23%" align="center"><font color="white">Continent</font></td>
			<td width="7%" align="center"><font color="white">Delete</font></td>
		</tr>
		<cfloop query="countries">
		<tr bgcolor="#iif(countries.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#countries.countryname#<input type="hidden" name="#countries.currentrow#_countryid" value="#countries.countryid#"></td>
			<td align="center"><input type=text name="#countries.currentrow#_code" size="1"  maxlength="2" value="#countries.countrycode#"></td>
			<td align="center"><input type=text name="#countries.currentrow#_sevis" size="1"  maxlength="2" value="#countries.seviscode#"></td>
			<td align="center">
			<select name="#countries.currentrow#_continent">
				<option value="0"></option>
				<option value="Africa" <cfif #countries.continent# is 'Africa'>Selected</cfif>>Africa</option>
				<option value="Asia" <cfif #countries.continent# is 'Asia'>Selected</cfif>>Asia</option>
				<option value="Europe" <cfif #countries.continent# is 'Europe'>Selected</cfif>>Europe</option>
				<option value="North America" <cfif #countries.continent# is 'North America'>Selected</cfif>>North America</option>
				<option value="South America" <cfif #countries.continent# is 'South America'>Selected</cfif>>South America</option>
				<!--- <option value="Oceania" <cfif #countries.continent# is 'Oceania'>Selected</cfif>>Oceania</option>	 --->					
			</select>
			<!--- <input type=text name="#countries.currentrow#_continent" size="12"  maxlength="30" value="#countries.continent#"> --->
			</td>
			<td align="center"><cfinput type="checkbox" name="delete#countries.currentrow#"></td>
		</tr>
		</cfloop>
		<Tr>
	</cfoutput>		
		<td><input name="Submit" type="image" src="pics/update.gif" border=0></td></cfform>
		<td colspan="3"><form action="index.cfm?curdoc=forms/" method="post"><input type="submit" value="   Add Country   " disabled></form></td>
		</Tr>
	</table>	
<cfelse>
	You do not have sufficient rights to edit countries.
</cfif>