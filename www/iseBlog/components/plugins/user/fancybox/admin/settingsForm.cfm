<cfoutput>

<form method="post" action="#cgi.script_name#">
	<fieldset>
		<legend>Fancybox Settings</legend>
		
		<p>
			<label for="fancyboxClass">Classname:</label>
			<span class="field">
				<input type="text" id="fancyboxClass" name="fancyboxClass" value="#getSetting("fancyboxClass")#" size="30" class="required"/>
				</span>
			</p>
		
		<p>
			<label for="fancyboxZoomSpeedIn">Zoom Speed In (in miliseconds):</label>
			<span class="field">
				<input type="text" id="fancyboxZoomSpeedIn" name="fancyboxZoomSpeedIn" value="#getSetting("fancyboxZoomSpeedIn")#" size="10" class="required"/>
				</span>
			</p>
		
		<p>
			<label for="fancyboxZoomSpeedOut">Zoom Speed Out (in miliseconds):</label>
			<span class="field">
				<input type="text" id="fancyboxZoomSpeedOut" name="fancyboxZoomSpeedOut" value="#getSetting("fancyboxZoomSpeedOut")#" size="10" class="required"/>
				</span>
			</p>
		
		<p>
			<label for="fancyboxOverlayShow">Show Overlay:</label>
			<span class="field">
				<select id="fancyboxOverlayShow" name="fancyboxOverlayShow">
					<option value="true"<cfif getSetting("fancyboxOverlayShow") is "true"> selected="selected"</cfif>>True</option>
					<option value="false"<cfif getSetting("fancyboxOverlayShow") is "false"> selected="selected"</cfif>>False</option>
				</select>
				</span>
			</p>
		
		</fieldset>
	
	<p class="actions">
		<input type="submit" class="primaryAction" value="Submit" />
		<input type="hidden" value="event" name="action" />
		<input type="hidden" value="true" name="apply" />
		<input type="hidden" value="showFancyboxSettings" name="event" />
		<input type="hidden" value="fancybox" name="selected" />
		</p>
	
</form>

</cfoutput>