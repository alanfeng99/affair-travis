@isTest
public with sharing class SubscriptionManagerViewModelTestCase {
    public static testMethod void testViewModelSubmitSubscription() {
        Account account = new Account(PersonEmail = 'jin@ifpa.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Subscription__c subscription = new Subscription__c(AccountStandard__c = account.id);
        Boolean submitResult = controller.viewModel.submit(subscription);
        System.assertEquals(true, submitResult);
    }
}
