<?php /* Smarty version 2.5.0, created on 2007-05-30 06:36:34
         compiled from reports/total_offered_by_queue.tpl.php */ ?>
<span class="cer_display_header">Reports: <?php echo $this->_tpl_vars['report_list']->report->report_name; ?>
</span><br>
<span class="cer_maintable_text"><?php echo $this->_tpl_vars['report_list']->report->report_summary; ?>
</span><br>
<span class="cer_maintable_text">(<a href="<?php echo $this->_tpl_vars['urls']['reports']; ?>
" class="cer_maintable_heading">back to reports list</a>)</span><br>
<br>
	<form action="" method="post">
		<input type="hidden" name="form_submit" value="x">
		<input type="hidden" name="report" value="<?php echo $this->_tpl_vars['report']; ?>
">
		<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("reports/shared_calender.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<table border="0" cellpadding="5" cellspacing="0">
			<tr>
				<td><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("reports/shared_queue_dropdown.tpl.php", array('report' => $this->_tpl_vars['report_list']->report));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?></td>
				<td><span class="cer_maintable_heading">Search By Requester:</span><br><input type="text" name="report_search_text" value="<?php echo $this->_tpl_vars['report_list']->report->report_search_text; ?>
"></td>
				<td valign="bottom"><input type="submit" class="cer_button_face" value="Run Report!"></td>
			</tr>
		</table>
	</form>

<br>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("reports/report_data.tpl.php", array('report' => $this->_tpl_vars['report_list']->report));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>