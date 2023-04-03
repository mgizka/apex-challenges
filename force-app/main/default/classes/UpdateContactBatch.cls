public without sharing class UpdateContactBatch implements Database.Batchable<sObject> {


    public Database.QueryLocator start(Database.BatchableContext bc){

        String query = 'SELECT Title, Account.Name, Account.Description FROM Contact where AccountId != null';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Contact> contacts){

        for(Contact contact : contacts){
            contact.Description = contact.Title + ' of ' + contact.Account.Name + ' : ' + contact.Account.Description; 
        }

        update contacts;
    }

    public void finish (Database.BatchableContext bc) {
        
    }
}