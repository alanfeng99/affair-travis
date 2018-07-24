@isTest
public with sharing class RegisterControllerTestCase {
    static testMethod void testRegister_Wrong_Email_Format_Return_Null() {
        RegisterController controller = new RegisterController();
        controller.viewModel.account.Email__c = 'jin@ccc';
        Pagereference page = controller.register();
        System.assertEquals(null, page);
        System.assertEquals(System.Label.Msg_EmailFormat, controller.baseErrorMessage);
    }

    static testMethod void testRegister_Account_Exist_Return_Null() {
        String email = 'jin@ccc.com';
        Account__c account = new Account__c();
        account.Email__c = email;
        insert account;
        RegisterController controller = new RegisterController();
        controller.viewModel.account.Email__c = email;
        Pagereference page = controller.register();
        System.assertEquals(null, page);
        System.assertEquals(System.Label.Msg_AccountAlreadyExist, controller.baseErrorMessage);
    }

    static testMethod void testRegister_Normal_Register_Return_Not_Null() {
        RegisterController controller = new RegisterController();
        controller.viewModel.account.Email__c = 'jin@xxx.com';
        Pagereference page = controller.register();
        System.assertNotEquals(null, page);
    }
}