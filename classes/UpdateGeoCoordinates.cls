public class UpdateGeoCoordinates implements Queueable, Database.AllowsCallouts {

    private Set<Id> recordIds;
    private static String GoogleAPIname= 'DirectionsAPI';

    public UpdateGeoCoordinates(Set<Id> recordIds) {
        this.recordIds = recordIds;
    }

    public void execute(QueueableContext context) {
        List<Order> records = [SELECT Id, ShippingCity, ShippingStreet, ShippingLongitude, ShippingLatitude FROM Order WHERE Id IN: recordIds LIMIT 10000];
        if (!records.isEmpty()) {      
            for (Order record : records) {
                if(record.ShippingCity != null && record.ShippingStreet != null) {
        
                    String address = '';
                    address += '+' + record.ShippingCity;
                    address += '+' + record.ShippingStreet;
                        
                    String encodedAddress = EncodingUtil.urlEncode(address, 'UTF-8');
    				System.debug(encodedAddress);
                    HttpRequest req = new HttpRequest();
                    System.debug(GoogleAPIkey__c.getValues(GoogleAPIname).key__c);
                    req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + encodedAddress +'&key=' + GoogleAPIkey__c.getValues(GoogleAPIname).key__c);
                    req.setMethod('GET');
                    Http http = new Http();
                    HttpResponse res = http.send(req);
        			
                    if (res.getStatusCode() != 200) continue;
                    GoogleJSONParser.Response prasResp = GoogleJSONParser.parse(res.getBody());
                    if (prasResp != null && !prasResp.Results.isEmpty()) {                            
                        record.ShippingLongitude = (Double) prasResp.Results[0].Geometry.Location.lng;
                        record.ShippingLatitude = (Double) prasResp.Results[0].Geometry.Location.lat;
                    }
                    System.debug(record);
                }             
            }
            update records;
		}        
    }
}