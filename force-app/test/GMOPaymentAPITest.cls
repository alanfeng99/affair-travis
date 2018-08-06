@isTest
public class GMOPaymentAPITest {
    public static GMOPaymentBean__c buildGMOPaymentBean() {
        GMOPaymentBean__c gmoPaymentBean = new GMOPaymentBean__c();

        gmoPaymentBean.contract_code__c = '10081070';
        gmoPaymentBean.version__c = '1';
        gmoPaymentBean.process_code__c = '1';
        gmoPaymentBean.user_id__c = 'test0001';
        gmoPaymentBean.user_name__c = 'Yamada Tarou';
        gmoPaymentBean.user_mail_add__c = 'test@test.com';
        gmoPaymentBean.lang_id__c = 'en';
        gmoPaymentBean.ip_address__c = '111.250.156.96';
        gmoPaymentBean.user_agent__c = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36';
        gmoPaymentBean.item_code__c = 'GP-0001';
        gmoPaymentBean.item_name__c = 'Apple';
        gmoPaymentBean.order_number__c = Datetime.now().format('yyyyMMddHHmmss');
        gmoPaymentBean.st_code__c = '10000-00000-00000-00000-00000-00000-00000';
        gmoPaymentBean.mission_code__c = '1';
        gmoPaymentBean.currency_id__c = 'TWD';
        gmoPaymentBean.item_price__c = '840';
        gmoPaymentBean.card_number__c = '4234567890123456';
        gmoPaymentBean.expire_year__c = '2020';
        gmoPaymentBean.expire_month__c = '12';
        gmoPaymentBean.security_code__c = '123';
        gmoPaymentBean.pan_bank__c = 'CitiBank';
        gmoPaymentBean.pan_country__c = 'TW';
        gmoPaymentBean.card_holder_name__c = 'TOM YAMADA';
        gmoPaymentBean.add_info1__c = '1';

        return gmoPaymentBean;
    }

    public static String buildDirectPaymentResponse() {
        return '<?xml version="1.0" encoding="UTF-8" ?>' +
        '<GlobalPayment_result>' +
        '    <result result="9" />' +
        '    <result trans_code="" />' +
        '    <result err_code="LO01000013" />' +
        '    <result err_detail="Card%20information%20is%20incorrect%20%28NEWEB%20order%20information%20acquisition%20error%29" />' +
        '    <result access_url="" />' +
        '    <result trans_code_hash="" />' +
        '    <result payment_code="" />' +
        '    <result mode="" />' +
        '    <result status="" />' +
        '</GlobalPayment_result>';
    }

    public static testMethod void testAddCommonGMOPaymentBeanValues() {
        GMOPaymentBean__c gmoPaymentBean = buildGMOPaymentBean();
        GMOPaymentAPI api = new GMOPaymentAPI(gmoPaymentBean);
        gmoPaymentBean = api.addCommonGMOPaymentBeanValues(gmoPaymentBean);

        System.assertEquals('UTF-8', gmoPaymentBean.character_code__c);
    }

    public static testMethod void testBuildGMOPaymentBodyForDirectPayment() {
        GMOPaymentBean__c gmoPaymentBean = buildGMOPaymentBean();
        GMOPaymentAPI api = new GMOPaymentAPI(gmoPaymentBean);
        String actual = api.buildGMOPaymentBodyForDirectPayment(gmoPaymentBean);
        System.assert(actual.length() > 0);
    }

    public static testMethod void test_getPaymentMethodFromStCode() {
        GMOPaymentBean__c gmoPaymentBean = buildGMOPaymentBean();
        GMOPaymentAPI api = new GMOPaymentAPI(gmoPaymentBean);
        String actual = api.getPaymentMethodFromStCode(Constants.ST_CODE_CREDIT_CARD_PAYMENT);
        System.assertEquals(Constants.PAYMENT_METHOD_CREDIT_CARD, actual);
        
        actual = api.getPaymentMethodFromStCode(Constants.ST_CODE_ATM);
        System.assertEquals(Constants.PAYMENT_METHOD_ATM, actual);

        actual = api.getPaymentMethodFromStCode(Constants.ST_CODE_SUPER_PAYMENT);
        System.assertEquals(Constants.PAYMENT_METHOD_SUPER_PAYMENT, actual);

        actual = api.getPaymentMethodFromStCode(Constants.ST_CODE_NOTHING);
        System.assertEquals('', actual);
    }

    public static testMethod void test_generateProcessCode() {
        String actual = GMOPaymentAPI.generateProcessCode(Constants.PAYMENT_METHOD_CREDIT_CARD);
        System.assertEquals(Constants.PROCESS_CODE_REGISTER_CREDIT_CARD, actual);
        
        actual = GMOPaymentAPI.generateProcessCode(Constants.PAYMENT_METHOD_SUPER_PAYMENT);
        System.assertEquals(Constants.PROCESS_CODE_ONE_TIME, actual);
    }

    public static testMethod void test_generateStCode() {
        String actual = GMOPaymentAPI.generateStCode(Constants.PAYMENT_METHOD_CREDIT_CARD);
        System.assertEquals(Constants.ST_CODE_CREDIT_CARD_PAYMENT, actual);
        
        actual = GMOPaymentAPI.generateStCode(Constants.PAYMENT_METHOD_ATM);
        System.assertEquals(Constants.ST_CODE_ATM, actual);

        actual = GMOPaymentAPI.generateStCode(Constants.PAYMENT_METHOD_SUPER_PAYMENT);
        System.assertEquals(Constants.ST_CODE_SUPER_PAYMENT, actual);

        actual = GMOPaymentAPI.generateStCode('');
        System.assertEquals(Constants.ST_CODE_NOTHING, actual);
    }

    public static testMethod void test_deserializationGMOResponse() {
        GMOPaymentBean__c gmoPaymentBean = buildGMOPaymentBean();
        GMOPaymentAPI api = new GMOPaymentAPI(gmoPaymentBean);
        GMOPaymentBean__c beanAPIResponse = (GMOPaymentBean__c) api.deserializationGMOResponse(buildDirectPaymentResponse(), GMOPaymentBean__c.class);
        String actual = beanAPIResponse.result__c;
        System.assertEquals('9', actual);
    }
    
}