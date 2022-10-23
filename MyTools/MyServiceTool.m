//
//  MyServiceTool.m
//  MyTools
//
//  Created by Shen on 2022/7/30.
//

#import "MyServiceTool.h"

@interface MyServiceTool()<NSURLSessionDelegate>

@property (nonatomic) BOOL skipSSL;
@property (strong, nonatomic) NSString *url;
@end

@implementation MyServiceTool

- (instancetype)init:(NSString*)url :(BOOL)skipSSL{
    self = [super init];
    self.url = url;
    self.skipSSL = skipSSL;
    
    return self;
}

- (NSDictionary*)doPost:(NSString*)param :(NSDictionary*)jsonBody{
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBody options:kNilOptions error:nil];

    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";

    [request setURL:[NSURL URLWithString:[self.url stringByAppendingPathComponent:param]]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonBodyData];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:nil];
    
    __block NSDictionary *jsonObject;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSHTTPURLResponse *asHTTPResponse = (NSHTTPURLResponse *) response;
        NSLog(@"The response is: %@", asHTTPResponse);

        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
        dispatch_semaphore_signal(sem);
        
    }];
    
    [task resume];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return jsonBody;
    
}

- (NSDictionary*)doPostMedia:(NSString*)param :(NSDictionary*)jsonBody :(NSData*)data{
    NSLog(@"%@", param);
    NSLog(@"%@", jsonBody);
    if(data){
        NSLog(@"hehe");
    }
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBody options:kNilOptions error:nil];
    
    NSString *boundary = @"boundaryYOYO";
    NSMutableData *body = [NSMutableData data];
    
     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Disposition: form-data; name=\"param\";\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Type: application/json\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:jsonBodyData];
     [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"files\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";

    [request setURL:[NSURL URLWithString:[self.url stringByAppendingPathComponent:param]]];
    [request setValue:@"multipart/form-data; boundary=boundaryYOYO" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:body];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:nil];
    
    __block NSDictionary *jsonObject;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSHTTPURLResponse *asHTTPResponse = (NSHTTPURLResponse *) response;
        NSLog(@"The response is: %@", asHTTPResponse);

        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
        dispatch_semaphore_signal(sem);
        
    }];
    
    [task resume];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return jsonBody;
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    
    if(self.skipSSL){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }else{
        
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    NSInteger percentage = (double)totalBytesSent * 100 / (double)totalBytesExpectedToSend;
    NSLog(@"Upload %ld%% ",(long)percentage);
    
}

@end
