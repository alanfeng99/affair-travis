@isTest
public with sharing class SubscriptionManagerViewModelTestCase {
    public static testMethod void testViewModelSubmitSubscription() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Subscription__c subscription = new Subscription__c(CustomAccount__c = account.id);
        Boolean submitResult = controller.viewModel.submit(subscription);
        System.assertEquals(true, submitResult);
    }
}
