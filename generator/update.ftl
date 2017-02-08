<?php

function ${plugin}_${table}_update() {
    global $wpdb;
    $table_name = $wpdb->prefix . "${tableName}";
    $${indice} = $_GET["${indice}"];
	<#list columnas as col>
	$${col.name} = $_POST["${col.name}"];
	</#list>
	
//update
    if (isset($_POST['update'])) {
        $wpdb->update(
                $table_name, //table
				array(<#list columnas as col> '${col.name}' => $${col.name}<#if col_has_next>,</#if></#list>), //data
                array('${indice}' => $${indice}), //where
				array(<#list columnas as col>'%s'<#if col_has_next>,</#if></#list>), //data format
                array('%s') //where format
        );
    }
//delete
    else if (isset($_POST['delete'])) {
        $wpdb->query($wpdb->prepare("DELETE FROM $table_name WHERE ${indice} = %s", $${indice}));
    } else {//selecting value to update	
        $results = $wpdb->get_results($wpdb->prepare("SELECT ${indice},<#list columnas as col> ${col.name} <#if col_has_next>,</#if></#list> from $table_name where ${indice}=%s", $${indice}));
        foreach ($results as $r) {
            <#list columnas as col> 
			$${col.name} = $r->${col.name};
			</#list>			
        }
    }
    ?>
    <link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/${plugin}/style-admin.css" rel="stylesheet" />
    <div class="wrap">
        <h2>${titulo}</h2>

        <?php if ($_POST['delete']) { ?>
            <div class="updated"><p>${titulo} deleted</p></div>
            <a href="<?php echo admin_url('admin.php?page=${plugin}_${table}_list') ?>">&laquo; Volver</a>

        <?php } else if ($_POST['update']) { ?>
            <div class="updated"><p>${titulo} updated</p></div>
            <a href="<?php echo admin_url('admin.php?page=${plugin}_${table}_list') ?>">&laquo; Volver</a>

        <?php } else { ?>
            <form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
                <table class='wp-list-table widefat fixed'>
                    <#list columnas as col>
					<tr><th>${col.alias}</th><td><input type="text" name="${col.name}" value="<?php echo $${col.name}; ?>"/></td></tr>
					</#list>
					
                </table>
                <input type='submit' name="update" value='Save' class='button'> &nbsp;&nbsp;
                <input type='submit' name="delete" value='Delete' class='button' onclick="return confirm('&iquest;Est&aacute;s seguro de borrar este elemento?')">
            </form>
        <?php } ?>

    </div>
    <?php
}