trigger AccountTrigger on Account (after insert, after update) {
    
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
    }

}