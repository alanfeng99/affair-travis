@isTest
public with sharing class SummaryControllerTestCase {
    public static testMethod void testGetAccount() {
        // Account__c account = new Account__c(Email__c = 'jin@4idps.com');
        // insert account;
        
        // String accountId = account.Id;
        // SummaryController controller = new SummaryController();
        // controller.viewModel = new SummaryViewModel(accountId);
        // Account__c account2 = controller.getAccount();
        // System.assertNotEquals(null, account2);
    }

    public static testMethod void testGreetringChange_GoodMorning() {
        SummaryController controller = new SummaryController();
        controller.greetingChange();
        System.assertEquals('午安', controller.greetingWord);
    }

    public static testMethod void testTurn_To_NewSubscriptionPage() {
        SummaryController controller = new SummaryController();
        Pagereference page = controller.toNewSubscriptionPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_SummaryPage() {
        SummaryController controller = new SummaryController();
        Pagereference page = controller.toSummaryPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_AccountSettingPage() {
        SummaryController controller = new SummaryController();
        Pagereference page = controller.toAccountSettingPage();
        System.assertNotEquals(null, page);
    }
    public static testMethod void testTurn_To_SubscriptionManagementPage() {
        SummaryController controller = new SummaryController();
        Pagereference page = controller.toSubscriptionManagementPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLogOut() {
        SummaryController controller = new SummaryController();
        Pagereference page = controller.logOut();
        System.assertNotEquals(null, page);
    }

  
    
}
