<?php

function ${schema}_${tableName}_create() {
    <#list columnas as col>
	$${col.name} = $_POST["${col.name}"];
	</#list>
	
    //insert
    if (isset($_POST['insert'])) {
        global $wpdb;
        $table_name = $wpdb->prefix ."${tableName}";

        $wpdb->insert(
                $table_name, //table
                array(<#list columnas as col> '${col.name}' => $${col.name} <#if col_has_next>,</#if></#list> ), //data
                array('%s', '%s') //data format	 		
        );
        $message.="${titulo} inserted";
    }
    ?>
    <link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/${plugin}/style-admin.css" rel="stylesheet" />
    <div class="wrap">
        <h2>Add New ${titulo}</h2>
        <?php if (isset($message)): ?><div class="updated"><p><?php echo $message; ?></p></div><?php endif; ?>
        <form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
            <p> </p>
            <table class='wp-list-table widefat fixed'>
                <#list columnas as col>
				<tr>
                    <th class="ss-th-width">${col.alias}</th>
                    <td><input type="text" name="${col.name}" value="<?php echo $${col.name}; ?>" class="ss-field-width" /></td>
                </tr>
				</#list>
            </table>
            <input type='submit' name="insert" value='Save' class='button'>
        </form>
		<a href="<?php echo admin_url('admin.php?page=tran_ot_list') ?>">&laquo; Volver</a>
    </div>
    <?php
}