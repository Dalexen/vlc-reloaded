/*****************************************************************************
 * ReloadedGlass.swift
 * VLC Reloaded
 *****************************************************************************
 * A small UIKit wrapper that uses iOS 26 "Liquid Glass" when available and
 * falls back to a regular blur on older systems. Use it for floating
 * controls (player buttons, mini player, sheets).
 *
 * Note: building with the iOS 26 SDK already gives the system bars and
 * controls Liquid Glass automatically. This view is only for custom UI.
 *****************************************************************************/

import UIKit

final class ReloadedGlassView: UIVisualEffectView {
    /// Put your subviews in here, like with any UIVisualEffectView.
    var glassContentView: UIView { contentView }

    init(cornerRadius: CGFloat = 20, interactive: Bool = true) {
        super.init(effect: Self.makeEffect(interactive: interactive))
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("ReloadedGlassView is created in code")
    }

    private static func makeEffect(interactive: Bool) -> UIVisualEffect {
        #if compiler(>=6.2)
        if #available(iOS 26.0, *) {
            let glass = UIGlassEffect()
            glass.isInteractive = interactive
            return glass
        }
        #endif
        return UIBlurEffect(style: .systemUltraThinMaterial)
    }
}
