//
//  Pet.h
//  CHKNTNDR
//
//  Created by Sarah Griffis on 5/7/15.
//  Copyright (c) 2015 Sarah Griffis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AnimalType) {
    AnimalTypeNone = -1,
    AnimalTypeDog = 0,
    AnimalTypeCat = 1,
    AnimalTypeBird = 2,
};

typedef NS_ENUM(NSInteger, AnimalSex){
    AnimalSexNone = -1,
    AnimalSexMale,
    AnimalSexFemale,
};

//Pet.h
@interface Pet : NSObject

@property (nonatomic, copy, readonly) NSString *age;
@property (nonatomic, assign, readonly) AnimalType animal;
@property (nonatomic, copy, readonly) NSString *breed;
@property (nonatomic, copy, readonly) NSDictionary *contact;

@property (nonatomic, copy, readonly) NSString *descriptionText;
@property (nonatomic, copy, readonly) NSDictionary *media;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSDictionary *options;
@property (nonatomic, assign, readonly) AnimalSex sex;
@property (nonatomic, copy, readonly) NSString *size;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
