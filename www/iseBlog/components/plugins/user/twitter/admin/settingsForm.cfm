<cfoutput>

<form method="post" action="#cgi.script_name#">

	<fieldset>
	
		<legend>Twitter account</legend>

		<p>
			<label for="twitterName">Username:</label>
			<span class="hint">Enter the username of the Twitter account you wish to display</span>
			<span class="field">
				<input type="text" id="twitterName" name="twitterName" value="#getSetting("twitterName")#" size="20" class="required"/>
			</span>
		</p>
		
	</fieldset>
	
	<fieldset>
	
		<legend>Display options</legend>
		
		<p>
			<label for="twitterCount">Number of updates:</label>
			<span class="hint">Hw many recent tweets would you like to show?</span>
			<span class="field">
				<input type="text" id="twitterCount" name="twitterCount" value="#getSetting("twitterCount")#" size="5" class="required digits"/>
			</span>
		</p>
		
		<p>
			<label for="showFollow" class="preField">Show "Follow Me" link:</label>
			<span class="hint">Choose the position, if any, of a link to follow you on Twitter</span>
			<span class="field">
				<select id="showFollow" name="showFollow">
					<option value="nofollow"<cfif getSetting("showFollow") is "nofollow"> selected="selected"</cfif>>none</option>
					<option value="above"<cfif getSetting("showFollow") is "above"> selected="selected"</cfif>>above</option>
					<option value="below"<cfif getSetting("showFollow") is "below"> selected="selected"</cfif>>below</option>
				</select>
			</span>
		</p>
		
		<p>
			<label for="twitterTitle" class="preField">Title:</label>
			<span class="hint">Leave blank for no title</span>
			<span class="field">
				<input type="text" id="twitterTitle" name="twitterTitle" value="#getSetting("twitterTitle")#" size="20"/>
			</span>
		</p>
	
	</fieldset>
		
	<p class="actions">
		<input type="submit" class="primaryAction" value="Submit"/>
		<input type="hidden" value="event" name="action" />
		<input type="hidden" value="showTwitterSettings" name="event" />
		<input type="hidden" value="true" name="apply" />
		<input type="hidden" value="twitter" name="selected" />
	</p>

</form>

</cfoutput>