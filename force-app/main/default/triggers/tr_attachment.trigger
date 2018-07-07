trigger tr_attachment on Attachment (after insert, after delete, after undelete) {
//ArtIds 先裝下所有本次觸發的附件中，image類別的父ID
    List<Id> imageIds = new List<Id>();
    List<Attachment> triggernew = new List<Attachment>();
    
    if(trigger.isDelete) {
	    triggernew = trigger.old;  
    } else {
        triggernew = trigger.new;   
    }
    
    for(Attachment Att:triggernew){
        if(Att.ContentType.contains('image')) 
        {
            imageIds.add(Att.ParentId);            	
        }
    }
    List<Product2> products = new List<Product2>();
    
    //AWs中放入需要被更新PURL的資料
    if(imageIds.size()>0) {
	     products = [Select Id,PicturePath__c from Product2 where Id in :imageIds];  
    } 
	
    //清空ArtIds重新放入只有ArtWork的ID
    imageIds.clear();
    
    for(Product2 product : products) {
        imageIds.add(product.Id);
    } 
    
    //Pics中放入可能被放入PURL的附件
    List<Attachment> Pics = [Select Id,ParentId,ContentType from Attachment where ParentId in :products and ContentType like '%image%' order by Id];
    
    //開始更新ArtWork的PURL，只要一但填入，就不再更新
    string xFlag;
    
    for(Product2 product:products){
        product.PicturePath__c=null;
        for(Attachment Att:Pics){
            if(Att.ParentId==product.Id && Att.ContentType.contains('image')) 
                If(product.PicturePath__c==null){
                    product.PicturePath__c = System.Label.BASE_IMAGE_URL + Att.Id;
                }
        }
    }
    if(products.size()>0) update products;
}