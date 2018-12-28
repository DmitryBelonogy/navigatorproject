public class UpdateGeoCoordinates implements Queueable, Database.AllowsCallouts {

    private Set<Id> recordIds;
    private static String GoogleAPIname= 'DirectionsAPI';

    public UpdateGeoCoordinates(Set<Id> recordIds) {
        this.recordIds = recordIds;
    }

    public void execute(QueueableContext context) {
        Id sampleid = (new List<Id>(recordIds))[0];
        String objectType = String.valueOf(sampleid.getsobjecttype());
        
        String query = 'SELECT Id, ShippingCity, ShippingStreet, ShippingLongitude, ShippingLatitude FROM ';
        query += objectType;
        query += ' WHERE Id IN: recordIds LIMIT 10000';
        
        List<sObject> records = Database.query(query);
        if (!records.isEmpty()) {
            for (sObject record : records) {               
                if(record.get('ShippingCity') != null && record.get('ShippingStreet') != null) {
            
                    String address = '';
                    address += '+' + record.get('ShippingCity');
                    address += '+' + record.get('ShippingStreet');
                        
                     HttpResponse res = getResponse(address);

                     if (res.getStatusCode() != 200) continue;
                     GoogleJSONParser.Response prasResp = GoogleJSONParser.parse(res.getBody());
                     if (prasResp != null && !prasResp.Results.isEmpty()) {                            
                         record.put('ShippingLongitude', (Double) prasResp.Results[0].Geometry.Location.lng);
                         record.put('ShippingLatitude', (Double) prasResp.Results[0].Geometry.Location.lat);
                     }
                }                                        
            }
            update records;
		}        
    }
    
    private static HttpResponse getResponse(String address) {
        String encodedAddress = EncodingUtil.urlEncode(address, 'UTF-8');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + encodedAddress +'&key=' + GoogleAPIkey__c.getValues(GoogleAPIname).key__c);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }
}