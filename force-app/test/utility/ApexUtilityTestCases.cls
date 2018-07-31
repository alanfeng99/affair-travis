@isTest
public with sharing class ApexUtilityTestCases {

    public static testMethod void testGenerateRandomAlphaNumeric() {
        String actual = ApexUtility.generateRandomAlphaNumeric(0);
        System.assertEquals('', actual);
    }

    public static testMethod void testGenerateRandomNumeric() {

        String actual = ApexUtility.generateRandomNumeric(0);
        System.assertEquals('', actual);
    }

    private static Contact createContact() {
        Contact contact = new Contact(Email = 'test@test.com', LastName = 'Testlastname');
        return contact;
    }

    private static ContactBean__c createContactBean() {
        ContactBean__c contactBean = new ContactBean__c(Email__c = 'test@test.com', LastName__c = 'Testlastname');
        return contactBean;
    }

    @isTest
    private static void copyNullIntoNull() {
        SObject actual = ApexUtility.copyFirstObjectValuesIntoSecondObject(null, null);
        System.assertEquals(null, actual);
    }

    @isTest
    private static void copyStandardObjectIntoSameObject() {
        Contact objectSource = createContact();
        Contact actual = new Contact();
        actual = (Contact) ApexUtility.copyFirstObjectValuesIntoSecondObject(objectSource, actual);
        
        System.assertNotEquals(null, actual);
        System.assertEquals(objectSource.Email, actual.Email);
    }

    @isTest
    private static void copyStandardObjectIntoCustomObject() {
        Contact objectSource = createContact();
        ContactBean__c actual = new ContactBean__c();
        actual = (ContactBean__c) ApexUtility.copyFirstObjectValuesIntoSecondObject(objectSource, actual);
        
        System.assertNotEquals(null, actual);
        System.assertEquals(objectSource.Email, actual.Email__c);
    }

    @isTest
    private static void copyCustomObjectIntoStandardObject() {
        ContactBean__c objectSource = createContactBean();
        Contact actual = new Contact();
        actual = (Contact) ApexUtility.copyFirstObjectValuesIntoSecondObject(objectSource, actual);

        System.assertNotEquals(null, actual);
        System.assertEquals(objectSource.Email__c, actual.Email);
    }
}