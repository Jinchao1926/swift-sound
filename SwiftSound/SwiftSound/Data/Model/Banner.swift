//
//  Banner.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation

/**
{
    "targetId": 3392582347,
    "bigImageUrl": "https://p5.music.126.net/obj/wonDlsKUwrLClGjCm8Kx/80828694563/0c17/d9a9/4ac9/e86e80f118c35af4f1e53c65599d7937.jpg",
    "imageUrl": "https://p5.music.126.net/obj/wonDlsKUwrLClGjCm8Kx/80828707078/3578/6b75/7729/7eccd119d134da981293fb79bd84d723.jpg",
    "targetType": 1,
    "typeTitle": "新歌首发",
    "s_ctrp": "linkPlatform$cc$pc_banner_op_channel$bpo$$rt$song$pc$BANNER_PC_V2$fgid$1487019$pgid$0$pid$4357273$rid$3392582347$cid$4360249$traceid$0000019ec5a06a930a250a3b207914b5$bcc$pc_banner_op_channel$spc$BANNER_PC_V2-6$fromId$1039024$fromType$promotion$bpc$BANNER_PC_V2",
    "url": "orpheus://song/3392582347"
 }
*/
/** 轮播图 */
struct Banner: Decodable {
    let targetId: Int
    let imageUrl: String
    let targetType: Int
    let typeTitle: String
    let url: String
}

// MARK: - Identifiable
extension Banner: Identifiable {
    var id: String { imageUrl }
}
