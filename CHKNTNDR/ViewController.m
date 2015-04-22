//
//  ViewController.m
//  CHKNTNDR
//
//  Created by Sarah Griffis on 4/20/15.
//  Copyright (c) 2015 Sarah Griffis. All rights reserved.
//

#import "ViewController.h"
#import "PetCollectionViewCell.h"
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
- (void)viewDidLayoutSubviews
{
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
    //cell.textLabel.text = self.dataSource[indexPath.row][0];
    cell.label.text = @"test text";
    //self.dataSource[indexPath.row][0];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.dataSource[indexPath.row][1]]];
    //cell.imageView.image = [UIImage imageWithData:imageData];
    
    [cell.imageView setImage:[UIImage imageWithData:imageData]];
    //UIImage *image = [UIImage imageWithContentsOfFile:filename];
    //cell.imageView = setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.textLabel.text = self.dataSource[indexPath.row][0];
    
//    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.dataSource[indexPath.row][1]]];
//    cell.imageView.image = [UIImage imageWithData:imageData];
//    return cell;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataSource.count;
//}

#pragma mark - helper
- (void)setupCollectionView
{
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    
    
    // self.collectionView = [UICollectionView new];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds  collectionViewLayout:flowLayout];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [flowLayout setItemSize:CGSizeMake(320, 548)];
    
    [self.collectionView registerClass:[PetCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];

    self.collectionView.dataSource = self;
    self.collectionView.delegate=self;
    
    [self.view addSubview:self.collectionView];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(320, 548);
}

// petFind()
// breedList()

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
        
        NSArray *pets = dictionary[@"petfinder"][@"pets"][@"pet"];
        NSMutableArray *petAttributes = [NSMutableArray array];
        
        for (NSDictionary *dict in pets) {
            NSMutableArray *innerArray = [NSMutableArray array];
            [innerArray addObject:dict[@"name"][@"$t"]];
            [innerArray addObject:dict[@"media"][@"photos"][@"photo"][3][@"$t"]];
            [petAttributes addObject:innerArray];
        }
        NSLog(@"our petAttributes: %@", petAttributes);
        
        weakSelf.dataSource = [petAttributes copy];
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
        
        weakSelf.dataSource = [petAttributes copy];
        [weakSelf.collectionView reloadData];
        
    }];
    
}
@end
