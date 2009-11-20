<?php /* Smarty version 2.5.0, created on 2007-01-15 21:56:46
         compiled from my_cerberus/tabs/my_cerberus_preferences.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'html_options', 'my_cerberus/tabs/my_cerberus_preferences.tpl.php', 19, false),
array('function', 'html_radios', 'my_cerberus/tabs/my_cerberus_preferences.tpl.php', 30, false),)); ?><table width="100%" border="0" cellspacing="0" cellpadding="0">
<form action="my_cerberus.php" method="post">
<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
<input type="hidden" name="mode" value="preferences">
<input type="hidden" name="form_submit" value="preferences">

  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr class="boxtitle_blue_glass"> 
    <td>&nbsp;<?php echo @constant('LANG_PREF_TITLE'); ?>
</td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr bgcolor="#DDDDDD" class="cer_maintable_text"> 
    <td bgcolor="#DDDDDD" class="cer_maintable_text" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="2">
        <tr> 
          <td width="30%" class="cer_maintable_heading" valign="top"><?php echo @constant('LANG_PREF_TIMEZONE'); ?>
:</td>
					<td>
            <select name="gmt_offset" class="cer_footer_text">
            	<?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['timezones']->timezones,'selected' => $this->_tpl_vars['user_prefs']->user_gmt_offset), $this) ; ?>

            </select>
            <br>
            <span class="cer_footer_text">
            	Using GMT <?php echo $this->_tpl_vars['user_prefs']->user_gmt_offset; ?>
.  The time is now <?php echo $this->_tpl_vars['time_now']; ?>
. 
            </span>
					</td>
        </tr>
	  		<tr> 
          <td class="cer_maintable_heading"><?php echo @constant('LANG_PREF_MSG_TITLE'); ?>
: </td>
          <td class="cer_footer_text">
            <?php echo $this->_plugins['function']['html_radios'][0](array('name' => 'ticket_order','options' => $this->_tpl_vars['user_prefs']->options_msg_order,'checked' => $this->_tpl_vars['user_prefs']->user_ticket_order), $this) ; ?>

          </td>
        </tr>
	  		<tr> 
          <td class="cer_maintable_heading"><?php echo @constant('LANG_WORD_LANGUAGE'); ?>
: </td>
          <td>
						<select name="prefs_user_language">
			  			<?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['user_prefs']->options_language,'selected' => $this->_tpl_vars['user_prefs']->user_language), $this) ; ?>

						</select>
            </td>
        </tr>
	  		<tr> 
          <td class="cer_maintable_heading"><?php echo @constant('LANG_PREF_KEYBOARD_SHORTCUTS'); ?>
: </td>
          <td class="cer_footer_text">
				<input type="checkbox" name="keyboard_shortcuts" value="1" <?php if ($this->_tpl_vars['user_prefs']->user_keyboard_shortcuts): ?>checked<?php endif; ?>> <?php echo @constant('LANG_WORD_ENABLED'); ?>

            </td>
        </tr>
        
			</table>
    </td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
</table>
<br>

<?php if (isset ( $this->_tpl_vars['password_error'] )): ?>
 <span class="cer_configuration_updated"><?php echo @constant('LANG_WORD_ERROR'); ?>
: <?php echo $this->_tpl_vars['password_error']; ?>
</span><br>
<?php endif; ?>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr class="boxtitle_orange_glass"> 
    <td>&nbsp;<?php echo @constant('LANG_PREF_PW_CHANGE'); ?>
</td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr bgcolor="#DDDDDD" class="cer_maintable_text"> 
    <td bgcolor="#DDDDDD" class="cer_maintable_text" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="2">
			  <tr> 
          <td class="cer_maintable_heading" width="30%"><?php echo @constant('LANG_PREF_PW_CURRENT'); ?>
</td>
          <td>
				<input type="password" name="password_current" size="25" maxlength="25">
          </td>
        </tr>
	  		<tr> 
          <td class="cer_maintable_heading"><?php echo @constant('LANG_PREF_PW_NEW'); ?>
</td>
          <td>
		  		<input type="password" name="password_new" size="25" maxlength="25">
          </td>
        </tr>
	  		<tr> 
          <td class="cer_maintable_heading"><?php echo @constant('LANG_PREF_PW_VERIFY'); ?>
</td>
          <td>
				<input type="password" name="password_verify" size="25" maxlength="25">
          </td>
        </tr>
			</table>
	 	</td>
	</tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
</table>
<br>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr class="boxtitle_green_glass"> 
    <td>&nbsp;<?php echo @constant('LANG_PREF_AUTO_SIG'); ?>
</td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr bgcolor="#DDDDDD" class="cer_maintable_text"> 
    <td bgcolor="#DDDDDD" class="cer_maintable_text" align="left"> 
	    <textarea name="signatureBox" cols="80" rows="10"><?php echo $this->_tpl_vars['user_prefs']->user_signature; ?>
</textarea><br>
	    <span class="cer_maintable_heading"><?php echo @constant('LANG_PREF_AUTO_SIG_PLACEMENT'); ?>
 </span> 	
	    <span class="cer_footer_text"> 
	     <?php echo $this->_plugins['function']['html_radios'][0](array('name' => 'signature_pos','options' => $this->_tpl_vars['user_prefs']->options_sig_pos,'checked' => $this->_tpl_vars['user_prefs']->user_signature_pos), $this) ; ?>

	    </span>&nbsp;&nbsp;&nbsp;
	    <span class="cer_maintable_heading"><?php echo @constant('LANG_PREF_AUTO_SIG_AUTO_INSERT'); ?>
 </span> 
	    <span class="cer_footer_text"> 
	     <input type=checkbox name="signature_autoinsert" <?php if ($this->_tpl_vars['user_prefs']->user_signature_autoinsert): ?>checked<?php endif; ?> value=1>
	    </span>
    </td>
  </tr>
	<tr bgcolor="#B0B0B0" class="cer_maintable_text">
		<td align="right">
		  <input type="submit" class="cer_button_face" value="<?php echo @constant('LANG_BUTTON_SUBMIT'); ?>
">
		</td>
	</tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
</table>

</form>