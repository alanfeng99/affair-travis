@isTest
public  class ChangePasswordTestCases {
    
    public static testMethod void testConstructor() {
        Account__c account = new Account__c(Email__c = 'jin@ggg.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        System.assertEquals('', controller.viewModel.account.Password__c);
        System.assertNotEquals(null, controller.accountVerify);
        System.assertEquals(controller.accountVerify.Password__c, controller.viewModel.account.Password__c);
    }

    public static testMethod void testPasswordFormat_Wrong_Return_False() {
        Account__c account = new Account__c(Email__c = 'jin@ggg.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.account.Password__c = '123';
        Pagereference page = controller.changePassword();
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_PasswordFormat);
        System.assertEquals(null, page);
    }

    public static testMethod void testPasswordFormat_Right() {
        Account__c account = new Account__c(Email__c = 'jin@ggg.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.account.Password__c = '1234qwer';
        Pagereference page = controller.changePassword();
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_PasswordFormat);
        System.assertEquals(null, page);
    }

    public static testMethod void testVerifyPassword_Not_Same_Return_False() {
        Account__c account = new Account__c(Email__c = 'jin@ggg.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.account.Password__c = '1234qwer';
        controller.accountVerify.Password__c = '1234qwerrr';
        Pagereference page = controller.changePassword();
        System.assertEquals('', controller.viewModel.account.Password__c);
        System.assertEquals('', controller.accountVerify.Password__c);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Password_Inconsistent);
        System.assertEquals(null, page);
    }

    public static testMethod void testVerifyPassword_Same() {
        Account__c account = new Account__c(Email__c = 'jin@ggg.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.account.Password__c = '1234qwer';
        controller.accountVerify.Password__c = '1234qwer';
        Pagereference page = controller.changePassword();
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_Password_Inconsistent);
        System.assertNotEquals(null, page);
    }

    public static testMethod void testCheckPassword_Success() {
        Account__c account = new Account__c(Email__c = 'jin@ggg.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.account.Password__c = '1234qwer';
        controller.accountVerify.Password__c = '1234qwer';
        Pagereference page = controller.changePassword();
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_UpdateCompleted);
        System.assertNotEquals(null, page);
    }
}