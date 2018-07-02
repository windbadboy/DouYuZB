//
//  PageContentView.swift
//  DYZB
//
//  Created by Ted on 2018/6/28.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class{
    func pageContentView(progress : CGFloat,sourceIndex : Int,targetIndex : Int)
}

private let contentCellId = "contentCellId"
class PageContentView: UIView {
    //定义PageContentView的属性
    //childVcs表示有几个可以滑动的content窗口
    private var childVcs : [UIViewController]
    //parentViewController表示在哪上面显示childVcs
    private weak var parentViewController : UIViewController?
    weak var delegate : PageContentViewDelegate?
    //滚动窗口初始偏移值
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate = false
    //初始化PageContentView
    init(frame : CGRect,childVcs : [UIViewController],parentViewController : UIViewController?) {
        //将传递过来的childVCs（ViewController数组)
        self.childVcs = childVcs
        //将传递过来的viewController（HomeViewController）给parentViewController
        self.parentViewController = parentViewController
        super.init(frame : frame)
        setupUI()
    }
    
    //懒加载colletionView
    private lazy var collectionView : UICollectionView = { [weak self] in
        //创建layout并设置属性
        let layout = UICollectionViewFlowLayout()
        //将PageContentView的height和width给layout
        layout.itemSize = self!.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //layout滚动方向
        layout.scrollDirection = .horizontal
        //创建collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        //使用dataSource表示哪一个对象需要实现UICollectionViewDataSource协议
        collectionView.dataSource = self
        //PageContentView实现其代理
        collectionView.delegate = self
        //注册cell，必须实现相应协议
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellId)
        return collectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageContentView {
    private func setupUI() {
        for childVc in childVcs {
            //将childVcs一一加入成父控件(HomeViewController)的子VC
            parentViewController?.addChildViewController(childVc)
        }
        
        //在PageContentView上添加collectionView
        addSubview(collectionView)
        collectionView.frame = bounds
    }
    
    
    
}

extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellId, for: indexPath)
        //给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
    
    
    
}

//Mark: - 实现UICollectionView代理
extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //滑动触发，将 isForbidScrollDelegate开关关闭
        isForbidScrollDelegate = false
        
        //这里的scrollView应该是CollectionView里面的值，记录滚动前的偏移值
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate {
            return
        }
        
         var progress : CGFloat = 0
         var sourceIndex = 0
         var targetIndex = 0
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        //右滑
        if(startOffsetX > currentOffsetX) {
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            if abs(currentOffsetX - startOffsetX) == scrollViewW {
                progress = 1
                sourceIndex = targetIndex
                
                
            }
         //   print("progress:\(progress) sourceIndex:\(sourceIndex) targetIndex:\(targetIndex)")
           // print("progress:\(progress) sourceIndex:\(sourceIndex) targetIndex:\(targetIndex) currentOffsetX:\(currentOffsetX) startOffsetX:\(startOffsetX) scrollViewW:\(scrollViewW)")
        }
        //左滑
        else {
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if(targetIndex >= childVcs.count) {
                targetIndex = childVcs.count - 1
            }
            //如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
                
            }
            //调用代理

        //    print("progress:\(progress) sourceIndex:\(sourceIndex) targetIndex:\(targetIndex)")
        }

            delegate?.pageContentView(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


//Mark: - 对外暴露的方法

extension PageContentView {
    func setupCurrentIndex(currentIndex : Int) {
        //点击事件，不需要执行scroll设置
        isForbidScrollDelegate = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
