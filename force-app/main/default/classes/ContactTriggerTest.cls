@isTest

public class ContactTriggerTest {

    private static String AccountName = 'Contract Trigger Test Account';

    @TestSetup
    static void makeData(){
        Account account = new Account(Name=AccountName);
        insert account;
    }

    @IsTest
    static void testTotalContactsCountAfterInsert(){

        Account account = [SELECT Name FROM Account WHERE Name = :AccountName];

        Contact contact = new Contact(FirstName = account.Name, LastName=account.Name );
        
        Test.startTest();
       
        insert contact;

        Test.stopTest();

        Account afterUpdate = [SELECT Total_Contacts_Count__c FROM Account WHERE Id =: account.id LIMIT 1];
               
        System.assertEquals(1, afterUpdate.Total_Contacts_Count__c, 'Total Contacts Count is 1 expected');
        
    }

    @IsTest
    static void testTotalContactsCountAfterDelete(){

        Account account = [SELECT Name, (SELECT Name FROM Contacts) FROM Account WHERE Name = :AccountName];

        List<Contact> contacts = account.Contacts;
        
        Test.startTest();
       
        delete contacts;

        Test.stopTest();

        Account afterUpdate = [SELECT Total_Contacts_Count__c FROM Account WHERE Id =: account.id LIMIT 1];
               
        System.assertEquals(0, afterUpdate.Total_Contacts_Count__c, 'Total Contracts Count is 0 expected');
        
    }
  
}