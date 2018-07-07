@isTest
public  class accountSettingTestCases {
    
    public static testMethod void runAccountSettingTests() {
        String email = 'alan.feng@4idps.com';
        String email2 = 'alan.feng2@4idps.com';

        Account__c account = new Account__c(LastName__c = 'Alan', Email__c = email);
        insert account;

        System.assertNotEquals(null, account.Id);

        AccountSettingController controller = new AccountSettingController();
        //Account account2 = controller.getAccount();

        //System.assertEquals(account.Id, account2.Id);

        //account2.PersonEmail = email2;
        //controller.submit();
        //Account account3 = [Select Id from Account where PersonEmail = :email2];
        
        //System.assertEquals(account.Id, account3.Id);
    }
}