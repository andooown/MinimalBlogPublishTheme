//
//  MinimalBlogHTMLFactory.swift
//  
//
//  Created by Yoshikazu Ando on 2021/08/08.
//

import Collections
import Foundation
import Plot
import Publish

struct MinimalBlogHTMLFactory<Site: Website>: HTMLFactory {
    let primarySection: Site.SectionID
}

extension MinimalBlogHTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return HTML(head: [
            .title("TITLE"),
            .encoding(.utf8)
        ]) {
            ItemList(divideItems(context.sections[primarySection].items))
        }
    }

    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return HTML(head: [
            .title("TITLE"),
            .encoding(.utf8)
        ]) {
            ItemList(divideItems(section.items))
        }
    }

    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML()
    }

    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        HTML()
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML()
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML()
    }
}

extension MinimalBlogHTMLFactory {
    private func divideItems(_ items: [Item<Site>]) -> OrderedDictionary<Date, [Item<Site>]> {
        let calendar = Calendar(identifier: .gregorian)
        let sortedItems = items.sorted(by: { $0.date > $1.date })

        return OrderedDictionary(grouping: sortedItems) { item in
            let components = calendar.dateComponents([.year], from: item.date)
            return calendar.date(from: components)!
        }
    }
}

// MARK: - Components

struct ItemList<Site: Website>: Component {
    let dividedItems: OrderedDictionary<Date, [Item<Site>]>
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    init(_ dividedItems: OrderedDictionary<Date, [Item<Site>]>) {
        self.dividedItems = dividedItems
    }

    var body: Component {
        Div {
            for (date, items) in dividedItems {
                H2(dateFormatter.string(from: date))
                List(items) { item in
                    ListItem {
                        Link(item.content.title, url: item.path.absoluteString)
                    }
                }
            }
        }
    }
}
