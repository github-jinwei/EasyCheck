//
//  ALAssetsLibrary+CodeFragments.h
//  Vodka
//
//  Created by jinyu on 15/8/3.
//  Copyright (c) 2015年 Vodka Inc. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^SaveImageCompletion) (NSError* error);

@interface ALAssetsLibrary (CodeFragments)
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
@end
