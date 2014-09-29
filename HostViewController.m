//
//  HostViewController.m
//  SocketTries
//
//  Created by Andrey Karaban on 29/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import "HostViewController.h"
#import "Packets.h"

@interface HostViewController ()

@end

@implementation HostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setDelegate:self];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //[self setDelegate:self];
   // [self startBroadcast];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_delegate) {
        _delegate = nil;
    }
    
    if (_socket) {
        [_socket setDelegate:nil delegateQueue:NULL];
        _socket = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)startBroadcast
{
    // Initialize GCDAsyncSocket
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Start Listening for Incoming Connections
    NSError *error = nil;
    if ([self.socket acceptOnPort:54506 error:&error])
    {
        // Initialize Service
        self.service = [[NSNetService alloc] initWithDomain:@"local." type:@"_TEST_VISION_ACEP._tcp." name:@"" port:54506];
        
        // Configure Service
        [self.service setDelegate:self];
        
        // Publish Service
        [self.service publish];
        
    } else {
        NSLog(@"Unable to create socket. Error %@ with user info %@.", error, [error userInfo]);
    }
}


#pragma mark - NSNetworking_Delegate

- (void)netServiceDidPublish:(NSNetService *)service
{
    NSLog(@"Bonjour Service Published: domain(%@) type(%@) name(%@) port(%i)", [service domain], [service type], [service name], (int)[service port]);
}

- (void)netService:(NSNetService *)service didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@", [service domain], [service type], [service name], errorDict);
}


#pragma mark - GCDAsyncSocket_Delegate

- (void)socket:(GCDAsyncSocket *)socket didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"Accepted New Socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    
    
//    // Notify Delegate
     // [self.delegate controller:self didHostOnSocket:newSocket];
//    
    // End Broadcast
    [self endBroadcast];
    
    
    // Socket
    [self setSocket:newSocket];
    
    // Read Data from Socket
    [newSocket readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:0];
    
//    NSString *msg = @"Hello, World!";
//    Packets *packet = [[Packets alloc]initWithData:msg type:0 action:0];
//    [self sendPackets: packet];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSError *error;
    [self.socket connectToHost:host onPort:port error:&error];
}


- (void)endBroadcast
{
    if (self.socket)
    {
        [self.socket setDelegate:nil delegateQueue:NULL];
        [self setSocket:nil];
    }
    
    if (self.service) {
        [self.service setDelegate:nil];
        [self setService:nil];
    }
}

//- (void)sendPackets:(Packets *)packet
//{
//    // Encode Packet Data
//    NSMutableData *packetData = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:packetData];
//    [archiver encodeObject:packet forKey:@"packet"];
//    [archiver finishEncoding];
//    
//    // Initialize Buffer
//    NSMutableData *buffer = [[NSMutableData alloc] init];
//    
//    // Fill Buffer
//    uint64_t headerLength = [packetData length];
//    [buffer appendBytes:&headerLength length:sizeof(uint64_t)];
//    [buffer appendBytes:[packetData bytes] length:[packetData length]];
//    
//    // Write Buffer
//    [self.socket writeData:buffer withTimeout:-1.0 tag:0];
//}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.socket == socket) {
        [self.socket setDelegate:nil];
        [self setSocket:nil];
        [self startBroadcast];
      //  [self checkConnection];
    }
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == 0)
    {
        uint64_t bodyLength = [self parseHeader:data];
        [socket readDataToLength:bodyLength withTimeout:-1.0 tag:1];

    } else if (tag == 1)
    {
        [self parseBody:data];
        [socket readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:0];
    }
}


- (uint64_t)parseHeader:(NSData *)data {
    uint64_t headerLength = 0;
    memcpy(&headerLength, [data bytes], sizeof(uint64_t));
    
    return headerLength;
}


- (void)parseBody:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    Packets *packet = [unarchiver decodeObjectForKey:@"packet"];
    [unarchiver finishDecoding];
    
    NSLog(@"Packet Data > %@", packet.data);
    NSLog(@"Packet Type > %i", packet.type);
    NSLog(@"Packet Action > %i", packet.action);
    if ([packet.data isEqualToString:@"111"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"TUT" message:@"PRISHLO" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    if ([packet.data isEqualToString:@"0"])
    {
    }

}


@end
