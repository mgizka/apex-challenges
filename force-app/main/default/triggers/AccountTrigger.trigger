trigger AccountTrigger on Account (before insert) {
    
    if (Trigger.isAfter && Trigger.isInsert){

        Set<Contact> contacts = new Set<Contact>(); 

        for(Account a : Trigger.new){
            contacts.add(
                new Contact(FirstName=a.Name, LastName=a.Name, AccountId=a.Id)
            );
        }

        insert contacts;
        
    }

}