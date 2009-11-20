<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:20
         compiled from display/rpc/requesters.tpl.php */ ?>
<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['ticket']->id; ?>
">
<table border="0" cellpadding="2" cellspacing="0" class="table_purple" width="100%">
      <tr>
        <td class="bg_purple"><table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td><span class="text_title_white"><img src="includes/images/icone/16x16/mail2.gif" alt="An envelope" width="16" height="16" /> Requesters
              </span></td>
              </tr>
        </table></td>
      </tr>
      <tr>
        <td bgcolor="#F6F3FF"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        		<?php if ($this->_tpl_vars['ticket']): ?>
				<?php if (count((array)$this->_tpl_vars['ticket']->getRequesters())):
    foreach ((array)$this->_tpl_vars['ticket']->getRequesters() as $this->_tpl_vars['reqId'] => $this->_tpl_vars['req']):
?>
              <tr>
                <td class="workflow_item"><?php echo $this->_tpl_vars['req']; ?>
</td>
                <td><a href="javascript:;" onclick="requesterDel(<?php echo $this->_tpl_vars['ticket']->id; ?>
,<?php echo $this->_tpl_vars['reqId']; ?>
);" class="text_ticket_links" title="Remove <?php echo $this->_tpl_vars['req']; ?>
"><b>X</b></a></td>
              </tr>
            <?php endforeach; endif; ?>
            <?php endif; ?>
            <tr>
            	<td colspan="2">
            		<input type="text" name="requester_add" size="15" value=""><input type="button" onclick="requesterAdd(<?php echo $this->_tpl_vars['ticket']->id; ?>
);" value="+">
            	</td>
            </tr>
          </table></td>
      </tr>
</table>
<br>