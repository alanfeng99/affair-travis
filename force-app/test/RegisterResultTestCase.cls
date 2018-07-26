@isTest
public with sharing class RegisterResultControllerTestCase {
    public static testMethod void testGetAccount_Info() {
        Account__c account = new Account__c(Email__c = 'jin@4idps.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        RegisterResultController controller = new RegisterResultController();
        System.assertNotEquals(null, controller.viewModel);
    }

    public static testMethod void testViewModel_Get_Account() {
        Account__c account = new Account__c(Email__c = 'jin@4idps.com');
        insert account;
        Test.setCurrentPage(Page.RegisterResultPage);
        ApexPages.currentPage().getParameters().put('id',account.id);
        
        RegisterResultController controller = new RegisterResultController();
        Account__c accountForViewModel = controller.viewModel.getAccount();
        System.assertNotEquals(null, accountForViewModel);
    }
}
