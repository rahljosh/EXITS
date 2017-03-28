
<script type="text/javascript">
    var mycallback = function(value, segment) {
        $segment = $('.optional' + segment);
        if (value) $segment.show();
        else $segment.hide();
    }
</script>

<?php echo (isset($zf_error) ? $zf_error : (isset($error) ? $error : ''))?>

<div class="row">
    <?php echo $label_firstname . $firstname?>
</div>
<div class="row even">
    <?php echo $label_lastname . $lastname?>
</div>
<div class="row">
    <?php echo $label_email . $email?>
</div>
<div class="row even">
    <?php echo $label_phone . $phone?>
</div>
<div class="row">
    <?php echo $label_address . $address?>
</div>
<div class="row even">
    <?php echo $label_city . $city?>
</div>
<div class="row">
    <?php echo $label_state . $state?>
</div>
<div class="row even">
    <?php echo $label_zip . $zip?>
</div>
<div class="row">
    <?php echo $label_howHear . $howHear?>
</div>
<div class="row even">
    <?php echo $label_rep . $rep?>
</div>
 <div class="optional optional1 row even">
        <?php echo $label_who . $who?>
 </div>

<div class="row last"><?php echo $btnsubmit?></div>
