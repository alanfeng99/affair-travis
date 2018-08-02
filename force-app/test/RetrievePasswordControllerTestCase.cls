@isTest
public with sharing class RetrievePasswordControllerTestCase {
    public static testMethod void testSubmit_No_Email_Return_Null() {
        RetrievePasswordController controller = new RetrievePasswordController();
        Pagereference page = controller.submit();
        System.assertEquals(null, page);
    }

    public static testMethod void testSubmit_sendEmail_Fail_Return_Message() {
        RetrievePasswordController controller = new RetrievePasswordController();
        controller.account.PersonEmail = 'jin@4a.com';
        Pagereference page = controller.submit();
        System.assertEquals(null, page);
        System.assertEquals(System.Label.Msg_EmailNotExist, controller.baseErrorMessage);
    }

    public static testMethod void testSubmit_Success() {
        Account account = new Account(PersonEmail = 'jin@4idps.com');
        insert account;
        RetrievePasswordController controller = new RetrievePasswordController();
        controller.account.PersonEmail = 'jin@4idps.com';
        Pagereference page = controller.submit();
        System.assertNotEquals(null, page);
    }
}
