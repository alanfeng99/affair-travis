@isTest
public with sharing class SubscriptionManagerControllerTestCase {
    @testSetup
    public static void createAccountForTest() {
        Account account = new Account(PersonEmail = 'jin@ifpa.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        
        insert account;
    }

    public static testMethod void testSunmitForm() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.submitForm();
        System.assertEquals('', controller.currentEditRowId);
        System.assertEquals(null, page);
    }
    
    public static testMethod void testStopAutoOrderPanel() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.stopAutoOrderPanel();
        System.assertEquals(null, page);
    }

    public static testMethod void testStopAutoOrderService() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.stopAutoOrderService();
        System.assertEquals(false, controller.updatedCreditcard);
        System.assertEquals('', controller.currentCancelRowId);
        System.assertEquals(null, page);
    }

    public static testMethod void testUseAutoOrderPanel() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.useAutoOrderPanel();
        System.assertEquals(null, page);
    }

    public static testMethod void testUseAutoOrderService() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        controller.currentUseRowId = '123';
        Pagereference page = controller.useAutoOrderService();
        System.assertEquals('123', controller.subIdForUpdateCredit);
        System.assertEquals('', controller.currentUseRowId);
        System.assertEquals(null, page);
    }

    public static testMethod void testUseAutoOrderService_isReplenish_True() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        Subscription__c tempSub = new Subscription__c(AccountStandard__c = account.id);
        insert tempSub;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        controller.currentUseRowId = tempSub.id;
        Pagereference page = controller.useAutoOrderService();
        for (Subscription__c sub : controller.viewModel.subscriptions) {
            System.assertEquals(true, sub.isReplenish__c);
        }
        
    }

    public static testMethod void testChangeRecipientInfo() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.changeRecipientInfo();
        System.assertEquals(null, page);
    }

    public static testMethod void testCancelReturn() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.cancelReturn();
        System.assertEquals('', controller.currentUseRowId);
        System.assertEquals('', controller.currentCancelRowId);
        System.assertEquals(null, page);
    }

    public static testMethod void testcancelChange() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.cancelChange();
        System.assertEquals('', controller.currentEditRowId);
        System.assertEquals(null, page);
    }

    public static testMethod void testAfterSubmit() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.afterSubmit();
        System.assertEquals(0, controller.viewModel.subscriptions.size());
        System.assertEquals(null, page);
    }

    public static testMethod void testCheckField_Recipient_Not_Complete_Return_Msg() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        Subscription__c tempSub = new Subscription__c(AccountStandard__c = account.id);
        insert tempSub;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        Pagereference page = controller.submitForm();
        System.assertEquals(System.Label.Msg_RecipientInfoEmpty, controller.baseErrorMessage); 
    }

    public static testMethod void testCheckField_Address_Email_Null_Return_Msg() {
        Address__c address = new Address__c(City__c = '台北', Area__c = '松山區');
        insert address;
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        Subscription__c tempSub = new Subscription__c(AccountStandard__c = account.id, Recipient__c = '123');
        insert tempSub;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        controller.viewModel.subscriptions.get(0).City_picklist__c = '台北';
        controller.viewModel.subscriptions.get(0).Area_picklist__c = '松山區';
        Pagereference page = controller.submitForm();
        System.assertEquals(System.Label.Msg_RecipientInfoEmpty, controller.baseErrorMessage); 
    }

    public static testMethod void testCheckField_Tel_Null_Return_Msg() {
        Address__c address = new Address__c(City__c = '台北', Area__c = '松山區');
        insert address;
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        Subscription__c tempSub = new Subscription__c(AccountStandard__c = account.id, Recipient__c = '123');
        insert tempSub;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        controller.viewModel.subscriptions.get(0).City_picklist__c = '台北';
        controller.viewModel.subscriptions.get(0).Area_picklist__c = '松山區';
        controller.viewModel.subscriptions.get(0).Address__c = '123';
        controller.viewModel.subscriptions.get(0).Email__c = 'jin@4idps.com';
        controller.viewModel.subscriptions.get(0).Tel__c = '123';
        Pagereference page = controller.submitForm();
        System.assertNotEquals(System.Label.Msg_RecipientInfoEmpty, controller.baseErrorMessage); 
        System.assertEquals(System.Label.Msg_PhoneFormat, controller.baseErrorMessage);
    }

    public static testMethod void testSubmitForm_CheckField_True() {
        Address__c address = new Address__c(City__c = '台北市', Area__c = '松山區');
        insert address;
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ifpa.com'];
        Subscription__c tempSub = new Subscription__c(AccountStandard__c = account.id, Recipient__c = '123');
        insert tempSub;
        SubscriptionManagementController controller = new SubscriptionManagementController(account.id);
        controller.viewModel.subscriptions.get(0).City_picklist__c = '台北市';
        controller.viewModel.subscriptions.get(0).Area_picklist__c = '松山區';
        controller.viewModel.subscriptions.get(0).Address__c = '123';
        controller.viewModel.subscriptions.get(0).Email__c = 'jin@4idps.com';
        controller.viewModel.subscriptions.get(0).Tel__c = '0987888222';
        Pagereference page = controller.submitForm();
        System.assertEquals(System.Label.Msg_SaveSuccess, controller.baseErrorMessage);
        System.assertEquals('', controller.currentEditRowId);
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
