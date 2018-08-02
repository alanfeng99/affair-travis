@isTest
public  class ChangePasswordTestCases {
    @testSetup
    public static void createAccountForTest() {
        Account account = new Account(PersonEmail = 'jin@ggg.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        
        insert account;
    }
    
    public static testMethod void testConstructor() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ggg.com'];
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        System.assertEquals('', controller.viewModel.password);
        System.assertNotEquals(null, controller.accountVerify);
        System.assertEquals(controller.accountVerify.Password__c, controller.viewModel.password);
    }

    public static testMethod void testPasswordFormat_Wrong_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ggg.com'];
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.password = '123';
        Pagereference page = controller.changePassword();
        System.assertEquals(System.Label.Msg_PasswordFormat, controller.baseErrorMessage);
        System.assertEquals(null, page);
    }

    public static testMethod void testPasswordFormat_Right() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ggg.com'];
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.password = '1234qwer';
        Pagereference page = controller.changePassword();
        System.assertNotEquals(System.Label.Msg_PasswordFormat, controller.baseErrorMessage);
        System.assertEquals(null, page);
    }

    public static testMethod void testVerifyPassword_Not_Same_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ggg.com'];
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.password = '1234qwer';
        controller.accountVerify.Password__c = '1234qwerrr';
        Pagereference page = controller.changePassword();
        System.assertEquals('', controller.viewModel.password);
        System.assertEquals('', controller.accountVerify.Password__c);
        System.assertEquals(System.Label.Msg_Password_Inconsistent, controller.baseErrorMessage);
        System.assertEquals(null, page);
    }

    public static testMethod void testVerifyPassword_Same() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ggg.com'];
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.password = '1234qwer';
        controller.accountVerify.Password__c = '1234qwer';
        Pagereference page = controller.changePassword();
        System.assertNotEquals(System.Label.Msg_Password_Inconsistent, controller.baseErrorMessage);
        System.assertNotEquals(null, page);
    }

    public static testMethod void testCheckPassword_Success() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@ggg.com'];
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        ChangePasswordController controller = new ChangePasswordController();
        controller.viewModel.password = '1234qwer';
        controller.accountVerify.Password__c = '1234qwer';
        Pagereference page = controller.changePassword();
        System.assertEquals(System.Label.Msg_UpdateCompleted, controller.baseErrorMessage);
        System.assertNotEquals(null, page);
    }
}