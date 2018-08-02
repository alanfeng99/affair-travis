@isTest
public with sharing class SummaryControllerTestCase {
    public static testMethod void testGetAccount() {
        Account account = new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        String accountId = account.Id;
        
        SummaryController controller = new SummaryController(accountId);
        controller.viewModel = new SummaryViewModel(accountId);
        Account account2 = controller.getAccount();
        System.assertNotEquals(null, account2);
    }

    public static testMethod void testGetSubscriptions() {
        Account account = new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        SummaryController controller = new SummaryController(account.id);
        List<Subscription__c> sub = controller.getSubscriptions();
        System.assertNotEquals(null, sub);
    }

    public static testMethod void testGreetringChange_GoodMorning() {
        SummaryController controller = new SummaryController();
        Integer timeForGreeting = 10;
        controller.greetingChange(timeForGreeting);
        System.assertEquals('早安', controller.greetingWord);
    }

    public static testMethod void testGreetringChange_GoodAfternoon() {
        SummaryController controller = new SummaryController();
        Integer timeForGreeting = 14;
        controller.greetingChange(timeForGreeting);
        System.assertEquals('午安', controller.greetingWord);
    }

    public static testMethod void testGreetringChange_GoodNight() {
        SummaryController controller = new SummaryController();
        Integer timeForGreeting = 22;
        controller.greetingChange(timeForGreeting);
        System.assertEquals('晚安', controller.greetingWord);
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

    public static testMethod void testViewModel_GetSumOfSubscription() {
        Account account = new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        SummaryController controller = new SummaryController(account.id);
        Integer size = controller.viewModel.getSumOfSubscription();
        System.assertEquals(0, size);
    }
  
    
}
