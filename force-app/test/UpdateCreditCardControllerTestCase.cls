@isTest
public with sharing class UpdateCreditCardControllerTestCase {
    public static testMethod void testCancel() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        Pagereference page = controller.cancel();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testCreditcard_Info_null_Return_Null() {
        Account account = new Account(PersonEmail = 'jin@aaa.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        UpdateCreditCardController controller = new UpdateCreditCardController(account.id);
        Pagereference page = controller.updateCreditcard();
        controller.viewModel.creditCardBean.expireYear = '';
        System.assertEquals(null, page);
    }

    public static testMethod void testCreditcard_ExpireMonth_null_Return_Null() {
        Account account = new Account(PersonEmail = 'jin@aaa.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        UpdateCreditCardController controller = new UpdateCreditCardController(account.id);
        controller.viewModel.creditCardBean.cc = '123';
        controller.viewModel.creditCardBean.expireYear = '2018';
        controller.viewModel.creditCardBean.expireMonth = '';
        Pagereference page = controller.updateCreditcard();
        System.assertEquals(null, page);
    }

    public static testMethod void testCreditcard_CVC_null_Return_Null() {
        Account account = new Account(PersonEmail = 'jin@aaa.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        UpdateCreditCardController controller = new UpdateCreditCardController(account.id);
        controller.viewModel.creditCardBean.cc = '123';
        controller.viewModel.creditCardBean.expireYear = '2018';
        controller.viewModel.creditCardBean.expireMonth = '5';
        Pagereference page = controller.updateCreditcard();
        System.assertEquals(null, page);
    }

    public static testMethod void testCreditcardPatternMatching_Wrong_Return_Null() {
        Account account = new Account(PersonEmail = 'jin@aaa.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        UpdateCreditCardController controller = new UpdateCreditCardController(account.id);
        controller.viewModel.creditCardBean.cc = '123';
        controller.viewModel.creditCardBean.expireYear = '2018';
        controller.viewModel.creditCardBean.expireMonth = '5';
        controller.viewModel.creditCardBean.cvc = '222';
        Pagereference page = controller.updateCreditcard();
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Creditcard_CheckNumber);
        System.assertEquals(null, page);
    }

    public static testMethod void testCVCPatternMatching_Wrong_Return_Null() {
        Account account = new Account(PersonEmail = 'jin@aaa.com', LastName = 'Alan');
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        UpdateCreditCardController controller = new UpdateCreditCardController(account.id);
        controller.viewModel.creditCardBean.cc = '4168613664325412';
        controller.viewModel.creditCardBean.expireYear = '2018';
        controller.viewModel.creditCardBean.expireMonth = '5';
        controller.viewModel.creditCardBean.cvc = '22';
        Pagereference page = controller.updateCreditcard();
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Creditcard_CheckCVC);
        System.assertEquals(null, page);
    }

    public static testMethod void testCreditcard_Year_Selection() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        List<SelectOption> year = controller.getCreditcard_Year();
        System.assertNotEquals(null, year);
    }

    public static testMethod void testCreditcard_Month_Selection() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        List<SelectOption> month = controller.getCreditcard_Month();
        System.assertNotEquals(null, month);
    }

    public static testMethod void testViewModel_updateAccount_Success_Return_True() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        
    }
}
