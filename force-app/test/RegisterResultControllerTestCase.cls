@isTest
public with sharing class RegisterResultControllerTestCase {
    public static testMethod void testGetAccount_Info() {
        Account account = new Account(PersonEmail = 'jin@4idps.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        RegisterResultController controller = new RegisterResultController();
        System.assertNotEquals(null, controller.viewModel);
    }

    public static testMethod void testViewModel_Get_Account() {
        Account account = new Account(PersonEmail = 'jin@4idps.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        
        RegisterResultController controller = new RegisterResultController();
        Account accountForViewModel = controller.viewModel.getAccount();
        System.assertNotEquals(null, accountForViewModel);
    }
}
