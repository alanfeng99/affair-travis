@isTest
public class loginTestCases {
    public static testMethod void testLoginSucceed() {
        
        //Prepare env
        String password = '1234';
        String email = 'alan.feng@4idps.com';
        Account__c preAccount = new Account__c(LastName__c = 'Alan', Password__c = password, Email__c = email);
        insert preAccount;

        //Test constructor
        LoginController controller = new LoginController();
        System.assertNotEquals(null, controller.viewModel.account);

        //Test function
        Account__c account = controller.viewModel.account;
        account.Password__c = password;
        account.Email__c = email;
        
        //controller.submit();

    }

    public static testMethod void testLoginFailed() {

    }
}
