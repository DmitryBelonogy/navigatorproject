@isTest
global class MockGoogleApiGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results" : [{"address_components" : [{"long_name" : "30","short_name" : "30","types" : [ "street_number" ]},{"long_name" : "North Mills Street","short_name" : "N Mills St","types" : [ "route" ]},{"long_name" : "Madison","short_name" : "Madison","types" : [ "locality", "political" ]},{"long_name" : "Dane County","short_name" : "Dane County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "Wisconsin","short_name" : "WI","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "Соединенные Штаты Америки","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "53715","short_name" : "53715","types" : [ "postal_code" ]}],"formatted_address" : "30 N Mills St, Madison, WI 53715, США","geometry" : {"bounds" : {"northeast" : {"lat" : 43.0686796,"lng" : -89.4042161},"southwest" : {"lat" : 43.0683854,"lng" : -89.4048736}},"location" : {"lat" : 43.0685554,"lng" : -89.40457379999999},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 43.0698814802915,"lng" : -89.4031958697085},"southwest" : {"lat" : 43.0671835197085,"lng" : -89.4058938302915}}},"place_id" : "ChIJxyiUXc6sB4gR-4X3NajvH1w","types" : [ "premise" ]}],"status" : "OK"}');
        res.setStatusCode(200);
        return res;
    }
}