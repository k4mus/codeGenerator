<?php

function tran_ot_list() {
    ?>
    <link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/tran/style-admin.css" rel="stylesheet" />
    <div class="wrap">
        <h2>Orden de Transporte</h2>
        <div class="tablenav top">
            <div class="alignleft actions">
                <a href="<?php echo admin_url('admin.php?page=tran_ot_create'); ?>">Agregar...</a>
            </div>
            <br class="clear">
        </div>
        <?php
        global $wpdb;
        $table_name = $wpdb->prefix . "ot";

        $rows = $wpdb->get_results("SELECT  col.name , col.name  from $table_name");
        ?>
        <table class='wp-list-table widefat fixed striped posts'>
            <tr>
				<th class="manage-column ss-list-width">ID</th>
				<th class="manage-column ss-list-width">empresa</th>
				<th class="manage-column ss-list-width">fecha</th>
                <th>&nbsp;</th>
            </tr>
            <?php foreach ($rows as $row) { ?>
                <tr>
                    <td class="manage-column ss-list-width"><?php echo $row->id_ot; ?></td>
					<td class="manage-column ss-list-width"><?php echo $row->nombreEmpresa; ?></td>
					<td class="manage-column ss-list-width"><?php echo $row->fecha; ?></td>
			        <td><a href="<?php echo admin_url('admin.php?page=tran_ot_update&id=' . $row->id_ot); ?>">Update</a></td>
                </tr>
            <?php } ?>
        </table>
    </div>
	
	<?php
	}