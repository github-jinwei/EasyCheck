//
//  ALAssetsLibrary+CodeFragments.m
//  Vodka
//
//  Created by jinyu on 15/8/3.
//  Copyright (c) 2015年 Vodka Inc. All rights reserved.
//

#import "ALAssetsLibrary+CodeFragments.h"

@implementation ALAssetsLibrary (CodeFragments)

-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
        //相册存在标示
    __block BOOL albumWasFound = NO;
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        //search all photo albums in the library
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
             //判断相册是否存在
         if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
             
                 //存在
             albumWasFound = YES;
             
                 //get a hold of the photo's asset instance
             [assetsLibrary assetForURL: assetURL
                            resultBlock:^(ALAsset *asset) {
                                
                                    //add photo to the target album
                                [group addAsset: asset];
                                
                                    //run the completion block
                                completionBlock(nil);
                                
                            } failureBlock: completionBlock];
             return;
         }
     
             //如果不存在该相册创建
         if (group==nil && albumWasFound==NO)
             {
                 __weak ALAssetsLibrary* weakSelf = assetsLibrary;
             
                     //创建相册
                 [assetsLibrary addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group)
                  {
                  
                          //get the photo's instance
                      [weakSelf assetForURL: assetURL
                                resultBlock:^(ALAsset *asset)
                       {
                       
                               //add photo to the newly created album
                           [group addAsset: asset];
                       
                               //call the completion block
                           completionBlock(nil);
                       
                       } failureBlock: completionBlock];
                  
                  } failureBlock: completionBlock];
                 return;  
             }  
         
     }failureBlock:completionBlock];  
}

@end
