trigger OpportunityTrigger on Opportunity (before delete, after insert, after update) {

    if (Trigger.isBefore && Trigger.isDelete){

        Profile systemAdminProfile = [Select Id from Profile where name='System Administrator'];

        if (UserInfo.getProfileId()!=systemAdminProfile.Id){

            for(Opportunity opp : Trigger.old){

                if(opp.IsClosed){
                    opp.addError('You don\'t have priviladges to delete closed opportunities');
                }
            }
        }
    }
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress limit 1];

        for(Opportunity opp : Trigger.new ){
            if (opp.IsClosed && (Trigger.isInsert || !Trigger.oldMap.get(opp.Id).IsClosed)){

                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(
                    opp.OwnerId !=opp.Account.OwnerId 
                    ? new List<String>{opp.Owner.Email, opp.Account.Owner.Email}
                    : new List<String>{opp.Owner.Email}
                );
                mail.setSubject('Opportunity '+opp.Name+' has been closed');
                mail.setPlainTextBody('Link: '+ URL.getSalesforceBaseUrl().toExternalForm()+ '/'+opp.Id);
                mail.setOrgWideEmailAddressId(owa.id);
                emails.add(mail);
                
            } 
        }
        Messaging.sendEmail(emails); 

    }

}