//
//  Theme+minimalBlog.swift
//  
//
//  Created by Yoshikazu Ando on 2021/08/08.
//

import Foundation
import Publish

public extension Theme {
    static func minimalBlog(primarySection: Site.SectionID) -> Self {
        Theme(htmlFactory: MinimalBlogHTMLFactory(primarySection: primarySection),
              resourcePaths: ["Resources/MinimalBlogPublishTheme/styles.css"])
    }
}
