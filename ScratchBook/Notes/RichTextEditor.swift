//
//  RichTextEditor.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct RichTextEditor: NSViewRepresentable {
    @EnvironmentObject var noteModel: NoteModel

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()

        guard let textView = scrollView.documentView as? NSTextView else {
            return scrollView
        }

        textView.isRichText = true
        textView.allowsUndo = true
        textView.allowsImageEditing = true
        textView.allowsDocumentBackgroundColorChange = true
        textView.allowsCharacterPickerTouchBarItem = true
        textView.isAutomaticLinkDetectionEnabled = true
        textView.displaysLinkToolTips = true
        textView.isAutomaticDataDetectionEnabled = true
        textView.isAutomaticTextReplacementEnabled = true
        textView.isAutomaticDashSubstitutionEnabled = true
        textView.isAutomaticSpellingCorrectionEnabled = true
        textView.isAutomaticQuoteSubstitutionEnabled = true
        textView.isAutomaticTextCompletionEnabled = true
        textView.isContinuousSpellCheckingEnabled = true
        textView.usesAdaptiveColorMappingForDarkAppearance = true
        textView.usesInspectorBar = true
        textView.usesRuler = true
        textView.usesFindBar = true
        textView.usesFontPanel = true
        textView.importsGraphics = true

        textView.delegate = context.coordinator
        context.coordinator.textView = textView

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = context.coordinator.textView else { return }
        let nsAttributedString = (try? NSAttributedString(noteModel.noteContents, including: \.appKit))
            ?? NSAttributedString(noteModel.noteContents)
        // Only update if the content actually changed to avoid overwriting the selection/undo stack
        if textView.attributedString() != nsAttributedString {
            textView.textStorage?.setAttributedString(nsAttributedString)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextEditor
        var textView: NSTextView?

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            let attributed = textView.attributedString()
            parent.noteModel.noteContents = (try? AttributedString(attributed, including: \.appKit))
                ?? AttributedString(attributed)
        }
    }
}

