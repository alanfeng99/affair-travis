@isTest
public with sharing class ApexBaseUtilityTestCases extends ApexBaseController{
    public static testMethod void testCheckCookie_Logout() {
        ApexBaseController controller = new ApexBaseController();
        PageReference page = controller.checkCookie();
        System.assertNotEquals(null, page);
    }
}
