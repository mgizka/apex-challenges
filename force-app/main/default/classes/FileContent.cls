@RestResource (urlMapping='/filecontent/*')
global with sharing class FileContent {
    
    @HttpGet
    global static void doGet(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;      

        String contentId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        System.debug('contentId: '+contentId);
        ContentVersion content = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :contentId];

        response.addHeader('Content-Type', 'image/jpeg');
        response.responseBody = content.VersionData ;
    } 
}