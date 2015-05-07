//
//  ViewController.m
//  CHKNTNDR
//
//  Created by Sarah Griffis on 4/20/15.
//  Copyright (c) 2015 Sarah Griffis. All rights reserved.
//

#import "ViewController.h"
#import "PetCollectionViewCell.h"
#import "Pet.h"
@import AVFoundation;
//#import "CollectionViewLayout.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface ViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSArray array];
    [self setupCollectionView];
    
    //[self makePetGetRandomRequest:@"&animal=dog"];
    [self makePetFindRequest:@"11211" options:nil];
}

#pragma mark - view
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}



#pragma mark - datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PetCollectionViewCell *cell = (PetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.label.text = self.dataSource[indexPath.row][@"name"];
    Pet *pet = self.dataSource[indexPath.row];
    cell.label.text = pet.name;
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: pet.media[@"photos"][@"photo"][3][@"$t"]]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    [cell.imageView setImage:image];
    
    return cell;
}


#pragma mark - helper
- (void)setupCollectionView
{
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //What's this?  seems like line spacing is the spacing between cells?
    //how do I center them?
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    //??What's this
    [flowLayout setItemSize:CGSizeMake(self.view.frame.size.width, 548)];
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds  collectionViewLayout:flowLayout];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerClass:[PetCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:1.00 green:0.95 blue:0.80 alpha:1.0];
    
    [self.view addSubview:self.collectionView];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 548);
}


#pragma mark - networking
- (void)makeBreedListRequest
{
    NSLog(@"==make request");
    
    //http://api.petfinder.com/pet.get?key=12345&id=24601
    // breed.list
    // animal=dog
    // format=json
    // key=63d0c8ea01b3fd815daa6e510f6f3d57
    
    //url
    NSURL *url = [[NSURL alloc] initWithString:@"http://api.petfinder.com/breed.list?key=63d0c8ea01b3fd815daa6e510f6f3d57&animal=dog&format=json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //    NSString *postBody = @"?http://api.petfinder.com/breed.list?key=63d0c8ea01b3fd815daa6e510f6f3d57&animal=dog&format=json";
    //    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
    __weak typeof(self)weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"got response: %@", response);
        if (!data) {
            NSLog(@"%s: sendAynchronousRequest error: %@", __FUNCTION__, connectionError);
            return;
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"%s: sendAsynchronousRequest status code != 200: response = %@", __FUNCTION__, response);
                return;
            }
        }
        
        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!dictionary) {
            NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            return;
        }
        
        NSLog(@"our dictionary: %@", dictionary);
        
        NSArray *breeds = dictionary[@"petfinder"][@"breeds"][@"breed"];
        NSMutableArray *breedNames = [NSMutableArray array];
        
        for (NSDictionary *dict in breeds) {
            [breedNames addObject:dict[@"$t"]];
        }
        
        weakSelf.dataSource = [breedNames copy];
        [weakSelf.collectionView reloadData];
        
    }];
    
}

- (void)makePetFindRequest:(NSString*)location options:(NSString*)options
{
    NSLog(@"==make request");
    
    //http://api.petfinder.com/pet.get?key=12345&id=24601
    // breed.list
    // animal=dog
    // format=json
    // key=63d0c8ea01b3fd815daa6e510f6f3d57
    
    //url
    //need to alloc/init or new?
    NSString *baseurl = [NSString stringWithFormat:@"http://api.petfinder.com/pet.find?key=63d0c8ea01b3fd815daa6e510f6f3d57&format=json&location=%@", location];
    if (options) {
        baseurl = [baseurl stringByAppendingString:options];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:baseurl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //    NSString *postBody = @"?http://api.petfinder.com/breed.list?key=63d0c8ea01b3fd815daa6e510f6f3d57&animal=dog&format=json";
    //    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
    __weak typeof(self)weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"got response: %@", response);
        if (!data) {
            NSLog(@"%s: sendAynchronousRequest error: %@", __FUNCTION__, connectionError);
            return;
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"%s: sendAsynchronousRequest status code != 200: response = %@", __FUNCTION__, response);
                return;
            }
        }
        
        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!dictionary) {
            NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            return;
        }
        
        //NSLog(@"our dictionary: %@", dictionary);
        
        NSArray *petJson = dictionary[@"petfinder"][@"pets"][@"pet"];
        NSMutableArray *pets = [NSMutableArray array];
        
        for (NSDictionary *dict in petJson) {
            //NSMutableArray *innerArray = [NSMutableArray array];
            //[innerArray addObject:dict[@"name"][@"$t"]];
            //[innerArray addObject:dict[@"media"][@"photos"][@"photo"][3][@"$t"]];
            
            Pet *loopPet = [[Pet alloc]initWithDictionary:dict];
            //NSString *description = dict[@"description"][@"$t"];
            //[innerArray addObject:(description) ? description : @""];
            [pets addObject:loopPet];
        }
        
        weakSelf.dataSource = [pets copy];
        [weakSelf.collectionView reloadData];
        
    }];
    
}

- (void)makePetGetRandomRequest:(NSString*)options
{
    NSLog(@"==make request");
    
    //http://api.petfinder.com/pet.get?key=12345&id=24601
    // breed.list
    // animal=dog
    // format=json
    // key=63d0c8ea01b3fd815daa6e510f6f3d57
    
    //url
    //need to alloc/init or new??
    NSString *baseurl = @"http://api.petfinder.com/pet.getRandom?key=63d0c8ea01b3fd815daa6e510f6f3d57&format=json&output=basic";
    if (options) {
        baseurl = [baseurl stringByAppendingString:options];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:baseurl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //    NSString *postBody = @"?http://api.petfinder.com/breed.list?key=63d0c8ea01b3fd815daa6e510f6f3d57&animal=dog&format=json";
    //    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
    __weak typeof(self)weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"got response: %@", response);
        if (!data) {
            NSLog(@"%s: sendAynchronousRequest error: %@", __FUNCTION__, connectionError);
            return;
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"%s: sendAsynchronousRequest status code != 200: response = %@", __FUNCTION__, response);
                return;
            }
        }
        
        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!dictionary) {
            NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            return;
        }
        
        //NSLog(@"our dictionary: %@", dictionary);
        
        NSDictionary *pets = dictionary[@"petfinder"][@"pet"];
        NSMutableArray *petAttributes = [NSMutableArray array];
        
        NSMutableArray *innerArray = [NSMutableArray array];
        [innerArray addObject:pets[@"name"][@"$t"]];
        [innerArray addObject:pets[@"media"][@"photos"][@"photo"][3][@"$t"]];
        [petAttributes addObject:innerArray];
        NSLog(@"our petAttributes: %@", petAttributes);
        
        //loop through petattributes and create new pet objects
        for (NSDictionary *dictionary in petAttributes) {
            //Pet initwithdictionary
        }
        
        weakSelf.dataSource = [petAttributes copy];
        [weakSelf.collectionView reloadData];
        
    }];
    
}
@end
