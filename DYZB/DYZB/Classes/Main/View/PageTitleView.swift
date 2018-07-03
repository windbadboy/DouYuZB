//
//  PageTitleView.swift
//  DYZB
//
//  Created by Ted on 2018/6/28.
//  Copyright © 2018年 Ted. All rights reserved.
//

import UIKit


//MARK: - 定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView : PageTitleView,selectedIndex index : Int)
}

//Mark: - 定义常量
private let kScrollLineH : CGFloat = 2
//当前选中的titleLabel
private var currentIndex = 0
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)


//Mark: - 定义类
class PageTitleView : UIView {
    //导航标题
    private var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    //Mark:懒加载scrollView
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    private lazy var titleLabels : [UILabel] = [UILabel]()
    
    init(frame : CGRect,titles : [String]) {
        self.titles = titles
        super.init(frame : frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageTitleView {
    private func setupUI() {
        //添加scrollView到PagetitleView上
        addSubview(scrollView)
        scrollView.frame = bounds

        //添加scrollView对应的Label
        setupTitleLabels()
        //添加底线和滑动块
        setupBottomLineAndScrollLine()
        
        
        
        
    }
    private func setupTitleLabels() {
        
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        for(index,title) in titles.enumerated() {
        //创建UILabel
            let label = UILabel()
        //设置label属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = UIColor(R: kNormalColor.0, G: kNormalColor.1, B: kNormalColor.2)
            label.textAlignment = .center
        //设置label手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        //设置label的frame

            let labelX : CGFloat = labelW * CGFloat(index)

            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
        //将label加入到scrollView
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
    }
    
    private func setupBottomLineAndScrollLine() {
        //添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        //添加scrollLine
        scrollView.addSubview(scrollLine)
        //获取第一个UILabel
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(R: kSelectColor.0, G: kSelectColor.1, B: kSelectColor.2)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - 2, width: firstLabel.frame.width, height: lineH)
    }
}

//MARK:监听label点击事件
extension PageTitleView {
    @objc private func titleLabelClick(tapGes : UITapGestureRecognizer) {
        //获取当前选中titleLabel，将view(UIView)类型转换为UILabel
        guard let currentLabel = tapGes.view as? UILabel else {return}
        
        //判断是否点击同一个label
        if currentLabel.tag == currentIndex {return}
        //获取上一个TitleLabel
        let oldLabel = titleLabels[currentIndex]
        
        //重新设置titleLabel的局部属性
        currentLabel.textColor = UIColor(R: kSelectColor.0, G: kSelectColor.1, B: kSelectColor.2)
        oldLabel.textColor = UIColor(R: kNormalColor.0, G: kNormalColor.1, B: kNormalColor.2)
        
        
        //设置currentIndex为当前选中的label
        currentIndex = currentLabel.tag
        
        //设置scrollLine滚动到对应的titleLabel下
        let scrollLineX = CGFloat(currentLabel.tag) * currentLabel.frame.width
        UIView.animate(withDuration: 0.2, animations: {
                    self.scrollLine.frame.origin.x = scrollLineX
            })
        
        //通知代理,此时是执行的HomeViewController的pageTitleView方法
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)

    }
}

//对外暴露方法
extension PageTitleView {
    func setTitleWithProgress(progress : CGFloat,sourceIndex : Int,targetIndex : Int) {
        //1.获取对应的titleLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
               // print("progress:\(progress) sourceIndex:\(sourceIndex) targetIndex:\(targetIndex)")
        //处理scrollLIne滑动逻辑
        //移动的总距离
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        //移动百分比
        let moveX = moveTotalX * progress
       // print("moveTotalX:\(moveTotalX) moveX:\(moveX)")
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //处理label标签文字渐变
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        sourceLabel.textColor = UIColor(R: kSelectColor.0 - colorDelta.0 * progress, G: kSelectColor.1 - colorDelta.1 * progress, B: kSelectColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(R: kNormalColor.0 + colorDelta.0 * progress, G: kNormalColor.1 + colorDelta.1 * progress, B: kNormalColor.2 + colorDelta.2 * progress)
        //同步当前currentIndex(当前标签页）
        currentIndex = targetIndex
        
        //print("progress:\(progress) sourceIndex:\(sourceIndex) targetIndex:\(targetIndex)")
    }
}

