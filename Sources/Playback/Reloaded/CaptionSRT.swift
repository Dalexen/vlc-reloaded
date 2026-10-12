/*****************************************************************************
 * CaptionSRT.swift
 * VLC Reloaded
 *****************************************************************************
 * Pure-Swift helpers for turning timed caption segments into SubRip (.srt).
 * No Apple-framework dependencies, so it is easy to unit test.
 *****************************************************************************/

import Foundation

/// One line of caption text with its start/end time in seconds.
struct CaptionSegment: Equatable {
    let start: TimeInterval
    let end: TimeInterval
    let text: String
}

enum CaptionSRT {
    /// Formats seconds as `HH:MM:SS,mmm` (the SubRip timestamp format).
    static func timestamp(_ seconds: TimeInterval) -> String {
        let totalMs = Int((max(0, seconds) * 1000).rounded())
        let ms = totalMs % 1000
        let s = (totalMs / 1000) % 60
        let m = (totalMs / 60000) % 60
        let h = totalMs / 3_600_000
        return String(format: "%02d:%02d:%02d,%03d", h, m, s, ms)
    }

    /// Renders segments as the contents of an `.srt` file.
    static func render(_ segments: [CaptionSegment]) -> String {
        segments
            .filter { !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .enumerated()
            .map { index, segment in
                "\(index + 1)\n\(timestamp(segment.start)) --> \(timestamp(segment.end))\n\(segment.text.trimmingCharacters(in: .whitespacesAndNewlines))\n"
            }
            .joined(separator: "\n")
    }
}
