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

    @isTest
    static void testAccontAgricultureIndustry(){


        Account account = new Account(Name='AutomatedTest Account try', Industry='Agriculture'); 

        insert account;

        List<Opportunity> opportunities = [SELECT Name, StageName, CloseDate, Amount from Opportunity WHERE AccountId = :account.Id];

        System.assert(opportunities.size()==1, 'There should be at least one opportunity');
        System.assertEquals(opportunities[0].StageName, 'Prospecting');

        Date today_90 = Date.today().addDays(90);
        System.assertEquals(opportunities[0].CloseDate, today_90 );

        System.assertEquals(opportunities[0].Amount, 0 );

        System.assertEquals(opportunities[0].Name, 'Opportunity for Agriculture' );
        

        
    }
    @isTest
    static void testAccontBankingIndustry(){


        Account account = new Account(Name='AutomatedTest Account try', Industry='Banking'); 

        insert account;

        List<Opportunity> opportunities = [SELECT Name, StageName, CloseDate, Amount from Opportunity WHERE AccountId = :account.Id];

        System.assert(opportunities.size()==0, 'There should not be any opportunities');
    }

    @isTest
    static void testAccontAgricultureIndustryUpdate(){


        Account account = new Account(Name='AutomatedTest Account try', Industry='Bankingß'); 

        insert account;

        account.Industry='Agriculture';

        update account;

        List<Opportunity> opportunities = [SELECT Name, StageName, CloseDate, Amount from Opportunity WHERE AccountId = :account.Id];

        System.assert(opportunities.size()==1, 'There should be at least one opportunity');
        System.assertEquals(opportunities[0].StageName, 'Prospecting');

        Date today_90 = Date.today().addDays(90);
        System.assertEquals(opportunities[0].CloseDate, today_90 );

        System.assertEquals(opportunities[0].Amount, 0 );

        System.assertEquals(opportunities[0].Name, 'Opportunity for Agriculture' );
        

        
    }
}