<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:32
         compiled from display/tabs/display_ticket_merge.tpl.php */ ?>
<?php echo '

<script type="text/javascript">

function verifyMerge()

{

'; ?>


	if(confirm("<?php echo @constant('LANG_ACTION_MERGE_SURE'); ?>
"))

<?php echo '

	{

		return true;

	}

	else

		return false;

}

</script>

'; ?>
<div align="right"></div>

<a name="merge"></a>

<table width="100%" border="0" cellspacing="0" cellpadding="2">

<form action="display.php#merge" method="post" OnSubmit="javascript:return verifyMerge();">

<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">

<input type="hidden" name="ticket" value="<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
">

<input type="hidden" name="mode" value="properties">

<input type="hidden" name="qid" value="<?php echo $this->_tpl_vars['o_ticket']->ticket_queue_id; ?>
">

<input type="hidden" name="form_submit" value="merge">

  <tr> 

		<td>

			<?php if (! empty ( $this->_tpl_vars['merge_error'] )): ?>

				<span class="cer_configuration_updated">ERROR: <?php echo $this->_tpl_vars['merge_error']; ?>
</span>

			<?php endif; ?>

				<table width="100%" border="0" cellspacing="0" cellpadding="0">

		  		<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img src="includes/images/spacer.gif" width="1" height="1" alt=""></td></tr>

          <tr>

          	<td class="boxtitle_blue_glass_pale">&nbsp;<?php echo @constant('LANG_ACTION_MERGE'); ?>
</td>

          </tr>

          <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img src="includes/images/spacer.gif" width="1" height="1" alt=""></td></tr>

		  		<tr bgcolor="#DDDDDD">

          	<td>

          	<table cellspacing="0" cellpadding="2" width="100%" border="0">

          		<tr>

          			<td><span class="cer_maintable_text"><?php echo @constant('LANG_ACTION_MERGE_INSTRUCTIONS'); ?>
</span></td>

          		</tr>

          		<tr>

          			<td><span class="cer_maintable_heading"><?php echo @constant('LANG_ACTION_MERGE_PROMPT_BEFORE'); ?>
<?php echo $this->_tpl_vars['o_ticket']->ticket_mask_id; ?>
<?php echo @constant('LANG_ACTION_MERGE_PROMPT_AFTER'); ?>
</span><input type="text" size="15" name="merge_to">

          			<input type="submit" value="<?php echo @constant('LANG_ACTION_MERGE_PROMPT_SUBMIT'); ?>
"></td>

          		</tr>

						</table>

            </td>

         </tr>

				 <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img src="includes/images/spacer.gif" width="1" height="1" alt=""></td></tr>

       </table>        

		</td>

  </tr>

</form>

</table>