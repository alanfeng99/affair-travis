@isTest
public  class updateCreditCardTestCases {
    public static testMethod void testViewModel_Constuctor() {
        Account account = new Account(PersonEmail = 'jin@ga.com', LastName = 'Alan');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        UpdateCreditCardViewModel viewModel = new UpdateCreditCardViewModel(account.id);
        System.assertNotEquals(null, viewModel.account);
        System.assertNotEquals(null, viewModel.subscriptions);
        System.assertNotEquals(null, viewModel.creditCardBean); 
    }

    public static testMethod void testUpdateAccount() {
        Account account = new Account(PersonEmail = 'jin@ga.com', LastName = 'Alan');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        UpdateCreditCardViewModel viewModel = new UpdateCreditCardViewModel(account.id);
        Boolean result = viewModel.updateAccount();
        System.assertEquals(true, result);
    }

    public static testMethod void testTurn_To_UpdateCreditcardPage() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        Pagereference page = controller.toUpdateCreditcardPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_SummaryPage() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        Pagereference page = controller.toSummaryPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_AccountSettingPage() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        Pagereference page = controller.toAccountSettingPage();
        System.assertNotEquals(null, page);
    }
    public static testMethod void testTurn_To_SubscriptionManagementPage() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        Pagereference page = controller.toSubscriptionManagementPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLogOut() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        Pagereference page = controller.logOut();
        System.assertNotEquals(null, page);
    }
}
