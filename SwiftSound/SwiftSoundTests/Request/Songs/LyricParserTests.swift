//
//  LyricParserTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/24.
//

import Testing
@testable import SwiftSound

struct LyricParserTests {

    @Test func returnsEmptyLinesForMissingLyricText() {
        #expect(LyricParser.parse(nil).isEmpty)
        #expect(LyricParser.parse("").isEmpty)
    }

    @Test func parsesTimestampAndText() throws {
        let lines = LyricParser.parse("[01:02.345] 我的小时候吵闹任性的时候")
        let line = try #require(lines.first)

        #expect(lines.count == 1)
        #expect(line.time == 62_345)
        #expect(line.text == "我的小时候吵闹任性的时候")
    }

    @Test func parsesTwoDigitMillisecondsAsCentiseconds() throws {
        let lines = LyricParser.parse("[00:00.48] 作曲 : 李偲菘")
        let line = try #require(lines.first)

        #expect(line.time == 480)
        #expect(line.text == "作曲 : 李偲菘")
    }

    @Test func parsesThreeDigitMillisecondsAsMilliseconds() throws {
        let lines = LyricParser.parse("[00:00.048] 作曲 : 李偲菘")
        let line = try #require(lines.first)

        #expect(line.time == 48)
        #expect(line.text == "作曲 : 李偲菘")
    }

    @Test func allowsEmptyLyricTextAfterTimestamp() throws {
        let lines = LyricParser.parse("[00:10.74]")
        let line = try #require(lines.first)

        #expect(line.time == 10_740)
        #expect(line.text == "")
    }

    @Test func trimsWhitespaceBetweenTimestampAndText() throws {
        let lines = LyricParser.parse("[00:10.74]    我的外婆总会唱歌哄我")
        let line = try #require(lines.first)

        #expect(line.time == 10_740)
        #expect(line.text == "我的外婆总会唱歌哄我")
    }

    @Test func ignoresBlankAndInvalidLines() {
        let lyricText = """

        作词 : 没有时间标签
        [00:aa.00] 非数字时间
        [00:00.0] 毫秒位数太短
        [00:00.0000] 毫秒位数太长
        [00:01.20] 有效歌词
        """

        let lines = LyricParser.parse(lyricText)

        #expect(lines.count == 1)
        #expect(lines.first?.time == 1_200)
        #expect(lines.first?.text == "有效歌词")
    }

    @Test func sortsParsedLinesByTime() {
        let lyricText = """
        [00:15.72] 我的外婆总会唱歌哄我
        [00:00.48] 作曲 : 李偲菘
        [00:10.74] 我的小时候吵闹任性的时候
        """

        let lines = LyricParser.parse(lyricText)

        #expect(lines.map(\.time) == [480, 10_740, 15_720])
        #expect(lines.map(\.text) == [
            "作曲 : 李偲菘",
            "我的小时候吵闹任性的时候",
            "我的外婆总会唱歌哄我"
        ])
    }
}
