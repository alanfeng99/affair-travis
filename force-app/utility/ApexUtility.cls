public with sharing class ApexUtility {
    public static PageReference toPage(String myVar){
        PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/' + myVar);
    	page.setRedirect(true);
    	return page;  
    }

    public static String generateRandomAlphaNumeric(Integer size) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randomAlphaNumeric = '';

        for (Integer i = 0; i < size; i++) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randomAlphaNumeric += chars.substring(idx, idx+1);
        }
        return randomAlphaNumeric;
    }

    public static String generateRandomNumeric(Integer size) {
        final String chars = '0123456789';
        String randomAlphaNumeric = '';

        for (Integer i = 0; i < size; i++) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randomAlphaNumeric += chars.substring(idx, idx+1);
        }
        return randomAlphaNumeric;
    }

     public static String getUserIPAddress() {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint( 'https://www.trackip.net/ip?json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String jsonInput = res.getBody();
        
        Map<String,String> responseBodyMapped = (Map<String,String>)JSON.deserialize(jsonInput, Map<String,String>.class);
        		
        return responseBodyMapped.get('IP');
    }
    
}