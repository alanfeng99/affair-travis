@isTest
public with sharing class SubscriptionManagerControllerTestCase {
    public static testMethod void testSunmitForm() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.submitForm();
        System.assertEquals('', controller.currentEditRowId);
        System.assertEquals(null, page);
    }
    
    public static testMethod void testStopAutoOrderPanel() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.stopAutoOrderPanel();
        System.assertEquals(null, page);
    }

    public static testMethod void testStopAutoOrderService() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.stopAutoOrderService();
        System.assertEquals(false, controller.updatedCreditcard);
        System.assertEquals('', controller.currentCancelRowId);
        System.assertEquals(null, page);
    }

    public static testMethod void testUseAutoOrderPanel() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.useAutoOrderPanel();
        System.assertEquals(null, page);
    }

    public static testMethod void testUseAutoOrderService() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        controller.currentUseRowId = '123';
        Pagereference page = controller.useAutoOrderService();
        System.assertEquals('123', controller.subIdForUpdateCredit);
        System.assertEquals('', controller.currentUseRowId);
        System.assertEquals(null, page);
    }

    public static testMethod void testChangeRecipientInfo() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.changeRecipientInfo();
        System.assertEquals(null, page);
    }

    public static testMethod void testCancelReturn() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.cancelReturn();
        System.assertEquals('', controller.currentUseRowId);
        System.assertEquals('', controller.currentCancelRowId);
        System.assertEquals(null, page);
    }

    public static testMethod void testcancelChange() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.cancelChange();
        System.assertEquals('', controller.currentEditRowId);
        System.assertEquals(null, page);
    }

    public static testMethod void testAfterSubmit() {
        Account__c account = new Account__c(Email__c = 'jin@ifpa.com');
        insert account;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.afterSubmit();
        System.assertEquals(0, controller.viewModel.subscriptions.size());
        System.assertEquals(null, page);
    }

    public static testMethod void testTurn_To_UpdateCreditcardPage() {
        SubscriptionManagementController controller = new SubscriptionManagementController();
        Pagereference page = controller.toUpdateCreditcardPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_SummaryPage() {
        SubscriptionManagementController controller = new SubscriptionManagementController();
        Pagereference page = controller.toSummaryPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_AccountSettingPage() {
        SubscriptionManagementController controller = new SubscriptionManagementController();
        Pagereference page = controller.toAccountSettingPage();
        System.assertNotEquals(null, page);
    }
    public static testMethod void testTurn_To_SubscriptionManagementPage() {
        SubscriptionManagementController controller = new SubscriptionManagementController();
        Pagereference page = controller.toSubscriptionManagementPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLogOut() {
        SubscriptionManagementController controller = new SubscriptionManagementController();
        Pagereference page = controller.logOut();
        System.assertNotEquals(null, page);
    }
}
