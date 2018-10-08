@RestResource(urlMapping='/gmopayment/updatestatus')
global with sharing class GMOPaymentWebhook {
    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        String bodyString = req.requestBody.toString();
        new ApexLogger.InfoLog('GMOPaymentWebhook', '/gmopayment/updatestatus/doGet', 'BodyString=' + bodyString);
        
        return '';
    }

    @HttpPost
    global static String doPost() {
        try {
            RestRequest req = RestContext.request;
            String bodyString = req.requestBody.toString();
            new ApexLogger.InfoLog(GMOPaymentWebhook.class.getName(), '/gmopayment/updatestatus/doPost', 'BodyString=' + bodyString);
        } catch (Exception ex) {
            new ApexLogger.ErrorLog(ex);
        }
        
        return null;
    }
}