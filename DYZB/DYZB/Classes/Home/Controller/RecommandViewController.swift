//
//  RecommandViewController.swift
//  DYZB
//
//  Created by Ted on 2018/6/30.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kItemW : CGFloat = (KscreenW - kItemMargin * 3) / 2
private let kNormalItemH : CGFloat = kItemW * 3 / 4
private let kPrettyItemH : CGFloat = kItemW * 4 / 3
private let kHeaderViewH : CGFloat = 50
private let kNormalCellId = "kNormalCellId"
private let kHeaderViewId = "kHeaderViewId"
private let kPrettyCellId = "kPrettyCellId"
private let kCycleViewH = KscreenW * 3 / 8
class RecommandViewController: UIViewController {
    private lazy var recommendVW : RecommendViewModel = RecommendViewModel()
    
    //定义轮播数据

    private lazy var cycleView : RecommentCycleView  = {
        //通过nib文件引用实例
        let cycleView = RecommentCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH, width: KscreenW, height: kCycleViewH)
        return cycleView
    }()
    private lazy var collectionView : UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: KscreenW, height: kHeaderViewH)
        //设置内边距
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellId)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellId)
        //自定义headView
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewId)
        collectionView.delegate = self
        //设置屏幕可显示区域自适应
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        return collectionView
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        requestData()
        
    }



}

//MARK: 设置UI
extension RecommandViewController {
    func setupUI() {
        self.view.backgroundColor = UIColor.blue
        self.view.addSubview(collectionView)
        collectionView.addSubview(cycleView)
        
        //设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH, left: 0, bottom: 0, right: 0)
    }
}

//MARK: 实现UICollectionViewDataSource协议
extension RecommandViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //显示返回多少组数据
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVW.anchorGroups.count
    }
    
    
    //每一组数据有多少条数据
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendVW.anchorGroups[section]
        return group.anchors.count
    }
    
    //返回cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = recommendVW.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        
       var cell : CollectionBaseCell
        if indexPath.section == 1 {
         cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellId, for: indexPath) as! CollectionPrettyCell
        } else {
         cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellId, for: indexPath) as! CollectionNormalCell
        }
        
        

        cell.anchor = anchor
        return cell
    }
    
    //设置headerView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewId, for: indexPath) as! CollectionHeaderView
        headView.group = recommendVW.anchorGroups[indexPath.section]
        return headView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        return CGSize(width: kItemW, height: kNormalItemH)
    }
}



extension RecommandViewController {
    //请求主播数据
    func requestData() {
        recommendVW.requestData {
            self.collectionView.reloadData()
        }
    //请求轮播数据
        recommendVW.requestCycleData {
            self.cycleView.cycleModels = self.recommendVW.cycleModels
        }
        
    }
}
