<?php
error_reporting(0);
function ${schema}_${tableName}_list(<#list foraneas as for>$${for.name}<#if for_has_next>,</#if></#list>) {
    ?>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.13/datatables.min.css"/>
 	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
	<link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/${plugin}/style-admin.css" rel="stylesheet" />
    
	<script src="//code.jquery.com/jquery-1.12.4.js"></script>
	<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.13/datatables.min.js"></script>
    
    <div class="wrap">
        <h2>${titulo}</h2>
        <div class="tablenav top">
            <div class="alignleft actions">
                <a href="<?php echo admin_url('admin.php?page=${schema}_${tableName}_create'<#list foraneas as for>.'&${for.name}='.$${for.name}</#list>); ?>">Agregar...</a>
            </div>
            <br class="clear">
        </div>
        <?php
        global $wpdb;
        $table_name = $wpdb->prefix ."${tableName}";
		
		<#list foraneas as for>
		$i${for.name}=$${for.name};
		if(!$i${for.name})$i${for.name}=$table_name .".${for.name}";	
		</#list>
        $rows = $wpdb->get_results("SELECT ${indice.name},<#list foraneas as for> " .$wpdb->prefix ."${for.table}.name_${for.table},</#list> <#list columnas as col>$table_name.${col.name} <#if col_has_next>,</#if></#list> from $table_name <#if foraneas?has_content > <#list foraneas as for> left join " .$wpdb->prefix ."${for.table} on " .$wpdb->prefix ."${for.table}.${for.name} = $table_name.${for.name}   </#list> where</#if> <#list foraneas as for> $table_name.${for.name}=$i${for.name} <#if for_has_next> AND </#if>  </#list> ");
        ?>
        <table id ="table_${tableName}" $table_name class='wp-list-table widefat fixed striped posts'>
            <thead>
            <tr>
				<th class="manage-column ss-list-width">${indice.alias}</th>
			<?php
			<#list foraneas as for>
			if (!$${for.name}) 
			echo "<th class='manage-column ss-list-width'>${for.alias} </th>"; 
			</#list>
			?>
			<#list columnas as col>
				<th class="manage-column ss-list-width">${col.alias}</th>
			</#list>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($rows as $row) { ?>
            	<tr>
                    <td class="manage-column ss-list-width">
						<a href="<?php echo admin_url('admin.php?page=${schema}_${tableName}_update&${indice.name}=' . $row->${indice.name} <#list foraneas as for>.'&${for.name}='.$${for.name}</#list>); ?>"><?php echo $row->${indice.name}; ?></a>
					</td>
					<?php
					<#list foraneas as for>
					if (!$${for.name}) 
						echo "<td class='manage-column ss-list-width'>" .$row->name_${for.table} ."</td>"; 
					</#list>
					?>
					<#list columnas as col>
					<td class="manage-column ss-list-width"><?php echo $row->${col.name}; ?></td>
					</#list>
			    </tr>
            <?php } ?>
            </tbody>
        </table>
    </div>
	<script>
	$('#table_${tableName}').DataTable();
	</script>
	
	<?php
	}