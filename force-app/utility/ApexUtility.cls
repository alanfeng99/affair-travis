public with sharing class ApexUtility {
    public static PageReference toPage(String myVar){
        PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/' + myVar);
    	page.setRedirect(true);
    	return page;  
    }
}