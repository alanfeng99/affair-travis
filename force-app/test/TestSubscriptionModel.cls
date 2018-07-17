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
}
