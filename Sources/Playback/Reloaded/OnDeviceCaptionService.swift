/*****************************************************************************
 * OnDeviceCaptionService.swift
 * VLC Reloaded
 *****************************************************************************
 * Generates subtitles for a local media file entirely on device using
 * Apple's SpeechAnalyzer / SpeechTranscriber (iOS 26+). No audio leaves the
 * phone. See docs/ARCHITECTURE.md ("On-device captions").
 *
 * Limitation: the audio is read with AVAudioFile, so only containers that
 * AVFoundation understands (mp4, m4v, mov, mp3, m4a, wav, ...) work today.
 * MKV/AVI and friends need audio extracted from libvlc first.
 *****************************************************************************/

import Foundation

#if compiler(>=6.2) && canImport(Speech)
import AVFoundation
import Speech

@available(iOS 26.0, *)
final class OnDeviceCaptionService {
    enum CaptionError: LocalizedError {
        case unsupportedLocale(Locale)
        case transcriberUnavailable

        var errorDescription: String? {
            switch self {
            case .unsupportedLocale(let locale):
                return "On-device captions are not available for \(locale.identifier)."
            case .transcriberUnavailable:
                return "On-device speech recognition is not available on this device."
            }
        }
    }

    /// Whether this device can run the on-device transcriber at all.
    static var isSupported: Bool { SpeechTranscriber.isAvailable }

    /// Transcribes `mediaURL` and writes `<name>.<locale>.srt` next to it.
    /// - Returns: URL of the generated subtitle file.
    func generateSubtitles(for mediaURL: URL,
                           locale: Locale = .current,
                           progress: ((TimeInterval) -> Void)? = nil) async throws -> URL {
        guard Self.isSupported else { throw CaptionError.transcriberUnavailable }
        guard let supported = await SpeechTranscriber.supportedLocale(equivalentTo: locale) else {
            throw CaptionError.unsupportedLocale(locale)
        }

        let transcriber = SpeechTranscriber(locale: supported,
                                            transcriptionOptions: [],
                                            reportingOptions: [],
                                            attributeOptions: [.audioTimeRange])

        // Downloads the on-device language model the first time it is needed.
        if let request = try await AssetInventory.assetInstallationRequest(supporting: [transcriber]) {
            try await request.downloadAndInstall()
        }

        let audioFile = try AVAudioFile(forReading: mediaURL)
        let analyzer = SpeechAnalyzer(modules: [transcriber])

        // Collect results concurrently while the analyzer consumes the file.
        let collector = Task { () -> [CaptionSegment] in
            var segments: [CaptionSegment] = []
            for try await result in transcriber.results where result.isFinal {
                let start = result.range.start.seconds
                let end = result.range.end.seconds
                segments.append(CaptionSegment(start: start,
                                               end: end,
                                               text: String(result.text.characters)))
                progress?(end)
            }
            return segments
        }

        if let lastSample = try await analyzer.analyzeSequence(from: audioFile) {
            try await analyzer.finalizeAndFinish(through: lastSample)
        } else {
            await analyzer.cancelAndFinishNow()
        }

        let segments = try await collector.value
        let srtURL = mediaURL
            .deletingPathExtension()
            .appendingPathExtension("\(supported.identifier(.bcp47)).srt")
        try CaptionSRT.render(segments).write(to: srtURL, atomically: true, encoding: .utf8)
        return srtURL
    }
}
#endif
