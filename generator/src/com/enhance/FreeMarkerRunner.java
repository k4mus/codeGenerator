package com.enhance;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.Version;


import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class FreeMarkerRunner{
	
	private static Configuration cfg = null;
	
	static{		
		// Freemarker below configuration object deprecated
		//Configuration cfg = new Configuration();
		//Please use this. To make it backward compatible. Please visit here for more info: 
		//http://freemarker.org/docs/api/freemarker/template/Configuration.html
		cfg = new Configuration(new Version("2.3.0"));
	}
	
	public static void main(String[] args) {
		JSONParser parser = new JSONParser();
		try {
			
			// Load template
			if (args.length<3) {
				System.out.println("Sin argumentos"); return; 
			}
			String templateName = args[0];
			String modelName =  args[1];
			String outputPath = args[2]; 
			
			System.out.println("Argumentos: plantilla, modelo, output");
			System.out.println("Argumentos: "+templateName+","+modelName+","+outputPath);
			if (templateName.isEmpty() || modelName.isEmpty() || outputPath.isEmpty())
				return;
			
			Template template = cfg.getTemplate(templateName);
			//Load Model on Jason
			Object obj = parser.parse(new FileReader("model"));
            JSONObject jsonObject = (JSONObject) obj;
            //parse model to Map
            Map demo = jsonToMap(jsonObject);
            
            outputPath= demo.get("plugin")+"_"+demo.get("tableName")+".php";
            
            System.out.println(demo.toString());
            
            // File output
			Writer file = new FileWriter(new File(outputPath));
			
			//Freemarker union model-template
			template.process(demo, file);
			file.flush();
			file.close();

		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	
	public static Map<String, Object> jsonToMap(JSONObject json) {
	    Map<String, Object> retMap = new HashMap<String, Object>();

	    if(json != null) {
	        retMap = toMap(json);
	    }
	    return retMap;
	}

	public static Map<String, Object> toMap(JSONObject object) {
	    Map<String, Object> map = new HashMap<String, Object>();

	    //Iterator<String> keysItr = object.keys();
	    Set<String> aux =  object.keySet();
	    Iterator<String> keysItr =  aux.iterator();
	    while(keysItr.hasNext()) {
	        String key = keysItr.next();
	        Object value = object.get(key);

	        if(value instanceof JSONArray) {
	            value = toList((JSONArray) value);
	        }

	        else if(value instanceof JSONObject) {
	            value = toMap((JSONObject) value);
	        }
	        map.put(key, value);
	    }
	    return map;
	}

	public static List<Object> toList(JSONArray array)  {
	    List<Object> list = new ArrayList<Object>();
	    for(int i = 0; i < array.size(); i++) {
	        Object value = array.get(i);
	        if(value instanceof JSONArray) {
	            value = toList((JSONArray) value);
	        }

	        else if(value instanceof JSONObject) {
	            value = toMap((JSONObject) value);
	        }
	        list.add(value);
	    }
	    return list;
	}
	
}
