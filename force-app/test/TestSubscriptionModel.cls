@isTest
public with sharing class TestSubscriptionModel {
    public static testMethod void testGetSubscriptionsByUserId() {
        Account__c account = new Account__c(Email__c = 'jin@4idps.com');
       
        Subscription__c sub = new Subscription__c(CustomAccount__c = account.Id);
       
        List<Subscription__c> subs = SubscriptionModel.getSubscriptionsByUserId(account.Id);
        System.assertNotEquals(null, subs);
    }

    public static testMethod void testGetProgram() {
        SubscriptionProgram__c program = new SubscriptionProgram__c();
        insert program;
        List<SubscriptionProgram__c> programs = SubscriptionModel.getProgram();
        System.assertNotEquals(null, programs);
    }

    public static testMethod void testGetProgramById() {
        SubscriptionProgram__c program = new SubscriptionProgram__c();
        insert program;
        List<SubscriptionProgram__c> programs = SubscriptionModel.getProgramById(program.Id);
        System.assertNotEquals(null, programs);
    }

    public static testMethod void testGetUniqueSubscriptionById_Success() {
        Account__c account = new Account__c(Email__c = 'jin@rrr.com');
        insert account;
        Subscription__c subscription = new Subscription__c(CustomAccount__c = account.id);
        insert subscription;
        Subscription__c sub = SubscriptionModel.getUniqueSubscriptionById(subscription.id);
        System.assertNotEquals(null, sub);
    }

    public static testMethod void testGetUniqueSubscriptionById_Not_Find_Return_Null() {
        Subscription__c sub = SubscriptionModel.getUniqueSubscriptionById('123');
        System.assertEquals(null, sub);
    }
}
