trigger AccountTrigger on Account (after insert, after update, before delete) {
    
    if (Trigger.isInsert && Trigger.isAfter){

        List<Contact> contacts = new List<Contact>(); 

        for(Account a : Trigger.new){
            contacts.add(
                new Contact(FirstName=a.Name, LastName=a.Name, AccountId=a.Id)
            );
        }

        insert contacts;
        
    } else if (Trigger.isUpdate && Trigger.isAfter){

        Set<Id> accIds = new Set<Id>();

        for(Account account : Trigger.new){
            if (account.OwnerId != Trigger.oldMap.get(account.Id).OwnerId) 
                accIds.add(account.Id);
        }

        if (accIds.size()>0){
        
            List<Contact> contacts = new List<Contact>([SELECT Id, OwnerId, Account.OwnerId FROM Contact WHERE AccountId IN :accIds]);

            if(!contacts.isEmpty()){

                for(Contact contact : contacts){
                    contact.OwnerId = Contact.Account.OwnerId;
                }

                update contacts;
            }
        }

        Map<Id, Account> accountsBillingCityChanged = new Map<Id,Account>();

        for(Account account : [SELECT BillingCity FROM Account where Id In: Trigger.new]){
            if(account.BillingCity!=Trigger.oldMap.get(account.Id).BillingCity){
                accountsBillingCityChanged.put(account.Id, account);
                
            }
        }

        List <Contact> contacts = new List<Contact>();

        for (Contact contact : [SELECT Id, MailingCity, AccountId FROM Contact WHERE AccountId IN :accountsBillingCityChanged.keySet()]){
            contact.MailingCity = accountsBillingCityChanged.get(contact.AccountId).BillingCity;
            contacts.add(contact);
        } 

        update contacts;

    }
     if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){

        Set<Id> agrIds = new Set<Id>();

        for(Account account : Trigger.New ){
            if (account.Industry == 'Agriculture' && 
                ( 
                    Trigger.isInsert ||
                    account.Industry != Trigger.oldMap.get(account.Id).Industry)
                )
                    {
                    agrIds.add(account.Id);
                }
            }

        if (!agrIds.isEmpty()){
                
            List<Opportunity> opportunities = new List<Opportunity>();

            Date today_90 = Date.today().addDays(90);

            for(Id accId : agrIds){
                opportunities.add (
                   new Opportunity(Name='Opportunity for Agriculture', AccountId=accId, StageName = 'Prospecting', Amount = 0, CloseDate = today_90)
                );
            }
                
            insert opportunities;
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete){

        List <Contact>  contacts = [SELECT Id, AccountId from Contact WHERE AccountId IN :Trigger.old];

        Set<Id> accIds = new Set<Id>(); 

        for(Contact contact : contacts){
            Trigger.oldMap.get(contact.AccountId).addError('Account with associated Contact(s) can not be deleted');
        }

    }

}