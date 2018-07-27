@isTest
public  class updateCreditCardTestCases {
    public static testMethod void testViewModel_Constuctor() {
        Account__c account = new Account__c(Email__c = 'jin@ga.com');
        insert account;
        UpdateCreditCardViewModel viewModel = new UpdateCreditCardViewModel(account.id);
        System.assertNotEquals(null, viewModel.account);
        System.assertNotEquals(null, viewModel.subscriptions);
        System.assertNotEquals(null, viewModel.creditCardBean); 
    }

    public static testMethod void testUpdateAccount() {
        Account__c account = new Account__c(Email__c = 'jin@ga.com');
        insert account;
        UpdateCreditCardViewModel viewModel = new UpdateCreditCardViewModel(account.id);
        Boolean result = viewModel.updateAccount();
        System.assertEquals(true, result);
    }
}
