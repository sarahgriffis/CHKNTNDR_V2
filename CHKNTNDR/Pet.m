//
//  Pet.m
//  CHKNTNDR
//
//  Created by Sarah Griffis on 5/7/15.
//  Copyright (c) 2015 Sarah Griffis. All rights reserved.
//

#import "Pet.h"

//Pet.m
@interface Pet ()

@property (nonatomic, copy, readwrite) NSString *age;
@property (nonatomic, assign, readwrite) AnimalType animal;
@property (nonatomic, copy, readwrite) NSString *breed;
@property (nonatomic, copy, readwrite) NSDictionary *contact;

@property (nonatomic, copy, readwrite) NSString *descriptionText;
@property (nonatomic, copy, readwrite) NSDictionary *media;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSDictionary *options;
@property (nonatomic, assign, readwrite) AnimalSex sex;
@property (nonatomic, copy, readwrite) NSString *size;

@end

@implementation Pet

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        //parse dictionary
        self.age = dictionary[@"age"][@"$t"];
        self.breed = dictionary[@"breeds"];
        self.animal = [Pet animalTypeForString:dictionary[@"animal"][@"$t"]];
        self.contact = dictionary[@"contact"];
        
        NSString *temp = dictionary[@"description"][@"$t"];
        
        self.descriptionText = (temp) ? temp : @"";
        self.media = dictionary[@"media"];
        self.name = dictionary[@"name"][@"$t"];
        self.options = dictionary[@"options"];
        self.sex = [Pet animalSexForString:dictionary[@"sex"][@"$t"]];
        self.size = dictionary[@"size"][@"$t"];


    }
    return self;
}

+ (AnimalType)animalTypeForString:(NSString *)string
{
    if ([string isEqualToString:@"Dog"]) {
        return AnimalTypeDog;
    }
    else if ([string isEqualToString:@"Cat"]){
        return AnimalTypeCat;
    }
    return AnimalTypeNone;
}

+ (AnimalSex)animalSexForString:(NSString *)string
{
    if ([string isEqualToString:@"M"]) {
        return AnimalSexMale;
    }
    else if ([string isEqualToString:@"F"]){
        return AnimalSexFemale;
    }
    return AnimalSexNone;
}

@end
