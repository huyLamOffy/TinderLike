//
//  KingFisher+Extensions.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/9/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import Kingfisher

extension UIImageView {
    func loadImage(urlString: String?) {
        guard let url = URL(string: urlString ?? "") else {
            return
        }
        kf.indicatorType = .activity
        kf.setImage(with: url, placeholder: PlaceHolderView(frame: bounds), options: [.transition(.fade(0.2))])
    }
}

private class PlaceHolderView: UIView, Placeholder {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

