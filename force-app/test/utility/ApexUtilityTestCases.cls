@isTest
public with sharing class ApexUtilityTestCases {

    public static testMethod void testGenerateRandomAlphaNumeric() {
        String actual = ApexUtility.generateRandomAlphaNumeric(0);
        System.assertEquals('', actual);
    }

    public static testMethod void testGenerateRandomNumeric() {

        String actual = ApexUtility.generateRandomNumeric(0);
        System.assertEquals('', actual);
    }

    private static Contact createContact() {
        Contact contact = new Contact(Email = 'test@test.com', LastName = 'Testlastname');
        return contact;
    }

    private static ContactBean__c createContactBean() {
        ContactBean__c contactBean = new ContactBean__c(Email__c = 'test@test.com', LastName__c = 'Testlastname');
        return contactBean;
    }

    @isTest
    private static void copyNullIntoNull() {
        SObject actual = ApexUtility.copyFirstObjectValuesIntoSecondObject(null, null);
        System.assertEquals(null, actual);
    }

    @isTest
    private static void copyStandardObjectIntoSameObject() {
        Contact objectSource = createContact();
        Contact actual = new Contact();
        actual = (Contact) ApexUtility.copyFirstObjectValuesIntoSecondObject(objectSource, actual);
        
        System.assertNotEquals(null, actual);
        System.assertEquals(objectSource.Email, actual.Email);
    }

    @isTest
    private static void copyStandardObjectIntoCustomObject() {
        Contact objectSource = createContact();
        ContactBean__c actual = new ContactBean__c();
        actual = (ContactBean__c) ApexUtility.copyFirstObjectValuesIntoSecondObject(objectSource, actual);
        
        System.assertNotEquals(null, actual);
        System.assertEquals(objectSource.Email, actual.Email__c);
    }

    @isTest
    private static void copyCustomObjectIntoStandardObject() {
        ContactBean__c objectSource = createContactBean();
        Contact actual = new Contact();
        actual = (Contact) ApexUtility.copyFirstObjectValuesIntoSecondObject(objectSource, actual);

        System.assertNotEquals(null, actual);
        System.assertEquals(objectSource.Email__c, actual.Email);
    }

    @isTest
    private static void test_generateGMOPaymentBeanForCancel() {
        Account account = new Account(PersonEmail = 'jin@fff.com', LastName = 'Jin', Password__c = '1234qwer');
        Order order = new Order();
        order.paymentMethod = Constants.PAYMENT_METHOD_ATM;
        order.itemCode = '0';
        order.itemName = 'Test';
        order.totalPrice = '0';
        ApexUtility.generateGMOPaymentBeanForCancel(account, order);
    }

    @isTest
    private static void test_generateGMOPaymentBeanForChange() {
        Account account = new Account(PersonEmail = 'jin@fff.com', LastName = 'Jin', Password__c = '1234qwer');
        Order order = new Order();
        order.paymentMethod = Constants.PAYMENT_METHOD_ATM;
        order.itemCode = '0';
        order.itemName = 'Test';
        order.totalPrice = '0';
        CreditCardBean creditCardBean = new CreditCardBean();
        creditCardBean.cc = '4123412341234123';
        creditCardBean.expireYear = '01';
        creditCardBean.expireMonth = '2020';
        creditCardBean.cvc = '123';

        ApexUtility.generateGMOPaymentBeanForChange(account, order, creditCardBean);
    }

    @isTest
    private static void test_generateGMOPaymentBeanForPayment() {
        Account account = new Account(PersonEmail = 'jin@fff.com', LastName = 'Jin', Password__c = '1234qwer');
        Order order = new Order();
        order.paymentMethod = Constants.PAYMENT_METHOD_ATM;
        order.itemCode = '0';
        order.itemName = 'Test';
        order.totalPrice = '0';
        CreditCardBean creditCardBean = new CreditCardBean();
        creditCardBean.cc = '4123412341234123';
        creditCardBean.expireYear = '01';
        creditCardBean.expireMonth = '2020';
        creditCardBean.cvc = '123';

        ApexUtility.generateGMOPaymentBeanForPayment(account, order, creditCardBean);
    }
}