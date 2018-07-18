@isTest
public class GMOPaymentAPITest {
    public GMOPaymentBean__c buildGMOPaymentBean() {
        GMOPaymentBean__c gmoPaymentBean = new GMOPaymentBean__c();

        gmoPaymentBean.contract_code__c = '10081070';
        gmoPaymentBean.version__c = '1';
        gmoPaymentBean.character_code__c = 'UTF-8';
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
}