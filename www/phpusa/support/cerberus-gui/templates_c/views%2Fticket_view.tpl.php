<?php /* Smarty version 2.5.0, created on 2007-01-15 18:54:14
         compiled from views/ticket_view.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'escape', 'views/ticket_view.tpl.php', 60, false),
array('modifier', 'cat', 'views/ticket_view.tpl.php', 61, false),
array('modifier', 'cer_href', 'views/ticket_view.tpl.php', 61, false),
array('modifier', 'string_format', 'views/ticket_view.tpl.php', 87, false),
array('modifier', 'lower', 'views/ticket_view.tpl.php', 98, false),
array('modifier', 'short_escape', 'views/ticket_view.tpl.php', 133, false),
array('function', 'assign', 'views/ticket_view.tpl.php', 83, false),
array('function', 'html_options', 'views/ticket_view.tpl.php', 88, false),
array('function', 'math', 'views/ticket_view.tpl.php', 215, false),)); ?><script type="text/javascript">

function doReload_<?php echo $this->_tpl_vars['view']->view_slot; ?>
(value)
<?php echo ' { '; ?>

	url = formatURL('<?php echo $this->_tpl_vars['view']->page_name; ?>
?<?php echo $this->_tpl_vars['view']->view_slot; ?>
=' + value);
	<?php if (! empty ( $this->_tpl_vars['ticket'] )): ?> url = url + '&ticket=<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
';<?php endif; ?>
	<?php if (! empty ( $this->_tpl_vars['mode'] )): ?> url = url + '&mode=<?php echo $this->_tpl_vars['mode']; ?>
';<?php endif; ?>
	document.location =  url;
<?php echo ' } '; ?>


var <?php echo $this->_tpl_vars['view']->view_slot; ?>
_toggleCheck = 0;
	
function checkAllToggle_<?php echo $this->_tpl_vars['view']->view_slot; ?>
()
<?php echo '
{
	'; ?>

	<?php echo $this->_tpl_vars['view']->view_slot; ?>
_toggleCheck = (<?php echo $this->_tpl_vars['view']->view_slot; ?>
_toggleCheck) ? 0 : 1;
	<?php echo '

	for(e = 0;e < document.viewform_'; ?>
<?php echo $this->_tpl_vars['view']->view_slot; ?>
<?php echo '.elements.length; e++) {
		if(document.viewform_'; ?>
<?php echo $this->_tpl_vars['view']->view_slot; ?>
<?php echo '.elements[e].type == \'checkbox\' && document.viewform_'; ?>
<?php echo $this->_tpl_vars['view']->view_slot; ?>
<?php echo '.elements[e].name == \'bids[]\') {
			document.viewform_'; ?>
<?php echo $this->_tpl_vars['view']->view_slot; ?>
<?php echo '.elements[e].checked = '; ?>
<?php echo $this->_tpl_vars['view']->view_slot; ?>
<?php echo '_toggleCheck;
		}
	}
}
'; ?>


function doViewOptions_<?php echo $this->_tpl_vars['view']->view_slot; ?>
() <?php echo '
{
	if(document.getElementById)
	{
			'; ?>
if(document.getElementById("view_<?php echo $this->_tpl_vars['view']->view_slot; ?>
_options").style.display=="block")<?php echo '
			{
				'; ?>

				document.getElementById("view_<?php echo $this->_tpl_vars['view']->view_slot; ?>
_options").style.display="none";
				<?php if ($this->_tpl_vars['urls']['save_layout'] && $this->_tpl_vars['page'] == $this->_tpl_vars['view']->view_bind_page): ?>
//						document.formSaveLayout.layout_view_options_<?php echo $this->_tpl_vars['view']->view_slot; ?>
.value = 0;
				<?php endif; ?>
				<?php echo '
			}
			else
			{
				'; ?>

				document.getElementById("view_<?php echo $this->_tpl_vars['view']->view_slot; ?>
_options").style.display="block";
				<?php if ($this->_tpl_vars['urls']['save_layout'] && $this->_tpl_vars['page'] == $this->_tpl_vars['view']->view_bind_page): ?>
//						document.formSaveLayout.layout_view_options_<?php echo $this->_tpl_vars['view']->view_slot; ?>
.value = 1;
				<?php endif; ?>
				<?php echo '
			}
	}
}
'; ?>


</script>

<table border="0" cellpadding="2" cellspacing="0" class="table_blue" bgcolor="#F0F0FF" width="100%">
	<tr>
	  <td class="bg_blue"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	      <td width="100%"><span class="text_title_white"> <?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['view']->view_name, 'htmlall'); ?>
</span></td>
	      <td width="0%" nowrap="nowrap"><?php if ($this->_tpl_vars['view']->view_id): ?><img alt="" src="includes/images/spacer.gif" width="15" height="8" align="middle"><a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "ticket_list.php?override=v", $this->_tpl_vars['view']->view_id)); ?>
" class="headerMenu">search</a> | <a href="javascript:;" onclick="doSearchCriteriaList('<?php echo $this->_tpl_vars['view']->view_slot; ?>
_customize');doViewOptions_<?php echo $this->_tpl_vars['view']->view_slot; ?>
();" class="headerMenu">customize</a><img alt="" src="includes/images/spacer.gif" width="15" height="8" align="middle"><?php endif; ?></td>
	  </tr>
	  </table></td>
	</tr>
</table>


<?php if ($this->_tpl_vars['view']->view_id): ?>
<div id="view_<?php echo $this->_tpl_vars['view']->view_slot; ?>
_options" style="display:<?php if ($this->_tpl_vars['view']->show_options): ?>block<?php else: ?>none<?php endif; ?>;">
<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<td align="left" bgcolor="#DDDDDD">
			<div id="view_slot_<?php echo $this->_tpl_vars['view']->view_slot; ?>
_options" style="display:block;">
			<form name="view_slot_<?php echo $this->_tpl_vars['view']->view_slot; ?>
" action="<?php echo $this->_tpl_vars['view']->page_name; ?>
" method="post" style="margin:0px;">
			<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
			<input type="hidden" name="vid" value="<?php echo $this->_tpl_vars['view']->view_id; ?>
">
			<input type="hidden" name="view_submit_mode" value="0">
			<input type="hidden" name="view_submit" value="<?php echo $this->_tpl_vars['view']->view_slot; ?>
">
			
				<b>Name: </b><br>
				<input type="text" name="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_name" value="<?php echo $this->_tpl_vars['view']->view_name; ?>
" size="45" maxlength="64"><br>
				<br>
				
				<?php echo $this->_plugins['function']['assign'][0](array('var' => 'cols','value' => $this->_tpl_vars['view']->getActiveColumns()), $this) ; ?>

				<b>Columns:</b><br>
				<?php if (isset($this->_sections['x'])) unset($this->_sections['x']);
$this->_sections['x']['loop'] = is_array(15) ? count(15) : max(0, (int)15);
$this->_sections['x']['start'] = (int)0;
$this->_sections['x']['step'] = ((int)1) == 0 ? 1 : (int)1;
$this->_sections['x']['name'] = 'x';
$this->_sections['x']['show'] = true;
$this->_sections['x']['max'] = $this->_sections['x']['loop'];
if ($this->_sections['x']['start'] < 0)
    $this->_sections['x']['start'] = max($this->_sections['x']['step'] > 0 ? 0 : -1, $this->_sections['x']['loop'] + $this->_sections['x']['start']);
else
    $this->_sections['x']['start'] = min($this->_sections['x']['start'], $this->_sections['x']['step'] > 0 ? $this->_sections['x']['loop'] : $this->_sections['x']['loop']-1);
if ($this->_sections['x']['show']) {
    $this->_sections['x']['total'] = min(ceil(($this->_sections['x']['step'] > 0 ? $this->_sections['x']['loop'] - $this->_sections['x']['start'] : $this->_sections['x']['start']+1)/abs($this->_sections['x']['step'])), $this->_sections['x']['max']);
    if ($this->_sections['x']['total'] == 0)
        $this->_sections['x']['show'] = false;
} else
    $this->_sections['x']['total'] = 0;
if ($this->_sections['x']['show']):

            for ($this->_sections['x']['index'] = $this->_sections['x']['start'], $this->_sections['x']['iteration'] = 1;
                 $this->_sections['x']['iteration'] <= $this->_sections['x']['total'];
                 $this->_sections['x']['index'] += $this->_sections['x']['step'], $this->_sections['x']['iteration']++):
$this->_sections['x']['rownum'] = $this->_sections['x']['iteration'];
$this->_sections['x']['index_prev'] = $this->_sections['x']['index'] - $this->_sections['x']['step'];
$this->_sections['x']['index_next'] = $this->_sections['x']['index'] + $this->_sections['x']['step'];
$this->_sections['x']['first']      = ($this->_sections['x']['iteration'] == 1);
$this->_sections['x']['last']       = ($this->_sections['x']['iteration'] == $this->_sections['x']['total']);
?>
					<?php echo $this->_plugins['function']['assign'][0](array('var' => 'i','value' => $this->_sections['x']['index']), $this) ; ?>

					<?php echo $this->_run_mod_handler('string_format', true, $this->_sections['x']['index'], "%02d"); ?>
: <select name="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_columns[]">
					<?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['view']->getColumnOptions(),'selected' => $this->_tpl_vars['cols'][$this->_tpl_vars['i']]), $this) ; ?>

					</select><br>
				<?php endfor; endif; ?>
				<br>
				<b>Paging: </b><br>
				<?php echo @constant('LANG_WORD_SHOW'); ?>

				<input type="text" name="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_filter_rows" value="<?php echo $this->_tpl_vars['view']->filter_rows; ?>
" size="2" maxlength="3" class="cer_footer_text"> rows<br>
				View position on page <input type="text" name="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_order" value="<?php echo $this->_tpl_vars['view']->view_order; ?>
" size="2" maxlength="3" class="cer_footer_text"><br>
				<br>

				<input type="button" onclick="this.form.view_submit_mode.value=1;this.form.submit();" value="<?php echo $this->_run_mod_handler('lower', true, @constant('LANG_WORD_DELETE')); ?>
" class="cer_button_face">
				<input type="button" onclick="this.form.view_submit_mode.value=0;this.form.submit();" value="<?php echo $this->_run_mod_handler('lower', true, @constant('LANG_BUTTON_SAVE')); ?>
" class="cer_button_face">
				</form>
				
				<br>
				
				<table>
					<tr>
						<td valign="top">
							<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_customize_searchCriteriaList"></span>
						</td>
						<td valign="top"><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("search/search_builder.tpl.php", array('label' => $this->_run_mod_handler('cat', true, $this->_tpl_vars['view']->view_slot, '_customize')));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?></td>
					</tr>
				</table>
				<br>
			</div>
		</td>
    </tr>
</table>
</div>
<?php endif; ?>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	
	<tr bgcolor="#C0C0C0"> 
	<?php if ($this->_tpl_vars['view']->view_adv_controls): ?>
		<td align="<?php echo $this->_tpl_vars['view']->columns[0]->column_align; ?>
" style="padding-left: 2px;">
			<a href="<?php echo $this->_tpl_vars['view']->columns[0]->column_url; ?>
" class="cer_maintable_heading"><?php echo $this->_tpl_vars['view']->columns[0]->column_heading; ?>
</a>
		</td>
	<?php endif; ?>
	
	<?php if (isset($this->_sections['col'])) unset($this->_sections['col']);
$this->_sections['col']['name'] = 'col';
$this->_sections['col']['loop'] = is_array($this->_tpl_vars['view']->columns) ? count($this->_tpl_vars['view']->columns) : max(0, (int)$this->_tpl_vars['view']->columns);
$this->_sections['col']['start'] = (int)2;
$this->_sections['col']['show'] = true;
$this->_sections['col']['max'] = $this->_sections['col']['loop'];
$this->_sections['col']['step'] = 1;
if ($this->_sections['col']['start'] < 0)
    $this->_sections['col']['start'] = max($this->_sections['col']['step'] > 0 ? 0 : -1, $this->_sections['col']['loop'] + $this->_sections['col']['start']);
else
    $this->_sections['col']['start'] = min($this->_sections['col']['start'], $this->_sections['col']['step'] > 0 ? $this->_sections['col']['loop'] : $this->_sections['col']['loop']-1);
if ($this->_sections['col']['show']) {
    $this->_sections['col']['total'] = min(ceil(($this->_sections['col']['step'] > 0 ? $this->_sections['col']['loop'] - $this->_sections['col']['start'] : $this->_sections['col']['start']+1)/abs($this->_sections['col']['step'])), $this->_sections['col']['max']);
    if ($this->_sections['col']['total'] == 0)
        $this->_sections['col']['show'] = false;
} else
    $this->_sections['col']['total'] = 0;
if ($this->_sections['col']['show']):

            for ($this->_sections['col']['index'] = $this->_sections['col']['start'], $this->_sections['col']['iteration'] = 1;
                 $this->_sections['col']['iteration'] <= $this->_sections['col']['total'];
                 $this->_sections['col']['index'] += $this->_sections['col']['step'], $this->_sections['col']['iteration']++):
$this->_sections['col']['rownum'] = $this->_sections['col']['iteration'];
$this->_sections['col']['index_prev'] = $this->_sections['col']['index'] - $this->_sections['col']['step'];
$this->_sections['col']['index_next'] = $this->_sections['col']['index'] + $this->_sections['col']['step'];
$this->_sections['col']['first']      = ($this->_sections['col']['iteration'] == 1);
$this->_sections['col']['last']       = ($this->_sections['col']['iteration'] == $this->_sections['col']['total']);
?>
	
		<td align="<?php echo $this->_tpl_vars['view']->columns[$this->_sections['col']['index']]->column_align; ?>
" style="padding-left: 2px;">
			<?php if ($this->_tpl_vars['view']->columns[$this->_sections['col']['index']]->column_sortable): ?>
				<a href="<?php echo $this->_tpl_vars['view']->columns[$this->_sections['col']['index']]->column_url; ?>
" class="cer_maintable_heading"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['view']->columns[$this->_sections['col']['index']]->column_heading); ?>
</a>
			<?php else: ?>
			 	<span class="cer_maintable_heading"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['view']->columns[$this->_sections['col']['index']]->column_heading); ?>
</span>
			<?php endif; ?>
		</td>
	<?php endfor; endif; ?>
    </tr>
    
    
    <?php if ($this->_tpl_vars['view']->show_modify): ?>
		<form action="ticket_list.php" method="post" name="viewform_<?php echo $this->_tpl_vars['view']->view_slot; ?>
" id="viewform_<?php echo $this->_tpl_vars['view']->view_slot; ?>
" onsubmit="return false;">
		<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
		<input type="hidden" name="mass_slot" value="<?php echo $this->_tpl_vars['view']->view_slot; ?>
">
		<input type="hidden" name="form_submit" value="tickets_modify">
	<?php endif; ?>
	
    <?php if ($this->_tpl_vars['view']->show_mass && $this->_tpl_vars['view']->view_adv_controls): ?>
		<form action="index.php" method="post" name="viewform_<?php echo $this->_tpl_vars['view']->view_slot; ?>
" id="viewform_<?php echo $this->_tpl_vars['view']->view_slot; ?>
" onsubmit="return false;">
		<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
		<input type="hidden" name="mass_slot" value="<?php echo $this->_tpl_vars['view']->view_slot; ?>
">
		<input type="hidden" name="form_submit" value="tickets_modify">
	<?php endif; ?>

	<tr><td colspan="<?php echo $this->_tpl_vars['view']->view_colspan; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
	<?php if (isset($this->_sections['row'])) unset($this->_sections['row']);
$this->_sections['row']['name'] = 'row';
$this->_sections['row']['loop'] = is_array($this->_tpl_vars['view']->rows) ? count($this->_tpl_vars['view']->rows) : max(0, (int)$this->_tpl_vars['view']->rows);
$this->_sections['row']['show'] = true;
$this->_sections['row']['max'] = $this->_sections['row']['loop'];
$this->_sections['row']['step'] = 1;
$this->_sections['row']['start'] = $this->_sections['row']['step'] > 0 ? 0 : $this->_sections['row']['loop']-1;
if ($this->_sections['row']['show']) {
    $this->_sections['row']['total'] = $this->_sections['row']['loop'];
    if ($this->_sections['row']['total'] == 0)
        $this->_sections['row']['show'] = false;
} else
    $this->_sections['row']['total'] = 0;
if ($this->_sections['row']['show']):

            for ($this->_sections['row']['index'] = $this->_sections['row']['start'], $this->_sections['row']['iteration'] = 1;
                 $this->_sections['row']['iteration'] <= $this->_sections['row']['total'];
                 $this->_sections['row']['index'] += $this->_sections['row']['step'], $this->_sections['row']['iteration']++):
$this->_sections['row']['rownum'] = $this->_sections['row']['iteration'];
$this->_sections['row']['index_prev'] = $this->_sections['row']['index'] - $this->_sections['row']['step'];
$this->_sections['row']['index_next'] = $this->_sections['row']['index'] + $this->_sections['row']['step'];
$this->_sections['row']['first']      = ($this->_sections['row']['iteration'] == 1);
$this->_sections['row']['last']       = ($this->_sections['row']['iteration'] == $this->_sections['row']['total']);
?>
		
		<?php if ($this->_tpl_vars['view']->view_adv_2line): ?>
		<tr class="<?php if ($this->_sections['row']['rownum'] % 2 == 0): ?>cer_maintable_text_1<?php else: ?>cer_maintable_text_2<?php endif; ?>">
		
			<?php if ($this->_tpl_vars['view']->view_adv_controls): ?>
			<td rowspan="<?php if ($this->_tpl_vars['view']->view_adv_2line): ?>2<?php else: ?>1<?php endif; ?>" align="center">
				<?php echo $this->_tpl_vars['view']->rows[$this->_sections['row']['index']][0]; ?>

			</td>
			<?php endif; ?>
			
			<?php if ($this->_tpl_vars['view']->view_adv_2line): ?>
				<td colspan="<?php echo $this->_tpl_vars['view']->view_colspan_subject; ?>
"><?php echo $this->_tpl_vars['view']->rows[$this->_sections['row']['index']][1]; ?>
</td>
			<?php endif; ?>
			
      </tr>
      <?php endif; ?>
        
		<tr class="<?php if ($this->_sections['row']['rownum'] % 2 == 0): ?>cer_maintable_text_1<?php else: ?>cer_maintable_text_2<?php endif; ?>" title="">
		
		
		<?php if (! $this->_tpl_vars['view']->view_adv_2line && $this->_tpl_vars['view']->view_adv_controls): ?>
          <td style="padding-left: 2px; padding-right: 2px;" align="<?php echo $this->_tpl_vars['view']->columns[0]->column_align; ?>
">
          	<?php echo $this->_tpl_vars['view']->rows[$this->_sections['row']['index']][0]; ?>

          </td>
		<?php endif; ?>
		
		<?php if (isset($this->_sections['col'])) unset($this->_sections['col']);
$this->_sections['col']['name'] = 'col';
$this->_sections['col']['loop'] = is_array($this->_tpl_vars['view']->rows[$this->_sections['row']['index']]) ? count($this->_tpl_vars['view']->rows[$this->_sections['row']['index']]) : max(0, (int)$this->_tpl_vars['view']->rows[$this->_sections['row']['index']]);
$this->_sections['col']['start'] = (int)2;
$this->_sections['col']['show'] = true;
$this->_sections['col']['max'] = $this->_sections['col']['loop'];
$this->_sections['col']['step'] = 1;
if ($this->_sections['col']['start'] < 0)
    $this->_sections['col']['start'] = max($this->_sections['col']['step'] > 0 ? 0 : -1, $this->_sections['col']['loop'] + $this->_sections['col']['start']);
else
    $this->_sections['col']['start'] = min($this->_sections['col']['start'], $this->_sections['col']['step'] > 0 ? $this->_sections['col']['loop'] : $this->_sections['col']['loop']-1);
if ($this->_sections['col']['show']) {
    $this->_sections['col']['total'] = min(ceil(($this->_sections['col']['step'] > 0 ? $this->_sections['col']['loop'] - $this->_sections['col']['start'] : $this->_sections['col']['start']+1)/abs($this->_sections['col']['step'])), $this->_sections['col']['max']);
    if ($this->_sections['col']['total'] == 0)
        $this->_sections['col']['show'] = false;
} else
    $this->_sections['col']['total'] = 0;
if ($this->_sections['col']['show']):

            for ($this->_sections['col']['index'] = $this->_sections['col']['start'], $this->_sections['col']['iteration'] = 1;
                 $this->_sections['col']['iteration'] <= $this->_sections['col']['total'];
                 $this->_sections['col']['index'] += $this->_sections['col']['step'], $this->_sections['col']['iteration']++):
$this->_sections['col']['rownum'] = $this->_sections['col']['iteration'];
$this->_sections['col']['index_prev'] = $this->_sections['col']['index'] - $this->_sections['col']['step'];
$this->_sections['col']['index_next'] = $this->_sections['col']['index'] + $this->_sections['col']['step'];
$this->_sections['col']['first']      = ($this->_sections['col']['iteration'] == 1);
$this->_sections['col']['last']       = ($this->_sections['col']['iteration'] == $this->_sections['col']['total']);
?>
          <td style="padding-left: 2px; padding-right: 2px;" align="<?php echo $this->_tpl_vars['view']->columns[$this->_sections['col']['index']]->column_align; ?>
" <?php echo $this->_tpl_vars['view']->columns[$this->_sections['col']['index']]->column_extras; ?>
>
          	<?php echo $this->_tpl_vars['view']->rows[$this->_sections['row']['index']][$this->_sections['col']['index']]; ?>

          </td>
        <?php endfor; endif; ?>
        </tr>
	    <tr><td colspan="<?php echo $this->_tpl_vars['view']->view_colspan; ?>
" bgcolor="#FFFFFF"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
	<?php endfor; endif; ?>
	
	<?php if ($this->_tpl_vars['view']->show_modify): ?>
	  <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("views/mass_actions.tpl.php", array('col_span' => $this->_tpl_vars['view']->view_colspan));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	  </form>
	<?php endif; ?>
	
	<?php if ($this->_tpl_vars['view']->show_mass && $this->_tpl_vars['view']->view_adv_controls): ?>
	  <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("views/mass_actions.tpl.php", array('col_span' => $this->_tpl_vars['view']->view_colspan));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	  </form>
	<?php endif; ?>
	
</table>

<table width="100%" border="0" cellspacing="1" cellpadding="2">
	<tr>
		<td width="100%" align="right" class="cer_footer_text">
			<?php if ($this->_tpl_vars['view']->show_prev): ?><a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cat', true, "", $GLOBALS['HTTP_SERVER_VARS']['PHP_SELF']), "?"), $this->_tpl_vars['view']->view_slot), "_p=0")); ?>
" class="cer_header_loginLink">&lt;&lt;</a><?php endif; ?>
			<?php if ($this->_tpl_vars['view']->show_prev): ?><a href="<?php echo $this->_tpl_vars['view']->view_prev_url; ?>
" class="cer_header_loginLink">&lt;<?php echo @constant('LANG_WORD_PREV'); ?>
</a><?php endif; ?>
			(<?php echo @constant('LANG_WORD_SHOWING'); ?>
 <?php echo $this->_tpl_vars['view']->show_from; ?>
-<?php echo $this->_tpl_vars['view']->show_to; ?>
 <?php echo @constant('LANG_WORD_OF'); ?>
 <?php echo $this->_tpl_vars['view']->show_of; ?>
) 
			<?php if ($this->_tpl_vars['view']->show_next): ?><a href="<?php echo $this->_tpl_vars['view']->view_next_url; ?>
" class="cer_header_loginLink"><?php echo @constant('LANG_WORD_NEXT'); ?>
&gt;</a><?php endif; ?>
			<?php if (! $this->_tpl_vars['view']->filter_rows): ?>
				<?php echo $this->_plugins['function']['assign'][0](array('var' => 'last_page','value' => 0), $this) ; ?>

			<?php else: ?>
				<?php echo $this->_plugins['function']['math'][0](array('assign' => 'last_page','equation' => "ceil(x/y)",'x' => $this->_tpl_vars['view']->show_of,'y' => $this->_tpl_vars['view']->filter_rows), $this) ; ?>

				<?php echo $this->_plugins['function']['math'][0](array('assign' => 'last_page','equation' => "x-1",'x' => $this->_tpl_vars['last_page'],'format' => "%0d"), $this) ; ?>

			<?php endif; ?>
			<?php if ($this->_tpl_vars['view']->show_next): ?><a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cat', true, "", $GLOBALS['HTTP_SERVER_VARS']['PHP_SELF']), "?"), $this->_tpl_vars['view']->view_slot), "_p="), $this->_tpl_vars['last_page'])); ?>
" class="cer_header_loginLink">&gt;&gt;</a><?php endif; ?>	
		</td>
	</tr>
</table>