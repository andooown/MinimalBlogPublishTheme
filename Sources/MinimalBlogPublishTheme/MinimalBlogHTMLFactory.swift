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
            .encoding(.utf8),
            .viewport(.accordingToDevice, initialScale: 1),
            .link(.href(URL(string: "https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css")!), .rel(.stylesheet), .integrity("sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We"), .attribute(named: "crossorigin", value: "anonymous")),
            .stylesheet("/styles.css"),
        ]) {
            Container {
                ItemList(divideItems(context.sections[primarySection].items))
                Node<HTML.BodyContext>.script(.src(URL(string: "https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js")!), .integrity("sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj"), .attribute(named: "crossorigin", value: "anonymous"))
            }
        }
    }

    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"

        return HTML(head: [
            .title("TITLE"),
            .encoding(.utf8),
            .viewport(.accordingToDevice, initialScale: 1),
            .link(.href(URL(string: "https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css")!), .rel(.stylesheet), .integrity("sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We"), .attribute(named: "crossorigin", value: "anonymous")),
            .stylesheet("/styles.css"),
        ]) {
            Container {
                ItemList(divideItems(section.items))
                Node<HTML.BodyContext>.script(.src(URL(string: "https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js")!), .integrity("sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj"), .attribute(named: "crossorigin", value: "anonymous"))
            }
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

struct Container: Component {
    let body: Component

    init(@ComponentBuilder component: () -> ComponentGroup) {
        body = Div(component()).class("container")
    }
}

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
        ComponentGroup {
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
