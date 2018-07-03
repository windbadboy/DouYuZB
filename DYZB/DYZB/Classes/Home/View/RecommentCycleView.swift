//
//  RecommentCycleView.swift
//  DYZB
//
//  Created by Ted on 2018/7/3.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

private let kCycleCellID = "kCycleCellID"
class RecommentCycleView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var cycleModels : [CycleModel]?{
        didSet {
            //当cycleModels获取到数据，重新加载collectionView的数据
            collectionView.reloadData()
            //设置pageController的数量
            pageControl.numberOfPages = cycleModels?.count ?? 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //不让其自动伸缩
        autoresizingMask = UIViewAutoresizing()

        //collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
       // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCycleCellID)
    }
}

extension RecommentCycleView {
    class func recommendCycleView() -> RecommentCycleView {
        return Bundle.main.loadNibNamed("RecommentCycleView", owner: nil, options: nil)?.first as! RecommentCycleView
    }
}

//MARK: - 遵守UICollectionView的数据源协议
extension RecommentCycleView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cycleModels?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
               cell.cycleModel = cycleModels![indexPath.item]
        return cell
    }
}

//Mark: - 遵守UICollectionViewDelegate
extension RecommentCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width)
    }
}
