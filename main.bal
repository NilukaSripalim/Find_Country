import ballerina/http;
import ballerina/lang.value;
 
service / on new http:Listener(8090) {
 
   resource function post iptocountry(http:Caller caller, http:Request request) returns error? {
       string jsonString = check request.getTextPayload();
       json jsonObj = check value:fromJsonString(jsonString);
       string ip = <string> check jsonObj.ip;
      //  string ip = "134.201.250.155";
       
       http:Client httpEndpoint = check new ("http://api.ipstack.com");
       http:Response getResponse = check httpEndpoint->get("/"+ip+"?access_key=cad8757ee02d0a232060f343a76b71e1");
  
       var jsonPayload = check getResponse.getJsonPayload();
        
       string country = <string> check jsonPayload.country_name;
      
      http:Response response = new;
        response.statusCode = http:STATUS_OK;
       response.setJsonPayload  ({"country" : country});
       check caller->respond(response);
   }
}