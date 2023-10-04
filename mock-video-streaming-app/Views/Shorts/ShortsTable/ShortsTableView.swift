//
//  ShortsTableView.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import Foundation
import UIKit

final class ShortsTableView: UITableView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}
