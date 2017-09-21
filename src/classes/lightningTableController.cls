public with sharing class lightningTableController {
   
    @AuraEnabled public static lightningTableWraper getsObjectRecords(String ObjectName,String fieldstoget){     
        
        List<String> lstfieldstoget = fieldstoget.split(',');
        List<lightningTableColumnWrapper> lstTableColumn = new list<lightningTableColumnWrapper> ();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(ObjectName).getDescribe();
		
        for(String field : lstfieldstoget){
           lightningTableColumnWrapper colWrapper = new lightningTableColumnWrapper();
           DescribeFieldResult fieldResult = objResult.fields.getMap().get(field).getDescribe();
           colWrapper.label = fieldResult.getLabel();
           colWrapper.fieldName = fieldResult.getName();
           colWrapper.type = String.valueof(fieldResult.getType()).toLowerCase();
           colWrapper.sortable = true;
           lstTableColumn.add(colWrapper);
        }
        
        String queryString = 'Select '+ String.escapeSingleQuotes(String.join(lstfieldstoget,','))+
                             ' from '+ String.escapeSingleQuotes(ObjectName) + ' Limit 10';
        			
      	LightningTableWraper ltngTableWrapper = new LightningTableWraper();
        ltngTableWrapper.tableRecord = database.query(queryString);
        ltngTableWrapper.tableColumn = lstTableColumn;
       
        return ltngTableWrapper;
        	
    }
    
    
     public class lightningTableColumnWrapper {
        @AuraEnabled
        public string label {get;set;}
        @AuraEnabled
        public String fieldName {get;set;}
        @AuraEnabled
        public string type {get;set;}
        @AuraEnabled
        public boolean sortable {get;set;}
        
    }
    
    public class lightningTableWraper{
        @AuraEnabled
        public List<sObject> tableRecord {get;Set;}
        @AuraEnabled
        public List<lightningTableColumnWrapper> tableColumn {get;set;}
       
    }
  
}