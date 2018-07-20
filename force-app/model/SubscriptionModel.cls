public with sharing class SubscriptionModel {
    public SubscriptionModel() {

    }

    public static List<Subscription__c> getSubscriptionsByUserId(String userId) {
        return [Select Id, Program__r.Order_Period__c, Program__r.ProgramName__c, Program__c, Name, Amount__c, Start_period__c, End_Period__c, 
        Payment_method__c, Payment_status__c, Company_name__c, isInvoice__c, isReplenish__c, memberInfo__c, Not_received__c, Note__c, Order_date__c,
        Payment_date__c, Subscription_item__c, Subscription_status__c, Tax_No__c
        FROM Subscription__c where CustomAccount__c = :userId];
    }
    

    public static List<SubscriptionProgram__c> getProgram() {
        return [SELECT Id, Price__c, ProgramId__c, ProgramName__c, Order_Period__c FROM SubscriptionProgram__c Order by Price__c];
    }

    public static List<SubscriptionProgram__c> getProgramById(String programId) {
        return [SELECT Id, Price__c, ProgramId__c, ProgramName__c, Order_Period__c FROM SubscriptionProgram__c WHERE ProgramId__c =: programId  Order by Price__c LIMIT 1] ;
    }
}