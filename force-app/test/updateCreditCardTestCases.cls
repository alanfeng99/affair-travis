@isTest
public  class updateCreditCardTestCases {
    public static testMethod void testViewModel_Constuctor() {
        Account account = new Account(PersonEmail = 'jin@ga.com');
        insert account;
        UpdateCreditCardViewModel viewModel = new UpdateCreditCardViewModel(account.id);
        System.assertNotEquals(null, viewModel.account);
        System.assertNotEquals(null, viewModel.subscriptions);
        System.assertNotEquals(null, viewModel.creditCardBean); 
    }

    public static testMethod void testUpdateAccount() {
        Account account = new Account(PersonEmail = 'jin@ga.com');
        insert account;
        UpdateCreditCardViewModel viewModel = new UpdateCreditCardViewModel(account.id);
        Boolean result = viewModel.updateAccount();
        System.assertEquals(true, result);
    }
}
