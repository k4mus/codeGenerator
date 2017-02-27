<?php

function ${schema}_${tableName}_list() {
    ?>
    <link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/${plugin}/style-admin.css" rel="stylesheet" />
    <div class="wrap">
        <h2>${titulo}</h2>
        <div class="tablenav top">
            <div class="alignleft actions">
                <a href="<?php echo admin_url('admin.php?page=${schema}_${tableName}_create'); ?>">Agregar...</a>
            </div>
            <br class="clear">
        </div>
        <?php
        global $wpdb;
        $table_name = $wpdb->prefix . "${tableName}";
		
		<#list foraneas as for>
		$i${for.name}=$${for.name};
		if(!$i${for.name})$i${for.name}="${for.name}";	
		</#list>
		

        $rows = $wpdb->get_results("SELECT ${indice.name}, <#list columnas as col> ${col.name} <#if col_has_next>,</#if></#list> from $table_name where ");
        ?>
        <table class='wp-list-table widefat fixed striped posts'>
            <tr>
				<th class="manage-column ss-list-width">${indice.alias}</th>
			<?php
			<#list foraneas as for>
			if (!$${for.name}) 
			echo "<th class='manage-column ss-list-width'>" .$row->${for.name} ."</th>"; 
			</#list>
			?>
			<#list columnas as col>
				<th class="manage-column ss-list-width">${col.alias}</th>
			</#list>
                <th>&nbsp;</th>
            </tr>
            <?php foreach ($rows as $row) { ?>
                <tr>
                    <td class="manage-column ss-list-width">
						<a href="<?php echo admin_url('admin.php?page=${schema}_${tableName}_update&${indice.name}=' . $row->${indice.name} <#list foraneas as for>.'&${for.name}='.$${for.name}</#list>); ?>"><?php echo $row->${indice.name}; ?></a>
					</td>
					<?php
					<#list foraneas as for>
					if (!$${for.name}) 
						echo "<td class='manage-column ss-list-width'>" .$row->${for.name} ."</td>"; 
					</#list>
					?>
					<#list columnas as col>
					<td class="manage-column ss-list-width"><?php echo $row->${col.name}; ?></td>
					</#list>
			    </tr>
            <?php } ?>
        </table>
    </div>
	<script>
	
	</script>
	
	<?php
	}