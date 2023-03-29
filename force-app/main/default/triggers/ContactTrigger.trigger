trigger ContactTrigger on Contact (after insert, after update, after delete) {

    if (Trigger.isAfter){

        Set<Id> accIds = new Set<Id>();

        if (Trigger.isInsert ){

            for(Contact contact : Trigger.new){
                if(contact.AccountId!=null){ 
                     accIds.add(contact.AccountId);
                }
            }
            
        } else if (Trigger.isUpdate){

            for(Contact contact : Trigger.new){
                if(contact.AccountId!=Trigger.oldMap.get(contact.Id).AccountId) {
                    accIds.add(contact.AccountId);
                    accIds.add(Trigger.oldMap.get(contact.Id).AccountId);
                }
            }

        } 
        else if (Trigger.isDelete){
            for(Contact contact : Trigger.old){
                if(contact.AccountId!=null) 
                    accIds.add(contact.AccountId);
            }
        }

        if (!accIds.isEmpty()){

            Map<Id, Decimal> aggregationAccounts = new Map<Id, Decimal>(); 
        
            for (AggregateResult result : [SELECT count(Id) cnt, AccountId FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId] ){
                aggregationAccounts.put((Id)result.get('AccountId'), (Decimal)result.get('cnt'));
            }

            List<Account> accounts = [SELECT Total_Contacts_Count__c FROM Account WHERE Id in :accIds];

            for(Account acc : accounts){
                acc.Total_Contacts_Count__c = aggregationAccounts.get(acc.Id);
            }

            update accounts;
        }
    }
}