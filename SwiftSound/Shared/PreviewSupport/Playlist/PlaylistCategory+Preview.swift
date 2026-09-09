import Foundation

#if DEBUG
extension PlaylistCategory {
    static func preview(name: String, category: Int) -> Self {
        Self(
            name: name,
            resourceCount: 100,
            type: 0,
            category: category,
            resourceType: 0,
            hot: true,
            activity: false
        )
    }
}

extension Array where Element == PlaylistCategoryGroup {
    static let preview = [
        PlaylistCategoryGroup(
            id: 0,
            name: "语种",
            subs: [
                .preview(name: "华语", category: 0),
                .preview(name: "欧美", category: 0),
                .preview(name: "日语", category: 0),
                .preview(name: "韩语", category: 0),
                .preview(name: "粤语", category: 0),
                .preview(name: "法语", category: 0)
            ]
        ),
        PlaylistCategoryGroup(
            id: 1,
            name: "风格",
            subs: [
                .preview(name: "流行", category: 1),
                .preview(name: "摇滚", category: 1),
                .preview(name: "民谣", category: 1),
                .preview(name: "电子", category: 1),
                .preview(name: "爵士", category: 1),
                .preview(name: "Bossa Nova", category: 1)
            ]
        )
    ]
}
#endif
