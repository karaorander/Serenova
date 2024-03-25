//
//  Article.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//

class Article {
    var articleTitle: String
    var articleLink: String
    var articlePreview: String
    var articleTags: [String]
    var articleId: String
    
    init(articleTitle: String, articleLink: String, articlePreview: String, articleTags: [String], articleId: String) {
        self.articleTitle = articleTitle
        self.articleLink = articleLink
        self.articlePreview = articlePreview
        self.articleTags = articleTags
        self.articleId = articleId
    }
}
