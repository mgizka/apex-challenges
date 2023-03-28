@IsTest
public class AccountTriggerTest {

    @IsTest
    static void testAccountWithContactCreation(){
        
        Account account = new Account(Name='AutomatedTest Account try');

        Test.startTest(); 

        insert account;

        Test.stopTest();

        List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE AccountId = :account.Id and FirstName = :account.Name];

        System.assert(contacts.size()==1, 'Exacly one contact should be created');
        
    }

    @isTest
    static void testAccountChangeOwnership() {

        User user = [SELECT Id from User where Id != : UserInfo.getUserId() limit 1];

        System.debug('Selected User Id' + user.Id);

        Account account = new Account(Name='AutomatedTest Account try'); 

        insert account;

        account.OwnerId = user.Id;

        update account;

        List<Contact> contacts = [SELECT Id, OwnerId FROM Contact WHERE AccountId = :account.Id and OwnerId =: user.Id];

        System.assert(contacts.size()>0,'There should be at least one contacts whith a new owner');
        
    }

    @isTest
    static void testAccountChangeButOwnership() {

        User user = [SELECT Id, Email from User where Id != : UserInfo.getUserId() limit 1];

        Account account = new Account(Name='AutomatedTest Account try'); 

        insert account;

        account.Name = user.Email;

        update account;

        List<Contact> contacts = [SELECT Id, OwnerId FROM Contact WHERE AccountId = :account.Id and OwnerId =: user.Id];

        System.assert(contacts.size()==0,'There should not be any contacts whith a new owner');
        
    }
}