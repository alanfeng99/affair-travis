@isTest
public class loginTestCases {
    public static testMethod void testCheckAuthenticationSucceed() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account__c preAccount = new Account__c(LastName__c = 'Alan', Password__c = password, Email__c = email, Active__c = true);
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        System.assertNotEquals(null, controller.viewModel.account);
        
        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = password;
        account.Email__c = email;
        Pagereference page = controller.checkAuthentication();
        System.assertNotEquals(null, page);

    }

    public static testMethod void testCheckAuthentication_CheckLogin_Success() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account__c preAccount = new Account__c(LastName__c = 'Alan', Password__c = password, Email__c = email, Active__c = true);
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        System.assertNotEquals(null, controller.viewModel.account);
        
        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = password;
        account.Email__c = email;
        controller.checkAuthentication();
        Pagereference page = controller.checkAutoLogin();
        System.assertNotEquals(null, page);
        System.assert(controller.baseErrorMessage.contains('登入成功'));
    }


    public static testMethod void testCheckAuthentication_Not_Active() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account__c preAccount = new Account__c(LastName__c = 'Alan', Password__c = password, Email__c = email);
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        
        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = password;
        account.Email__c = email;
        Pagereference page = controller.checkAuthentication();

        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_AccountNotVerify);

    }

    public static testMethod void testCheckAuthentication_Locked() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account__c preAccount = new Account__c(LastName__c = 'Alan', Password__c = password, Email__c = email,Active__c = true, Locked__c = true);
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        
        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = password;
        account.Email__c = email;
        Pagereference page = controller.checkAuthentication();

        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_AccountLocked);

    }

    public static testMethod void test_CheckAuthentication_Password_Not_Correct() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account__c preAccount = new Account__c(LastName__c = 'Alan', Password__c = password, Email__c = email,Active__c = true);
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        
        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = '4567';
        account.Email__c = email;
        Pagereference page = controller.checkAuthentication();

        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_LockedRemind);
    }

    public static testMethod void test_CheckAuthentication_Password_Wrong_Lock_Account() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account__c preAccount = new Account__c(LastName__c = 'Alan', Password__c = password, Email__c = email,Active__c = true);
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        
        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = '4567';
        account.Email__c = email;
        
        controller.checkAuthentication();
        controller.checkAuthentication();
        controller.checkAuthentication();

        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Login_AccountLocked);
    }

    public static testMethod void testCheckAuthenticationFailed() {
        LoginController controller = new LoginController();
        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = 'abcedtest';
        account.Email__c = 'alan.feng@4idps.com';
        Pagereference page = controller.checkAuthentication();
        System.assertEquals(null, page);
    }

    public static testMethod void testCheckAuthenticationFailed_AutoLoginFail() {
        LoginController controller = new LoginController();
        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = 'abcedtest';
        account.Email__c = 'alan.feng@4idps.com';
        Pagereference page = controller.checkAuthentication();
        Pagereference pageAutoLoginFail = controller.checkAutoLogin();
        System.assertEquals(null, pageAutoLoginFail);
    }
}
