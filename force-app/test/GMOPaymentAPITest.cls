public class GMOPaymentAPITest {
    public GMOPaymentBean buildGMOPaymentBean() {
        GMOPaymentBean gmoPaymentBean = new GMOPaymentBean();

        gmoPaymentBean.contract_code = '10081070';
        gmoPaymentBean.version = '1';
        gmoPaymentBean.character_code = 'UTF-8';
        gmoPaymentBean.process_code = '1';
        gmoPaymentBean.user_id = 'test0001';
        gmoPaymentBean.user_name = 'Yamada Tarou';
        gmoPaymentBean.user_mail_add = 'test@test.com';
        gmoPaymentBean.lang_id = 'en';
        gmoPaymentBean.ip_address = '111.250.156.96';
        gmoPaymentBean.user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36';
        gmoPaymentBean.item_code = 'GP-0001';
        gmoPaymentBean.item_name = 'Apple';
        gmoPaymentBean.order_number = Datetime.now().format('yyyyMMddHHmmss');
        gmoPaymentBean.st_code = '10000-00000-00000-00000-00000-00000-00000';
        gmoPaymentBean.mission_code = '1';
        gmoPaymentBean.currency_id = 'TWD';
        gmoPaymentBean.item_price = '840';
        gmoPaymentBean.card_number = '4234567890123456';
        gmoPaymentBean.expire_year = '2020';
        gmoPaymentBean.expire_month = '12';
        gmoPaymentBean.security_code = '123';
        gmoPaymentBean.pan_bank = 'CitiBank';
        gmoPaymentBean.pan_country = 'TW';
        gmoPaymentBean.card_holder_name = 'TOM YAMADA';
        gmoPaymentBean.add_info1 = '1';

        return gmoPaymentBean;
    }
}