@isTest
public with sharing class UpdateCreditCardControllerTestCase {
    public static testMethod void testCancel() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        Pagereference page = controller.cancel();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testCreditcard_Year_Selection() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        List<SelectOption> year = controller.getCreditcard_Year();
        System.assertNotEquals(null, year);
    }

    public static testMethod void testCreditcard_Month_Selection() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        List<SelectOption> month = controller.getCreditcard_Month();
        System.assertNotEquals(null, month);
    }

    public static testMethod void testViewModel_updateAccount_Success_Return_True() {
        UpdateCreditCardController controller = new UpdateCreditCardController();
        
    }
}
