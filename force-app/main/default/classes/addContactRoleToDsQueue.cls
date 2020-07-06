/***************************************************
Brief Description: InstaQueue funtionality for lightning.
****************************************************/
public class addContactRoleToDsQueue {

    @AuraEnabled 
    public static void httpPostContactRole(id record) {
        system.debug('function');
          
        String ObjectName;
        String Phone;
        sObject sObj;
        
        IF(record.getSobjectType() == Schema.Contact_Role__c.getSObjectType())
        {
            //CRUS/FLS Checks
            //Create string array with fields to query.
            String [] updateFields = new String []{'Id', 'Contact_Role_Phone__c', 'Contact_Name__c'};
            
            //Obtain field name/token map for object
            Map<String,Schema.SObjectField> tokenMap = Schema.SObjectType.Contact_Role__c.fields.getMap();
            
            //Check User permissions for each field
            for(String field : updateFields){
                
                if (!tokenMap.get(field).getDescribe().isAccessible()){
                    NoAccessException ex = new NoAccessException();
                    ex.setMessage('Insufficient Field-Level Access');
                    throw ex;
                }
            }
            
            Contact_Role__c c = [SELECT Id, Contact_Role_Phone__c, Contact_Name__c FROM Contact_Role__c WHERE id =:record]; 
            ObjectName = c.Contact_Name__c.replaceAll(' ', '%20');
            Phone = c.Contact_Role_Phone__c.replaceAll('[^0-9]', '');
            sObj = c.getSObjectType().newSObject(c.id);
        }
        
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String url = 'https://ws.dialsource.com:8000/addToQueue?aid='+UserInfo.getOrganizationId()+'&uid='+UserInfo.getUserId()+'&object_id='+record; 
        String urlParams = url + '&number='+Phone+ '&object_name='+ObjectName;
        req.setMethod('POST');
        req.setHeader('Connection', 'close');
        req.setEndpoint(urlParams);
        String response = '';
        try{
            System.debug('Entered try catch'); 
            HttpResponse res = http.send(req);
            response = res.getBody();
        }
        catch(Exception e) {
        } 
    }

}