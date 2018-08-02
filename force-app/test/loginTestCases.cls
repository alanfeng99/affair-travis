@isTest
public class loginTestCases {
    
    public static testMethod void testCheckAuthentication_Password_Null() {
        Account account = new Account(PersonEmail = 'jin@444.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        LoginController controller = new LoginController();
        Pagereference page = controller.checkAuthentication();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_AccountPasswordEmpty);
    }

    public static testMethod void testCheckAuthenticationSucceed() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account preAccount = new Account(LastName = 'Alan', Password__c = password, PersonEmail = email, Active__c = true);
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        System.assertNotEquals(null, controller.viewModel.account);
        
        //Test function
        Account account = controller.viewModel.account;
        account.Password__c = password;
        account.PersonEmail = email;
        Pagereference page = controller.checkAuthentication();
        System.assertNotEquals(null, page);

    }

    public static testMethod void testCheckGoogleAuthentication_Return_Null() {
        LoginController controller = new LoginController();
        Pagereference page = controller.checkGoogleAuthentication();
        System.assertEquals(null, page);
    }

    public static testMethod void testCheckFacebookAuthentication_Return_Null() {
        LoginController controller = new LoginController();
        Pagereference page = controller.checkFacebookAuthentication();
        System.assertEquals(null, page);
    }

    public static testMethod void testCheckAuthentication_CheckLogin_Success() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account preAccount = new Account(LastName = 'Alan', Password__c = password, PersonEmail = email, Active__c = true);
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        System.assertNotEquals(null, controller.viewModel.account);
        
        //Test function
        Account account = controller.viewModel.account;
        account.Password__c = password;
        account.PersonEmail = email;
        controller.checkAuthentication();
        Pagereference page = controller.checkAutoLogin();
        System.assertNotEquals(null, page);
        System.assert(controller.baseErrorMessage.contains('登入成功'));
    }


    public static testMethod void testCheckAuthentication_Not_Active() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account preAccount = new Account(LastName = 'Alan', Password__c = password, PersonEmail = email);
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        
        //Test function
        Account account = controller.viewModel.account;
        account.Password__c = password;
        account.PersonEmail = email;
        Pagereference page = controller.checkAuthentication();

        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_AccountNotVerify);

    }

    public static testMethod void testCheckAuthentication_Locked() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account preAccount = new Account(LastName = 'Alan', Password__c = password, PersonEmail = email,Active__c = true, Locked__c = true);
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        
        //Test function
        Account account = controller.viewModel.account;
        account.Password__c = password;
        account.PersonEmail = email;
        Pagereference page = controller.checkAuthentication();

        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_AccountLocked);

    }

    public static testMethod void test_CheckAuthentication_Password_Not_Correct() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account preAccount = new Account(LastName = 'Alan', Password__c = password, PersonEmail = email,Active__c = true);
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        
        //Test function
        Account account = controller.viewModel.account;
        account.Password__c = '4567';
        account.PersonEmail = email;
        Pagereference page = controller.checkAuthentication();

        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_LockedRemind);
    }

    public static testMethod void test_CheckAuthentication_Password_Wrong_Lock_Account() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account preAccount = new Account(LastName = 'Alan', Password__c = password, PersonEmail = email,Active__c = true);
        preAccount.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        
        //Test function
        Account account = controller.viewModel.account;
        account.Password__c = '4567';
        account.PersonEmail = email;
        
        controller.checkAuthentication();
        controller.checkAuthentication();
        controller.checkAuthentication();

        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_AccountLocked);
    }

    public static testMethod void testCheckAuthenticationFailed() {
        LoginController controller = new LoginController();
        //Test function
        Account account = controller.viewModel.account;
        account.Password__c = 'abcedtest';
        account.PersonEmail = 'alan.feng@4idps.com';
        Pagereference page = controller.checkAuthentication();
        System.assertEquals(null, page);
    }

    public static testMethod void testCheckAuthenticationFailed_AutoLoginFail() {
        LoginController controller = new LoginController();
        //Test function
        Account account = controller.viewModel.account;
        account.Password__c = 'abcedtest';
        account.PersonEmail = 'alan.feng@4idps.com';
        Pagereference page = controller.checkAuthentication();
        Pagereference pageAutoLoginFail = controller.checkAutoLogin();
        System.assertEquals(null, pageAutoLoginFail);
    }

    public static testMethod void testLoginWithFacebook_tokenHasNull_ReturnNull() {
        LoginController controller = new LoginController();
        Pagereference page = controller.loginWithFacebook();
        System.assertEquals(null, page);
    }

    public static testMethod void testLoginWithFacebook_Login_Success_Return_Not_Null() {
        LoginController controller = new LoginController();
        controller.facebookUserEmail = 'alan@gmail.com';
        controller.facebookUserName = 'alan';
        controller.facebookUserToken = '123';
        controller.facebookUserID = '222';
        Pagereference page = controller.loginWithFacebook();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLoginWithFacebook_Login_Success_Account_Already_Exist_Return_Not_Null() {
        Account account = new Account();
        account.PersonEmail = 'alan@gmail.com';
        insert account;
        LoginController controller = new LoginController();
        controller.facebookUserEmail = 'alan@gmail.com';
        controller.facebookUserName = 'alan';
        controller.facebookUserToken = '123';
        Pagereference page = controller.loginWithFacebook();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLoginWithGoogle_tokenHasNull_Return_Null() {
        LoginController controller = new LoginController();
        Pagereference page = controller.loginWithGoogle();
        System.assertEquals(null, page);
    }

    public static testMethod void testLoginWithGoogle_Login_Success_Return_Not_Null() {
        LoginController controller = new LoginController();
        controller.googleUserEmail = 'alan@gmail.com';
        controller.googleUserName = 'alan';
        controller.googleUserID = '123';
        Pagereference page = controller.loginWithGoogle();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLoginWithGoogle_Login_Success_Account_Already_Exist_Return_Not_Null() {
        Account account = new Account();
        account.PersonEmail = 'alan@gmail.com';
        insert account;
        LoginController controller = new LoginController();
        controller.googleUserEmail = 'alan@gmail.com';
        controller.googleUserName = 'alan';
        controller.googleUserID = '123';
        Pagereference page = controller.loginWithGoogle();
        System.assertNotEquals(null, page);
    }
}
