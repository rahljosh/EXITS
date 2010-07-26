<cfoutput>
<form method="post" action="#cgi.script_name#">

	<fieldset>
	
		<legend>Resizing Options</legend>
		
		<p>
			<label for="MementoMaxThumbSize">Max Thumbnail Size:</label>
			<span class="hint">Defines the maximum height and width of a thumbnail. Defaults is 100</span>
			<span class="field">
				<input type="text" id="MementoMaxThumbSize" name="MementoMaxThumbSize" value="#getSetting("MementoMaxThumbSize")#" size="5" class="required digits"/>
			</span>
		</p>
		
		<p>
			<label for="MementoResizeMethod">Resizing Method:</label>
			<span class="hint">If using Square Crop method, set the thumbnail height and width to the same value.</span>
			<span class="field">
				<select id="MementoResizeMethod" name="MementoResizeMethod">
					<option value="scaleToFit"<cfif getSetting("MementoResizeMethod") is "scaleToFit"> selected="selected"</cfif>>Scale To Fit (Recommended)</option>
					<option value="crop"<cfif getSetting("MementoResizeMethod") is "crop"> selected="selected"</cfif>>Square Crop (Crops to center of image)</option>
				</select>
			</span>
		</p>
		
	</fieldset>
		
	<fieldset>
	
		<legend>Display Options</legend>
		
		<p>
			<label for="MementoGalleryType">Gallery Lightbox Effects:</label>
			<span class="hint">May require additional plugins.</span>
			<span class="field">
				<select id="MementoGalleryEffect" name="MementoGalleryEffect">
					<option value="shadowbox"<cfif getSetting("MementoGalleryEffect") is "shadowbox"> selected="selected"</cfif>>Shadowbox</option>
					<option value="fancybox"<cfif getSetting("MementoGalleryEffect") is "fancybox"> selected="selected"</cfif>>Fancybox</option>
					<option value="lightbox"<cfif getSetting("MementoGalleryEffect") is "lightbox"> selected="selected"</cfif>>Lightbox</option>
					<option value="none"<cfif getSetting("MementoGalleryEffect") is "none"> selected="selected"</cfif>>None</option>
				</select>
			</span>
		</p>
		
		<p>
			<label for="MementoShowTitle">Show Image Title:</label>
			<span class="hint">Displays the image file name as the title in the larger preview overlay.</span>
			<span class="field">
				<select id="MementoShowTitle" name="MementoShowTitle">
					<option value="yes"<cfif getSetting("MementoShowTitle") is "yes"> selected="selected"</cfif>>Yes</option>
					<option value="no"<cfif getSetting("MementoShowTitle") is "no"> selected="selected"</cfif>>No</option>
				</select>
			</span>
		</p>
		
		<p>
			<label for="MementoThumbClass">Thumbnail Link Class:</label>
			<span class="hint">Apply class name value to anchor tag for advanced gallery styling. Some plugins like fancybox require a class name in order to work. e.g. &lt;a class=&quot;mementothumbs&quot; ...&gt;. Default: mementothumbs</span>
			<span class="field">
				.<input type="text" id="MementoThumbClass" name="MementoThumbClass" value="#getSetting("MementoThumbClass")#" class="required"/>
			</span>
		</p>
		
		<p>
			<label for="MementoCSS">CSS Style:</label>
			<span class="hint">Define your css style rules here. If you're defining rules in your themes css stylesheet, you can delete these rules. Defalult: .mementothumbs img {margin: 10px;}</span>
			<span class="field">
				<textarea cols="50" rows="7" name="MementoCSS" id="MementoCSS">#getSetting("MementoCSS")#</textarea>
			</span>
		</p>
	
	</fieldset>
	
	
	<fieldset>
	
		<legend>System Settings (Required)</legend>

		<p>
			<label for="MementoResizeEngine">Resize Engine:</label>
			<span class="hint">The recommended method of resizing images is with iEdit. It supports ColdFusion servers version 7 and above.</span>
			<span class="field">
				<select id="MementoResizeEngine" name="MementoResizeEngine">
					<option value="iEdit"<cfif getSetting("MementoResizeEngine") is "iEdit"> selected="selected"</cfif>>iEdit (CF 7 +) (Recommended)</option>
					<option value="cfimage"<cfif getSetting("MementoResizeEngine") is "cfimage"> selected="selected"</cfif>>CFIMAGE (CF 8+ Only)</option>
				</select>
			</span>
		</p>
		
		<p>
			<label for="MementoDotPathToiEdit">Dot Path To iEdit:</label>
			<span class="hint"> If your blog is installed in the root of your domain, the default asstets.plugin.Memento should be correct. If you installed Mango Blog in a sub folder then you will need to use the dot separator notation to define your blog's path. e.g. domain.com/<strong>blog</strong> would be <strong>blog</strong>.asstets.plugin.Memento</span>
			<span class="field">
				<input type="text" id="MementoDotPathToiEdit" name="MementoDotPathToiEdit" value="#getSetting("MementoDotPathToiEdit")#" class="required"/>
			</span>
		</p>
		
	</fieldset>
		
	<p class="actions">
		<input type="submit" class="primaryAction" value="Submit"/>
		<input type="hidden" value="event" name="action" />
		<input type="hidden" value="showMementoSettings" name="event" />
		<input type="hidden" value="true" name="apply" />
		<input type="hidden" value="Memento" name="selected" />
	</p>

</form>

</cfoutput>
<hr />
<h3>How to use Memento</h3>
<ol>
	<li>Click the &quot;Files&quot; button in the sidebar</li>
	<li>Select the  &quot;memento&quot; folder</li>
	<li>Create a new folder and give it a name e.g. &quot;christmas2009&quot; is a good one. This new folder is your Memento album.</li>
	<li>Select your newly created folder and upload your large images to it.</li>
	<li>Add the secret code to the page where you want the Memento gallery to go. <br />
	The secret code looks like this: <tt>[memento:<strong>AlbumName</strong>]</tt> <strong>AlbumName</strong> is the name you gave your folder. e.g. &quot;christmas2009&quot;</li>
	<li>Now go check your page and the photos will be created automatically.</li>
</ol>
<p class="warning"><strong>NOTE:</strong> The first time Memento runs on your new album, it will automatically create the thumbnails for you. Depending on the number of images you added or how large they are it will take some time to process them. Be patient. If you are impatient or experiencing issues, try adding only a few images at a time and refreshing the page to build your gallery in smaller chunks. </p>
<h3>Plugin Requirements</h3>
<ul>
	<li>jQuery plugin (required to get shadowbox, lightbox or fancybox gallery effects) </li>
	<li>Gallery Effect Plugins - Shadowbox, Lightbox, or Fancybox</li>
	<li>ColdFusion 7 or higher</li>
</ul>
