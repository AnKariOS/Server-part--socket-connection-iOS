//
//  Packets.h
//  SocketTries
//
//  Created by Andrey Karaban on 31/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const PacketsKeyData;
extern NSString * const PacketsKeyType;
extern NSString * const PacketsKeyAction;

typedef enum
{
    PacketsTypeUnknown = -1
} PacketsType;

typedef enum
{
    MTPacketActionUnknown = -1
} PacketsAction;

@interface Packets : NSObject

@property (strong, nonatomic) id data;
@property (assign, nonatomic)PacketsType type;
@property (assign, nonatomic)PacketsAction action;


#pragma mark -
#pragma mark Initialization

- (id)initWithData:(id)data type:(PacketsType)type action:(PacketsAction)action;

@end
