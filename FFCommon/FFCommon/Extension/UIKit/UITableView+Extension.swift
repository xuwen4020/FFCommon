//
//  UITableView+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

extension UITableView {
    
    @discardableResult
    public func contentInset(_ inset: UIEdgeInsets) -> UITableView {
        self.contentInset = inset
        return self
    }
    
    @discardableResult
    public func tableHeader(_ header: UIView?) -> UITableView {
        self.tableHeaderView = header
        return self
    }
    
    @discardableResult
    public func tableFooter(_ footer: UIView?) -> UITableView {
        self.tableFooterView = footer
        return self
    }
    
    @discardableResult
    public func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> UITableView {
        self.separatorStyle = style
        return self
    }
    
    @discardableResult
    public func separatorInset(_ inset: UIEdgeInsets) -> UITableView {
        self.separatorInset = inset
        return self
    }
    
    @discardableResult
    public func separatorColor(_ color: UIColor?) -> UITableView {
        self.separatorColor = color
        return self
    }
    
    /// 每组Section Header高度 sectionHeaderHeight/sectionFooterHeight 不能同时使用
    public func sectionHeaderHeight(_ height: CGFloat) {
        self.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        self.sectionHeaderHeight = height
        self.sectionFooterHeight = 0.01
    }
    
    /// 每组Section Footer高度 sectionHeaderHeight/sectionFooterHeight 不能同时使用
    public func sectionFooterHeight(_ height: CGFloat) {
        self.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        self.sectionHeaderHeight = 0.01
        self.sectionFooterHeight = height
    }
    
    /// 在ScrollViewDidScroll调用 取消悬浮
    public func cleanFloating(_ scrollView: UIScrollView, _ height: CGFloat) {
        //headerView的高度
        let sectionHeaderHeight = CGFloat(height)
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
    /// section圆形边框
    public func setCornerRadiusSection(radius: CGFloat = 10.0, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 圆角半径
        let cornerRadius = radius
        // 下面为设置圆角操作（通过遮罩实现）
        let sectionCount = self.numberOfRows(inSection: indexPath.section)
        cell.layer.mask = nil
        // 当前分区有多行数据时
        if sectionCount > 1 {
            switch indexPath.row {
            // 如果是第一行,左上、右上角为圆角
            case 0:
                cell.cornerRadius(corners: [.topLeft,.topRight], radius: cornerRadius)
            // 如果是最后一行,左下、右下角为圆角
            case sectionCount - 1:
                cell.cornerRadius(corners: [.bottomLeft,.bottomRight], radius: cornerRadius)
            default: break
            }
        }
        //当前分区只有一行行数据时
        else {
            //四个角都为圆角（同样设置偏移隐藏首、尾分隔线）
            cell.cornerRadius(corners: [.allCorners], radius: cornerRadius)
        }
    }
}

