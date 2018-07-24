@isTest
public with sharing class NewSubscriptionControllerTestCase {
    public static testMethod void testPageInit() {
        NewSubscriptionController controller = new NewSubscriptionController();
        System.assertEquals(false, controller.isChooseCreditcard);
        System.assertEquals(false, controller.showProgramResult);
        System.assertEquals(false, controller.showErrorForNullProgram);
        System.assertNotEquals(null, controller.subscriptionInsertList);
    }

    public static testMethod void testNewSubscription_ProgramId_Null_Return_Null() {
        NewSubscriptionController controller = new NewSubscriptionController();
        Pagereference page = controller.newSubscription();
        System.assertEquals(null, page);
        System.assertEquals(true, controller.showErrorForNullProgram);
    }

    // public static testMethod void deleteSubscription_deleteRowId_0_Size_0() {
    //     NewSubscriptionController controller = new NewSubscriptionController();
    //     Account__c account =  new Account__c(Email__c = 'jin@4idps.com');
    //     insert account;
    //     controller.viewModel.account.id = account.id;
    //     controller.newSubscription();
    //     controller.deleteRowId = 1;
    //     System.assertEquals(1, controller.tempSubscriptions.size());
    // }

    public static testMethod void testCreditcard_Year_Selection() {
        NewSubscriptionController controller = new NewSubscriptionController();
        List<SelectOption> year = controller.getCreditcard_Year();
        System.assertNotEquals(null, year);
    }

    public static testMethod void testCreditcard_Month_Selection() {
        NewSubscriptionController controller = new NewSubscriptionController();
        List<SelectOption> month = controller.getCreditcard_Month();
        System.assertNotEquals(null, month);
    }

    public static testMethod void testGetProductRadioButton_No_Product() {
        NewSubscriptionController controller = new NewSubscriptionController();
        List<SelectOption> options = controller.getProductRadioButton();
        Integer size = options.size();
        System.assertEquals(1, size);
    }

    public static testMethod void testGetProductRadioButton() {
        Product2 product = new Product2(Name = '草', ProductCode = '2', StartDate__c = Date.valueOf(System.now())-1, 
            EndDate__c = Date.valueOf(System.now())+8);
        Product2 product2 = new Product2(Name = '花', ProductCode = '3', StartDate__c = Date.valueOf(System.now())+9, 
        EndDate__c = Date.valueOf(System.now())+20);
        
        insert product;
        insert product2;
        NewSubscriptionController controller = new NewSubscriptionController();
        List<SelectOption> options = controller.getProductRadioButton();
        Integer size = options.size();
        System.assertEquals(2, size);
        System.assertEquals('草', options.get(0).getLabel());
    }

    public static testMethod void testPaymentOption() {
        NewSubscriptionController controller = new NewSubscriptionController();
        List<SelectOption> options = controller.getPaymentOptions();
        System.assertNotEquals(null, options);
    }

    public static testMethod void testProgramSelction() {
        SubscriptionProgram__c program = new SubscriptionProgram__c(ProgramName__c = 'a', ProgramId__c = '1');
        insert program;
        NewSubscriptionController controller = new NewSubscriptionController();
        List<SelectOption> options = controller.getProgramSelection();
        System.assertNotEquals(null, options);
    }

    public static testMethod void testPaymentMethod_Credit_isChooseCreditcard_True() {
        NewSubscriptionController controller = new NewSubscriptionController();
        controller.paymentMethod = '信用卡';
        Pagereference page = controller.chooseCreditCard();
        System.assertEquals(true, controller.isChooseCreditcard);
        System.assertEquals(null, page);
    }

    public static testMethod void testPaymentMethod_Not_Credit_isChooseCreditcard_False() {
        NewSubscriptionController controller = new NewSubscriptionController();
        controller.paymentMethod = 'ATM';
        Pagereference page = controller.chooseCreditCard();
        System.assertEquals(false, controller.isChooseCreditcard);
        System.assertEquals(null, page);
    }

    public static testMethod void testTurn_To_UpdateCreditcardPage() {
        NewSubscriptionController controller = new NewSubscriptionController();
        Pagereference page = controller.toUpdateCreditcardPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_SummaryPage() {
        NewSubscriptionController controller = new NewSubscriptionController();
        Pagereference page = controller.toSummaryPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_AccountSettingPage() {
        NewSubscriptionController controller = new NewSubscriptionController();
        Pagereference page = controller.toAccountSettingPage();
        System.assertNotEquals(null, page);
    }
    public static testMethod void testTurn_To_SubscriptionManagementPage() {
        NewSubscriptionController controller = new NewSubscriptionController();
        Pagereference page = controller.toSubscriptionManagementPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLogOut() {
        NewSubscriptionController controller = new NewSubscriptionController();
        Pagereference page = controller.logOut();
        System.assertNotEquals(null, page);
    }
}
