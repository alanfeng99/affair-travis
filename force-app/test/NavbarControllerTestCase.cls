@isTest
public with sharing class NavbarControllerTestCase {
    public static testMethod void testTurn_To_SummaryPage() {
        NavbarController controller = new NavbarController();
        Pagereference page = controller.toSummaryPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testTurn_To_AccountSettingPage() {
        NavbarController controller = new NavbarController();
        Pagereference page = controller.toAccountSettingPage();
        System.assertNotEquals(null, page);
    }
    public static testMethod void testTurn_To_SubscriptionManagementPage() {
        NavbarController controller = new NavbarController();
        Pagereference page = controller.toSubscriptionManagementPage();
        System.assertNotEquals(null, page);
    }

    public static testMethod void testLogOut() {
        NavbarController controller = new NavbarController();
        Pagereference page = controller.logOut();
        System.assertNotEquals(null, page);
    }
}
