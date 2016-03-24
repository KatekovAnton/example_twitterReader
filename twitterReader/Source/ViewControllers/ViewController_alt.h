//
//  ViewController.h
//  twitterReader
//
//  Created by Katekov Anton on 22.12.15.
//  Copyright © 2015 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {

    UISegmentedControl *_segments;
    
    IBOutlet UICollectionViewFlowLayout *_layoutFlow;
    IBOutlet UICollectionViewFlowLayout *_layoutGrid;
    
    IBOutlet UICollectionView *_collectionView;
    UIRefreshControl *_collectionRefresh;
}

@end

