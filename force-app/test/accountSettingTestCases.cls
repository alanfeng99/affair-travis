@isTest
public  class accountSettingTestCases {
    @testSetup
    public static void createAccountForTest() {
        Account account = new Account(PersonEmail = 'jin@fff.com', LastName = 'Jin', Password__c = '1234qwer');
        account.recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' and SObjectType = 'Account'].Id;
        
        insert account;
    }

    public static testMethod void testAccountSettingCustructor() {
        Account account = new Account(LastName = 'Alan',PersonEmail = 'jin@fff.com');
        insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        System.assertNotEquals(null, controller.accountVerify);
        System.assertNotEquals(null, controller.accountOld);
        System.assertNotEquals(null, controller.accountNew);
        System.assertEquals(true, controller.isMainShow);
        System.assertEquals(false, controller.ifChangeEmail);
    }

    public static testMethod void testCheckPasswordFormat_OldPassword_Wrong_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234';
        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Password_Old);
    }

    public static testMethod void testCheckPasswordFormat_OldPassword_Right() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_Password_Old);
    }

    public static testMethod void testCheckPasswordFormat_NewPassword_Null_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_PasswordEmpty);
    }

    public static testMethod void testCheckPasswordFormat_NewPassword_Not_Null_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = 'qwertyui';
        
        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_PasswordEmpty);
    }

    public static testMethod void testCheckPasswordFormat_NewPassword_Format_Wrong_NoNumber_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = 'qwertyui';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_PasswordFormat);
    }

    public static testMethod void testCheckPasswordFormat_NewPassword_Format_Wrong_NoLetter_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = '12345678';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_PasswordFormat);
    }

    public static testMethod void testCheckPasswordFormat_NewPassword_Format_Length_Wrong_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = '123qwe';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_PasswordFormat);
    }

    public static testMethod void testCheckPasswordFormat_NewPassword_Format_Right() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = '12345qwert';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_PasswordFormat);
    }

    public static testMethod void testCheckPasswordFormat_accountVerify_Null_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = '12345qwert';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_ValidationEmpty);
    }

    public static testMethod void testCheckPasswordFormat_accountVerify_Not_Null_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = '12345qwert';
        controller.accountVerify.Password__c = '12345qwt';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertNotEquals(controller.baseErrorMessage, System.Label.Msg_ValidationEmpty);
    }

    public static testMethod void testCheckPasswordFormat_accountVerify_Not_Same_For_NewAccount_Return_False() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = '12345qwert';
        controller.accountVerify.Password__c = '12345qwt';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_Password_Inconsistent);
    }

    public static testMethod void testCheckPasswordFormat_Right() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.accountOld.Password__c = '1234qwer';
        controller.accountNew.Password__c = '12345qwert';
        controller.accountVerify.Password__c = '12345qwert';

        Pagereference page = controller.submitPassword();
        System.assertEquals(null, page);
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_UpdateCompleted);
    }

    public static testMethod void testSubmitName_LastName_Null_Return_Msg() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        
        controller.viewModel.newLastName = null;
        Pagereference page = controller.submitName();
        
        System.assertEquals(null, page);
        System.assertEquals(System.Label.Msg_NameEmpty, controller.baseErrorMessage);
    }

    public static testMethod void testSubmitName_LastName_Not_Null_Return_Msg() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);

        Pagereference page = controller.submitName();
        System.assertEquals(null, page);
        System.assertNotEquals(System.Label.Msg_NameEmpty, controller.baseErrorMessage);
        System.assertEquals(System.Label.Msg_UpdateCompleted, controller.baseErrorMessage);
    }

    public static testMethod void testViewModel_UpdateEmail_Email_Exist() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.viewModel.account.PersonEmail = 'jin@fff.com';
        
        Boolean updateEmail = controller.viewModel.updateEmail();
        System.assertEquals(false, updateEmail);
    }

    public static testMethod void testViewModel_UpdateEmai() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.viewModel.newEmail = 'jin@ggg.com';
        
        Boolean updateEmail = controller.viewModel.updateEmail();
        System.assertEquals(true, updateEmail);
        System.assertEquals(false, controller.viewModel.account.Active__c);
    }

    public static testMethod void testSubmitEmail_Email_Null_Return_Msg() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        Pagereference page = controller.submitEmail();
        System.assertEquals(null, page); 
        System.assertEquals(System.Label.Msg_AccountAlreadyExist, controller.baseErrorMessage);
    }

    public static testMethod void testSubmitEmail_Email_Not_Null_Return_Msg() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.viewModel.newEmail = 'jin@ggg.com';
        Pagereference page = controller.submitEmail();
        System.assertNotEquals(null, page); 
        System.assertNotEquals(System.Label.Msg_EmailEmpty, controller.baseErrorMessage);
    }

    public static testMethod void testSubmitEmail_Email_Update_Complete_Return_Msg() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.viewModel.newEmail = 'jin@ggg.com';
        Pagereference page = controller.submitEmail();
        System.assertNotEquals(null, page); 
        System.assertEquals(System.Label.Msg_UpdateCompleted, controller.baseErrorMessage);
    }

    public static testMethod void testSubmitEmial_UpdateEmail_Fail_Return_Msg() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        controller.viewModel.account.PersonEmail = 'jin@fff.com';
        Pagereference page = controller.submitEmail();
        System.assertEquals(controller.baseErrorMessage, System.Label.Msg_AccountAlreadyExist);
        System.assertEquals(null, page); 
    }

    public static testMethod void testChagneName() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        Pagereference page = controller.changeName();
        System.assertEquals(true, controller.isChangeName);
        System.assertEquals(null, page); 
    }

    public static testMethod void testChagneEmail() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        Pagereference page = controller.changeEmail();
        System.assertEquals(true, controller.isChangeEmail);
        System.assertEquals(null, page); 
    }

    public static testMethod void testChagnePassword() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        Pagereference page = controller.changePassword();
        System.assertEquals(true, controller.isChangePassword);
        System.assertEquals(null, page); 
    }

    public static testMethod void testChangeCreditCard() {
        Account account = [SELECT ID FROM Account WHERE PersonEmail = 'jin@fff.com'];
        // insert account;
        AccountSettingController controller = new AccountSettingController(account.id);
        Pagereference page = controller.changeCreditCard();
        System.assertNotEquals(null, page); 
    }

    public static testMethod void testTurn_To_SummaryPage() {
        AccountSettingController controller = new AccountSettingController();
        Pagereference page = controller.toSummaryPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_AccountSettingPage() {
        AccountSettingController controller = new AccountSettingController();
        Pagereference page = controller.toAccountSettingPage();
        System.assertNotEquals(null, page);
    }
    public static testMethod void testTurn_To_SubscriptionManagementPage() {
        AccountSettingController controller = new AccountSettingController();
        Pagereference page = controller.toSubscriptionManagementPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLogOut() {
        AccountSettingController controller = new AccountSettingController();
        Pagereference page = controller.logOut();
        System.assertNotEquals(null, page);
    }
}