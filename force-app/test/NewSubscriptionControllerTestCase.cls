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

    public static testMethod void testNewSubscription_ProgramId_Not_Null() {
        Account account = new Account(PersonEmail = 'jin@222.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        SubscriptionProgram__c program = new SubscriptionProgram__c(ProgramId__c = '123', Price__c = 400, Name = 'a');
        insert program;
        
        NewSubscriptionController controller = new NewSubscriptionController(account.id);
        controller.programId = program.ProgramId__c;
        //controller.viewModel.account.id = account.id;
        PageReference page = controller.newSubscription();
        System.assertNotEquals(null, controller.newSubscription);
        System.assertEquals(2, controller.newSubscription.Index__c);
        System.assertEquals(2, controller.subscriptionSize);
        System.assertEquals(null, page);

    }

    public static testMethod void deleteSubscription_deleteRowId_0_Size_0() {
        Account account =  new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        NewSubscriptionController controller = new NewSubscriptionController(account.id);
        controller.deleteRowId = 1;
        Pagereference page = controller.deleteSubscription();
        System.assertEquals(0, controller.tempSubscriptions.size());
        System.assertEquals(null, page);
    }

    public static testMethod void testProgramPriceDecide() {
        SubscriptionProgram__c program = new SubscriptionProgram__c(ProgramId__c = '123', Price__c = 400, Name = 'a');
        insert program;
        NewSubscriptionController controller = new NewSubscriptionController();
        controller.programId = program.ProgramId__c;
        controller.subscriptionSize = 1;
        Pagereference page = controller.programPriceDecide();
        System.assertEquals(400, controller.programPrice);
        System.assertEquals('a', controller.programName);
        System.assertEquals(400, controller.programTotalPrice);
        System.assertEquals(true, controller.showProgramResult);
        System.assertEquals(false, controller.showErrorForNullProgram);
        System.assertEquals(null, page);
    }

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
        System.assertEquals('當期', options.get(0).getLabel());
    }

    public static testMethod void testPaymentOption() {
        NewSubscriptionController controller = new NewSubscriptionController();
        List<SelectOption> options = controller.getPaymentOptions();
        System.assertNotEquals(null, options);
    }

    public static testMethod void testProgramSelction() {
        SubscriptionProgram__c program = new SubscriptionProgram__c(Name = 'a', ProgramId__c = '1');
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

    public static testMethod void testSubmitForm_ProgramId_Null_Return_Msg() {
        NewSubscriptionController controller = new NewSubscriptionController();
        Pagereference page = controller.submitForm();
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_ProgramEmpty);
    }

    public static testMethod void testSubmitForm_CheckField_StartPeriod_Null_Return_False() {
        SubscriptionProgram__c program = new SubscriptionProgram__c(ProgramId__c = '123', Price__c = 400, Name = 'a');
        insert program;
        Account account =  new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        NewSubscriptionController controller = new NewSubscriptionController(account.Id);
        controller.programId = program.ProgramId__c;
        controller.paymentMethod = 'ATM';

        Pagereference page = controller.submitForm();
        System.assertEquals(1, controller.subscriptionInsertList.size());
        System.assertEquals('ATM', controller.firstSubscription.Payment_method__c);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_PeriodEmpty);
    }

    public static testMethod void testSubmitForm_CheckField_Reciepient_Null_Return_False() {
        SubscriptionProgram__c program = new SubscriptionProgram__c(ProgramId__c = '123', Price__c = 400, Name = 'a');
        insert program;
        Account account =  new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        NewSubscriptionController controller = new NewSubscriptionController(account.Id);
        controller.programId = program.ProgramId__c;
        controller.paymentMethod = 'ATM';
        controller.startPeriod = '2';

        Pagereference page = controller.submitForm();
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_RecipientInfoEmpty);
    }

    public static testMethod void testSubmitForm_CheckField_Reciepient_Not_Null_Tel_Format_Wrong_Return_False() {
        SubscriptionProgram__c program = new SubscriptionProgram__c(ProgramId__c = '123', Price__c = 400, Name = 'a');
        insert program;
        Account account =  new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        NewSubscriptionController controller = new NewSubscriptionController(account.Id);
        controller.programId = program.ProgramId__c;
        controller.paymentMethod = 'ATM';
        controller.startPeriod = '2';
        
        controller.firstSubscription.Recipient__c = 'jin';
        controller.firstSubscription.City_picklist__c = '台北市';
        controller.firstSubscription.Area_picklist__c = '松山區';
        controller.firstSubscription.Address__c = '123';
        controller.firstSubscription.Tel__c = '123';
        controller.firstSubscription.Email__c = 'jin@4idps.com';
    

        Pagereference page = controller.submitForm();
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_RecipientInfoEmpty);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_PhoneFormat);
    }

    public static testMethod void testSubmitForm_CheckField_Tel_Format_Right_Paymentmethod_Null_Return_False() {
        SubscriptionProgram__c program = new SubscriptionProgram__c(ProgramId__c = '123', Price__c = 400, Name = 'a');
        insert program;
        Account account =  new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        NewSubscriptionController controller = new NewSubscriptionController(account.Id);
        controller.programId = program.ProgramId__c;
        controller.startPeriod = '2';
        
        controller.firstSubscription.Recipient__c = 'jin';
        controller.firstSubscription.City_picklist__c = '台北市';
        controller.firstSubscription.Area_picklist__c = '松山區';
        controller.firstSubscription.Address__c = '123';
        controller.firstSubscription.Tel__c = '0987777888';
        controller.firstSubscription.Email__c = 'jin@4idps.com';
    
        Pagereference page = controller.submitForm();
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_PhoneFormat);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_PaymentEmpty);
    }

    public static testMethod void testSubmitForm_CheckField_Creditcard_Info_Not_Complete_Return_False() {
        SubscriptionProgram__c program = new SubscriptionProgram__c(ProgramId__c = '123', Price__c = 400, Name = 'a');
        insert program;
        Account account =  new Account(PersonEmail = 'jin@4idps.com', LastName = 'Jin');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        insert account;
        NewSubscriptionController controller = new NewSubscriptionController(account.Id);
        controller.programId = program.ProgramId__c;
        controller.paymentMethod = '信用卡';
        controller.startPeriod = '2';
        
        controller.firstSubscription.Recipient__c = 'jin';
        controller.firstSubscription.City_picklist__c = '台北市';
        controller.firstSubscription.Area_picklist__c = '松山區';
        controller.firstSubscription.Address__c = '123';
        controller.firstSubscription.Tel__c = '0987777888';
        controller.firstSubscription.Email__c = 'jin@4ifps.com';
    

        Pagereference page = controller.submitForm();
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_PaymentEmpty);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Creditcard_CheckAll);
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
