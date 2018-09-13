@isTest
public with sharing class PaymentResultControllerTestCases {
    // public static testMethod void testConstructor() {
    //     Account account = new Account(LastName = 'jin');
    //     account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
    //     insert account; 
    //     GMOPaymentBean__c paymentBean = new GMOPaymentBean__c(contract_code__c = '10081070', order_number__c = '784420180802115557', st_code__c = '00010-00000-00000-00000-00000-00000-00000', trans_code__c = '131551');
    //     insert paymentBean;
        
    //     Test.setCurrentPage(Page.RegisterResultPage);
    //     ApexPages.currentPage().getParameters().put('ordernumber', paymentBean.order_number__c);
    //     PaymentResultController controller = new PaymentResultController(account.id);
    //     System.assertEquals(Constants.PAYMENT_METHOD_ATM, controller.paymentMethod);
    // }

    public static testMethod void testTurn_To_SummaryPage() {
        PaymentResultController controller = new PaymentResultController();
        Pagereference page = controller.toSummaryPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLogOut() {
        PaymentResultController controller = new PaymentResultController();
        Pagereference page = controller.logOut();
        System.assertNotEquals(null, page);
    }
}
