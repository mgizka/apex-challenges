global without sharing class SendAccountStatusCallout {

    @future(callout=true)
    public static void syncStatus(Set<Id> accIds){
        List<Account> accounts = [SELECT SyncStatus__c FROM Account WHERE Id IN :accIds];

        for(Account acc : accounts){
    
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v56.0/sobjects/Account/' + acc.Id);
            request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
      //      request.setHeader('Content-Type', 'application/json');
            request.setMethod('GET');
       //     request.setBody('{ "SyncStatus__c" : "In Progress" }');

            HttpResponse response = h.send(request);

            if(response.getStatusCode()==200){
                acc.SyncStatus__c='Sync';
                System.debug('Setting sync: ' + acc.SyncStatus__c); 
            }
        }

        update accounts;
    }
}